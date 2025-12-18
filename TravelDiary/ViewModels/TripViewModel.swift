//
//  TripViewModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 12/08/25.
//

import Foundation
import SwiftData

@Observable
class TripViewModel {
  private var modelContext: ModelContext
  private var tripRepository: TripRepository
  init(modelContext: ModelContext, repository: TripRepository) {
    self.modelContext = modelContext
    self.tripRepository = repository
    loadInitialData()
  }

  private func loadInitialData() {
    Task {
      do {
        try await tripRepository.fetchDataFromFireStore()
      } catch {
        print(
          "Error loading initial data: \(error.localizedDescription)")
      }
    }
  }

  func saveTripToDB(
    destination: DestinationModel,
    startDate: Date,
    budgetEstimate: Double,
    days: Int,
    status: TripStatus
  ) async {
    let newTrip = TripModel(
      destination: destination,
      destinationName: destination.name,
      startDate: startDate,
      budgetEstimate: budgetEstimate,
      status: status,
      days: days
    )

    Task {
      do {
        try await tripRepository.addTrip(
          newTrip, destination: destination)
      } catch {
        print(
          "Error saving the trip to databases\(error.localizedDescription)"
        )
      }
    }
  }

  func updateTripDetailsToDB(
    _ trip: TripModel,
    headerImage: Data?,
    notes: String,
    budgetSpent: Double
  ) {
    if let headerImage = headerImage {
      trip.headerImage = headerImage
    }
    trip.notes = notes
    trip.budgetSpent = budgetSpent

    Task {
      do {
        try await tripRepository.updateTripDetails(
          trip, headerImageData: headerImage)
        print("Trip updated successfully!")
      } catch {
        print("Error updating trip: \(error.localizedDescription)")
      }
    }
  }

  func deleteTripsInDB(from trips: [TripModel], at offsets: IndexSet) {
    Task {
      do {
        for index in offsets {
          try await tripRepository.deletetripDetails(for: [
            trips[index]
          ])
        }
      } catch {
        print("Error deleting trips: \(error)")
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
