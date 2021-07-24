//
//  OptionQuestionTableCell.swift
//  911credit
//
//  Created by ideveloper5 on 22/07/21.
//

import UIKit

class OptionQuestionTableCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
