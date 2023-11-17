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
                    // TODO: Remove later
                    print()
                    print("Login Data:")
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

func getUserProfile(userId: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
    // Define the URL for Sign Up API
    let userProfileURL = URL(string: Constant.apiPath + Constant.userProfileEndpoint)!

    // Create a URLRequest
    var request = URLRequest(url: userProfileURL)
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
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    // Decode the JSON data into our custom `UserProfile`
                    let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    User.saveJwt(userProfile.jwtToken)
                    
                    completion(.success(userProfile))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}

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

func searchEmail(email: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    // Define the URL for Login API
    let searchEmailURL = URL(string: Constant.apiPath + Constant.searchEmailEndpoint)!

    // Create a URLRequest
    var request = URLRequest(url: searchEmailURL)
    request.httpMethod = "POST"
    
    // Create a dictionary for the request body
    let requestBody: [String: String] = [
        "partialEmail": email,
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
                    // TODO: Remove later
                    print("Search Email Json:")
                    print(json)
                    
                    // TODO: Parse Users, save jwtToken, and return user list
                    // ...
                    
                    completion(.success(json))
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
