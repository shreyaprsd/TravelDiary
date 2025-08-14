//
//  TripDetailsModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 13/08/25.
//

import Foundation
import SwiftData

@Model
class TripDetailsModel {
    var destination: String
    var image: Data
    var days: Int
    var notes : String
    var estimatedBudget: Double
    var budgetSpent : Double
    init(destination: String, image: Data, days: Int, notes: String, estimatedBudget: Double, budgetSpent: Double) {
        self.destination = destination
        self.image = image
        self.days = days
        self.notes = notes
        self.estimatedBudget = estimatedBudget
        self.budgetSpent = budgetSpent
    }
    var moneyleft : Double {
        return estimatedBudget - budgetSpent
    }
    var percentageOfMoneyLeft: Double {
        return  moneyleft/estimatedBudget * 100
    }
}
