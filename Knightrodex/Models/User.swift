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
    let error: String
}

extension User {
    static var userLogin: String {
        return "currentUser"
    }
    
    static func save(_ user: User) {
       let defaults = UserDefaults.standard
       let encodedData = try! JSONEncoder().encode(user)
       defaults.set(encodedData, forKey: User.userLogin)
    }
    
    static func getUserLogin() -> User {
       let defaults = UserDefaults.standard
       if let data = defaults.data(forKey: User.userLogin) {
           let decodedUser = try! JSONDecoder().decode(User.self, from: data)
           return decodedUser
       } else {
           return User(userId: "", email: "", firstName: "", lastName: "", error: "")
       }
    }

    func deleteUserLogin() {
        User.save(User(userId: "", email: "", firstName: "", lastName: "", error: ""))
    }
}


