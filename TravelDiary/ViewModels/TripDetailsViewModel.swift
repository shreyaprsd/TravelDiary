//
//  TripDetailsViewModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 13/08/25.
//

import Foundation
import SwiftData

@Observable
class TripDetailsViewModel {
    var modelContext : ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}
