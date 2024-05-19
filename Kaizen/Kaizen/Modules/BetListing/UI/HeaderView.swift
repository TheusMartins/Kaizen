//
//  HeaderView.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

/// A custom header view that includes a title label and a chevron image to indicate collapsible sections.
final class HeaderView: UIView {
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: .chevronDown)?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Public Properties
    
    /// Closure invoked when the header is tapped.
    var didTapHeader: (() -> Void)?
    
    // MARK: - Initialization
    
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
    
    // MARK: - Configuration
    
    /// Updates the chevron image based on the collapsed state.
    /// - Parameter collapsed: A Boolean value indicating whether the section is collapsed.
    func setCollapsed(_ collapsed: Bool) {
        let systemName: String = collapsed ? .chevronRight : .chevronDown
        chevronImageView.image = UIImage(systemName: systemName)
    }
    
    // MARK: - Actions
    
    @objc private func handleTap() {
        didTapHeader?()
    }
}

// MARK: - ViewConfiguration

extension HeaderView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(chevronImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .leadingPadding),
            
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.trailingPadding),
            chevronImageView.widthAnchor.constraint(equalToConstant: .iconSize),
            chevronImageView.heightAnchor.constraint(equalToConstant: .iconSize),
        ])
    }
    
    func configureViews() {
        backgroundColor = .darkGray
    }
}

// MARK: - Constants and Extensions

private extension CGFloat {
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = 24
    static let iconSize: CGFloat = 20
}

private extension String {
    static let chevronDown = "chevron.down"
    static let chevronRight = "chevron.right"
}
