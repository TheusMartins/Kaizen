//
//  BetListingCell.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

final class BetListingCell: UICollectionViewCell {
    struct ViewModel {
        let eventName: String
        let timeToStartStart: Int
    }
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "star"))
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Timer for the counter
    private var timer: Timer?
    private var endTime: TimeInterval?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
        starImageView.image = UIImage(systemName: "star") // Reset to default state
    }
    
    func configureWithEvent(viewModel: BetListingCell.ViewModel) {
        eventNameLabel.text = viewModel.eventName
        self.endTime = TimeInterval(viewModel.timeToStartStart)
        startTimer()
    }
    
    @objc private func toggleFavorite() {
        // Toggle the favorite state and update the star image
        if starImageView.image == UIImage(systemName: "star.fill") {
            starImageView.image = UIImage(systemName: "star")
        } else {
            starImageView.image = UIImage(systemName: "star.fill")
        }
    }
    
    private func startTimer() {
        timer?.invalidate() // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let endTime = self.endTime else { return }
            let currentTime = Date().timeIntervalSince1970
            let remainingTime = max(endTime - currentTime, 0)
            if remainingTime <= 0 {
                self.timer?.invalidate()
                self.timer = nil
            }
            // Update the counter label
            let hours = Int(remainingTime) / 3600
            let minutes = Int(remainingTime) / 60 % 60
            let seconds = Int(remainingTime) % 60
            counterLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
    }
}

extension BetListingCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(counterLabel)
        addSubview(starImageView)
        addSubview(eventNameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            counterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            counterLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            
            starImageView.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 8),
            starImageView.widthAnchor.constraint(equalToConstant: 24),
            starImageView.heightAnchor.constraint(equalToConstant: 24),
            
            eventNameLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            eventNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            eventNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
