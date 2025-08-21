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
                }
            } else {
                ZStack(alignment: .bottomTrailing) {
                    if let image = headerPhotoViewModel.images.first {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                            .ignoresSafeArea(edges: .top)
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
                            .foregroundColor(.white)
                    }
                    .padding(24)
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
