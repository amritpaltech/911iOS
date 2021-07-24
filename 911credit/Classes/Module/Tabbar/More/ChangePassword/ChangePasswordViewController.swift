//
//  ChangePasswordViewController.swift
//  911credit
//
//  Created by ideveloper5 on 05/07/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Change Password")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Methods
extension ChangePasswordViewController {
    func setupUI() {
        //        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - Actions
extension ChangePasswordViewController {
    
    @IBAction func saveAction(_ sender: Any) {
        changePassword()
    }
}

// MARK: - API's
extension ChangePasswordViewController {
    func changePassword() {
        if let firstName = newPasswordTextField.text, firstName.isEmpty {
            Utils.showAlertMessage(message: "Please enter first name")
        } else if let lastName = confirmPasswordTextField.text, lastName.isEmpty {
            Utils.showAlertMessage(message: "Please enter last name")
        } else {
            Utils.showSpinner()
            let param = ["new_password": newPasswordTextField.text, "new_confirm_password": confirmPasswordTextField.text]
            APIServices.changePassword(param: param as [String: Any]) { (message) in
                Utils.hideSpinner()
                Utils.showAlertAction(message: message, buttons: ["Ok"]) { action in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
