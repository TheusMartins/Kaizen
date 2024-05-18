//
//  BetListingController..swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

final class BetListingController: UIViewController {
    
    private lazy var customView: BetListingView = {
        let view = BetListingView(viewModel: .init(bets: []))
        return view
    }()
    
    private let viewModel: BetListingViewModel
    
    init(viewModel: BetListingViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = customView
        customView.setLoading(isLoading: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        Task { await viewModel.getBets() }
    }
}

extension BetListingController: BetListingViewModelDelegate {
    func stateDidChange(state: BetListingViewModel.State) {
        switch state {
        case .didLoad(let bets):
            let uiModel = bets.map { bet in
                return BetListingView.ViewModel.Bet.init(sportName: bet.sportName, events: bet.activeEvents.map({ eventModel in
                    return BetListingCell.ViewModel(eventName: eventModel.eventName, timeToStartStart: eventModel.eventStartTime)
                }))
            }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                customView.setLoading(isLoading: false)
                customView.viewModel = .init(bets: uiModel)
            }
        case .didFailOnLoad(let feedbackMessage):
            let alert = UIAlertController(title: feedbackMessage, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Try again", style: .cancel) { [weak self] _ in
                self?.setupViewModel()
            }
            alert.addAction(alertAction)
            navigationController?.present(alert, animated: true, completion: nil)
        }
    }
}
