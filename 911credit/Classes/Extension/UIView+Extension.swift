//
//  UIView+Extension.swift
//  911credit
//
//  Created by ideveloper5 on 29/06/21.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        //        mask.masksToBounds = true
        layer.mask = mask
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func removeGradient(){
        if let lastLayer = self.layer.sublayers?.first(where: { (layer) -> Bool in
            return layer.name ?? "" == "Gradient"
        }) {
            lastLayer.removeFromSuperlayer()
        }
    }
    
    func underlined(color:UIColor,width:CGFloat){
        
        let layer = UIView()
        
        layer.frame = CGRect.init(x:0.0, y: self.frame.size.height - 1, width: width, height: 1.5)
        
        layer.backgroundColor = color
        
        self.addSubview(layer)
    }
}
