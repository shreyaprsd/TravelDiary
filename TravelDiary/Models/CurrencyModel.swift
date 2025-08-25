//
//  CurrencyModel.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 19/08/25.
//

import Foundation

struct CurrencyModel: Codable {
    let result: String
    let timeLastUpdateUTC: String
    let  baseCode, targetCode: String
    let conversionRate: Double

    enum CodingKeys: String, CodingKey {
        case result
        case timeLastUpdateUTC = "time_last_update_utc"
        case baseCode = "base_code"
        case targetCode = "target_code"
        case conversionRate = "conversion_rate"
    }
}
