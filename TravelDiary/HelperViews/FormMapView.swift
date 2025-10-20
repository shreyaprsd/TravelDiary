//
//  FormMap.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 27/08/25.
//

import MapKit
import SwiftData
import SwiftUI

struct FormMapView: View {
  @State private var searchText = ""
  @State private var locationManager = LocationManager()
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
    span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
  )
  @Environment(\.modelContext) var modelContext
  @Query var destinations: [DestinationModel] = []
  @Binding var selectedDestination: DestinationModel?
  @State private var hasSearched = false
  private var ViewModel: TripViewModel {
    TripViewModel(
      modelContext: modelContext,
      repository: TripRepository(modelContext: modelContext))
  }
  @State private var position: MapCameraPosition
  init(selectedDestination: Binding<DestinationModel?>) {
    self._selectedDestination = selectedDestination
    if let selectedDest = selectedDestination.wrappedValue,
      let coordinates = selectedDest.coordinates
    {
      self._position = State(
        initialValue: .region(
          MKCoordinateRegion(
            center: coordinates,
            span: MKCoordinateSpan(
              latitudeDelta: 0.1,
              longitudeDelta: 0.1
            )
          )
        )
      )
    } else {
      self._position = State(
        initialValue: .region(
          MKCoordinateRegion(
            center: CLLocationCoordinate2D(
              latitude: 0,
              longitude: 0
            ),
            span: MKCoordinateSpan(
              latitudeDelta: 180,
              longitudeDelta: 180
            )
          )
        )
      )
    }
  }

  private var annotations: [DestinationModel] {
    guard let selectedDestination = selectedDestination else { return [] }
    return [selectedDestination]
  }

  var body: some View {
    Group {
      if locationManager.authorizationStatus == .denied
        || locationManager.authorizationStatus == .restricted
      {
        LocationAccessDeniedView()
          .frame(width: 100, height: 200)
      } else {
        mapContentView
      }
    }
    .onAppear {
      locationManager.checkLocationAuthorization()
    }
    .onReceive(locationManager.$lastKnownLocation) { location in
      if let location = location,
        !hasSearched
      {
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
        TextField("Enter destination", text: $searchText)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Button("Search") {
          searchLocation()
          print("Searched and saved location")
        }
      }.padding()

      Map(position: $position, interactionModes: []) {
        ForEach(annotations, id: \.name) { annotation in
          if let coordinates = annotation.coordinates {
            Marker(annotation.name, coordinate: coordinates)
              .tint(.red)
          }
        }
      }
      .frame(width: 275, height: 295)
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .padding()
      .onTapGesture {
        hideKeyboard()
      }
    }
  }

  func searchLocation() {
    hasSearched = true
    hideKeyboard()

    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchText
    request.region = region
    let search = MKLocalSearch(request: request)
    search.start { response, error in
      guard let response = response else {
        print(
          "Error while searching location \(error?.localizedDescription ?? "error")"
        )
        return
      }
      DispatchQueue.main.async {
        if let firstItem = response.mapItems.first {
          let coordinate = firstItem.placemark.coordinate
          region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(
              latitudeDelta: 0.1,
              longitudeDelta: 0.1
            )
          )
          position = .region(region)
          selectedDestination = DestinationModel(
            name: firstItem.name ?? searchText,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
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
}

#Preview {
  @Previewable @State var previewDestination: DestinationModel? =
    DestinationModel(name: "Paris")
  FormMapView(selectedDestination: $previewDestination)
    .modelContainer(for: DestinationModel.self, inMemory: true)
}
