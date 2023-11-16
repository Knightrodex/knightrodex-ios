//
//  User.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 10/26/23.
//

import Foundation

struct User: Codable, Equatable {
    let userId: String
    let email: String
    let firstName: String
    let lastName: String
    var error: String?
}

extension User {
    static var userLoginKey: String {
        return "currentUser"
    }

    static var jwtTokenKey: String {
        return "jwtToken"
    }

    static func save(_ user: User) {
        let defaults = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(user)
        defaults.set(encodedData, forKey: User.userLoginKey)
    }

    static func saveJwt(_ jwtToken: String) {
        if (jwtToken.isEmpty) {
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(jwtToken, forKey: User.jwtTokenKey)
    }

    static func getUserLogin() -> User {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: User.userLoginKey) {
            let decodedUser = try! JSONDecoder().decode(User.self, from: data)
            return decodedUser
        } else {
            return initializeUser()
        }
    }

    static func getJwtToken() -> String {
        let defaults = UserDefaults.standard
        if let data = defaults.string(forKey: User.jwtTokenKey) {
            return data
        } else {
            return ""
        }
    }

    static func deleteUserLogin() {
        User.save(initializeUser())
    }

    static func initializeUser() -> User {
        return User(userId: "", email: "", firstName: "", lastName: "", error: "")
    }
}
