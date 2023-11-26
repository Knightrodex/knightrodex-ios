// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let activities = try? JSONDecoder().decode(Activities.self, from: jsonData)

import Foundation

// MARK: - Activities
struct Activities: Codable {
    let activity: [Activity]
}

// MARK: - Activity
struct Activity: Codable {
    let firstName, lastName, email: String
    let profilePicture: String
    let badgeID, badgeTitle, dateObtained: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, email, profilePicture
        case badgeID = "badgeId"
        case badgeTitle, dateObtained
    }
}
