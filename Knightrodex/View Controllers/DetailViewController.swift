//
//  DetailViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/18/23.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    
    // May have to remove this!
    var badge: BadgesCollected!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var dateObtainedLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var badgeNumberLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = badge.title
        dateObtainedLabel.text = badge.dateObtained
        locationLabel.text = "Somewhere"
        descriptionLabel.text = badge.description
        badgeNumberLabel.text = "Badge Number: \(badge.uniqueNumber)"
        
        // Those are just for testing purposes:
        let imageUrl = URL(string: "https://i.ebayimg.com/images/g/xY8AAOSweFtlQUMn/s-l1600.png")
        
        Nuke.loadImage(with: imageUrl!, into: posterImage)
    }
    

}
