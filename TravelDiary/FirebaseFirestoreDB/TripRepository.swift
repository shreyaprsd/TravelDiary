//
//  TripRepository.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 17/10/25.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftData

class TripRepository {
  private let db = Firestore.firestore()
  private var modelContext: ModelContext

  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }

  func addTrip(
    _ trip: TripModel, destination: DestinationModel
  ) async throws {
    guard !destination.name.isEmpty else {
      throw TripDataError.invalidDestination
    }

    guard trip.budgetEstimate >= 0 else {
      throw TripDataError.invalidBudget
    }

    let newTrip = TripModel(
      destination: destination,
      destinationName: destination.name,
      startDate: trip.startDate,
      budgetEstimate: trip.budgetEstimate,
      status: trip.status,
      days: trip.days
    )
    // first save trip to the firestore
    try await saveTripToFirestore(trip: newTrip)
    print("Trip saved to Firestore successfully!")
    //then on the main thread, save trip to the local db
    await MainActor.run {
      modelContext.insert(destination)
      modelContext.insert(newTrip)
      do {
        try modelContext.save()
        print("Trip saved to local DB successfully!")
      } catch {
        print("Error saving to local DB: \(error)")
      }
    }
  }

  func updateTripDetails(_ trip: TripModel, headerImageData: Data?)
    async throws
  {
    if let headerImageData = headerImageData {
      trip.headerImage = headerImageData
    }

    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }
    //get the existing document and then add additional details
    let docRef = db.collection("users")
      .document(userId)
      .collection("trips")
      .document(trip.id.uuidString)
    let document = try await docRef.getDocument()

    var tripRemote = try document.data(as: TripRemote.self)
    tripRemote.notes = trip.notes
    tripRemote.budgetSpent = trip.budgetSpent

    if let headerImageData = headerImageData {
      let imageURL = try await StorageManager.shared
        .uploadTripHeaderImage(
          imageData: headerImageData,
          tripId: trip.id.uuidString)
      tripRemote.headerImageURL = imageURL
    }

    try docRef.setData(from: tripRemote, merge: true)
    print("Trip details updated in Firestore")
    // save the additional details in local db
    await MainActor.run {
      do {
        try modelContext.save()
        print("Trip details updated in local DB")
      } catch {
        print("Error saving to local DB: \(error)")
      }
    }
  }

  func saveTripToFirestore(trip: TripModel) async throws {
    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }

    var tripData = TripRemote.fromModel(trip)
    if let destination = trip.destination {
      tripData.destination = DestinationRemote.fromModel(destination)
    }
    do {
      let profileRef = db.collection("users")
        .document(userId)
        .collection("trips")
        .document(trip.id.uuidString)
      _ = try profileRef.setData(from: tripData)
    } catch {
      print("Failed to save trips in firestore db ")
    }
  }

  func deletetripDetails(for trips: [TripModel]) async throws {
    guard let userId = Auth.auth().currentUser?.uid else {
      fatalError("User not signed in")
    }

    for trip in trips {
      //delete the image stored in the storage first
      if trip.headerImage != nil {
        try? await StorageManager.shared.deleteTripHeaderImage(
          tripId: trip.id.uuidString)
      }
      // then the trip in firestore
      try await db.collection("users")
        .document(userId)
        .collection("trips")
        .document(trip.id.uuidString)
        .delete()
      print("Trip deleted from Firestore db")
      //then on the main thread delete the trip from local db
      await MainActor.run {
        modelContext.delete(trip)
        print("Deleted trip locally ")
        do {
          try modelContext.save()
          print("Changes saved")
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }

  func fetchDataFromFireStore() async throws {
    guard let userId = Auth.auth().currentUser?.uid else {
      fatalError("User not signed in")
    }

    let snapshot = try await db.collection("users")
      .document(userId)
      .collection("trips").getDocuments()

    await MainActor.run {
      do {
        let descriptor = FetchDescriptor<TripModel>()
        let existingTrips = try modelContext.fetch(descriptor)
        let existingIDs = Set(existingTrips.map { $0.id })
        try snapshot.documents.forEach { document in
          let firestoreData = try document.data(as: TripRemote.self)
          let tripData = firestoreData.toModel()

          if !existingIDs.contains(tripData.id) {
            modelContext.insert(tripData)
            print(
              "Adding new trip to the local db \(tripData.destinationName)"
            )
          } else {
            print(
              "Trip already exists locally: \(tripData.destinationName)"
            )
          }
        }
      } catch {
        print("Error getting the documents")
      }
    }
  }

  enum TripDataError: Error {
    case invalidDestination
    case invalidBudget
    case noImageData
    case saveError(Error)
    case deleteError(Error)
    var errorDescription: String? {
      switch self {
      case .invalidDestination:
        return "Please enter a valid destination"
      case .invalidBudget:
        return "Please enter a valid budget amount"
      case .noImageData:
        return "Please select an image"
      case .saveError(let error):
        return "Failed to save trip: \(error.localizedDescription)"
      case .deleteError(let error):
        return "Failed to delete trip: \(error.localizedDescription)"
      }
    }
  }
}
