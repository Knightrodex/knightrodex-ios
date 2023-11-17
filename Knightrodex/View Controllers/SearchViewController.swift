//
//  SearchViewController.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/17/23.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersTableView: UITableView!
    
    // TODO: Change struct type after API changes
    var usersArray: [User] = [User(userId: "1", email: "max@email.com", firstName: "Max", lastName: "Bagatini Alves"),
                              User(userId: "2", email: "ramir@email.com", firstName: "Ramir", lastName: "Dalencour"),
                              User(userId: "3", email: "steven@email.com", firstName: "Steven", lastName: "Grady")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        usersTableView.dataSource = self
        self.refreshSearch()
        
        // TODO: Remove later
        print()
        print("search jwt: " + User.getJwtToken())
    }
    
    func refreshSearch() {
        // TODO: Perform API call
        // ...
        
        usersTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Test if keyboard disappears on physical phone
        // ...
        
        print(searchText)
        refreshSearch()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        let user = usersArray[indexPath.row]
        cell.nameLabel.text = user.firstName + " " + user.lastName
        // TODO: Check if user is already followed or not
        // ...
        
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
