//
//  BetListingRepositorySpy.swift
//  KaizenTests
//
//  Created by Scizor on 5/18/24.
//

@testable import Kaizen
import Foundation

final class BetListingRepositorySpy: BetListingRepository {
    var invokedGetBets = false
    var invokedGetBetsCount = 0
    var shouldThrowError = false
    var stubbedGetBetsResult: [BetListingModel] = []

    func getBets() async throws -> [BetListingModel] {
        invokedGetBets = true
        invokedGetBetsCount += 1
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        return stubbedGetBetsResult
    }
}
