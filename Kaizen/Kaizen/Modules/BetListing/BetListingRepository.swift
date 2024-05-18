//
//  BetListingRepository.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation
import Network

protocol BetListingRepository {
    func getBets() async throws -> [BetListingModel]
}

final class BetListingRepositoryImplementation: BetListingRepository {
    // MARK: - Private properties
    
    private var requester: Requester
    
    // MARK: - Initialization
    
    init(requester: Requester = DefaultRequester()) {
        self.requester = requester
    }
    
    // MARK: - Open methods
    
    func getBets() async throws -> [BetListingModel] {
        let response = try await requester.request(basedOn: BetListingRequest.getBets)
        return try await parseBetsResponse(response: response)
    }
    
    // MARK: - Private methods
    
    private func parseBetsResponse(response: RequestSuccessResponse) async throws -> [BetListingModel] {
        do {
            let model = try JSONDecoder().decode([BetListingModel].self, from: response.data)
            return model
        } catch {
            throw error
        }
    }
}

