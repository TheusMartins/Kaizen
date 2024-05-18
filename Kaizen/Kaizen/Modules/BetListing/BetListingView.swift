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
        let bets: [Bet]
        
        struct Bet {
            let sportName: String
            let events: [BetListingCell.ViewModel]
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
        self.backgroundColor = .darkGray
    }
}

extension BetListingView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.bets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bets[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BetListingCell.reuseIdentifier, for: indexPath) as? BetListingCell else {
            return UITableViewCell()
        }
        
        cell.setupWith(viewModel: viewModel.bets[indexPath.section].events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CustomHeaderView()
        header.titleLabel.text = viewModel.bets[section].sportName
        return header
    }
}

extension BetListingView: UITableViewDelegate {
    
}

class CustomHeaderView: UITableViewHeaderFooterView {
    static let identifier = "CustomHeaderView"
    
    let titleLabel = UILabel()
    let chevronImageView = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(chevronImageView)
        
        // Chevron image setup
        chevronImageView.image = UIImage(systemName: "chevron.down") // Default state
        chevronImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setCollapsed(_ collapsed: Bool) {
        chevronImageView.image = collapsed ? UIImage(systemName: "chevron.right") : UIImage(systemName: "chevron.down")
    }
}
