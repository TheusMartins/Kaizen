//
//  BetListingViewModel.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation

/// Defines the delegate protocol for `BetListingViewModel`.
/// The delegate is notified of state changes in the view model, such as successful data loading or errors.
protocol BetListingViewModelDelegate: AnyObject {
    /// Notifies the delegate of a state change in the view model.
    /// - Parameter state: The new state of the view model.
    func stateDidChange(state: BetListingViewModel.State)
}

/// `BetListingViewModel` is responsible for fetching and managing the data for a list of bets,
/// and notifying its delegate of any state changes.
final class BetListingViewModel {
    // MARK: - Private Properties
    
    /// The repository responsible for fetching the bets data.
    private let repository: BetListingRepository
    
    // MARK: - Open Properties
    
    /// Represents the possible states of the view model.
    enum State {
        case didLoad(bets: [BetListingModel]) // Indicates that bets have been successfully loaded.
        case didFailOnLoad(feedbackMessage: String) // Indicates that loading bets failed with an error message.
    }
    
    /// The delegate that will be notified of state changes.
    weak var delegate: BetListingViewModelDelegate?
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `BetListingViewModel`.
    /// - Parameter repository: The repository used to fetch bets data. Defaults to `BetListingRepositoryImplementation`.
    init(repository: BetListingRepository = BetListingRepositoryImplementation()) {
        self.repository = repository
    }
    
    // MARK: - Open Methods
    
    /// Fetches the bets asynchronously from the repository and notifies the delegate of the outcome.
    func getBets() async {
        do {
            // Attempt to fetch the bets from the repository.
            let betsModel = try await repository.getBets()
            // Notify the delegate that bets have been loaded successfully.
            delegate?.stateDidChange(state: .didLoad(bets: betsModel))
        } catch {
            // Notify the delegate that loading bets failed with an error message.
            delegate?.stateDidChange(state: .didFailOnLoad(feedbackMessage: "We could not load Bets, please try again later =("))
        }
    }
}
