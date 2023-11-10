//
//  UserProfileViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/9/23.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows for the table.
        return badges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create, configure, and return a table view cell for the given row (i.e., `indexPath.row`)
        
        // Create the cell
        let cell = UITableViewCell()
        
        let badge = badges[indexPath.row]
        
        cell.textLabel?.text = badge.title
        
        return cell
    }
    
    
    
    // Getting the returned value from the API Call
    private var badges: [BadgesCollected] = []
    
    // Still in testing stages:
    private var names: [String] = []
    
    
    // This is in testing stages so far:
    private var firstName: String?
    private var lastName: String?
    private var noFollowUsers: Int?
    // This is in testing stages so far:
    
    @IBOutlet weak var userProfileAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberFollowedUser: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        
        
        // Come back here to pass what's actually relevant
        getUserProfile(userId: "6525c13e21cb5f9f2b270d87", jwtToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTI1YzEzZTIxY2I1ZjlmMmIyNzBkODciLCJmaXJzdE5hbWUiOiJTdGV2ZW4iLCJsYXN0TmFtZSI6IkdyYWR5IiwiZW1haWwiOiJzdGV2ZW5hZ3JhZHlAZ21haWwuY29tIiwiaWF0IjoxNjk5NTkxMzc4LCJleHAiOjE2OTk2Nzc3Nzh9.02E2OJdPwpenJLxQVY1dPK60snFxa_mtWZFjWan4Iqc")
        
        

//        nameLabel.text = names[0] + " " + names[1]
        print(names.count)
        
    }
    
    
    // I had to put this here, so `self` could be accessible
    func getUserProfile(userId: String, jwtToken: String) -> Void {
        // Define the URL for Sign Up API
        let userProfileURL = URL(string: Constant.apiPath + Constant.userProfileEndpoint)!

        // Create a URLRequest
        var request = URLRequest(url: userProfileURL)
        request.httpMethod = "POST"
        
        // Create a dictionary for the request body
        let requestBody: [String: String] = [
            "userId": userId,
            "jwtToken": jwtToken
        ]
        
        do {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request Failed: \(error.localizedDescription)")
                return
            }

            // Process the API response (assuming it's JSON)
            if let data = data {
                do {
                    // Decode the JSON data into our custom `UserProfile`
                    let userprofile = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    // This is where some direct data can be accessed to send back to Dispatch Main
                    // Refer to here if more data are needed in the Profile Page
                    let badges = userprofile.badgesCollected
                    
                    // In the testing phase
                    let firstName = userprofile.firstName
                    let lastName = userprofile.lastName
                    let noFollowedUsers = userprofile.usersFollowed.count
                    
                    
                    // Run any code that will update UI on the main thread
                    DispatchQueue.main.async { [weak self] in
                        
                        
                        self?.badges = badges
                        
                        // Testing stages:
                        self?.firstName = firstName
                        self?.lastName = lastName
                        self?.noFollowUsers = noFollowedUsers
                        
              
                        
                        // This is in testing stages so far:
                        self?.tableView.reloadData()
                        self?.nameLabel.text = "\(firstName) \(lastName)"
                        self?.numberFollowedUser.text = "\(noFollowedUsers) Followed Users"
                        
                    
                        
                        
                        print("Success!!! Fetched \(badges.count) badges")
                        
                    }
                    
                } catch {
                }
            }
        }

        task.resume()
    }
}
