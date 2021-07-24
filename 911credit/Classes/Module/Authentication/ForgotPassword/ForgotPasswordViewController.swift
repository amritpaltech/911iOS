//
//  ForgotPasswordViewController.swift
//  911credit
//
//  Created by ideveloper5 on 02/07/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Forgot Password")
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: false)
     }
     
     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: false)
     }
}

// MARK: - Actions
extension ForgotPasswordViewController {
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        forgotPassword()
    }
}

// MARK: - API's
extension ForgotPasswordViewController {
    func forgotPassword() {
        if let forgotPassword = emailTextField.text, forgotPassword.isEmpty {
            Utils.showAlertMessage(message: "Please enter email address")
        } else {
            Utils.showSpinner()
            let param = ["email": emailTextField.text]
            APIServices.forgotPassword(param: param as [String : Any]) { (message) in
                Utils.hideSpinner()
                Utils.showAlertAction(message: message, buttons: ["Ok"]) { action in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
