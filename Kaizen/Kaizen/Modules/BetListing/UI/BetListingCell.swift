//
//  BetListingCell.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

/// Represents a cell in the bet listing table view, displaying information about a betting event.
final class BetListingCell: UITableViewCell {
    
    /// Encapsulates the data needed to populate a `BetListingCell`.
    struct ViewModel {
        let eventName: String  // The name of the event.
        let timeToStartStart: Int  // The time until the event starts, in seconds.
        var isFavorite: Bool = false  // Indicates whether the event is marked as a favorite.
    }
    
    // MARK: - UI Components
    
    private lazy var counterContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = .cornerRadius
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = .borderWidth
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"  // Placeholder text for the countdown timer.
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: .systemNameForStar)?.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        counterContainer.removeFromSuperview()
        starImageView.removeFromSuperview()
        eventNameLabel.removeFromSuperview()
    }
    
    /// Configures the cell with the provided view model.
    func setupWith(viewModel: BetListingCell.ViewModel) {
        eventNameLabel.text = viewModel.eventName
        starImageView.tintColor = viewModel.isFavorite ? .yellow : .darkGray
        setupViewConfiguration()
    }
    
    /// Updates the countdown timer based on the provided view model.
    func updateWith(viewModel: ViewModel) {
        guard let endTime = TimeInterval(exactly: viewModel.timeToStartStart) else { return }
        counterLabel.text = calculateRemainingTime(endTime: endTime)
    }
    
    /// Calculates the remaining time until the event starts and formats it as a string.
    func calculateRemainingTime(endTime: TimeInterval) -> String {
        let currentTime = Date().timeIntervalSince1970
        let remainingTime = max(endTime - currentTime, 0)
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

// MARK: - ViewConfiguration

extension BetListingCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(counterContainer)
        counterContainer.addSubview(counterLabel)
        addSubview(starImageView)
        addSubview(eventNameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            counterContainer.topAnchor.constraint(equalTo: topAnchor, constant: .padding),
            counterContainer.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
            
            counterLabel.topAnchor.constraint(equalTo: counterContainer.topAnchor, constant: .innerPadding),
            counterLabel.leadingAnchor.constraint(equalTo: counterContainer.leadingAnchor, constant: .innerPadding),
            counterLabel.trailingAnchor.constraint(equalTo: counterContainer.trailingAnchor, constant: -.innerPadding),
            counterLabel.bottomAnchor.constraint(equalTo: counterContainer.bottomAnchor, constant: -.innerPadding),
            
            eventNameLabel.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: .padding),
            eventNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .sidePadding),
            eventNameLabel.trailingAnchor.constraint(equalTo: starImageView.leadingAnchor, constant: -.sidePadding),
            eventNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.padding),
            
            starImageView.widthAnchor.constraint(equalToConstant: .iconSize),
            starImageView.heightAnchor.constraint(equalToConstant: .iconSize),
            starImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            starImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.sidePadding)
        ])
    }
    
    func configureViews() {
        selectionStyle = .none
        backgroundColor = .gray
    }
}

// MARK: - Extensions

private extension CGFloat {
    static let cornerRadius: CGFloat = 4
    static let borderWidth: CGFloat = 1
    static let padding: CGFloat = 8
    static let innerPadding: CGFloat = 4
    static let sidePadding: CGFloat = 24
    static let iconSize: CGFloat = 24
}

private extension String {
    static let systemNameForStar = "star"
}
