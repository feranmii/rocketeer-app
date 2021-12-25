//
//  LaunchesModel.swift
//  rocketeer
//
//  Created by Feranmi on 24/12/2021.
//

import Foundation
import UIKit

// MARK: - LaunchesModel

struct LaunchesModel: Codable {
    let docs: [LaunchDoc]
    let totalDocs, offset, limit, totalPages: Int
    let page, pagingCounter: Int
    let hasPrevPage, hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

// MARK: - Doc

struct LaunchDoc: Codable {
    let links: Links?
    let success: Bool?
    let details: String?
    let flightNumber: Int
    let name: String
    let rocket: Rocket?
    let dateUTC: String
    var imageData: UIImage? // For image caching
    
    enum CodingKeys: String, CodingKey {
        case links
        case success, details
        case flightNumber = "flight_number"
        case name
        case rocket
        case dateUTC = "date_utc"
    }
}

struct Rocket: Codable {
    let flickrImages: [String]
    let name: String
    let wikipedia: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case flickrImages = "flickr_images"
        case name
        case wikipedia
        case description
    }
}

struct Links: Codable {
    let patch: Patch?
    let article: String?
    let wikipedia: String?
}

struct Patch: Codable {
    let small: String?
    let large: String?
}
