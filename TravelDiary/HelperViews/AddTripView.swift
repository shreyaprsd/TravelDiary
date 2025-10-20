//
//  AddTripView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 12/08/25.
//

import SwiftData
import SwiftUI

struct AddTripView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  @State private var destination: DestinationModel?
  @State private var startDate = Date()
  @State private var duration: Int? = nil
  @State private var budgetEstimate: Double? = nil
  @State private var selectedStatus = TripStatus.planned

  private var tripViewModel: TripViewModel {
    TripViewModel(
      modelContext: modelContext,
      repository: TripRepository(modelContext: modelContext))
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Trip Location")) {
          FormMapView(selectedDestination: $destination)
        }
        Section(header: Text("Trip Details")) {
          if let destination = destination {
            Text("\(destination.name)")
          }

          DatePicker(
            "Start Date",
            selection: $startDate,
            displayedComponents: .date
          )
          TextField(
            "Trip duration (in days)",
            value: $duration,
            format: .number
          )
          .keyboardType(.decimalPad)

          TextField(
            "Budget Estimate",
            value: $budgetEstimate,
            format: .number
          )
          .keyboardType(.decimalPad)

          Picker("Status", selection: $selectedStatus) {
            ForEach(
              [
                TripStatus.planned, TripStatus.inProgress,
                TripStatus.completed,
              ],
              id: \.self
            ) { status in
              Text(status.rawValue).tag(status)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
      }
      .navigationTitle("Add New Trip")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            Task {
              await saveTrip()
              dismiss()
            }
          }
        }
      }
    }
  }

  private func saveTrip() async {
    guard let destination = destination else {
      print("destination not selected")
      return
    }
    print(" Saving trip with destination: \(destination.name)")
    print(
      " Destination coordinates: \(destination.latitude ?? 0), \(destination.longitude ?? 0)"
    )

    await tripViewModel.saveTripToDB(
      destination: destination,
      startDate: startDate,
      budgetEstimate: budgetEstimate ?? 0.0,
      days: duration ?? 0,
      status: selectedStatus
    )

  }
}

#Preview {
  AddTripView()
    .modelContainer(
      for: [TripModel.self, DestinationModel.self],
      inMemory: true
    )
}
