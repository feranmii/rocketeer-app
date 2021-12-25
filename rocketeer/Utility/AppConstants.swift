//
//  AppConstants.swift
//  rocketeer
//
//  Created by Feranmi on 24/12/2021.
//

import Foundation

struct Storyboardnames {
    static let main = "Main"
}

enum UrlConstants {
    static let baseUrl = "api.spacexdata.com"
    static let launchesUrl = "/v4/launches/query"
}

enum AppError: Error {
    case defaultError(String)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .defaultError(message):
            return message
        }
    }
}
