//
//  UIView.swift
//  English Simplified
//
//  Created by Funde, Rohit on 2/17/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadowEffect() {
        layer.cornerRadius = 4
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.40
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = 2.0
    }
}
