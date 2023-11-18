//
//  BadgeCell.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/17/23.
//

import UIKit

class BadgeCell: UITableViewCell {
    
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
