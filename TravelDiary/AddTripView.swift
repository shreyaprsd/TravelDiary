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
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var budgetEstimate : Double? = nil
    @State private var selectedStatus = TripStatus.planned
    
    private var tripViewModel: TripViewModel {
        TripViewModel(modelContext: modelContext)
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Trip Details")) {
                    TextField("Destination", text: $destination)
                    
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    )
                    
                    TextField("Budget Estimate", value: $budgetEstimate, format: .number)
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
                        saveTrip()
                    }
                }
            }
        }
    }
    
    private func saveTrip() {
        let result = tripViewModel.addTrip(
            destination: destination,
            startDate: startDate,
            budgetEstimate: budgetEstimate ?? 0.0,
            status: selectedStatus
        )
        
        switch result {
        case .success:
            dismiss()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
#Preview {
    AddTripView()
        .modelContainer(for: TripModel.self, inMemory: true)
}
