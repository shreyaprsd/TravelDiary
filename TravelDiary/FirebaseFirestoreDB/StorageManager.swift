//
//  StorageManager.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 14/10/25.
//
import FirebaseStorage
import Foundation

class StorageManager {
  static let shared = StorageManager()
  private let storage = Storage.storage()

  private init() {}

  //upload the image and return url
  func uploadProfileImage(imageData: Data) async throws -> String {

    //reference to the file location
    let storageRef = storage.reference()
    let profileImageRef = storageRef.child(
      "profileImages/\(UUID().uuidString).jpg")

    //setting up of metadata
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"

    // upload the image
    _ = try await profileImageRef.putDataAsync(
      imageData, metadata: metadata)

    // download the url
    let downloadURL = try await profileImageRef.downloadURL()
    return downloadURL.absoluteString
  }

  //delete the image if needed
  func deleteImage(imageURL: String) async throws {
    let storageRef = storage.reference(forURL: imageURL)
    _ = try await storageRef.delete()
    print("Successfully deleted from storage")
  }

  func uploadTripHeaderImage(imageData: Data, tripId: String) async throws
    -> String
  {
    let storageRef = storage.reference()
    let imageRef = storageRef.child("headerImages/\(tripId).jpg")

    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"

    _ = try await imageRef.putDataAsync(imageData, metadata: metadata)

    let downloadURL = try await imageRef.downloadURL()
    return downloadURL.absoluteString
  }

  func deleteTripHeaderImage(tripId: String) async throws {
    let storageRef = storage.reference()
    let imageRef = storageRef.child("headerImages/\(tripId).jpg")
    try await imageRef.delete()
  }
}
