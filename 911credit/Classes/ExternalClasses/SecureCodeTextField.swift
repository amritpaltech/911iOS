//
//  SecureCodeTextField.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import Foundation
import UIKit

class SecureCodeTextField: UITextField {

    // MARK: Properties

    var previousTextField: UITextField?
    var nextTextField: UITextField?
    var textFieldDidEndEditingCompletion: ((UITextField) -> Void)?
    var moveToNextFromCurrentTextFieldCompletion: ((UITextField) -> Void)?

    // MARK: Object Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }

    // MARK: Superclass Functions

    /// Add additional actions to backspace event
    override func deleteBackward() {
        super.deleteBackward()
        moveToPreviousFromCurrent(self)
    }

    /// Prevent user from accessing UITextField action menu
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

// MARK: UITextFieldDelegate

extension SecureCodeTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textRange = Range.init(range, in: textField.text!), let endString = textField.text?.replacingCharacters(in: textRange, with: string) {
            if endString.count > 1 {
                nextTextField?.text = string
                moveToNextFromCurrent(textField)
            }

            if endString.count == 1 {
                textField.text = endString
                moveToNextFromCurrent(textField)
            }

            if endString.count <= 0 {
                textField.text = ""
                moveToPreviousFromCurrent(textField)
            }
        }

        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditingCompletion?(textField)
    }
}

// MARK: Helpers

private extension SecureCodeTextField {
    func moveToPreviousFromCurrent(_ textField: UITextField) {
        textField.resignFirstResponder()
        previousTextField?.becomeFirstResponder()
    }

    func moveToNextFromCurrent(_ textField: UITextField) {
        textField.resignFirstResponder()
        nextTextField?.becomeFirstResponder()
        moveToNextFromCurrentTextFieldCompletion?(textField)
    }
}
