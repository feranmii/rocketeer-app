//
//  LaunchesViewModel.swift
//  rocketeer
//
//  Created by Feranmi on 25/12/2021.
//

import RxSwift
import Foundation

final class LaunchesViewModel {
    var isFetching = PublishSubject<Bool>()
    var isFetchingCompleted = PublishSubject<Bool>()
    
    var isFetchingUpcoming = PublishSubject<Bool>()
    var isFetchingUpcomingCompleted = PublishSubject<Bool>()
    
    let disposeBag = DisposeBag()
    let apiClient: APIClient?

    var upcomingLaunches = [LaunchDoc]()
    var successfulLaunches = [LaunchDoc]()
    
    let dateFormatter = DateFormatter()

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }

    func getUpcomingLaunches(startDate: String, endDate: String) {
        guard let apiClient = apiClient else {
            return
        }
        
        guard let startDate = dateFormatter.date(from: startDate),
           let endDate = dateFormatter.date(from: endDate) else {
               isFetchingUpcoming.onError(AppError.defaultError("Invalid Date"))
               return
        }

        isFetchingUpcoming.onNext(true)
        apiClient.performRequest(LaunchesModel.self, .getUpcomingLaunches(startDate: startDate.toFormattedString, endDate: endDate.toFormattedString))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?.upcomingLaunches = response.docs
                self?.isFetchingUpcomingCompleted.onNext(true)
            }, onError: { [weak self] error in
                self?.isFetchingUpcomingCompleted.onError(error)
            }, onCompleted: { [weak self] in
                self?.isFetchingUpcoming.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    func getSuccessfulLaunches(startDate: String, endDate: String) {
        guard let apiClient = apiClient else {
            return
        }

        guard let startDate = dateFormatter.date(from: startDate),
           let endDate = dateFormatter.date(from: endDate) else {
               isFetchingUpcoming.onError(AppError.defaultError("Invalid Date"))
               return
        }
        
        isFetching.onNext(true)
        apiClient.performRequest(LaunchesModel.self, .getSuccessfulLaunches(startDate: startDate.toFormattedString, endDate: endDate.toFormattedString))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?.successfulLaunches = response.docs
                self?.isFetchingCompleted.onNext(true)
            }, onError: { [weak self] error in
                self?.isFetchingCompleted.onError(error)
            }, onCompleted: { [weak self] in
                self?.isFetching.onNext(false)
            }).disposed(by: disposeBag)
    }
}
