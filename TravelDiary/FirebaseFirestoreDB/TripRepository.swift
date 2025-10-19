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
  func updateTripDetails(_ trip: TripModel, headerImageData: Data?)
    async throws
  {
    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }
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
          imageData: headerImageData, tripId: trip.id.uuidString)

      tripRemote.headerImageURL = imageURL
    }
    try docRef.setData(from: tripRemote, merge: true)
    print("Trip details updated in db ")
  }

  func deletetripDetails(for trips: [TripModel]) async throws {
    guard let userId = Auth.auth().currentUser?.uid else {
      fatalError("User not signed in")
    }
    for trip in trips {
      if trip.headerImage != nil {
        try? await StorageManager.shared.deleteTripHeaderImage(
          tripId: trip.id.uuidString)
      }
      try await db.collection("users")
        .document(userId)
        .collection("trips")
        .document(trip.id.uuidString)
        .delete()

      print("Trip deleted from Firestore db")
    }
  }
}
