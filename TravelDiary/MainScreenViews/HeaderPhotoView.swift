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
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 375, height: 400)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Select a header photo")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                            }
                        )
                        .padding()
                }
            } else {
                ZStack(alignment: .bottomTrailing) {
                    if let image = headerPhotoViewModel.images.first {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 375, height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
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
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.white)
                    }
                    .padding(.bottom, 20)
                    .padding(.trailing, 20)
                }
                .padding(12)
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
