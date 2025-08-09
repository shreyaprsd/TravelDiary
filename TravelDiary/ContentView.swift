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
            LoginView(viewModel: viewModel)
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: AuthViewModel())
}
