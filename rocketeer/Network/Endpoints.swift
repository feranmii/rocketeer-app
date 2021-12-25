//
//  Endpoints.swift
//  rocketeer
//
//  Created by Feranmi on 24/12/2021.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    let requestType: RequestType
    let parameters: Parameters
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = UrlConstants.baseUrl
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

extension Endpoint {
    static func getSuccessfulLaunches(startDate: String, endDate: String) -> Endpoint {
        return Endpoint(
            path: UrlConstants.launchesUrl,
            queryItems: [
            ],
            requestType: .POST,
            parameters: ["query": ["success": true, "date_utc": ["$gte": startDate, "$lte": endDate]],
                         "options" : ["limit": 100, "populate" : ["rocket"]]]
        )
    }
    
    static func getUpcomingLaunches(startDate: String, endDate: String) -> Endpoint {
        return Endpoint(
            path: UrlConstants.launchesUrl,
            queryItems: [
            ],
            requestType: .POST,
            parameters: ["query": ["upcoming": true, "date_utc": ["$gte": startDate, "$lte": endDate]],
                         "options" : ["limit": 100, "populate" : ["rocket"]]]
        )
    }
}
