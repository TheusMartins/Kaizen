//
//  BetListingModel.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation

struct BetListingModel : Codable {
    let sportName: String
    let activeEvents: [BetEventsModel]
    
    enum CodingKeys: String, CodingKey {
        case sportName = "d"
        case activeEvents = "e"
    }
}

struct BetEventsModel: Codable {
    let eventName: String
    let eventStartTime: Int
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case eventName = "d"
        case eventStartTime = "tt"
        case id = "i"
    }
}
