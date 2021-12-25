//
//  SuccessfulLaunchTableViewCell.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import UIKit

class SuccessfulLaunchTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var rocketNameLabel: UILabel!
    
    public func updateCell(_ model: LaunchDoc) {
        nameLabel.text = model.name
        dateLabel.text = model.dateUTC.formatDate
        numberLabel.text = "#\(model.flightNumber)"
        rocketNameLabel.text = model.rocket?.name ?? ""
    }
}
