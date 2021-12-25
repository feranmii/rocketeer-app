//
//  Ext+UITableViewCell.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
