//
//  ChatDetailsViewController.swift
//  911credit
//
//  Created by ideveloper5 on 10/07/21.
//

import UIKit

class ChatDetailsViewController: UIViewController {
    
    @IBOutlet weak var chatDetailsTableview: UITableView!
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "John Smith")
        setupUI()
        fetchData()
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
extension ChatDetailsViewController {
    func setupUI() {
        self.chatDetailsTableview.delegate = self
        self.chatDetailsTableview.dataSource = self
        self.chatDetailsTableview.register(UINib(nibName: "LeftViewCell", bundle: nil), forCellReuseIdentifier: "LeftViewCell")
        self.chatDetailsTableview.register(UINib(nibName: "RightViewCell", bundle: nil), forCellReuseIdentifier: "RightViewCell")
    }
    
    func fetchData() {
        messages = MessageStore.getAll()
        chatDetailsTableview.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ChatDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        if message.side == .left {
            let cell = chatDetailsTableview.dequeueReusableCell(withIdentifier: "LeftViewCell") as? LeftViewCell ?? LeftViewCell()
            cell.configureCell(message: message)
            return cell
        } else {
            let cell = chatDetailsTableview.dequeueReusableCell(withIdentifier: "RightViewCell") as? RightViewCell ?? RightViewCell()
            cell.configureCell(message: message)
            return cell
        }
    }
}
