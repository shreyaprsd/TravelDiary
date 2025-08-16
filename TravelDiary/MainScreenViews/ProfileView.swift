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
        VStack(spacing: 20) {
            Text("User : \(viewModel.displayName)")
                .font(.largeTitle)
            ProfileImageView()
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
