//
//  Ext+String.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import Foundation

extension String {
    var formatDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMM d, yyyy"

            return dateFormatter.string(from: date)
        }
        return self
    }
}
