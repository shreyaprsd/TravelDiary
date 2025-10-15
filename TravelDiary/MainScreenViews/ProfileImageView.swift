//
//  ProfileImageView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 15/08/25.
//

import FirebaseAuth
import PhotosUI
import SwiftData
import SwiftUI

struct ProfileImageView: View {

  @Environment(\.modelContext) private var modelContext
  @Query(
    filter: #Predicate<UserProfile> { profile in
      profile.id == "main_profile"
    }
  ) private var userProfiles: [UserProfile]

  @State private var selectedImage: UIImage? = nil
  @State private var photosPickerItem: PhotosPickerItem? = nil
  @State private var showingImagePicker = false
  @State var editingPhotoAlert = false
  private var currentProfile: UserProfile? {
    return userProfiles.first
  }

  var body: some View {
    VStack(spacing: 20) {
      ZStack(alignment: .bottomTrailing) {
        if let selectedImage = selectedImage {
          Image(uiImage: selectedImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120, height: 120)
            .clipShape(Circle())
        } else {
          Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .foregroundStyle(.gray)
        }

        Button(action: {
          editingPhotoAlert = true
        }) {
          Image(systemName: "pencil.circle.fill")
            .font(.title2)
            .foregroundStyle(Color.blue)
            .background(Color.white)
            .clipShape(Circle())
        }
        .offset(x: -5, y: -5)
      }
      .padding(10)
    }
    .alert(
      "Edit ProfileImage",
      isPresented: $editingPhotoAlert,
      actions: {
        Button("Change") {
          showingImagePicker = true
        }
        Button("Remove") {
          Task {
            await removeProfileImage()
          }
        }
      }
    )
    .padding()
    .navigationTitle("Profile")
    .photosPicker(
      isPresented: $showingImagePicker,
      selection: $photosPickerItem,
      matching: .images
    )
    .onChange(of: photosPickerItem) { oldValue, newValue in
      Task {
        if let newValue = newValue {
          if let data = try? await newValue.loadTransferable(
            type: Data.self
          ) {
            if let uiImage = UIImage(data: data) {
              selectedImage = uiImage
              await saveProfileImageAutomatically(image: uiImage)
            }
          }
        }
        photosPickerItem = nil
      }
    }
    .onAppear {
      loadProfileImage()
    }
  }

  private func saveProfileImageAutomatically(image: UIImage) async {

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

  private func loadProfileImage() {
    guard let profile = currentProfile,
      let imageData = profile.profileImageData
    else {
      selectedImage = nil
      return
    }

    selectedImage = UIImage(data: imageData)
  }

  private func removeProfileImage() async {
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

#Preview {
  NavigationStack {
    ProfileImageView()
  }
  .modelContainer(for: UserProfile.self, inMemory: true)
}
