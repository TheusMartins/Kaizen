//
//  BetListingRepositoryTests.swift
//  KaizenTests
//
//  Created by Scizor on 5/18/24.
//

import XCTest
@testable import Kaizen

final class BetListingRepositoryTests: XCTestCase {
    var requesterSpy: RequesterSpy!
    var repository: BetListingRepositoryImplementation!

    override func setUp() {
        super.setUp()
        requesterSpy = RequesterSpy()
        repository = BetListingRepositoryImplementation(requester: requesterSpy)
    }

    override func tearDown() {
        requesterSpy = nil
        repository = nil
        super.tearDown()
    }

    func testGetBets_SuccessfulRequestAndParsing() async {
        // Given: A successful response setup
        let expectedModels = [BetListingModel(sportName: "Test", activeEvents: [])]
        let responseData = try! JSONEncoder().encode(expectedModels)
        requesterSpy.stubbedRequestResult = RequestSuccessResponse(data: responseData, response: URLResponse())

        // When: getBets is called
        do {
            let models = try await repository.getBets()

            // Then: The models are successfully returned
            XCTAssertEqual(models.count, expectedModels.count)
        } catch {
            XCTFail("Expected successful parsing, but got error: \(error)")
        }
    }

    func testGetBets_RequestFailsWithError() async {
        // Given: A setup where the request will fail
        requesterSpy.shouldThrowError = true
        requesterSpy.stubbedRequestError = BaseRequestErrors.invalidResponse

        // When: getBets is called
        do {
            _ = try await repository.getBets()
            XCTFail("Expected an error to be thrown, but getBets succeeded")
        } catch {
            XCTAssertEqual((error as? BaseRequestErrors), .invalidResponse)
        }
    }

    func testGetBets_ParsingFailsWithError() async {
        // Given: A setup where parsing will fail (invalid JSON for example)
        let invalidJSONData = "invalid JSON".data(using: .utf8)!
        requesterSpy.stubbedRequestResult = RequestSuccessResponse(data: invalidJSONData, response: URLResponse())

        // When: getBets is called
        do {
            _ = try await repository.getBets()
            XCTFail("Expected a parsing error, but getBets succeeded")
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
    }
}
