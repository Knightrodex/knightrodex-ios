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
    
    var user = User.getUserLogin()
    
    var usersArray: [[String: Any]] = []
    
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
        searchEmail(userId: user.userId, email: searchBar.text!) { result in
            switch result {
            case .success(let json):
                DispatchQueue.main.async {
                    self.usersArray = json
                    self.usersTableView.reloadData()
                }
            case .failure(let error):
                print("Search Email API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Search Email Error", message: error.localizedDescription)
                }
            }
        }
        
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
        cell.setUserJson(json: user)
        
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
