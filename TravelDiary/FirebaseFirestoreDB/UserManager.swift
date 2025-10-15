//
//  UserManager.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 13/10/25.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class UserManager {
  static let shared = UserManager()
  private let db = Firestore.firestore()

  private init() {}

  func createUserDocument(for user: User) async {
    let userRef = db.collection("users").document(user.uid)
    do {
      try await userRef.setData(
        [
          "id": user.uid,
          "displayName": user.displayName ?? "",
        ], merge: true)
      print("User document created \(user.uid)")
    } catch {
      print(error.localizedDescription)
    }
  }

  func saveProfileImage(userId: String, imageData: Data) async {
    do {
      //upload to firebase storage
      let imageURL = try await StorageManager.shared.uploadProfileImage(
        imageData: imageData)
      print("Image uploaded to storage with url \(imageURL)")

      // save url to the database
      let profileRef = db.collection("users")
        .document(userId)
        .collection("profile")
        .document("profileImage")

      try await profileRef.setData(
        [
          "id": "main_profile",
          "image_url": imageURL,
          "updated_at": Timestamp(date: Date()),
        ], merge: true)
      print("url saved to database")
    } catch {
      print("\(error.localizedDescription)")

    }
  }

  func deleteProfileImage(userId: String) async {
    do {

      let profileRef = db.collection("users")
        .document(userId)
        .collection("profile")
        .document("profileImage")

      print("Fetching document at path: \(profileRef.path)")

      let document = try await profileRef.getDocument()

      if let imageURL = document.data()?["image_url"] as? String {

        print("Found image URL: \(imageURL)")

        try await StorageManager.shared.deleteImage(imageURL: imageURL)
        print("Image deleted from storage")
      } else {
        print("WARNING: No image_url found in document")
      }

      try await profileRef.delete()
      print("image document deleted from database")
    } catch {

      print("Error in deleteProfileImage: \(error.localizedDescription)")

    }
  }
}
