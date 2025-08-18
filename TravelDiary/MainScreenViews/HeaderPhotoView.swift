//
//  HeaderPhotoView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 14/08/25.
//

import PhotosUI
import SwiftUI

struct HeaderPhotoView: View {
    @State var viewModel = HeaderPhotoViewModel()
    var body: some View {
        VStack {
            PhotosPicker(
                "Select a header photo",
                selection: $viewModel.selectedPhotos,
                maxSelectionCount: 1,
                selectionBehavior: .ordered,
                matching: .images,
            )
            .buttonStyle(.bordered)
            ScrollView {
                LazyHGrid(rows: [GridItem(.fixed(100))]) {
                    ForEach(0..<viewModel.images.count, id: \.self) { index in
                        Image(uiImage: viewModel.images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                }.onChange(of: viewModel.selectedPhotos) {
                    viewModel.convertDataToImage()
                }

            }
        }
    }

}

#Preview {
    HeaderPhotoView()
}
