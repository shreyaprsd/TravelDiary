//
//  Tips.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 25/08/25.
//

import TipKit

struct HelperTips : Tip  {

    var title : Text {
        Text("Enter ")
    }
    var message: Text?  {
        Text("Enter expenses to view changes in the fiscal details")
    }
    var image : Image? {
        Image(systemName: "square.and.arrow.down")
    }

}
