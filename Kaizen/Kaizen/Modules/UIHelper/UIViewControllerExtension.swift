//
//  UIViewControllerExtension.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

extension UIViewController {
    func setupTitle(_ title: String?, color: UIColor = .white) {
        let text = UILabel()
        text.text = title?.capitalized
        self.navigationItem.titleView = text
    }
}
