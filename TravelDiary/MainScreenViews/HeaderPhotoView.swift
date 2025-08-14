//
//  HeaderPhotoView.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 14/08/25.
//

import SwiftUI
import PhotosUI

struct HeaderPhotoView: View {
    @State var viewModel = HeaderPhotoViewModel()
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                LazyHGrid(rows: [GridItem(.fixed(300))]){
                    ForEach(0..<viewModel.images.count, id: \.self){ index in
                        Image(uiImage: viewModel.images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)
                    }
                    .padding()
                }.onChange(of: viewModel.selectedPhotos) { viewModel.convertDataToImage()
                }
                
            }
            PhotosPicker(
                "Select a header photo",
                selection: $viewModel.selectedPhotos,
                maxSelectionCount: 4,
                selectionBehavior: .ordered,
                matching: .images,
            )
            .buttonStyle(.bordered)
        }
        Spacer()
    }

}

#Preview {
    HeaderPhotoView()
}
