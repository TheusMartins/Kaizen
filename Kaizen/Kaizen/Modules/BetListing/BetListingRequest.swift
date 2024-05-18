//
//  BetListingRequest.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation

enum BetListingRequest {
    case getBets
}

extension BetListingRequest: RequestInfos {
    var endpoint: String {
        return ""
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: [String : Any]? {
        nil
    }
}
