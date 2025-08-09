//
//  MainView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 09/08/25.
//
 import SwiftUI
struct MainView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        TabView {
            .tabItem{
                Label("Profile", systemImage: "person")
            }
        }
    }
}

#Preview {
    MainView(viewModel: AuthViewModel())
}
