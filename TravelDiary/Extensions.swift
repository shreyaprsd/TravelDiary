//
//  Extensions.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 18/08/25.
//

extension Double {
    var twoDecimalString: String {
        return String(format: "%.2f", self)
    }

    var twoDecimalPlacesNoTrailingZeros: String {
        let rounded = (self * 100).rounded() / 100
        return String(format: "%g", rounded)
    }

}
