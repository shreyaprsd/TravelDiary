//
//  TripSpecificNotes.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 18/08/25.
//

import SwiftUI

struct TripSpecificNotes: View {
    @State var selectedTrip: TripModel
    var body: some View {
        ZStack {
            TextEditor(text: $selectedTrip.notes)
                .padding(12)
            if selectedTrip.notes.isEmpty {
                Text("Write whatever is in your mind about this trip...")
                    .foregroundColor(.secondary)
            }
        }

        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    TripSpecificNotes(
        selectedTrip: TripModel(
            destination: "London",
            startDate: .now,
            budgetEstimate: 900,
            status: .completed,
            days: 9,
            notes: " ",
            budgetSpent: 100
        )
    )
}
