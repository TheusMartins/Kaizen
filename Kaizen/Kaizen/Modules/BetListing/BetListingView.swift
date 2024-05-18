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
            collectionView.reloadData()
        }
    }
    
    // MARK: - Private properties
    
    private lazy var spinnerLoader: SpinnerLoader = {
        let loader = SpinnerLoader()
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.backgroundColor = .darkGray
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BetListingCell.self, forCellWithReuseIdentifier: BetListingCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
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
        collectionView.isHidden = isLoading
        isLoading ? spinnerLoader.startAnimation() : spinnerLoader.stopAnimating()
    }
}

// MARK: - ViewConfiguration
extension BetListingView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(collectionView)
        addSubview(spinnerLoader)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
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

extension BetListingView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.bets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bets[section].events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BetListingCell.reuseIdentifier, for: indexPath) as? BetListingCell else {
            return UICollectionViewCell()
        }
        
        cell.configureWithEvent(viewModel: viewModel.bets[indexPath.section].events[indexPath.row])
        return cell
    }
}

extension BetListingView: UICollectionViewDelegate {
    
}
