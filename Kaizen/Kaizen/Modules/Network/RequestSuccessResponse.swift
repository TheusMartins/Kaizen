//
//  RequestSuccessResponse.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation

public struct RequestSuccessResponse {
    public let data: Data
    public let response: URLResponse
    
    public init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }
}

