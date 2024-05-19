//
//  BetListingController..swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

/// `BetListingController` is responsible for managing the view that displays a list of betting options.
/// It interacts with a view model to fetch and display bets, handling state changes and user interactions.
final class BetListingController: UIViewController {
    
    // MARK: - Properties
    
    /// The custom view that displays the list of bets.
    private lazy var customView: BetListingView = {
        let view = BetListingView(viewModel: .init(bets: []))
        return view
    }()
    
    /// The view model that manages the business logic of the bet listing.
    private let viewModel: BetListingViewModel
    
    // MARK: - Initialization
    
    /// Initializes a new instance of the controller with an optional view model.
    /// - Parameter viewModel: The view model for managing bet listing logic. Defaults to a new instance if not provided.
    init(viewModel: BetListingViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = customView
        customView.setLoading(isLoading: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    // MARK: - Setup
    
    /// Sets up the view model, including fetching bets and handling state changes.
    private func setupViewModel() {
        viewModel.delegate = self
        Task { await viewModel.getBets() }
    }
}

// MARK: - BetListingViewModelDelegate

extension BetListingController: BetListingViewModelDelegate {
    
    /// Handles state changes from the view model, updating the UI accordingly.
    /// - Parameter state: The current state of the bet listing, including loaded bets or an error state.
    func stateDidChange(state: BetListingViewModel.State) {
        switch state {
        case .didLoad(let bets):
            // Map the loaded bets to the view model format expected by the custom view.
            let uiModel = bets.map { bet in
                BetListingView.ViewModel.Bet(sportName: bet.sportName, events: bet.activeEvents.map { eventModel in
                    BetListingCell.ViewModel(eventName: eventModel.eventName, timeToStartStart: eventModel.eventStartTime)
                })
            }
            // Update the UI on the main thread.
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.customView.setLoading(isLoading: false)
                self.customView.viewModel = .init(bets: uiModel)
            }
        case .didFailOnLoad(let feedbackMessage):
            // Present an alert on failure, offering a retry option.
            let alert = UIAlertController(title: feedbackMessage, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Try again", style: .cancel) { [weak self] _ in
                self?.setupViewModel()
            }
            alert.addAction(alertAction)
            navigationController?.present(alert, animated: true, completion: nil)
        }
    }
}
