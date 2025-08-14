//
//  HeaderPhotoViewModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 14/08/25.
//

import Foundation
import Observation
import PhotosUI
import SwiftUI

@Observable
class HeaderPhotoViewModel {
    var selectedPhotos : [PhotosPickerItem] = []
    var images = [UIImage]()
    
    func convertDataToImage(){
        images.removeAll()
        if !selectedPhotos.isEmpty{
            for eachItem in selectedPhotos{
                Task {
                    if let imageData = try? await
                        eachItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: imageData) {
                            images.append(image)
                        }
                    }
                }
            }
        }
    }
}
