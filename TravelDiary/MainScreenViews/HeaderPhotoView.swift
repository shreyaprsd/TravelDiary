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
          UnevenRoundedRectangle(
            cornerRadii: .init(
              topLeading: 0,
              bottomLeading: 12,
              bottomTrailing: 12,
              topTrailing: 0
            )
          )
          .fill(Color(hex: "D9D9D9"))
          .overlay(
            Text("Select a header photo")
              .font(.subheadline)
          )
        }
      } else {
        ZStack(alignment: .center) {
          if let image = headerPhotoViewModel.images.first {
            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .clipShape(
                UnevenRoundedRectangle(
                  cornerRadii: .init(
                    topLeading: 0,
                    bottomLeading: 12,
                    bottomTrailing: 12,
                    topTrailing: 0
                  ))
              )
              .blur(radius: isEditing ? 10 : 0)
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
                  .font(.system(size: 15))
                Text("Update Image")
                  .font(.subheadline)
                  .fontWeight(.regular)
                  .lineSpacing(20)
              }
              .padding(.top, 7)
              .padding(.bottom, 7)
              .padding(.leading, 14)
              .padding(.trailing, 14)
              .foregroundStyle(Color.white)
              .background(Color.blue)
              .clipShape(RoundedRectangle(cornerRadius: 40))
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

    .onChange(of: selectedImageData) {
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
