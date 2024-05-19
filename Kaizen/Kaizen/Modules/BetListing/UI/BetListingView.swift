//
//  BetListingView.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

protocol BetListingViewDelegate: AnyObject {
    func didTriggerAction(action: BetListingView.Actions)
}

/**
 `BetListingView` is responsible for displaying a list of bets. It supports toggling the visibility of bet sections and marking bets as favorite.
 */
final class BetListingView: UIView {
    // MARK: - ViewModel
    struct ViewModel {
        var bets: [Bet]
        
        struct Bet {
            let sportName: String
            var events: [BetListingCell.ViewModel]
            var isCollapsed: Bool = false
        }
        
        /// Sorts the events within each bet, putting favorites first.
        mutating func sortEventsPuttingFavoritesFirst() {
            for index in bets.indices {
                bets[index].events.sort { $0.isFavorite && !$1.isFavorite }
            }
        }
    }
    
    enum Actions {
        // Define actions here
    }
    
    // MARK: - Properties
    weak var delegate: BetListingViewDelegate?
    
    var viewModel: BetListingView.ViewModel {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var timer: Timer?
    
    private lazy var spinnerLoader: SpinnerLoader = {
        let loader = SpinnerLoader()
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .darkGray
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BetListingCell.self, forCellReuseIdentifier: BetListingCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Initialization
    init(viewModel: BetListingView.ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    /// Sets the loading state of the view, showing or hiding the spinner loader accordingly.
    func setLoading(isLoading: Bool) {
        spinnerLoader.isHidden = !isLoading
        tableView.isHidden = isLoading
        isLoading ? spinnerLoader.startAnimation() : spinnerLoader.stopAnimating()
    }
    
    /// Toggles the collapsed state of a section.
    private func toggleSection(_ section: Int) {
        viewModel.bets[section].isCollapsed.toggle()
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: section), with: .none)
        }
    }
    
    /// Toggles the favorite state of an event and sorts the events list.
    func toggleFavorite(forEventAt indexPath: IndexPath) {
        viewModel.bets[indexPath.section].events[indexPath.row].isFavorite.toggle()
        viewModel.sortEventsPuttingFavoritesFirst()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    /// Updates the countdown for all visible cells.
    @objc func updateCountdown() {
        for cell in tableView.visibleCells as! [BetListingCell] {
            if let indexPath = tableView.indexPath(for: cell) {
                let viewModel = viewModel.bets[indexPath.section].events[indexPath.row]
                cell.updateWith(viewModel: viewModel)
            }
        }
    }
}

// MARK: - ViewConfiguration
extension BetListingView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(spinnerLoader)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .tableViewTopBottomPadding),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.tableViewTopBottomPadding),
            
            spinnerLoader.heightAnchor.constraint(equalToConstant: .spinnerLoaderSize),
            spinnerLoader.widthAnchor.constraint(equalToConstant: .spinnerLoaderSize),
            spinnerLoader.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinnerLoader.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configureViews() {
        backgroundColor = .darkGray
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
}

extension BetListingView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.bets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bets[section].isCollapsed ? 0 : viewModel.bets[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BetListingCell.reuseIdentifier, for: indexPath) as? BetListingCell else {
            return UITableViewCell()
        }
        
        cell.setupWith(viewModel: viewModel.bets[indexPath.section].events[indexPath.row])
        return cell
    }
}

extension BetListingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderView(headerTitle: viewModel.bets[section].sportName)
        header.didTapHeader = { [weak self] in
            guard let self else { return }
            toggleSection(section)
        }
        header.setCollapsed(viewModel.bets[section].isCollapsed)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleFavorite(forEventAt: indexPath)
    }
}

// MARK: - Constants
private extension CGFloat {
    static let tableViewTopBottomPadding: CGFloat = 24.0
    static let spinnerLoaderSize: CGFloat = 56.0
}
