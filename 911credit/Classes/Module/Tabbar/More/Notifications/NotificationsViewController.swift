//
//  NotificationsViewController.swift
//  911credit
//
//  Created by ideveloper5 on 05/07/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var notificationTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Notifications")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
}

// MARK: - Methods
extension NotificationsViewController {
    func setupUI() {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.notificationTableview.delegate = self
        self.notificationTableview.dataSource = self
        self.notificationTableview.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: "NotificationsCell")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTableview.dequeueReusableCell(withIdentifier: "NotificationsCell") as? NotificationsCell ?? NotificationsCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
