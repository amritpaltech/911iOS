//
//  SideMenuTableViewCell.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import UIKit

class MoreViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreListImageView: UIImageView!
    @IBOutlet weak var moreListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
