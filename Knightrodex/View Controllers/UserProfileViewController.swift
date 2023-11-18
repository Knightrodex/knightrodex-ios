//
//  UserProfileViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/9/23.
//

import UIKit
import Nuke

class UserProfileViewController: UIViewController, UITableViewDataSource {
    
    // This is in testing stages so far:
    @IBOutlet weak var userProfileAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberFollowedUser: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private var user = User.getUserLogin()
    
    // Getting the returned value from the API Call
    private var badges: [BadgesCollected] = []
    
    // Still in testing stages:
    private var names: [String] = []
    
    // This is in testing stages so far:
    private var firstName: String?
    private var lastName: String?
    private var noFollowUsers: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Remove later
        print()
        print("profile jwt: " + User.getJwtToken())
        
        tableView.dataSource = self
        self.refreshProfile()
    }
    
    func refreshProfile() {
        getUserProfile(userId: user.userId) { result in
            switch result {
            case .success(let userProfile):
                DispatchQueue.main.async {
                    if (!userProfile.error.isEmpty) {
                        self.showAlert(title: "User Profile Failed", message: userProfile.error)
                        return;
                    }
                    
                    // Refer to here if more data are needed in the Profile Page
                    let badges = userProfile.badgesCollected

                    // In the testing phase
                    let firstName = userProfile.firstName
                    let lastName = userProfile.lastName
                    let noFollowedUsers = userProfile.usersFollowed.count

                    self.badges = badges

                    // Testing stages:
                    self.firstName = firstName
                    self.lastName = lastName
                    self.noFollowUsers = noFollowedUsers
                    
                    // This is in testing stages so far:
                    self.tableView.reloadData()
                    self.nameLabel.text = "\(firstName) \(lastName)"
                    self.numberFollowedUser.text = "\(noFollowedUsers) Followed Users"
                    
                    
                    // Just for testing purposes:
                    
                    let imageUrl = URL(string: "https://www.shareicon.net/data/512x512/2016/05/26/771188_man_512x512.png")
                    
                    Nuke.loadImage(with: imageUrl!, into: self.userProfileAvatar)
                    
                    

                    // TODO: Remove later
                    print("Success! Fetched \(badges.count) badges")
                    print()
                    print("New JWT:")
                    print(User.getJwtToken())
                }
            case .failure(let error):
                print("Show User Profile API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "User Profile Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create, configure, and return a table view cell for the given row (i.e., `indexPath.row`)
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeCell", for: indexPath) as! BadgeCell
        
        let badge = badges[indexPath.row]
        
//        cell.titleLabel.text = badge.title
        
        cell.titleLabel.text = badge.title
        
        
        
        
        return cell
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "Dismiss",
            style: .default,
            handler: { action in
                // Handle the OK button action (if needed)
            }
        )

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
