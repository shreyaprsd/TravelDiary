//
//  ProfileImageViewModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 24/10/25.
//

import FirebaseAuth
import PhotosUI
import SwiftData
import SwiftUI

@Observable
class ProfileImageViewModel {
  var selectedImage: UIImage? = nil
  var photosPickerItem: PhotosPickerItem? = nil
  var showingImagePicker = false
  var editingPhotoAlert = false
  private var modelContext: ModelContext
  var currentProfile: UserProfile?

  init(modelContext: ModelContext, currentProfile: UserProfile?) {
    self.modelContext = modelContext
    self.currentProfile = currentProfile
  }

  func saveProfileImageAutomatically(image: UIImage) async {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
      print("Could not convert image to data")
      return
    }
    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }

    do {
      // 1. saving to SwiftData
      if let existingProfile = currentProfile {
        existingProfile.updateProfileImage(with: imageData)
      } else {
        let newProfile = UserProfile(profileImageData: imageData)
        modelContext.insert(newProfile)
      }

      try modelContext.save()
      print("Image saved to SwiftData")

      //2. saving in the firestore storage
      _ = await UserManager.shared.saveProfileImage(
        userId: userId, imageData: imageData
      )
    } catch {
      print(
        "Failed to save image: \(error) to swiftData and online storage"
      )
    }
  }

  func loadProfileImage() {
    guard let profile = currentProfile,
      let imageData = profile.profileImageData
    else {
      selectedImage = nil
      return
    }

    selectedImage = UIImage(data: imageData)
  }

  func syncProfileImageFromFirebase() async {
    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }

    // Fetch image data from Firebase
    guard
      let imageData = await UserManager.shared.fetchProfileImageData(
        userId: userId)
    else {
      print("No profile image found in Firebase")
      return
    }

    // Save to SwiftData
    if let existingProfile = currentProfile {
      existingProfile.updateProfileImage(with: imageData)
    } else {
      let newProfile = UserProfile(profileImageData: imageData)
      modelContext.insert(newProfile)
    }

    do {
      try modelContext.save()
      print("Profile image synced from Firebase to SwiftData")
      loadProfileImage()
    } catch {
      print("Failed to save synced image: \(error)")
    }
  }

  func removeProfileImage() async {
    do {
      //1. remove image from the SwiftData
      if let existingProfile = currentProfile {
        existingProfile.updateProfileImage(with: nil)
        try modelContext.save()
        selectedImage = nil
        print("Image removed successfully!")

        //2. remove image from the firestore storage and database
        guard let userId = Auth.auth().currentUser?.uid else {
          print("No authenticated user found")
          return
        }
        _ = await UserManager.shared.deleteProfileImage(userId: userId)
      }
    } catch {
      print("Failed to remove image: \(error)")
    }
  }
}
