//
//  Ext+UIView.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
