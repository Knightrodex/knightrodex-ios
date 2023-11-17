//
//  ScannerViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/3/23.
//

import UIKit

class ScannerViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var hintsTableView: UITableView!
    
    var user: User = User.getUserLogin()
    var hintsArray: [String] = []
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.layer.zPosition = -1
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Hints...")
        hintsTableView.refreshControl = refreshControl
        
        hintsTableView.dataSource = self
        self.refreshHints()
        
        // TODO: Remove later
        print()
        print("scanner jwt: " + User.getJwtToken())
    }
    
    func refreshHints() {
        getHints(userId: user.userId) { result in
            switch result {
            case .success(let hints):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.hintsArray = hints
                    self.hintsTableView.reloadData()
                }
            case .failure(let error):
                print("Get Hints API Call Failed: \(error)")
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.showAlert(title: "Hints Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func refreshData(_ sender: Any) {
        refreshHints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hintsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HintTableViewCell", for: indexPath) as! HintTableViewCell
        cell.hintLabel.text = hintsArray[indexPath.row]
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

