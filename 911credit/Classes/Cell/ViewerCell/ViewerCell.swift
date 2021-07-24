//
//  ViewerCell.swift
//  911credit
//
//  Created by ideveloper5 on 29/06/21.
//

import UIKit

class ViewerCell: UICollectionViewCell {
    static let cellid = "ViewerCell"

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
