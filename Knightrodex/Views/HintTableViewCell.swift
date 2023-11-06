//
//  HintTableViewCell.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/6/23.
//

import UIKit

class HintTableViewCell: UITableViewCell {

    @IBOutlet weak var hintLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
