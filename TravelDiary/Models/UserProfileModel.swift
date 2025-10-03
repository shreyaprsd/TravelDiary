//
//  UserProfileModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 15/08/25.
//
import SwiftUI
import SwiftData
import Foundation

@Model
class UserProfile {
    @Attribute(.unique) var id : String
    var profileImageData : Data?
    var updatedAt : Date?
    
    init(id: String = "main_profile", profileImageData: Data? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.profileImageData = profileImageData
        self.updatedAt = updatedAt
    }
    
    func updateProfileImage(with imageData:Data?){
        self.profileImageData = imageData
        self.updatedAt = Date()
    }
}
