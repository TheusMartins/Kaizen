//
//  Requester.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation

protocol Requester {
    func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse
}

final class DefaultRequester: Requester {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse {
        guard let request = buildURLRequest(basedOn: infos) else {
            throw BaseRequestErrors.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            return .init(data: data, response: response)
        } catch {
            throw BaseRequestErrors.invalidResponse
        }
    }
    
    // MARK: Helpers
    
    private func buildURLRequest(basedOn infos: RequestInfos) -> URLRequest? {
        guard let baseURL = infos.baseURL, var url = URLComponents(string: "\(baseURL)\(infos.endpoint)") else {
            return nil
        }
        
        var components: [URLQueryItem] = []
        
        infos.parameters?.forEach({ key, value in
            components.append(URLQueryItem(name: key, value: "\(value)"))
        })
        
        url.queryItems = components
        
        guard let finalURL = url.url else {
            return nil
        }
        
        return URLRequest(url: finalURL)
    }
}
