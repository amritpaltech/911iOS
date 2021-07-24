//
//  Utils+Credit.swift
//  911credit
//
//  Created by ideveloper5 on 08/07/21.
//

import Foundation
import UIKit

enum Key: String {
    case userInfo
}

extension Utils {
    
    class func showAlertMessage(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.show()
        }
    }
    
    class func showAlertAction(message: String, buttons: [String]? = nil, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (_) in
                handler(buttons?.count ?? 0)
            }
            alert.addAction(OKAction)
            alert.show()
        }
    }
    
    class func saveUserData(userInfo: User?) {
        guard let userInfo = userInfo else {
            UserDefaults.standard.removeObject(forKey: Key.userInfo.rawValue)
            return
        }
        let v = try? JSONEncoder().encode(userInfo)
        UserDefaults.standard.set(v, forKey: Key.userInfo.rawValue)
    }
    
    class func getUserInfo() -> User? {
        if let data = UserDefaults.standard.object(forKey: Key.userInfo.rawValue) as? Data {
            return try? JSONDecoder().decode(User.self, from: data)
        } else {
            return nil
        }
    }
    
    class func removeUserInfo() {
        UserDefaults.standard.removeObject(forKey: Key.userInfo.rawValue)
        UserDefaults.standard.synchronize()
    }
}
