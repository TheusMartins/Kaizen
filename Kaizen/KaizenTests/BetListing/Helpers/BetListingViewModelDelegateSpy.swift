//
//  BetListingViewModelDelegateSpy.swift
//  KaizenTests
//
//  Created by Scizor on 5/18/24.
//

@testable import Kaizen
import Foundation

// Assuming the existence of BetListingViewModel and its State enum somewhere in your project
final class BetListingViewModelDelegateSpy: BetListingViewModelDelegate {
    var invokedStateDidChange = false
    var invokedStateDidChangeCount = 0
    var invokedStateDidChangeParameters: (state: BetListingViewModel.State, Void)?
    var invokedStateDidChangeParametersList = [(state: BetListingViewModel.State, Void)]()

    func stateDidChange(state: BetListingViewModel.State) {
        invokedStateDidChange = true
        invokedStateDidChangeCount += 1
        invokedStateDidChangeParameters = (state, ())
        invokedStateDidChangeParametersList.append((state, ()))
    }
}
