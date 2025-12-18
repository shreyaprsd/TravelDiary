//
//  HomeView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 09/08/25.
//

import FirebaseAuth
import SwiftData
import SwiftUI

struct HomeView: View {
  @Query var trips: [TripModel]
  @Environment(\.modelContext) var modelContext
  @State private var showingAddTrip = false
  @State private var showingTripDetails = false
  @State private var selectedTrip: TripModel?
  @State private var viewModel: TripViewModel?

  var body: some View {
    Group {
      if trips.isEmpty {
        VStack(spacing: 20) {
          Image(systemName: "suitcase")
            .font(.system(size: 50))
            .foregroundColor(.gray)
          Text("No trips yet!")
            .font(.title2)
            .foregroundColor(.gray)
          Text("Tap the + button to add your first trip")
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
      } else {
        List {
          ForEach(trips, id: \.id) { trip in
            Button(action: {
              selectedTrip = trip
            }) {
              TripRowView(trip: trip)
            }
          }
          .onDelete { offsets in
            if let viewModel = viewModel {
              viewModel.deleteTripsInDB(
                from: trips, at: offsets)
            }
          }
        }
      }
    }
    .navigationTitle("Trips 🧳")
    .sheet(item: $selectedTrip) { trip in
      NavigationView {
        TripSpecifics(selectedTrip: trip)
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          showingAddTrip = true
        } label: {
          Image(systemName: "plus")
        }
      }
    }
    .sheet(isPresented: $showingAddTrip) {
      AddTripView()
    }
    .task {
      if viewModel == nil {
        viewModel = TripViewModel(
          modelContext: modelContext,
          repository: TripRepository(modelContext: modelContext))
        print("HomeView appeared, trips count: \(trips.count)")
      }
    }
    .onChange(of: Auth.auth().currentUser?.uid) { _, _ in
      viewModel = nil
      viewModel = TripViewModel(
        modelContext: modelContext,
        repository: TripRepository(modelContext: modelContext))
    }
  }
}

#Preview {
  HomeView()
    .modelContainer(for: TripModel.self, inMemory: true)
}
