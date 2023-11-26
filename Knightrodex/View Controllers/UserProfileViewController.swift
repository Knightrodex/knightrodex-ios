//
//  UserProfileViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/9/23.
//

import UIKit
import Nuke

class UserProfileViewController: UIViewController, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emptyBadgesLabel: UILabel!
    
    // This is in testing stages so far:
    @IBOutlet weak var userProfileAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var numberFollowedUser: UILabel!
    @IBOutlet weak var numberBadgesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    let refreshControl = UIRefreshControl()

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
        
        imagePicker.delegate = self
        
        refreshControl.layer.zPosition = -1
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Profile...")
        tableView.refreshControl = refreshControl
        
        tableView.dataSource = self
        self.refreshProfile()
    }
    
    // This is for sending the badge details over t the Details View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        
        let selectedBadge = badges[selectedIndexPath.row]
        
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        
        detailViewController.badge = selectedBadge
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
                    self.createDateLabel.text = "Created at \(self.getFormattedDate(dateObtained: userProfile.dateCreated))"
                    self.numberFollowedUser.text = "\(noFollowedUsers)\nFollowing"
                    self.numberBadgesLabel.text = "\(badges.count)\nBadges"
                    
                    // Just for testing purposes:
                    let imageUrl = URL(string: userProfile.profilePicture)
                    
                    Nuke.loadImage(with: imageUrl!, into: self.userProfileAvatar)
                    
                    // Add the defer statement here in case of empty badges array
                    defer {
                        self.emptyBadgesLabel.isHidden = !badges.isEmpty
                    }
                    
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print("Show User Profile API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "User Profile Error", message: error.localizedDescription)
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func getFormattedDate(dateObtained: String) -> String {
        let dateFormatterGet = ISO8601DateFormatter()
        dateFormatterGet.formatOptions.insert(.withFractionalSeconds)

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateStyle = .short
        
        let date = dateFormatterGet.date(from: dateObtained)
        let displayDate = dateFormatterPrint.string(from: date!)
        
        return displayDate
    }
    
    @objc func refreshData(_ sender: Any) {
        refreshProfile()
    }
    
    @IBAction func didTapProfilePicture(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Photo Gallery", style: .default) { _ in
            self.openGallery()
        }
        alert.addAction(galleryAction)

        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        }
        alert.addAction(cameraAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    func openGallery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available on this device.")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImageToCloudiary(image: pickedImage, userId: user.userId) { imageURL in
                if let imageURL = imageURL {
                    uploadProfilePictureURL(userId: self.user.userId, url: imageURL) { result in
                        switch result {
                        case .success(let error):
                            DispatchQueue.main.async {
                                if (!error.isEmpty) {
                                    self.showAlert(title: "Picture Upload Failed", message: error)
                                    return
                                }
                                
                                let url = URL(string: imageURL)
                                Nuke.loadImage(with: url!, into: self.userProfileAvatar)
                            }
                        case .failure(let error):
                            print("Profile Picture API Call Error: \(error)")
                            DispatchQueue.main.async {
                                self.showAlert(title: "Picture Upload Error", message: error.localizedDescription)
                            }
                        }
                    }
                } else {
                    print("Image upload failed.")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Picture Upload Error", message: "Unkown Cloudinary error.")
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapLogOut(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create, configure, and return a table view cell for the given row (i.e., `indexPath.row`)
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeCell", for: indexPath) as! BadgeCell
        
        let badge = badges[indexPath.row]
        
        let imageUrl = URL(string: "https://i.ebayimg.com/images/g/xY8AAOSweFtlQUMn/s-l1600.png")
        
        Nuke.loadImage(with: imageUrl!, into: cell.posterImageView)
        
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
