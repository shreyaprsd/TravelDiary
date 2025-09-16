//
//  TripModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 11/08/25.
//

import Foundation
import PhotosUI
import SwiftData

@Model
class TripModel {
  @Attribute(.unique) var id = UUID()
  var startDate: Date
  var budgetEstimate: Double
  var status: TripStatus
  var headerImage: Data?
  var days: Int
  var notes: String
  var budgetSpent: Double
  var destinationName: String
  @Relationship var destination: DestinationModel?
  var moneyleft: Double {
    return (budgetEstimate - budgetSpent)
  }
  var percentageOfMoneyLeft: Double {
    return (moneyleft / budgetEstimate * 100)
  }

  init(
    id: UUID = UUID(),
    destination: DestinationModel? = nil,
    destinationName: String = "",
    startDate: Date,
    budgetEstimate: Double,
    status: TripStatus,
    headerImage: Data? = nil,
    days: Int,
    notes: String = "",
    budgetSpent: Double = 0.0
  ) {
    self.id = id
    self.destination = destination
    self.destinationName = destinationName
    self.startDate = startDate
    self.budgetEstimate = budgetEstimate
    self.status = status
    self.headerImage = headerImage
    self.days = days
    self.notes = notes
    self.budgetSpent = budgetSpent
  }
}

enum TripStatus: String, Codable {
  case planned = "Planned"
  case inProgress = "In Progress"
  case completed = "Completed"
}
