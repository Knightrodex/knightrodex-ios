//
//  APIClient.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 10/26/23.
//

import Foundation
import UIKit
import CryptoKit

func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
    // Define the URL for Login API
    let loginURL = URL(string: Constant.apiPath + Constant.loginEndpoint)!

    // Create a URLRequest
    var request = URLRequest(url: loginURL)
    request.httpMethod = "POST"
    
    // Create a dictionary for the request body
    let requestBody: [String: String] = [
        "email": email,
        "password": MD5(string: password)
    ]
    
    do {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    } catch {
        completion(.failure(error))
        return
    }

    // Create a URLSession data task
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        // Process the API response (assuming it's JSON)
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(json)
                    var user = User.initializeUser()
                    user.error = json["error"] as? String ?? ""
                    let jwt = json["jwtToken"] as? String ?? ""
                    if (jwt.isEmpty) {
                        completion(.success(user))
                    } else {
                        user = getUserFromJWT(jwtToken: jwt)
                        User.saveJwt(jwt)
                        completion(.success(user))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}

func addBadge(userId: String, badgeId: String, completion: @escaping (Result<Badge, Error>) -> Void) {
    // Define the URL for Sign Up API
    let addBadgeURL = URL(string: Constant.apiPath + Constant.badgeEndpoint)!

    // Create a URLRequest
    var request = URLRequest(url: addBadgeURL)
    request.httpMethod = "POST"
    
    // Create a dictionary for the request body
    let requestBody: [String: String] = [
        "userId": userId,
        "badgeId": badgeId,
        "jwtToken": User.getJwtToken()
    ]
    
    do {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    } catch {
        completion(.failure(error))
        return
    }
    
    // Create a URLSession data task
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        // Process the API response (assuming it's JSON)
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let badge = try JSONDecoder().decode(Badge.self, from: data)
                    User.saveJwt(json["jwtToken"] as? String ?? "")
                    completion(.success(badge))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}

// This is the start
//func getUserProfile(userId: String, jwtToken: String) -> Void {
//    // Define the URL for Sign Up API
//    let userProfileURL = URL(string: Constant.apiPath + Constant.userProfileEndpoint)!
//
//    // Create a URLRequest
//    var request = URLRequest(url: userProfileURL)
//    request.httpMethod = "POST"
//    
//    // Create a dictionary for the request body
//    let requestBody: [String: String] = [
//        "userId": userId,
//        "jwtToken": jwtToken
//    ]
//    
//    do {
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
//    } catch {
//        return
//    }
//    
//    // Create a URLSession data task
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            print("Request Failed: \(error.localizedDescription)")
//            return
//        }
//
//        // Process the API response (assuming it's JSON)
//        if let data = data {
//            do {
//                // Decode the JSON data into our custom `UserProfile`
//                let userprofile = try JSONDecoder().decode(UserProfile.self, from: data)
//                
//                // This is where some direct data can be accessed to send back to Dispatch Main
//                // Refer to here if more data are needed in the Profile Page
//                let userProfile = userprofile.badgesCollected
//                
//                // Run any code that will update UI on the main thread
//                DispatchQueue.main.async { [weak self] in
//                    
//                    
////                    self?.userProfile = userprofile
//                    self?.userProfile = userProfile
//                    
//                    print("Success!!! Fetched \(userProfile.count) badges")
//                    
//                    
//                    for userP in userProfile {
//                        print("Title: \(userP.title)")
//                    }
//                }
//                
//            } catch {
//            }
//        }
//    }
//
//    task.resume()
//}

func signUpUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
    // Define the URL for Sign Up API
    let signUpURL = URL(string: Constant.apiPath + Constant.signUpEndpoint)!

    // Create a URLRequest
    var request = URLRequest(url: signUpURL)
    request.httpMethod = "POST"
    
    // Create a dictionary for the request body
    let requestBody: [String: String] = [
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": MD5(string: password)
    ]
    
    do {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    } catch {
        completion(.failure(error))
        return
    }
    
    // Create a URLSession data task
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        // Process the API response (assuming it's JSON)
        if let data = data {
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}

func getHints(userId: String, completion: @escaping (Result<[String], Error>) -> Void) {
    // Define the URL for Login API
    let hintsURL = URL(string: Constant.apiPath + Constant.hintsEndpoint)!

    // Create a URLRequest
    var request = URLRequest(url: hintsURL)
    request.httpMethod = "POST"
    
    // Create a dictionary for the request body
    let requestBody: [String: String] = [
        "userId": userId,
        "jwtToken": User.getJwtToken()
    ]
    
    do {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    } catch {
        completion(.failure(error))
        return
    }

    // Create a URLSession data task
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        // Process the API response (assuming it's JSON)
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                    // Access the "hints" field and cast it to an array of strings
                    if let hintsArray = json["hints"] as? [String] {
                        User.saveJwt(json["jwtToken"] as? String ?? "")
                        completion(.success(hintsArray))
                    } else {
                        print("Failed to cast 'hints' to an array of strings.")
                    }
                } else {
                    print("Failed to parse JSON data as a dictionary.")
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

func decode(jwtToken jwt: String) throws -> [String: Any] {

    enum DecodeErrors: Error {
        case badToken
        case other
    }

    func base64Decode(_ base64: String) throws -> Data {
        let base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
        guard let decoded = Data(base64Encoded: padded) else {
            throw DecodeErrors.badToken
        }
        return decoded
    }

    func decodeJWTPart(_ value: String) throws -> [String: Any] {
        let bodyData = try base64Decode(value)
        let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
        guard let payload = json as? [String: Any] else {
            throw DecodeErrors.other
        }
        return payload
    }

    let segments = jwt.components(separatedBy: ".")
    return try decodeJWTPart(segments[1])
}

func getUserFromJWT(jwtToken: String) -> User {
    do {
        let data = try decode(jwtToken: jwtToken)
        return User(userId: data["userId"] as! String, email: data["email"] as! String, firstName: data["firstName"] as! String, lastName: data["lastName"] as! String, error: "")
    } catch {
        return User.initializeUser();
    }
}
