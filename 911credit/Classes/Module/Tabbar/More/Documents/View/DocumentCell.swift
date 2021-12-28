//
//  DocumentCell.swift
//  911credit
//
//  Created by shubham singla on 09/08/21.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initCellForRequired(_ required:Document){
        titleLbl.text = required.label
        self.docStatusHandling(required.status ?? "")
        descLbl.text = required.description!.count > 0 ? required.description : required.message
    }

    func docStatusHandling(_ status:String){
        if status == "missing" {
            bgView.backgroundColor = #colorLiteral(red: 1, green: 0.9921568627, blue: 0.7960784314, alpha: 1)
            descLbl.text = "..."
            descLbl.textColor = #colorLiteral(red: 0.9607843137, green: 0.5764705882, blue: 0.2588235294, alpha: 1)
            titleLbl.textColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
            imgView.image = #imageLiteral(resourceName: "greydot")
            imageView?.setImageColor(color: #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1))
        } else if status == "pending" {
            bgView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9764705882, blue: 0.9529411765, alpha: 1)
            descLbl.text = "Pending Approval"
            descLbl.textColor = #colorLiteral(red: 0.9607843137, green: 0.5764705882, blue: 0.2588235294, alpha: 1)
            titleLbl.textColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
            imgView.image = #imageLiteral(resourceName: "greydot")
            imageView?.setImageColor(color: #colorLiteral(red: 0.9607843137, green: 0.5764705882, blue: 0.2588235294, alpha: 1))
        } else if status == "approved" {
            bgView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.9450980392, blue: 0.8941176471, alpha: 1)
            descLbl.text = "Completed"
            descLbl.textColor = #colorLiteral(red: 0.1882352941, green: 0.6235294118, blue: 0.4941176471, alpha: 1)
            titleLbl.textColor = .black
            imgView.image = #imageLiteral(resourceName: "rightGreen")
            imageView?.setImageColor(color: #colorLiteral(red: 0.1882352941, green: 0.6235294118, blue: 0.4941176471, alpha: 1))
        } else if status == "rejected" {
            bgView.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.231372549, blue: 0.168627451, alpha: 1)
            descLbl.text = "Rejected"
            descLbl.textColor = .white
            titleLbl.textColor = .white
            imgView.image = #imageLiteral(resourceName: "rejectedProof")
            imageView?.setImageColor(color: .white)
        }
    }
    
    func initCellForOther(_ other:Document){
        titleLbl.text = other.label
        self.docStatusHandling(other.status ?? "")
        descLbl.text = other.description!.count > 0 ? other.description : other.message

    }

}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
