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
        Text("Username : \(viewModel.displayName)")
            .font(.headline)
    }
}

#Preview {
    ProfileView(viewModel: AuthViewModel())
}
