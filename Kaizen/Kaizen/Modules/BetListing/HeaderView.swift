//
//  HeaderView.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

final class HeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "chevron.down"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Add a closure to handle tap action
    var didTapHeader: (() -> Void)?
    
    init(headerTitle: String) {
        super.init(frame: .zero)
        setupViewConfiguration()
        titleLabel.text = headerTitle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollapsed(_ collapsed: Bool) {
        chevronImageView.image = collapsed ? UIImage(systemName: "chevron.right") : UIImage(systemName: "chevron.down")
    }
    
    @objc private func handleTap() {
        didTapHeader?()
    }
}

extension HeaderView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(chevronImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func configureViews() {
        backgroundColor = .darkGray
    }
}
