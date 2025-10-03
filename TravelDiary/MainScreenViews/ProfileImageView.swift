//
//  ProfileImageView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 15/08/25.
//

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
          removeProfileImage()
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

    do {
      if let existingProfile = currentProfile {
        existingProfile.updateProfileImage(with: imageData)
      } else {
        let newProfile = UserProfile(profileImageData: imageData)
        modelContext.insert(newProfile)
      }

      try modelContext.save()
      print("Image automatically saved!")

    } catch {
      print("Failed to auto-save image: \(error)")
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

  private func removeProfileImage() {
    do {
      if let existingProfile = currentProfile {
        existingProfile.updateProfileImage(with: nil)
        try modelContext.save()
        selectedImage = nil
        print("Image removed successfully!")
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
