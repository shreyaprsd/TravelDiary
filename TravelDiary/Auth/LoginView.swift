//
//  LoginView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 08/08/25.
//

import GoogleSignIn
import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    private func signInWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() == true {
                dismiss()
            }
        }
    }
    var body: some View {
        VStack(spacing: 20) {
            Text("Login Page")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            Spacer()
            Button(action: signInWithGoogle) {
                Text("Sign in with Google")
                    .frame(maxWidth: 280)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.bordered)
            .background(alignment: .leading) {
                Image("Google")
                    .frame(width: 30, alignment: .center)
            }
            Spacer()
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}
