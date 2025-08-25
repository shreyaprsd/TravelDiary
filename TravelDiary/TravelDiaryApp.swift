//
//  TravelDiaryApp.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 08/08/25.
//

import FirebaseCore
import SwiftUI
import SwiftData
import TipKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TravelDiaryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel: AuthViewModel = .init()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .modelContainer(for: [TripModel.self, UserProfile.self])
         
        }
    }
    init() {
            do{
                try Tips.resetDatastore()
                try Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
                
            }
            catch{
                print("Error initialising tip kit \(error.localizedDescription)")
                    
                }
            
        }
    
   
}
