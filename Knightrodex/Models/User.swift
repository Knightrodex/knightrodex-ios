//
//  User.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 10/26/23.
//

import Foundation

struct User: Codable, Equatable {
    // Define properties for the user data
    let userId: String
    let email: String
    let firstName: String
    let lastName: String
    let error: String
}

extension User {
    static var userLogin: String {
        return "NewLogin"
    }
    
    
    // Save an array of favorite movies to UserDefaults.
       //    - Similar to the favoritesKey, we add the `static` keyword to make this a "Type Method".
       //    - We can call it from anywhere by calling it on the `Movie` type.
       //    - ex: `Movie.save(favoriteMovies, forKey: favoritesKey)`
       // 1. Create an instance of UserDefaults
       // 2. Try to encode the array of `Movie` objects to `Data`
       // 3. Save the encoded movie `Data` to UserDefaults
       
       static func save(_ user: User) {
           // 1.
           let defaults = UserDefaults.standard
           // 2.
           let encodedData = try! JSONEncoder().encode(user)
           // 3.
           defaults.set(encodedData, forKey: User.userLogin)
       }
    
    
    // Get the array of favorite movies from UserDefaults
       //    - Again, a static "Type method" we can call anywhere like this...`Movie.getMovies(forKey: favoritesKey)`
       // 1. Create an instance of UserDefaults
       // 2. Get any favorite movies `Data` saved to UserDefaults (if any exist)
       // 3. Try to decode the movie `Data` to `Movie` objects
       // 4. If 2-3 are successful, return the array of movies
       // 5. Otherwise, return an empty array
       static func getUserLogin() -> User {
           // 1.
           let defaults = UserDefaults.standard
           // 2.
           if let data = defaults.data(forKey: User.userLogin) {
               // 3.
               let decodedUser = try! JSONDecoder().decode(User.self, from: data)
               // 4.
               return decodedUser
           } else {
               // 5.
               return User(userId: "", email: "", firstName: "", lastName: "", error: "")
           }
       }
   
    
        // Removes the movie from the favorites array in UserDefaults
        // 1. Get all favorite movies from UserDefaults
        // 2. remove all movies from the array that match the movie instance this method is being called on (i.e. `self`)
        //   - The `removeAll` method iterates through each movie in the array and passes the movie into a closure where it can be used to determine if it should be removed from the array.
        // 3. If a given movie passed into the closure is equal to `self` (i.e. the movie calling the method) we want to remove it. Returning a `Bool` of `true` removes the given movie.
        // 4. Save the updated favorite movies array.
        func deleteUserLogin() {
          
            User.save(User(userId: "", email: "", firstName: "", lastName: "", error: ""))
        }
}


