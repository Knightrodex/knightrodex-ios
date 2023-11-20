//
//  UserTableViewCell.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/17/23.
//

import Nuke
import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user: User = User.initializeUser()
    var isFollowed = false;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapFollowButton(_ sender: Any) {
        followButton.isUserInteractionEnabled = false
        
        updateFollowStatus(currentUserId: User.getUserLogin().userId, otherUserId: user.userId, shouldFollow: !isFollowed) { result in
            switch result {
            case .success(let error):
                DispatchQueue.main.async {
                    if (!error.isEmpty) {
                        print("Follow/Unfollow API Call Failed: \(error)")
                        return
                    }
                    self.isFollowed = !self.isFollowed
                    self.checkButtonStyle()
                    self.followButton.isUserInteractionEnabled = true
                }
            case .failure(let error):
                print("Follow/Unfollow API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.followButton.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func setUserJson(json: [String: Any]) {
        do {
//            let data = try JSONSerialization.data(withJSONObject: json, options: [])
//            user = try JSONDecoder().decode(User.self, from: data)
            user = User.init(userId: json["_id"] as? String ?? "",
                             email: json["email"] as? String ?? "",
                             firstName: json["firstName"] as? String ?? "",
                             lastName: json["lastName"] as? String ?? "")
            isFollowed = ((json["isFollowed"] as? NSNumber ?? 0).intValue == 1)
            
            let profileImgURL = URL(string: json["profilePicture"] as? String ?? "")
            if (profileImgURL != nil) {
                Nuke.loadImage(with: profileImgURL!, into: self.userProfileAvatar)
            }
            
            checkButtonStyle()
            
            self.emailLabel.text = user.email
            self.nameLabel.text = "\(user.firstName) \(user.lastName)"
        } catch {
            print("Parsing Error: \(error.localizedDescription)")
        }
    }
    
    func checkButtonStyle() {
        if (isFollowed) {
            followButton.setTitle("Unfollow", for: UIControl.State.normal)
            followButton.sizeToFit()
            followButton.tintColor = UIColor.gray
        } else {
            followButton.setTitle("Follow", for: UIControl.State.normal)
            followButton.sizeToFit()
            followButton.tintColor = UIColor.systemBlue
        }
    }
}
