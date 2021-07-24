//
//  VerificationCodeViewController.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import UIKit

class VerificationCodeViewController: UIViewController {
    
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var oneOTPTextFeild: SecureCodeTextField!
    @IBOutlet weak var twoOTPTextFeild: SecureCodeTextField!
    @IBOutlet weak var threeOTPTextFeild: SecureCodeTextField!
    @IBOutlet weak var fourOTPTextFeild: SecureCodeTextField!
    @IBOutlet weak var fiveOTPTextFeild: SecureCodeTextField!
    @IBOutlet weak var sixOTPTextFeild: SecureCodeTextField!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    var textFields: [SecureCodeTextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Login")
        setupTextField()
        setupUI()
        generateToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupTextField() {
        textFields = [oneOTPTextFeild, twoOTPTextFeild, threeOTPTextFeild, fourOTPTextFeild, fiveOTPTextFeild, sixOTPTextFeild]
        textFields.forEach { (textfield) in
            textfield.tintColor = .white
            textfield.keyboardType = .numberPad
        }
        let minIndex = 0
        let maxIndex = textFields.count - 1
        
        for index in minIndex...maxIndex {
            if index != minIndex {
                textFields[index].previousTextField = textFields[index - 1]
            }
            if index != maxIndex {
                textFields[index].nextTextField = textFields[index + 1]
            }
            textFields[index].textFieldDidEndEditingCompletion = textFieldDidEndEditingCompletion(_:)
            textFields[index].moveToNextFromCurrentTextFieldCompletion = moveToNextFromCurrentTextFieldCompletion(_:)
        }
    }
}

// MARK: - Methods
extension VerificationCodeViewController {
    
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        resendOTPButton.setAttributedTitle("Resend OTP?".attributedUnderLineWithRedText, for: .normal)
        if let info = Utils.getUserInfo()?.phoneNumber {
            self.mobileNumberLabel.text = "Please enter the verification code sent to \(info)"
        }
        oneOTPTextFeild.becomeFirstResponder()
    }
}

// MARK: - Actions
extension VerificationCodeViewController {
    
    @IBAction func resendOTPAction(_ sender: Any) {
        Utils.showSpinner()
        APIServices.resendOTP { (message) in
            Utils.hideSpinner()
            Utils.showAlertMessage(message: message)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        verificationCode()
        resetTextFields()
    }
    
    func textFieldDidEndEditingCompletion(_ textField: UITextField) {
        if isFilledAllTextFields() {
            print(getEnteredCode())
            view.endEditing(true)
            // API Calling
        } else {
            
        }
    }
    
    func moveToNextFromCurrentTextFieldCompletion(_ textField: UITextField) {
        if textField.isEqual(fiveOTPTextFeild) && isFilledAllTextFields() {
            view.endEditing(true)
        }
    }
    
    private func isFilledAllTextFields() -> Bool {
        for textField in textFields {
            if textField.text == nil || textField.text?.count != 1 {
                return false
            }
        }
        return true
    }
    
    private func getEnteredCode() -> String {
        var enteredCode = ""
        for textField in textFields {
            if let code = textField.text {
                enteredCode.append(code)
            }
        }
        return enteredCode
    }
    
    private func resetTextFields() {
        for textField in textFields {
            textField.text = ""
        }
    }
}

// MARK: - API's
extension VerificationCodeViewController {
    
    func generateToken() {
        APIServices.generateToken {
            print("Generate Token")
        }
    }
    
    func verificationCode() {
        
        if getEnteredCode().count == 6 {
            Utils.showSpinner()
            let param = ["code": getEnteredCode()]
            APIServices.verificationCode(param: param as [String : Any]) {
                Utils.hideSpinner()
                let info = Utils.getUserInfo()?.id
                Utils.saveDataToUserDefault(info as Any, "storeId")
                AppDelegate.shared?.setupTabbar()
            }
        } else {
            Utils.showAlertMessage(message: "Please enter valid verification code")
        }
    }
}
