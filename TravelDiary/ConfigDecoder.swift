//
//  ConfigDecoder.swift
//  TravelDiary
//
//  Created by Shreya Prasad on 22/08/25.
//

import Foundation

enum Config {
    static var exchangeAPIKey : String {
        guard let key = Bundle.main.infoDictionary?["EXCHANGE_API_KEY"] as? String else {
            fatalError("Exchange rate API key not found in Config.xcconfig")
        }
        return key 
    }
}
