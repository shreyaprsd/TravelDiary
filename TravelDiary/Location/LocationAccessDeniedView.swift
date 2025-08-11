//
//  LocationAccessDeniedView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 11/08/25.
//

import SwiftUI

struct LocationAccessDeniedView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.slash.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            Text("Location Access Denied")
                .font(.title)
                .fontWeight(.bold)

            Text(
                "To use the map feature, please enable location access in Settings."
            )
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .padding(.horizontal, 40)

            Button("Open Settings") {
                if let settingsUrl = URL(
                    string: UIApplication.openSettingsURLString
                ) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    LocationAccessDeniedView()
}
