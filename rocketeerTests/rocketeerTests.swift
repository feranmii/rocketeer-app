//
//  rocketeerTests.swift
//  rocketeerTests
//
//  Created by Feranmi on 24/12/2021.
//

@testable import rocketeer
import RxSwift
import XCTest

class rocketeerTests: XCTestCase {
    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpcomingLaunchesFetch() throws {
        let apiClient = APIClient()
        let viewModel = LaunchesViewModel(apiClient: apiClient)
        let expectation = expectation(description: "Waiting for data")
        viewModel.getUpcomingLaunches(startDate: "01/01/2022", endDate: "31/01/2022")
        viewModel.isFetchingUpcomingCompleted.subscribe(onNext: { _ in
            XCTAssert(!viewModel.upcomingLaunches.isEmpty)
            expectation.fulfill()
        }, onError: { _ in
            XCTFail()
            expectation.fulfill()
        }).disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)
    }

    func testSuccessfulLaunchesFetch() throws {
        let apiClient = APIClient()
        let viewModel = LaunchesViewModel(apiClient: apiClient)
        let expectation = expectation(description: "Waiting for data")
        viewModel.getSuccessfulLaunches(startDate: "01/01/2021", endDate: "31/01/2021")
        viewModel.isFetchingCompleted.subscribe(onNext: { _ in
            XCTAssert(!viewModel.successfulLaunches.isEmpty)
            expectation.fulfill()
        }, onError: { _ in
            XCTFail()
            expectation.fulfill()
        }).disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)
    }

    func testNetworkImageLoading() throws {
        let url = "https://farm9.staticflickr.com/8617/16789019815_f99a165dc5_o.jpg"
        let expectation = expectation(description: "Waiting for data")
        APIClient.loadImage(url: url, completion: { image in
            XCTAssert(image.pngData() != nil)
            expectation.fulfill()
        }, failure: {
            XCTFail()
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10)
    }
}
