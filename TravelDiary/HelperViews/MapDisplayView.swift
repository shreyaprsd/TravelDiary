//
//  MapDisplayView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 01/09/25.
//

import MapKit
import SwiftData
import SwiftUI

struct MapDisplayView: View {
  @Environment(\.modelContext) var modelContext
  let destination: DestinationModel?
  @State private var position: MapCameraPosition
  init(destination: DestinationModel?) {
    self.destination = destination
    if let destination = destination,
      let coordinates = destination.coordinates
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

  @Query var destinations: [DestinationModel] = []
  private var mapRegion: MKCoordinateRegion {
    guard let destination = destination,
      let coordinates = destination.coordinates
    else {
      return MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
      )
    }
    return MKCoordinateRegion(
      center: coordinates,
      span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
  }

  var body: some View {
    Map(position: $position, interactionModes: []) {
      ForEach(destinations, id: \.name) { destination in
        if let coordinates = destination.coordinates {
          Marker(destination.name, coordinate: coordinates)
            .tint(.red)
        }
      }
    }
    .frame(width: 370, height: 211)
    .clipShape(RoundedRectangle(cornerRadius: 24))
  }
}

#Preview {
  MapDisplayView(destination: DestinationModel(name: "Paris"))
    .modelContainer(for: DestinationModel.self, inMemory: true)
}
