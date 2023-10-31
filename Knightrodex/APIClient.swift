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
    // Define the URL for your login API
    let loginURL = URL(string: "https://knightrodex-49dcc2a6c1ae.herokuapp.com/api/login")!

    // Create a URLRequest
    var request = URLRequest(url: loginURL)
    request.httpMethod = "POST"
    
    // Create a dictionary for the request body
    let requestBody: [String: String] = [
        "email": email,
        "password": password
    ]
    
    do {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // May need to remove
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
                print(user) // Will need to remove
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}


func signUpUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<SignUpTemp, Error>) -> Void) {
    // Define the URL for your signup API
    let signUpURL = URL(string: "https://knightrodex-49dcc2a6c1ae.herokuapp.com/api/signup")!

    // Create a URLRequest
    var request = URLRequest(url: signUpURL)
    request.httpMethod = "POST"
    
    // Create a dictionary for the request body
    let requestBody: [String: String] = [
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password
    ]
    
    do {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    } catch {
        completion(.failure(error))
        return
    }
    print(request) // Remove this
    // Create a URLSession data task
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        // Process the API response (assuming it's JSON)
        if let data = data {
            do {
                let user = try JSONDecoder().decode(SignUpTemp.self, from: data)
                print(user) // Will need to remove
                completion(.success(user))
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

