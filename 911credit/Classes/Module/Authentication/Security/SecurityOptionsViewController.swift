//
//  SecurityOptionsViewController.swift
//  911credit
//
//  Created by ideveloper5 on 22/07/21.
//

import UIKit

protocol SecurityOptionDelegate {
    func selectedAnswer(ans: [String: Any], position: Int)
}

class SecurityOptionsViewController: BaseViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    var selectedQuestionIndex: Int = 0
    var selectedIndex: Int = 0
    var question: [String: Any] = [:]
    var answers: [[String: Any]] = [[:]]
    var delegate: SecurityOptionDelegate?
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
// MARK: - Methods
extension SecurityOptionsViewController {
    func setupUI() {
        setLeftAlignedNavigationItemTitle(text: "Security Questions")
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UINib(nibName: "SecurityOptionCell", bundle: nil), forCellReuseIdentifier: "SecurityOptionCell")
        self.tableview.register(UINib(nibName: "OptionQuestionTableCell", bundle: nil), forCellReuseIdentifier: "OptionQuestionTableCell")
    }
}

// MARK: - Actions
extension SecurityOptionsViewController {
    
    @IBAction func submitAction(_ sender: Any) {
        if let answers = question["answers"] as? [[String: Any]] {
            let selectedAnswer =  answers[selectedIndex]
            delegate?.selectedAnswer(ans: selectedAnswer, position: selectedQuestionIndex)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SecurityOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let answers = question["answers"] as? [[String:String]] {
                return answers.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionQuestionTableCell") as? OptionQuestionTableCell ?? OptionQuestionTableCell()
            if let qdata = question["text"] as? String {
                cell.questionLabel.text =  qdata.uppercased()
            }
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecurityOptionCell") as? SecurityOptionCell ?? SecurityOptionCell()
            if let answers = question["answers"] as? [[String: String]] {
                let opt = answers[indexPath.row]["text"] as? String ?? ""
                cell.selectionStyle = .none
                cell.optionLabel.text = opt.htmlToString()
            }
           
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        selectedIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableview.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}
