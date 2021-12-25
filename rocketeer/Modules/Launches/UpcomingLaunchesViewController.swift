//
//  UpcomingLaunchesViewController.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import RxSwift
import UIKit

final class UpcomingLaunchesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .red
        return indicator
    }()

    var viewModel: LaunchesViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupEvents()
    }

    func setupViews() {
        view.addSubview(loadingIndicator)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UpcomingLaunchTableViewCell.nib, forCellReuseIdentifier: UpcomingLaunchTableViewCell.identifier)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupEvents() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.getUpcomingLaunches(startDate: "01-01-2020", endDate: "31-12-2020")
        
        viewModel.isFetchingUpcoming.subscribe(onNext: { [weak self] loading in
            if loading {
                self?.loadingIndicator.startAnimating()
            }
            else {
                self?.loadingIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        viewModel.isFetchingUpcomingCompleted.subscribe(onNext: { [weak self] _ in
            self?.updateUI()
        }, onError: { [weak self] error in
            self?.showErrorAlert(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    private func updateUI() {
        tableView.reloadData()
    }
}

extension UpcomingLaunchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.upcomingLaunches.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingLaunchTableViewCell.identifier) as! UpcomingLaunchTableViewCell
        if let data = viewModel?.upcomingLaunches[indexPath.row] {
            if let imageUrl = data.links?.patch?.small {
                if data.imageData == nil { // We check if we haven't loaded the image once
                    APIClient.loadImage(url: imageUrl, completion: { [weak self, weak cell] image in
                        self?.viewModel.upcomingLaunches[indexPath.row].imageData = image
                        cell?.badgeImageView.image = image
                    })
                }
                else {
                    cell.badgeImageView.image = data.imageData
                }
            }
            cell.updateCell(data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard else { return }
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: RocketDetailsViewController.self)) as! RocketDetailsViewController
        guard let viewModel = viewModel else { return }

        if let rocket = viewModel.upcomingLaunches[indexPath.row].rocket {
            vc.rocket = rocket
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
}
