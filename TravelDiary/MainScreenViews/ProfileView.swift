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
        VStack(spacing: 30) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Text("User : \(viewModel.displayName)")
                .font(.headline)
            Button("Sign Out") {
                viewModel.signOut()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
    }
}

#Preview {
    ProfileView(viewModel: AuthViewModel())
}
