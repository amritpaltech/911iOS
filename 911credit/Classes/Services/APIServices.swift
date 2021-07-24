//
//  APIServices.swift
//  911credit
//
//  Created by ideveloper5 on 08/07/21.
//

import UIKit

class APIServices: NSObject {
    
    class func decodeObject<T: Decodable>(fromData data: Any?) -> T? {
        if let data = data {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            return try? jsonDecoder.decode(
                T.self, from: JSONSerialization.data(withJSONObject: data, options: [])
            ) as T?
        } else {
            return nil
        }
    }
    
    class func loginRequest(param: [String: Any], complition: @escaping(() -> Void)) {
        NetworkManager.shared.requestPost(path: API.login.rawValue, params: param, contentType: .formUrlencoded) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if  result["status"] as? String == "success" {
                        if let data = result["data"] {
                            if let user: User? = self.decodeObject(fromData: data) {
                                Utils.saveUserData(userInfo: user)
                            }
                            complition()
                        }
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func generateToken( complition: @escaping(() -> Void)) {
        NetworkManager.shared.requestGet(path: API.generattoken.rawValue, params: (Any).self) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if result["status"] as? String == "success" {
                        complition()
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func verificationCode(param: [String: Any], complition: @escaping(() -> Void)) {
        NetworkManager.shared.requestPost(path: API.verificationcode.rawValue, params: param, contentType: .formUrlencoded) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if result["status"] as? String == "success" {
                        complition()
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func resendOTP( complition: @escaping((_ message: String) -> Void)) {
        NetworkManager.shared.requestGet(path: API.generattoken.rawValue, params: (Any).self) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if result["status"] as? String == "success" {
                        complition(result["message"] as? String ?? "")
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func forgotPassword(param: [String: Any], complition: @escaping((_ message: String) -> Void)) {
        NetworkManager.shared.requestPost(path: API.forgotpassword.rawValue, params: param, contentType: .formUrlencoded) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if result["status"] as? String == "success" {
                        complition(result["message"] as? String ?? "")
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func changePassword(param: [String: Any], complition: @escaping((_ message: String) -> Void)) {
        NetworkManager.shared.requestPost(path: API.changepassword.rawValue, params: param, contentType: .formUrlencoded) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if result["status"] as? String == "success" {
                        complition(result["message"] as? String ?? "")
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func updateProfile(param: [String: Any], complition: @escaping((_ message: String) -> Void)) {
        NetworkManager.shared.requestPost(path: API.updateprofile.rawValue, params: param, contentType: .formUrlencoded) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if result["status"] as? String == "success" {
                        complition(result["message"] as? String ?? "")
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func getUserInfo(complition: @escaping((_ list: Security?, _ code: String) -> Void)) {
        NetworkManager.shared.requestGet(path: API.getuserinfo.rawValue, params: (Any).self) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if  result["status"] as? String == "success" {
                        if let data = result["data"] {
                            let info: Security? = self.decodeObject(fromData: data)
                            complition(info, result["code"] as? String ?? "")
                        }
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func updateAvatar(param: [String: Any],complition: @escaping((_ message: String) -> Void)) {
        NetworkManager.shared.requestPost(path: API.updateavatar.rawValue, params: param, contentType: .formUrlencoded) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if result["status"] as? String == "success" {
                        complition(result["message"] as? String ?? "")
                    } else {
                        Utils.hideSpinner()
                        Utils.showAlertMessage(message: result["message"] as? String ?? "")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    class func securityQuestion(param: [String: Any],complition: @escaping((_ status: String,_ message:String) -> Void)) {
        NetworkManager.shared.requestPost(path: API.securityquestions.rawValue, params: param, contentType: .formUrlencoded) { response, error, _ in
            if error == nil {
                if let result = response as? [String: Any] {
                    if result["status"] as? String == "success" {
                        complition(result["status"] as? String ?? "",result["message"] as? String ?? "")
                    } else {
                        complition("fail","")
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.showAlertMessage(message: error?.localizedDescription ?? "")
            }
        }
    }

}
