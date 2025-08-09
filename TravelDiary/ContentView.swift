//
//  ContentView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 08/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: AuthViewModel
    var body: some View {
        VStack {
            switch viewModel.authenticationState {
            case .unauthenticated:
                LoginView(viewModel: viewModel)
            case .authenticating:
                ProgressView("Signing in ..")
                    .progressViewStyle(CircularProgressViewStyle())
    
            case .authenticated:
                MainView(viewModel: viewModel)
            }
            
        }
        .padding()
        .onAppear {
            viewModel.registerAuthStateHandler()
        }
    }
}
#Preview {
    ContentView(viewModel: AuthViewModel())
}
