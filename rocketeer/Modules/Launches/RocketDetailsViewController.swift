//
//  LaunchDetailsViewController.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import UIKit

final class RocketDetailsViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var rocketImage: UIImageView!
    @IBOutlet var wikiButton: UIView!
    
    var rocket: Rocket?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onBackPressed))
        backButton.tintColor = .init(named: "Grey")
        navigationItem.leftBarButtonItem = backButton
        wikiButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onWikiTapped)))
        
        nameLabel.text = rocket?.name
        descriptionLabel.text = rocket?.description
        if let randomImage = rocket?.flickrImages.randomElement() {
            APIClient.loadImage(url: randomImage, completion: { [weak self] image in
                self?.rocketImage.image = image
            })
        }
    }
    
    @objc func onBackPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onWikiTapped() {
        guard let rocket = rocket, let url = URL(string: rocket.wikipedia) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
