//
//  TripRemoteModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 13/10/25.
//

import FirebaseFirestore
import Foundation

// TripRemote Model
struct TripRemote: Codable, Identifiable {
  @DocumentID var id: String?
  var startDate: Timestamp
  var budgetEstimate: Double
  var status: String
  var headerImageURL: String?
  var days: Int
  var notes: String
  var budgetSpent: Double
  var destinationName: String
  var destination: DestinationRemote?
  enum CodingKeys: String, CodingKey {
    case id
    case startDate = "start_date"
    case budgetEstimate = "budget_estimate"
    case status
    case headerImageURL = "header_image_url"
    case days
    case notes
    case budgetSpent = "budget_spent"
    case destinationName = "destination_name"
    case destination
  }

  // Convert from TripModel  to TripRemote
  static func fromModel(_ model: TripModel) -> TripRemote {
    return TripRemote(
      id: model.id.uuidString,
      startDate: Timestamp(date: model.startDate),
      budgetEstimate: model.budgetEstimate,
      status: model.status.rawValue,
      headerImageURL: nil,
      days: model.days,
      notes: model.notes,
      budgetSpent: model.budgetSpent,
      destinationName: model.destinationName
    )
  }

  // Convert from TripRemote to TripModel
  func toModel() -> TripModel {
    return TripModel(
      id: UUID(uuidString: self.id ?? UUID().uuidString) ?? UUID(),
      destinationName: self.destinationName,
      startDate: self.startDate.dateValue(),
      budgetEstimate: self.budgetEstimate,
      status: TripStatus(rawValue: self.status) ?? .planned,
      headerImage: nil,
      days: self.days,
      notes: self.notes,
      budgetSpent: self.budgetSpent
    )
  }
}

//  DestinationRemote Model
struct DestinationRemote: Codable, Identifiable {
  @DocumentID var id: String?
  var name: String
  var latitude: Double?
  var longitude: Double?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case latitude
    case longitude
  }

  // Convert from DestinationModel to DestinationRemote
  static func fromModel(_ model: DestinationModel) -> DestinationRemote {
    return DestinationRemote(
      id: model.name,
      name: model.name,
      latitude: model.latitude,
      longitude: model.longitude
    )
  }

  // Convert from DestinationRemote to DestinationModel
  func toModel() -> DestinationModel {
    return DestinationModel(
      name: self.name,
      latitude: self.latitude,
      longitude: self.longitude
    )
  }
}
