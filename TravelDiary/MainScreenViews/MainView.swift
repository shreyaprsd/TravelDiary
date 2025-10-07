//
//  MainView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 09/08/25.
//
import SwiftUI

struct MainView: View {
  @StateObject var viewModel: AuthViewModel
  @State private var selectedIndex: Int = 0

  var body: some View {
    TabView(selection: $selectedIndex) {
      NavigationStack {
        HomeView()
      }
      .tabItem {
        Label("Home", systemImage: "house")
      }
      .tag(0)

      NavigationStack {
        ProfileView(viewModel: viewModel)
          .navigationTitle("Profile")
      }
      .tabItem {
        Label("Profile", systemImage: "person")
      }
      .tag(1)

      NavigationStack {
        ConversionCalculatorView()
          .navigationTitle("Currency Converter")
      }
      .tabItem {
        Label("Currency", systemImage: "dollarsign.circle")
      }
      .tag(2)
    }
  }
}

#Preview {
  MainView(viewModel: AuthViewModel())
    .modelContainer(for: TripModel.self, inMemory: true)
}
