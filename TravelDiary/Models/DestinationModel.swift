//
//  DestinationModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 27/08/25.
//
import Foundation
import MapKit
import SwiftData

@Model
class DestinationModel: Identifiable {
  var name: String
  var latitude: Double?
  var longitude: Double?
  @Relationship(deleteRule: .cascade, inverse: \TripModel.destination) var trips: [TripModel]?
  init(name: String, latitude: Double? = nil, longitude: Double? = nil) {
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
  }
  var coordinates: CLLocationCoordinate2D? {
    guard let latitude = latitude, let longitude = longitude else {
      return nil
    }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
