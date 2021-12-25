//
//  MainViewController.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet var upcomingContainer: UIView!
    @IBOutlet var successContainer: UIView!
    @IBOutlet var yearBarButtonItem: UIBarButtonItem!
    
    var upcomingViewController: UpcomingLaunchesViewController?
    var successfulViewController: SuccessfulLaunchesViewController?
    
    let viewModel = LaunchesViewModel(apiClient: APIClient())
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        showScreen(index: 0)
    }

    func setupViews() {
        upcomingViewController = children.first as? UpcomingLaunchesViewController
        
        successfulViewController = children.last as? SuccessfulLaunchesViewController
        
        upcomingViewController?.viewModel = viewModel
        successfulViewController?.viewModel = viewModel
    }

    @IBAction func onSegmentChanged(_ sender: UISegmentedControl) {
        showScreen(index: sender.selectedSegmentIndex)
    }

    @IBAction func onDateTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Select Year", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(.init(title: "2020", style: .default) { [weak self] _ in
            self?.viewModel.getUpcomingLaunches(startDate: "01-01-2020", endDate: "31-12-2020")
            self?.viewModel.getSuccessfulLaunches(startDate: "01-01-2020", endDate: "31-12-2020")
            self?.yearBarButtonItem.title = "2020"
        })
        
        alert.addAction(.init(title: "2021", style: .default) { [weak self] _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            self?.viewModel.getUpcomingLaunches(startDate: "01-01-2021", endDate: "31-12-2021")
            self?.viewModel.getSuccessfulLaunches(startDate: "01-01-2021", endDate: "31-12-2021")
            self?.yearBarButtonItem.title = "2021"
        })
        
        alert.addAction(.init(title: "2022", style: .default) { [weak self] _ in
            self?.viewModel.getUpcomingLaunches(startDate: "01-01-2022", endDate: "31-12-2022")
            self?.viewModel.getSuccessfulLaunches(startDate: "01-01-2022", endDate: "31-12-2022")
            self?.yearBarButtonItem.title = "2022"
        }) // Added 2022 because 2020 has no upcoming launches
        
        alert.addAction(.init(title: "Cancel", style: .cancel) { _ in
            
        })
        
        present(alert, animated: true)
    }

    func showScreen(index: Int) {
        if index == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.upcomingContainer.alpha = 1
                self.successContainer.alpha = 0
            })
        }
        else {
            UIView.animate(withDuration: 0.25, animations: {
                self.upcomingContainer.alpha = 0
                self.successContainer.alpha = 1
            })
        }
    }
}
