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
    var activityArray: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.layer.zPosition = -1
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Activity...")
        activityTableView.refreshControl = refreshControl
        
        activityTableView.dataSource = self
        self.refreshActivity()
    }
    
    func refreshActivity() {
        getActivity(userId: user.userId) { result in
            switch result {
            case .success(let activities):
                DispatchQueue.main.async {
                    self.activityArray = activities
                    self.refreshControl.endRefreshing()
                    self.activityTableView.reloadData()
                }
            case .failure(let error):
                print("Get Activity API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Activity Error", message: error.localizedDescription)
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc func refreshData(_ sender: Any) {
        refreshActivity()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        
        cell.setActivity(activityArray[indexPath.row])
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
