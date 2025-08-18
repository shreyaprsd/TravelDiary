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

    var body: some View {
        VStack {
            if headerPhotoViewModel.images.isEmpty {
                PhotosPicker(
                    selection: $headerPhotoViewModel.selectedPhotos,
                    maxSelectionCount: 1,
                    matching: .images
                ) {
                    Text("Select a header photo")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            } else {
                if let image = headerPhotoViewModel.images.first {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                        .onAppear {
                            selectedImageData = image.jpegData(
                                compressionQuality: 0.8
                            )
                        }
                }

                PhotosPicker(
                    selection: $headerPhotoViewModel.selectedPhotos,
                    maxSelectionCount: 1,
                    matching: .images
                ) {
                    Text("Change Photo")
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                }
            }
        }
        .onChange(of: headerPhotoViewModel.selectedPhotos) { _, _ in
            Task {
                await headerPhotoViewModel.convertDataToImage()
            }
        }

        .onAppear {
            if let existingImageData = selectedImageData,
                let existingImage = UIImage(data: existingImageData)
            {
                headerPhotoViewModel.images = [existingImage]
            }
        }
    }
}
