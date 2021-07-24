//
//  ChatViewController.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import UIKit

class ChatViewController: BaseViewController {
    
    @IBOutlet weak var chatTableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
//        setLeftAlignedNavigationItemTitle(text: "Chat")
        setupUI()
    }
}

// MARK: - Methods
extension ChatViewController {
    func setupUI() {
        self.chatTableview.delegate = self
        self.chatTableview.dataSource = self
        self.chatTableview.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableview.dequeueReusableCell(withIdentifier: "ChatCell") as? ChatCell ?? ChatCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(
                withIdentifier: "ChatDetailsViewController") as? ChatDetailsViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
