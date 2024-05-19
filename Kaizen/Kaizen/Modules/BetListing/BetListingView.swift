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

final class BetListingView: UIView {
    struct ViewModel {
        var bets: [Bet]
        
        struct Bet {
            let sportName: String
            var events: [BetListingCell.ViewModel]
            var isCollapsed: Bool = false
        }
        
        mutating func sortEventsPuttingFavoritesFirst() {
            for index in bets.indices {
                bets[index].events.sort { $0.isFavorite && !$1.isFavorite }
            }
        }
    }
    
    enum Actions {
        
    }
    
    // MARK: - Open properties
    
    weak var delegate: BetListingViewDelegate?
    
    var viewModel: BetListingView.ViewModel {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Private properties
    
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
    
    //MARK: - Initialization
    init(
        viewModel: BetListingView.ViewModel
    ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setLoading(isLoading: Bool) {
        spinnerLoader.isHidden = !isLoading
        tableView.isHidden = isLoading
        isLoading ? spinnerLoader.startAnimation() : spinnerLoader.stopAnimating()
    }
    
    private func toggleSection(_ section: Int) {
        // Toggle collapsed state
        viewModel.bets[section].isCollapsed.toggle()
        
        // Reload section with animation
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: section), with: .none)
        }
    }
    
    func toggleFavorite(forEventAt indexPath: IndexPath) {
        // Toggle the favorite state
        viewModel.bets[indexPath.section].events[indexPath.row].isFavorite.toggle()
        
        // Sort events to move favorites to the top
        viewModel.sortEventsPuttingFavoritesFirst()
        
        // Reload the table view to reflect changes
        tableView.reloadData()
    }
    
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
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            spinnerLoader.heightAnchor.constraint(equalToConstant: 56),
            spinnerLoader.widthAnchor.constraint(equalToConstant: 56),
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
