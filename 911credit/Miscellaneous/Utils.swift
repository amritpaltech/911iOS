//
//  Utils.swift
//  911credit
//
//  Created by iChirag on 28/06/21.
//

import Foundation
import UIKit
import SVProgressHUD

class Utils {
    static let shared = Utils()
}

// MARK: - Alerts
extension Utils {
    
    class func notReadyAlert() {
        let alert = UIAlertController(title: "In development!", message: "This component isn't ready", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.show()
    }
    
    class func alert(message: String, title: String? = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//            action.setValue(UIColor.white, forKey: "titleTextColor")
            alert.addAction(action)
            alert.show()
        }
    }
    
    class func alert(message: String? = nil,
                     title: String? = nil,
                     titleImage: UIImage? = nil,
                     buttons: [String]? = nil,
                     preferredText: String? = nil,
                     cancel: String? = nil,
                     destructive: String? = nil,
                     type: UIAlertController.Style = .alert,
                     buttonColor: UIColor = UIColor.white,
                     preferredColor: UIColor = UIColor.white,
                     cancelColor: UIColor = UIColor.red,
                     handler: @escaping (Int) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: type)
            // Set Image with Title
            if titleImage != nil {
                // Create Attachment
                let imageAttachment =  NSTextAttachment()
                imageAttachment.image = titleImage
                let imageOffsetY: CGFloat = -15.0
                imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                
                let completeText = NSMutableAttributedString(string: "")
                completeText.append(attachmentString)
                
                let text = "\n" + (title ?? "")
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 0.7
                paragraphStyle.alignment = .center
                paragraphStyle.lineHeightMultiple = 1.4
                let titleImage = NSMutableAttributedString(string: text,
                                                           attributes: [
                                                            NSAttributedString.Key.foregroundColor: UIColor.black,
                                                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0),
                                                            NSAttributedString.Key.paragraphStyle: paragraphStyle
                                                           ]
                )
                completeText.append(titleImage)
                alert.setValue(completeText, forKey: "attributedTitle")
            } else {
                
                if let title = title {
                   /* let titFont = [NSAttributedString.Key.font: UIFont.semibold(sz: 17.0)]
                    let titAttrString = NSMutableAttributedString(string: title, attributes: titFont)
                    alert.setValue(titAttrString, forKey: "attributedTitle")*/
                }
                
                if let message = message {
                    /*let msgFont = [NSAttributedString.Key.font: UIFont.regular(sz: 13.0)]
                    let msgAttrString = NSMutableAttributedString(string: message, attributes: msgFont)
                    alert.setValue(msgAttrString, forKey: "attributedMessage")*/
                }
            }
            
            for button in buttons ?? [] {
                let action = UIAlertAction(title: button, style: .default) { (action) in
                    if let index = buttons?.firstIndex(of: action.title!) {
                        DispatchQueue.main.async {
                            handler(index)
                        }
                    }
                }
                action.setValue(buttonColor, forKey: "titleTextColor")
                alert.addAction(action)
            }
            
            if let preferredAction = preferredText {
                let action = UIAlertAction(title: preferredAction, style: .default) { (_) in
                    handler(buttons?.count ?? 0)
                }
                action.setValue(preferredColor, forKey: "titleTextColor")
                alert.addAction(action)
                alert.preferredAction = action
            }
            
            if let destructiveText = destructive {
                let action = UIAlertAction(title: destructiveText, style: .destructive) { (_) in
                    handler(buttons?.count ?? 0)
                }
                alert.addAction(action)
            }
            
            if let cancelText = cancel {
                let action = UIAlertAction(title: cancelText, style: .cancel) { (_) in
                    let index = (buttons?.count ?? 0) + (destructive != nil ? 1 : 0)
                    handler(index)
                }
                action.setValue(cancelColor, forKey: "titleTextColor")
                alert.addAction(action)
            }
            alert.show()
        }
    }
}

// MARK: - UserDefault Functions
extension Utils {
    class func saveDataToUserDefault(_ data: Any, _ key: String) {
        let archived = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
        UserDefaults.standard.set(archived, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getDataFromUserDefault(_ key: String) -> Any? {
        guard let archived =  UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archived)
    }
    
    class func removeDataFromUserDefault(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}

// MARK: - Spinner
extension Utils {
    class func showSpinner() {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show()
        }
    }
    
    class func showSpinner(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show(withStatus: message)
        }
    }
    class func hideSpinner() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
