//
//  Ext+UIViewController.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import UIKit

extension UIViewController {
    func showErrorAlert(_ error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
