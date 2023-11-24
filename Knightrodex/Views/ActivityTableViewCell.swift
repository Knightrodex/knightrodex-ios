//
//  ActivityTableViewCell.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/17/23.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
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
        let firstName = activity.firstName
        let lastName = activity.lastName
        // let profilePicture = activity.profilePicture
        // let badgeName = activity.badgeName
        let badgeName = activity.badgeID
        let date = getFormattedDate(dateObtained: activity.dateObtained)
        
        self.label.text = "\(firstName) \(lastName) obtained \"\(badgeName)\" badge!"
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
