//
//  MapView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 09/08/25.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var searchText = ""
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 12.9967, longitude: 77.5775),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var annotations: [MapAnnotation] = []
    @State private var hasUserSearched = false

    var body: some View {
        Group {
            if locationManager.authorizationStatus == .denied
                || locationManager.authorizationStatus == .restricted
            {
                LocationAccessDeniedView()
            } else {
                mapContentView
            }
        }
        .onAppear {
            locationManager.checkLocationAuthorization()
        }
        .onReceive(locationManager.$lastKnownLocation) { location in
            if let location = location, !hasUserSearched {
                region = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.1,
                        longitudeDelta: 0.1
                    )
                )
            }
        }
    }

    private var mapContentView: some View {
        VStack {
            HStack {
                TextField("Search for a location", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        searchLocation()
                    }

                Button("Search") {
                    searchLocation()
                }
            }
            .padding()

            Map(coordinateRegion: $region, annotationItems: annotations) {
                annotation in
                MapMarker(coordinate: annotation.coordinate, tint: .red)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    func searchLocation() {
        hasUserSearched = true
        hideKeyboard()

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print(
                    "Search error: \(error?.localizedDescription ?? "Unknown error")"
                )
                return
            }

            DispatchQueue.main.async {
                annotations.removeAll()

                if let firstItem = response.mapItems.first {
                    let coordinate = firstItem.placemark.coordinate
                    region = MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(
                            latitudeDelta: 0.01,
                            longitudeDelta: 0.01
                        )
                    )
                    annotations.append(
                        MapAnnotation(
                            coordinate: coordinate,
                            title: firstItem.name ?? "Unknown Location"
                        )
                    )
                }
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    struct MapAnnotation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let title: String
    }
}

#Preview {
    MapView()
}
