//
//  Ext+UIImageView.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import UIKit

extension UIImageView {
    func load(url: String, imageData: Data) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
