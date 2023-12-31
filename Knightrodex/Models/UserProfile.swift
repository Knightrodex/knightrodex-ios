//
//  UserProfile.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/4/23.
//

import Foundation

struct UserProfile: Codable {
    let userID, firstName, lastName: String
    let profilePicture: String
    let usersFollowed: [String]
    let dateCreated: String
    let badgesCollected: [BadgesCollected]
    let jwtToken: String
    let error: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, profilePicture, usersFollowed, dateCreated, badgesCollected, jwtToken, error
    }
}

// MARK: - BadgesCollected
struct BadgesCollected: Codable {
    let id, title, location: String
    let coordinates: [Double]
    let dateCreated, dateExpired: String
    let description: String
    let limit: Int
    let badgeImage: String
    let dateObtained: String
    let uniqueNumber: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, dateCreated, dateExpired, description, limit, dateObtained, uniqueNumber, location, coordinates, badgeImage
    }
}
