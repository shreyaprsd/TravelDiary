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
    var modelContext: ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addTrip(
        destination: String,
        startDate: Date,
        budgetEstimate: Double,
        days:Int,
        status: TripStatus
    ) -> Result<TripModel, TripDataError> {
        guard !destination.isEmpty else {
            return .failure(.invalidDestination)
        }

        guard budgetEstimate >= 0 || budgetEstimate <= 0 else {
            return .failure(.invalidBudget)
        }

        let newTrip = TripModel(
            destination: destination,
            startDate: startDate,
            budgetEstimate: budgetEstimate,
            status: status, days: days,
        )

        print("Attempting to save trip: \(newTrip.destination)")
        modelContext.insert(newTrip)

        do {
            try modelContext.save()
            print("Trip saved successfully!")
            return .success(newTrip)
        } catch {
            print("Error saving trip: \(error)")
            return .failure(.saveError(error))
        }
    }

    func updateTripDetails(
        _ trip: TripModel,
        headerImage: Data?,
        notes: String,
        budgetSpent: Double
    ) -> Result<TripModel, TripDataError> {

        if let headerImage = headerImage {
            trip.headerImage = headerImage
        }
        trip.notes = notes
        trip.budgetSpent = budgetSpent

        print("Attempting to update trip details for: \(trip.destination)")

        do {
            try modelContext.save()
            print("Trip details updated successfully!")
            return .success(trip)
        } catch {
            print("Error updating trip: \(error)")
            return .failure(.saveError(error))
        }
    }

    func deleteTrips(from trips: [TripModel], at offsets: IndexSet) -> Result<
        Void, TripDataError
    > {
        for index in offsets {
            modelContext.delete(trips[index])
        }
        do {
            try modelContext.save()
            print("Trips deleted successfully!")
            return .success(())
        } catch {
            print("Error deleting trips: \(error)")
            return .failure(.deleteError(error))
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
