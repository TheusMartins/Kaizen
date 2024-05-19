//
//  Reusable.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit


protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

extension UITableViewCell: Reusable { }
