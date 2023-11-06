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
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
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
        "userId": userId
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
