//
//  TableViewExtension.swift
//  911credit
//
//  Created by iChirag on 28/06/21.
//

import UIKit
import Foundation

extension UITableView {
    
    func register(cell nibName: String) {
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func register(view nibName: String) {
        register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    func updateTable() {
        // Disable animations
        UIView.setAnimationsEnabled(false)
        beginUpdates()
        endUpdates()
        // Enable animations
        UIView.setAnimationsEnabled(true)
    }
    
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
    
    func updateFooterViewHeight() {
        if let footer = self.tableFooterView {
            let newSize = footer.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            footer.frame.size.height = newSize.height
        }
    }
}

extension UIView {
    func setupShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true
    }
}
