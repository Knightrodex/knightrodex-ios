//
//  ActivityTableViewCell.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/17/23.
//

import Nuke
import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

    func setActivity(_ activity: Activity) {
        let profileImgURL = URL(string: activity.profilePicture)
        let firstName = activity.firstName
        let lastName = activity.lastName
        let email = activity.email
        let badgeTitle = "\"\(activity.badgeTitle)\""
        let date = getFormattedDate(dateObtained: activity.dateObtained)
        
        let fullText = "Obtained \(badgeTitle) badge!"
        let range = (fullText as NSString).range(of: badgeTitle)
        let attributedText = NSMutableAttributedString.init(string: fullText)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue , range: range)
        
        Nuke.loadImage(with: profileImgURL!, into: self.userProfileAvatar)
        self.nameLabel.text = "\(firstName) \(lastName)"        
        self.emailLabel.text = email
        self.label.attributedText = attributedText
        self.dateLabel.text = date
    }
    
    func getFormattedDate(dateObtained: String) -> String {
        let dateFormatterGet = ISO8601DateFormatter()
        dateFormatterGet.formatOptions.insert(.withFractionalSeconds)

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateStyle = .medium
        dateFormatterPrint.timeStyle = .short
        
        let timeAgoformatter = RelativeDateTimeFormatter()
        timeAgoformatter.unitsStyle = .full
        
        let date = dateFormatterGet.date(from: dateObtained)
        let displayDate = dateFormatterPrint.string(from: date!)
        let timeAgo = timeAgoformatter.localizedString(for: date!, relativeTo: Date())
        
        return "\(timeAgo) · \(displayDate)"
    }
}
