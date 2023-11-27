//
//  DetailViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/18/23.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    
    var badge: BadgesCollected!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var dateObtainedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var badgeNumberLabel: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = badge.title
        dateObtainedLabel.text = badge.dateObtained
        descriptionLabel.text = badge.description
        badgeNumberLabel.text = "Badge Number: \(badge.uniqueNumber)"
        
        // Those are just for testing purposes:
        let imageUrl = URL(string: "https://i.ebayimg.com/images/g/xY8AAOSweFtlQUMn/s-l1600.png")
        
        Nuke.loadImage(with: imageUrl!, into: posterImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapViewController = segue.destination as? MapViewController else { return }
        
        mapViewController.lat = badge.coordinates[0]
        mapViewController.long = badge.coordinates[1]
    }
    
    
    
    // This is for sending the badge details over t the Details View Controller
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
//        
//        let selectedBadge = badges[selectedIndexPath.row]
//        
//        guard let detailViewController = segue.destination as? DetailViewController else { return }
//        
//        detailViewController.badge = selectedBadge
//    }
    

}
