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
    
    @IBOutlet weak var oneOTPTextFeild: UITextField!
    @IBOutlet weak var twoOTPTextFeild: UITextField!
    @IBOutlet weak var threeOTPTextFeild: UITextField!
    @IBOutlet weak var fourOTPTextFeild: UITextField!
    @IBOutlet weak var fiveOTPTextFeild: UITextField!
    @IBOutlet weak var sixOTPTextFeild: UITextField!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    var textFields: [UITextField] = []
//    SecureCodeTextField
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
            textfield.delegate = self
            textfield.addBottomBorder(value: -2, color: UIColor.darkGray)
        }
//        let minIndex = 0
//        let maxIndex = textFields.count - 1
//
//        for index in minIndex...maxIndex {
//            if index != minIndex {
//                textFields[index].previousTextField = textFields[index - 1]
//            }
//            if index != maxIndex {
//                textFields[index].nextTextField = textFields[index + 1]
//            }
//            textFields[index].textFieldDidEndEditingCompletion = textFieldDidEndEditingCompletion(_:)
//            textFields[index].moveToNextFromCurrentTextFieldCompletion = moveToNextFromCurrentTextFieldCompletion(_:)
//        }
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
extension VerificationCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1  && string.count > 0) || (textField.text?.count == 1 && string.count > 0) {
            let nextTag = textField.tag + 1
            
            // get next responder
            let nextResponder = textField.superview?.viewWithTag(nextTag)
            textField.text = string
            
            if (nextResponder == nil) {
                textField.resignFirstResponder()
            }
            nextResponder?.becomeFirstResponder()
            return false
        }
        else if ((textField.text?.count)! >= 1  && string.count == 0) {
            // on deleting value from Textfield
            let previousTag = textField.tag - 1;
            
            // get previous responder
            var previousResponder = textField.superview?.viewWithTag(previousTag)
            
            if (previousResponder == nil) {
                previousResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
            return false
        }
        return true
    }
}

extension UITextField {
    func addBottomBorder(value:CGFloat = 1,color:UIColor = .black){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height + value, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

