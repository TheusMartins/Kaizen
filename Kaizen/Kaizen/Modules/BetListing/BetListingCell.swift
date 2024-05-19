//
//  BetListingCell.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

final class BetListingCell: UITableViewCell {
    struct ViewModel {
        let eventName: String
        let timeToStartStart: Int
        var isFavorite: Bool = false
    }
    
    private lazy var counterContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "star")?.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        counterContainer.removeFromSuperview()
        starImageView.removeFromSuperview()
        eventNameLabel.removeFromSuperview()
    }
    
    func setupWith(viewModel: BetListingCell.ViewModel) {
        eventNameLabel.text = viewModel.eventName
        starImageView.tintColor = viewModel.isFavorite ? .yellow : .darkGray
        setupViewConfiguration()
    }
    
    func updateWith(viewModel: ViewModel) {
        guard let endTime = TimeInterval(exactly: viewModel.timeToStartStart) else { return }
        counterLabel.text = calculateRemainingTime(endTime: endTime)
    }
    
    func calculateRemainingTime(endTime: TimeInterval) -> String {
        let currentTime = Date().timeIntervalSince1970
        let remainingTime = max(endTime - currentTime, 0)
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

extension BetListingCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(counterContainer)
        counterContainer.addSubview(counterLabel)
        addSubview(starImageView)
        addSubview(eventNameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            counterContainer.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            counterContainer.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
            
            counterLabel.topAnchor.constraint(equalTo: counterContainer.topAnchor, constant: 4),
            counterLabel.leadingAnchor.constraint(equalTo: counterContainer.leadingAnchor, constant: 4),
            counterLabel.trailingAnchor.constraint(equalTo: counterContainer.trailingAnchor, constant: -4),
            counterLabel.bottomAnchor.constraint(equalTo: counterContainer.bottomAnchor, constant: -4),
            
            eventNameLabel.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            eventNameLabel.trailingAnchor.constraint(equalTo: starImageView.leadingAnchor, constant: -24),
            eventNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            starImageView.widthAnchor.constraint(equalToConstant: 24),
            starImageView.heightAnchor.constraint(equalToConstant: 24),
            starImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            starImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    func configureViews() {
        selectionStyle = .none
        backgroundColor = .gray
    }
}
