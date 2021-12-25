//
//  LaunchesViewController.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import RxSwift
import UIKit

final class SuccessfulLaunchesViewController: UIViewController {
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
        if viewModel.successfulLaunches.isEmpty {
            setupEvents()
        }
    }
    
    func setupViews() {
        view.addSubview(loadingIndicator)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.directionalLayoutMargins = .init(top: 4, leading: 16, bottom: 4, trailing: 16)
        
        tableView.register(SuccessfulLaunchTableViewCell.nib, forCellReuseIdentifier: SuccessfulLaunchTableViewCell.identifier)
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
        viewModel.getSuccessfulLaunches(startDate: "01-01-2020", endDate: "31-12-2020")
        
        viewModel.isFetching.subscribe(onNext: { [weak self] loading in
            if loading {
                self?.loadingIndicator.startAnimating()
            }
            else {
                self?.loadingIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        viewModel.isFetchingCompleted.subscribe(onNext: { [weak self] _ in
            self?.updateUI()
        }, onError: { [weak self] error in
            self?.showErrorAlert(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    private func updateUI() {
        tableView.reloadData()
    }
}

extension SuccessfulLaunchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }

        return viewModel.successfulLaunches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuccessfulLaunchTableViewCell.identifier) as! SuccessfulLaunchTableViewCell
        if let data = viewModel?.successfulLaunches[indexPath.row] {
            cell.updateCell(data)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard else { return }
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: RocketDetailsViewController.self)) as! RocketDetailsViewController
        guard let viewModel = viewModel else { return }

        if let rocket = viewModel.successfulLaunches[indexPath.row].rocket {
            vc.rocket = rocket
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
}
