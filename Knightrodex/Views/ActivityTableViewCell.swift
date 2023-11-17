//
//  ActivityTableViewCell.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/17/23.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

}
