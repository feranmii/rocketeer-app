//
//  UpcomingLaunchTableViewCell.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import UIKit

class UpcomingLaunchTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!

    override func prepareForReuse() {
        badgeImageView.image = nil
    }
    
    public func updateCell(_ model: LaunchDoc) {
        nameLabel.text = model.name
        dateLabel.text = model.dateUTC.formatDate
        numberLabel.text = "#\(model.flightNumber)"
    }
}
