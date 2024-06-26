//
//  RequestInfos.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RequestInfos {
    
    var baseURL: URL? { get }
    
    var endpoint: String { get }
    
    var method: HTTPMethod { get }
    
    var parameters: [String: Any]? { get }

}

 extension RequestInfos {
    var baseURL: URL? {
        return URL(string: "https://618d3aa7fe09aa001744060a.mockapi.io/api/sports")!
    }
}

