//
//  StringExtension.swift
//  911credit
//
//  Created by iChirag on 28/06/21.
//

import Foundation
import UIKit

extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    var isValidEmailAddress: Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.+-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    var numberWithoutFormat: String {
        return replacingOccurrences(of: "[ |()-/]", with: "", options: [.regularExpression])
    }
    var inPhoneNumberWithoutCode: String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    var attributedUnderLineWithRedText: NSAttributedString {
        let attrs = [NSAttributedString.Key.underlineStyle: 1] as [NSAttributedString.Key: Any]
          let buttonTitleStr = NSMutableAttributedString(string: self, attributes: attrs)
          let attributedString = NSMutableAttributedString(string: "")
          attributedString.append(buttonTitleStr)
          return attributedString
      }
    
    func base64ToImage() -> UIImage? {
          if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
              return image
          }
          return nil
      }
    

    func htmlToString() -> String {

            guard let data = self.data(using: .utf8) else {
                return self
            }

            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]

            guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
                return self
            }

        return attributedString.string

        }
}
