//
//  BetListingViewModel.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import Foundation

protocol BetListingViewModelDelegate: AnyObject {
    func stateDidChange(state: BetListingViewModel.State)
}

public final class BetListingViewModel {
    // MARK: - Private properties
    
    private let repository: BetListingRepository
    
    // MARK: - Open properties
    
    enum State {
        case didLoad(bets: [BetListingModel])
        case didFailOnLoad(feedbackMessage: String)
    }
    
    weak var delegate: BetListingViewModelDelegate?
    
    // MARK: - Initialization
    
    init(repository: BetListingRepository = BetListingRepositoryImplementation()) {
        self.repository = repository
    }
    
    // MARK: - Open methods
    
    func getBets() async {
        do {
            let betsModel = try await repository.getBets()
            delegate?.stateDidChange(state: .didLoad(bets: betsModel))
        } catch {
            delegate?.stateDidChange(state: .didFailOnLoad(feedbackMessage: "We could not load Bets, please try again later =("))
        }
    }
}

