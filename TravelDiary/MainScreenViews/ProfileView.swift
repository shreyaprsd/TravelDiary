//
//  ProfileView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 09/08/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 60) {
            HStack(alignment: .top) {
                HStack {
                    ProfileImageView()
                    Text("\(viewModel.displayName)")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                Spacer()
            }

            Button("Sign Out") {
                viewModel.signOut()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        Spacer()
    }
}

#Preview {
    ProfileView(viewModel: AuthViewModel())
}
