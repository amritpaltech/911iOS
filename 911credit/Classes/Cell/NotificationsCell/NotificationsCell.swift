//
//  NotificationsCell.swift
//  911credit
//
//  Created by ideveloper5 on 05/07/21.
//

import UIKit

class NotificationsCell: UITableViewCell {
    
    @IBOutlet weak var notificationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
