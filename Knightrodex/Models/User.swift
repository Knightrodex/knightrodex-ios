//
//  User.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 10/26/23.
//

import Foundation

struct User: Codable {
    // Define properties for the user data
    let userId: String
    let email: String
    let firstName: String
    let lastName: String
    let error: String
}
