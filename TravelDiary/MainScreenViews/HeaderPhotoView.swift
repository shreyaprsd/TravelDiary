//
//  HeaderPhotoView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 14/08/25.
//

import PhotosUI
import SwiftUI

struct HeaderPhotoView: View {
  @State private var headerPhotoViewModel = HeaderPhotoViewModel()
  @Binding var selectedImageData: Data?
  var isEditing = false
  var body: some View {
    VStack {
      if headerPhotoViewModel.images.isEmpty {
        PhotosPicker(
          selection: $headerPhotoViewModel.selectedPhotos,
          maxSelectionCount: 1,
          matching: .images
        ) {
          RoundedRectangle(cornerRadius: 25)
            .fill(Color.gray.opacity(0.1))
            .frame(width: 402, height: 311)
            .overlay(
              Text("Select a header photo")
                .font(.headline)
            )
        }
      } else {
        ZStack(alignment: .center) {
          if let image = headerPhotoViewModel.images.first {
            Image(uiImage: image)
              .resizable()
              .frame(width: 402, height: 211)
              .clipShape(RoundedRectangle(cornerRadius: 25))
              .blur(radius: isEditing ? 5 : 0)
              .onAppear {
                selectedImageData = image.jpegData(
                  compressionQuality: 0.8
                )
              }
          }

          if isEditing {
            PhotosPicker(
              selection: $headerPhotoViewModel.selectedPhotos,
              maxSelectionCount: 1,
              matching: .images
            ) {
              HStack {
                Image(systemName: "photo.badge.plus")
                  .font(.system(size: 20))
                Text("Update Image")
                  .font(.headline)
              }
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .foregroundStyle(Color.white)
              .background(Color.blue)
              .clipShape(RoundedRectangle(cornerRadius: 16))
            }
          }
        }
      }
    }
    .onChange(of: headerPhotoViewModel.selectedPhotos) { _, _ in
      Task {
        await headerPhotoViewModel.convertDataToImage()
        if let image = headerPhotoViewModel.images.first {
          selectedImageData = image.jpegData(compressionQuality: 0.8)
        }
      }
    }

    .task(id: selectedImageData) {
      if let existingImageData = selectedImageData,
        let existingImage = UIImage(data: existingImageData)
      {
        headerPhotoViewModel.images = [existingImage]
      }
    }
  }
}

#Preview {
  HeaderPhotoView(selectedImageData: .constant(nil), isEditing: false)
}
