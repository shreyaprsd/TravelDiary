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

  @State private var viewModel: ProfileImageViewModel?
  private var currentProfile: UserProfile? {
    return userProfiles.first
  }

  var body: some View {
    VStack(spacing: 20) {
      ZStack(alignment: .bottomTrailing) {
        if let selectedImage = viewModel?.selectedImage {
          Image(uiImage: selectedImage)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
        } else {
          Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .foregroundStyle(.gray)
        }

        Button(action: {
          viewModel?.editingPhotoAlert = true
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
      isPresented: Binding(
        get: { viewModel?.editingPhotoAlert ?? false },
        set: { viewModel?.editingPhotoAlert = $0 }
      ),
      actions: {
        Button("Change") {
          viewModel?.showingImagePicker = true
        }
        Button("Remove") {
          Task {
            await viewModel?.removeProfileImage()
          }
        }
      }
    )
    .padding()
    .navigationTitle("Profile")
    .photosPicker(
      isPresented: Binding(
        get: { viewModel?.showingImagePicker ?? false },
        set: { viewModel?.showingImagePicker = $0 }
      ),
      selection: Binding(
        get: { viewModel?.photosPickerItem },
        set: { viewModel?.photosPickerItem = $0 }
      ),
      matching: .images
    )
    .onChange(of: viewModel?.photosPickerItem) { oldValue, newValue in
      Task {
        if let newValue = newValue {
          if let data = try? await newValue.loadTransferable(
            type: Data.self)
          {
            if let uiImage = UIImage(data: data) {
              viewModel?.selectedImage = uiImage
              await viewModel?.saveProfileImageAutomatically(
                image: uiImage)
            }
          }
        }
        viewModel?.photosPickerItem = nil
      }
    }
    .onAppear {
      if viewModel == nil {
        viewModel = ProfileImageViewModel(
          modelContext: modelContext, currentProfile: currentProfile)
        viewModel?.loadProfileImage()

        // If no image in SwiftData, sync from Firebase
        if viewModel?.selectedImage == nil {
          Task {
            await viewModel?.syncProfileImageFromFirebase()
          }
        }
      }
    }
    .onChange(of: currentProfile) { _, newValue in
      viewModel?.currentProfile = newValue
      viewModel?.loadProfileImage()
    }
  }
}

#Preview {
  NavigationStack {
    ProfileImageView()
  }
  .modelContainer(for: UserProfile.self, inMemory: true)
}
