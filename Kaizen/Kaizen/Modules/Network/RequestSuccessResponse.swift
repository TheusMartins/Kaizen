//
//  RequestSuccessResponse.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation

struct RequestSuccessResponse {
    let data: Data
    let response: URLResponse
    
    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }
}

