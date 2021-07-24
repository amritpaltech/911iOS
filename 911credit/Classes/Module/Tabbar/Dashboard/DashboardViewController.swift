//
//  DashboardViewController.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import UIKit

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var failureView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        setupUI()
    }
}

// MARK: - Methods
extension DashboardViewController {
    func setupUI() {
        self.navigationItem.title = "Dashboard"
    }
}

// MARK: - API's
extension DashboardViewController {
    func getUserInfo() {
        if let value = UserDefaults.standard.value(forKey: "unauthorized") as? Bool,value{
            failureView.isHidden = false
            return
        }
        failureView.isHidden = true
        Utils.showSpinner()
        APIServices.getUserInfo {(list, code) in
            Utils.hideSpinner()
            if code == "100" {
                AppDelegate.shared?.setupSecurityQuestion()
            } else {
                //load dashboard data
            }
        }
    }
}

// MARK: - Actions
extension DashboardViewController {
    
    @IBAction func openQuestion(_ sender: Any) {
    }
}
