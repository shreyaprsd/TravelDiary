//
//  TripModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 11/08/25.
//

import Foundation
import SwiftData

@Model
class TripModel {
    @Attribute(.unique) var id = UUID()
    var destination: String
    var startDate : Date
    var budgetEstimate : Double
    var status : TripStatus
    init(id: UUID = UUID(), destination: String, startDate: Date, budgetEstimate: Double, status: TripStatus) {
        self.id = id
        self.destination = destination
        self.startDate = startDate
        self.budgetEstimate = budgetEstimate
        self.status = status
    }
}

enum TripStatus : String, Codable {
    case planned = "Planned"
    case inProgress = "In Progress"
    case completed = "Completed"
}
