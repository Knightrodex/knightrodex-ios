//
//  HomeViewController.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/17/23.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var activityTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var user = User.getUserLogin()
    // TODO: Change data type after API changes
    var activityArray: [String] = ["You obtained the \"Spirit Splash 2023\" Badge - (1 min ago)",
                                   "Ramir obtained the \"Spirit Splash 2023\" Badge - (3 hrs ago)",
                                   "Steven obtained the \"Spirit Splash 2023\" Badge - (1 day ago)",
                                   "Caleb obtained the \"Spirit Splash 2023\" Badge - (5 days ago)",
                                   "Ethan obtained the \"Bachata 4 Life\" Badge - (11/09/2023)",
                                   "Zach obtained the \"G.O.A.T.\" Badge - (09/10/2023)",
                                   "Caden obtained the \"The Band\" Badge - (06/20/2023)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.layer.zPosition = -1
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Activity...")
        activityTableView.refreshControl = refreshControl
        
        activityTableView.dataSource = self
        self.refreshActivity()
        
        // TODO: Remove later
        print()
        print("home jwt: " + User.getJwtToken())
    }
    
    func refreshActivity() {
        // TODO: Perform API call
        // ...
        refreshControl.endRefreshing()
        activityTableView.reloadData()
    }
    
    @objc func refreshData(_ sender: Any) {
        refreshActivity()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        
        // TODO: Improve later
        cell.label.text = activityArray[indexPath.row]
        
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
