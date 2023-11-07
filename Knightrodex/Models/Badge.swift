//
//  Badge.swift
//  Knightrodex
//
//  Created by Steven Grady on 11/6/23.


import Foundation

struct Badge: Codable {
    let badgeInfo: BadgeInfo
    let dateObtained: String
    let uniqueNumber: Int
    let error: String
}

struct BadgeInfo: Codable {
    let id, title: String
    let coordinates: [Double]
    let numObtained: Int
    let location, dateCreated, dateExpired, hint: String
    let description: String
    let limit: Int
    let badgeImage: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, coordinates, numObtained, location, dateCreated, dateExpired, hint, description, limit, badgeImage
    }
}

