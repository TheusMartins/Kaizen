//
//  BetListingViewModelTests.swift
//  KaizenTests
//
//  Created by Scizor on 5/18/24.
//

import XCTest
@testable import Kaizen

final class BetListingViewModelTests: XCTestCase {
    var viewModel: BetListingViewModel!
    var repositorySpy: BetListingRepositorySpy!
    var delegateSpy: BetListingViewModelDelegateSpy!

    override func setUp() {
        super.setUp()
        repositorySpy = BetListingRepositorySpy()
        delegateSpy = BetListingViewModelDelegateSpy()
        viewModel = BetListingViewModel(repository: repositorySpy)
        viewModel.delegate = delegateSpy
    }

    override func tearDown() {
        viewModel = nil
        repositorySpy = nil
        delegateSpy = nil
        super.tearDown()
    }

    func testGetBets_Success() async {
        // Given: A successful response setup in the repository spy
        let expectedModels = [BetListingModel(sportName: "Football", activeEvents: [BetEventsModel(eventName: "Match 1", eventStartTime: 123456789, id: "1")])]
        repositorySpy.stubbedGetBetsResult = expectedModels

        // When: getBets is called
        await viewModel.getBets()

        // Then: The delegate is notified of the successful state change
        XCTAssertTrue(delegateSpy.invokedStateDidChange)
        XCTAssertEqual(delegateSpy.invokedStateDidChangeCount, 1)
        guard case .didLoad(let bets) = delegateSpy.invokedStateDidChangeParameters?.state else {
            XCTFail("Expected .didLoad state")
            return
        }
        XCTAssertEqual(bets.count, expectedModels.count)
    }

    func testGetBets_Failure() async {
        // Given: A setup where the repository will throw an error
        repositorySpy.shouldThrowError = true

        // When: getBets is called
        await viewModel.getBets()

        // Then: The delegate is notified of the failure state change
        XCTAssertTrue(delegateSpy.invokedStateDidChange)
        XCTAssertEqual(delegateSpy.invokedStateDidChangeCount, 1)
        guard case .didFailOnLoad(let feedbackMessage) = delegateSpy.invokedStateDidChangeParameters?.state else {
            XCTFail("Expected .didFailOnLoad state")
            return
        }
        XCTAssertNotNil(feedbackMessage)
        XCTAssertEqual(feedbackMessage, "We could not load Bets, please try again later =(")
    }
}
