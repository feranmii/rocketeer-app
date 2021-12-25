//
//  Ext+Date.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import Foundation

extension Date {
    var toFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateFormatter.string(from: self)
    }
}
