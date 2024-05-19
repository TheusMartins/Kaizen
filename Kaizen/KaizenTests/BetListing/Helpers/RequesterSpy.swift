//
//  RequesterSpy.swift
//  KaizenTests
//
//  Created by Scizor on 5/18/24.
//

@testable import Kaizen
import Foundation

final class RequesterSpy: Requester {
    var invokedRequest = false
    var invokedRequestCount = 0
    var invokedRequestParameters: RequestInfos?
    var invokedRequestParametersList = [RequestInfos]()
    var stubbedRequestResult: RequestSuccessResponse!
    var stubbedRequestError: Error?
    var shouldThrowError = false

    func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse {
        invokedRequest = true
        invokedRequestCount += 1
        invokedRequestParameters = infos
        invokedRequestParametersList.append(infos)

        if shouldThrowError {
            throw stubbedRequestError ?? NSError(domain: "TestError", code: 0, userInfo: nil)
        }
        return stubbedRequestResult
    }
}
