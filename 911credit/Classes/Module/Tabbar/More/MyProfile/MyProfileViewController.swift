//
//  MyProfileViewController.swift
//  911credit
//
//  Created by ideveloper5 on 05/07/21.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var addressOneTextField: UITextField!
    @IBOutlet weak var addressTwoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "My Profile")
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
extension MyProfileViewController {
    func setupUI() {
    }
}

// MARK: - Actions
extension MyProfileViewController {
    
    @IBAction func saveAction(_ sender: Any) {
        updateProfile()
    }
}

// MARK: - API's
extension MyProfileViewController {
    func updateProfile() {
        if let firstName = firstNameTextField.text, firstName.isEmpty {
            Utils.showAlertMessage(message: "Please enter first name")
        } else if let lastName = lastNameTextField.text, lastName.isEmpty {
            Utils.showAlertMessage(message: "Please enter last name")
        } else if let phoneNumber = phoneNumberTextField.text, phoneNumber.isEmpty {
            Utils.showAlertMessage(message: "Please enter phone number")
        } else {
            Utils.showSpinner()
            let param = ["first_name": firstNameTextField.text, "last_name": lastNameTextField.text, "phone_number": phoneNumberTextField.text]
            APIServices.updateProfile(param: param as [String: Any]) { (message) in
                Utils.hideSpinner()
                Utils.showAlertAction(message: message, buttons: ["Ok"]) { action in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
