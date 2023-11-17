//
//  UserTableViewCell.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/17/23.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapFollowButton(_ sender: Any) {
        // TODO: Check if followed or not and change text/image
        // ...
        
        print("follow " + nameLabel.text!)
    }
    

}
