//
//  CaseManagementDetailsViewController.swift
//  911credit
//
//  Created by ideveloper5 on 03/07/21.
//

import UIKit

class CaseManagementDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var agentImageView: UIImageView!
    @IBOutlet weak var agentNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var caseMangement : Cases?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Case Management")
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func initData(){
        guard let obj = caseMangement else {
            return
        }
        nameLabel.text = obj.name
        descriptionLabel.text = obj.description
        dateLabel.text = ""
        statusLabel.text = obj.status
        if let url = URL(string: obj.matters?.first?.agentDetails?.avatar ?? "") {
            //agentImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "user"), options: nil, completionHandler: nil)
        }
        let name = (obj.matters?.first?.agentDetails?.firstName ?? "") + " " + (obj.matters?.first?.agentDetails?.lastName ?? "")
        agentNameLabel.text = "Agent: " + name

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
