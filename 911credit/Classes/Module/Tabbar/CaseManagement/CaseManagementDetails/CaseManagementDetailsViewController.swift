//
//  CaseManagementDetailsViewController.swift
//  911credit
//
//  Created by ideveloper5 on 03/07/21.
//

import UIKit

class CaseManagementDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Case Management")
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

// MARK: - Actions
extension CaseManagementDetailsViewController {
    
    @IBAction func chatWithAgentButtonAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(
                withIdentifier: "ChatDetailsViewController") as? ChatDetailsViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
