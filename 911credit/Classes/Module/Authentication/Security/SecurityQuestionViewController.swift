//
//  SecurityQuestionViewController.swift
//  911credit
//
//  Created by ideveloper5 on 22/07/21.
//

import UIKit

class SecurityQuestionViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sucessMsgLbl: UILabel!
    
    var jsonString = String()
    var authtoken = String()
    var questionData = [Any]()
    var ansData = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        setupUI()
        self.navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Methods
extension SecurityQuestionViewController {
    func setupUI() {
        setLeftAlignedNavigationItemTitle(text: "Security Questions")
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UINib(nibName: "SecurityQuestionCell", bundle: nil), forCellReuseIdentifier: "SecurityQuestionCell")
        tableview.reloadData()
        submitButton.isHidden = true
        successView.isHidden = true
        errorView.isHidden = true
    }
    
    func convertToDictionary(text: String) -> [Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

// MARK: - Actions
extension SecurityQuestionViewController {
    
    @IBAction func submitAction(_ sender: Any) {
        if ansData.count == 3 {
            securityQuestionAPI()
        } else {
            Utils.showAlertMessage(message: "Please select answers for each question")
        }
    }
    
    @IBAction func dashboardAction(_ sender: Any) {
        AppDelegate.shared?.setupTabbar()
    }
}

extension SecurityQuestionViewController: SecurityOptionDelegate {
    func selectedAnswer(ans: [String: Any], position: Int) {
        ansData["\(position)"] = ans
        tableview.reloadData()
    }
}

// MARK: - API's
extension SecurityQuestionViewController {
    
    func getUserInfo() {
        if let value = UserDefaults.standard.value(forKey: "unauthorized") as? Bool,value{
            AppDelegate.shared?.setupTabbar()
            return
        }
        Utils.showSpinner()
        APIServices.getUserInfo { (list, code) in
            Utils.hideSpinner()
            self.submitButton.isHidden = false
            if code == "100" {
                if let qdata = list?.questions {
                    self.questionData = self.convertToDictionary(text: qdata) ?? [Any]()
                    
                    self.tableview.reloadData()
                }
                self.authtoken = list?.authToken ?? ""
            } else {
                // dashboard load data
                AppDelegate.shared?.setupTabbar()
            }
        }
    }
    
    func securityQuestionAPI() {
        Utils.showSpinner()
        
        if let que0 = questionData[0] as? [String: Any], let que1 =  questionData[1] as? [String: Any], let que2 = questionData[2]  as? [String: Any], let answer0 = ansData["0"] as? [String: Any], let answer1 = ansData["1"] as? [String: Any],  let answer2 = ansData["2"] as? [String: Any] {
            
            let param = ["answer[\(que0["id"] ?? "")]": "\(answer0["id"] ?? "")",
                         "answer[\(que1["id"] ?? "")]": "\(answer1["id"] ?? "")",
                         "answer[\(que2["id"] ?? "")]": "\(answer2["id"] ?? "")", "auth-token": self.authtoken]
            APIServices.securityQuestion(param: param as [String: Any]) { (status,msg)  in
                Utils.hideSpinner()
                if status == "success" {
                    self.successView.isHidden = false
                    self.sucessMsgLbl.text = msg
                    self.errorView.isHidden = true
                    UserDefaults.standard.set(false, forKey: "unauthorized")
                    //                    AppDelegate.shared?.setupTabbar()
                } else {
                    self.successView.isHidden = true
                    self.errorView.isHidden = false
                    self.sucessMsgLbl.text = ""
                    DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
                        AppDelegate.shared?.setupTabbar()
                        UserDefaults.standard.set(true, forKey: "unauthorized")
                    }
                }
            }
        }
        
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SecurityQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "SecurityQuestionCell") as? SecurityQuestionCell ?? SecurityQuestionCell()
        if let qdata = questionData[indexPath.row] as? [String: Any] {
            cell.questionLabel.text = qdata["text"] as? String
            if let answer = ansData["\(indexPath.row)"] as? [String: Any] {
                cell.answerLabel.text = answer["text"] as? String ?? ""
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Security", bundle: nil)
        guard let vc = storyboard.instantiateViewController(
                withIdentifier: "SecurityOptionsViewController") as? SecurityOptionsViewController else { return }
        if let qdata = questionData[indexPath.row] as? [String: Any] {
            vc.question = qdata
            vc.delegate = self
            vc.selectedQuestionIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
