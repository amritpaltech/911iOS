//
//  CaseManagementViewController.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import UIKit

class CaseManagementViewController: BaseViewController {
    
    @IBOutlet weak var caseManagementTableview: UITableView!
    var cases : [Cases] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        setLeftAlignedNavigationItemTitle(text: "Case Management")
                self.navigationItem.title = "Case Management"

        setupUI()
    }
}

// MARK: - Methods
extension CaseManagementViewController {
    func setupUI() {
        self.caseManagementTableview.delegate = self
        self.caseManagementTableview.dataSource = self
        self.caseManagementTableview.register(UINib(nibName: "CaseManagementCell", bundle: nil), forCellReuseIdentifier: "CaseManagementCell")
        self.getCaseList()
    }
    
    
    func getCaseList() {
        Utils.showSpinner()
        APIServices.getCaseList{list in
            Utils.hideSpinner()
            //load dashboard data
            self.cases = list ?? []
            self.caseManagementTableview.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension CaseManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = caseManagementTableview.dequeueReusableCell(withIdentifier: "CaseManagementCell") as? CaseManagementCell ?? CaseManagementCell()
        let obj = self.cases[indexPath.row]
        cell.initCell(obj)
        cell.descriptionLabel.numberOfLines = 3
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(
                withIdentifier: "CaseManagementDetailsViewController") as? CaseManagementDetailsViewController else { return }
        
        vc.caseMangement = self.cases[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
