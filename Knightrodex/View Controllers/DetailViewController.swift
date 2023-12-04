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
        dateObtainedLabel.text = getFormattedDate(dateObtained: badge.dateObtained)
        descriptionLabel.text = badge.description
        badgeNumberLabel.text = "Badge Number: \(badge.uniqueNumber)"
        
        // Those are just for testing purposes:
//        let imageUrl = URL(string: "https://i.ebayimg.com/images/g/xY8AAOSweFtlQUMn/s-l1600.png")
        let imageUrl = URL(string: badge.badgeImage)
        
        Nuke.loadImage(with: imageUrl!, into: posterImage)
        
        // May have to delete
        navigationItem.largeTitleDisplayMode = .never
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapViewController = segue.destination as? MapViewController else { return }
        
        mapViewController.lat = badge.coordinates[0]
        mapViewController.long = badge.coordinates[1]
        mapViewController.tittle = badge.title
    }
}
