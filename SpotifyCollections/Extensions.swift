//
//  Extensions.swift
//  SpotifyCollections
//
//  Created by Frank Tan on 10/10/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyShadow() {
        self.layer.applyShadow()
    }
}

extension CALayer {
    func applyShadow() {
        self.shadowColor = UIColor.black.cgColor
        self.shadowOffset = CGSize.zero
        self.shadowRadius = 1.0
        self.shadowOpacity = 0.5
        self.masksToBounds = false
    }
}
