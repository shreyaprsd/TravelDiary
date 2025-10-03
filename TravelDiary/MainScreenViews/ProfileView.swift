//
//  ProfileView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 09/08/25.
//

import SwiftData
import SwiftUI

struct ProfileView: View {
  @StateObject var viewModel: AuthViewModel
  @Query var trips: [TripModel]

  var body: some View {
    VStack {
      VStack(spacing: 8) {
        HStack {
          ProfileImageView()
          Text("\(viewModel.displayName)")
            .font(
              .system(size: 20, weight: .bold, design: .default)
            )
        }
        Divider()
        Text("👋🏻, Travel Buff!")
          .font(.headline)
        Text(
          "Your adventures have led you across \(trips.count) incredible places, each with its own story to tell."
        )
        .font(.body)
        .foregroundColor(.secondary)
      }
      .padding(20)
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)

      Button("Sign Out", role: .destructive) {
        viewModel.signOut()
      }
      .buttonStyle(.borderedProminent)
      .padding(.top, 20)
      Spacer()
    }
    .padding(.horizontal)
  }
}

#Preview {
  ProfileView(viewModel: AuthViewModel())
}
