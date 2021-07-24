//
//  UIViewControllerExtension.swift
//  911credit
//
//  Created by ideveloper5 on 13/07/21.
//

import Foundation
import UIKit

extension UIViewController {

    func setLeftAlignedNavigationItemTitle(text: String) {
        
        let title = UILabel()
        title.textColor = UIColor.black
        title.text = text
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: title)
        self.navigationItem.leftItemsSupplementBackButton = true
        
        let string = text
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.montserratMedium(size: 24)]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        title.attributedText = attributedString
    }
}
