//
//  CaseManagementCell.swift
//  911credit
//
//  Created by ideveloper5 on 03/07/21.
//

import UIKit
import Kingfisher
class CaseManagementCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var agentImageView: UIImageView!
    @IBOutlet weak var agentNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(_ obj : Cases){
        nameLabel.text = obj.name
        descriptionLabel.text = obj.description
        dateLabel.text = ""
        statusLabel.text = obj.status
        if let url = URL(string: obj.matters?.first?.agentDetails?.avatar ?? "") {
            agentImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "user"), options: nil, completionHandler: nil)
        }
        let name = (obj.matters?.first?.agentDetails?.firstName ?? "") + " " + (obj.matters?.first?.agentDetails?.lastName ?? "")
        agentNameLabel.text = "Agent: " + name
    }
    
}
