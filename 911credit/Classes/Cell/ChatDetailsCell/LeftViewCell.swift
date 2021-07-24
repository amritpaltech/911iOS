//
//  LeftViewCell.swift
//  911credit
//
//  Created by ideveloper5 on 10/07/21.
//

import UIKit

class LeftViewCell: UITableViewCell {
    
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message: Message) {
        textMessageLabel.text = message.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
