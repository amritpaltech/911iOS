//
//  MoreViewController.swift
//  911credit
//
//  Created by ideveloper5 on 01/07/21.
//

import UIKit
import Kingfisher
class MoreViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var moreTableview: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imageStringData = ""
    var userInfo : Userinfo?
    var moreMenuItem = ["My Profile", "Documents", "Change Password", "Chat", "Notifications", "Case Management", "Log out"]
    var moreIconList = ["user", "user", "changePassword", "chat", "chat", "caseManagement", "logout"]
    var photoManager: PhotoManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setUpUserInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - Methods
extension MoreViewController {
    func setupUI() {
        self.moreTableview.delegate = self
        self.moreTableview.dataSource = self
        self.moreTableview.register(UINib(nibName: "MoreViewTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreViewTableViewCell")
        emailLbl.numberOfLines = 2
        getUserInfo()
    }
    
    func setUpUserInfo(){
        if let info = self.userInfo{
            emailLbl.text = info.email
            phoneNumberLbl.text = info.phoneNumber
            nameLbl.text = (info.firstName ?? "") + " " + (info.lastName ?? "")
            if let url = URL(string: info.userAvatar ?? "") {
                profileImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "user"), options: nil, completionHandler: nil)
            }
        }
    }
}

// MARK: - Actions
extension MoreViewController {
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        if let navVC = self.navigationController {
            photoManager = PhotoManager.init(navigationController: navVC, allowEditing: true) { (image) in
                if let value = image {
                    //                    self.coverImgVw.image = value
                    self.profileImageView.image = value
                    self.imageStringData = self.convertImageToBase64(image: value)
                    self.updateAvatar()
                    
                }
            }
        }

        
//        let alert = UIAlertController(title: "Choose Option", message: "Please Select an Option", preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { [self] (_ UIAlertAction)in
//            self.checkCameraPermission()
//
//        }))
//
//        alert.addAction(UIAlertAction(title: "Choose From Gallery", style: .default, handler: { (_ UIAlertAction)in
//            self.photoLibraryPermissionCheck()
//        }))
//
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_ UIAlertAction)in
//            print("User click Dismiss button")
//        }))
//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
    }
}

// MARK: Check Camera Permission
extension MoreViewController {
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 0.5)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func checkCameraPermission() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func photoLibraryPermissionCheck() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let captureImage = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage {
            profileImageView.image = captureImage
            imageStringData = convertImageToBase64(image: captureImage)
        }
        self.updateAvatar()
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreMenuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moreTableview.dequeueReusableCell(withIdentifier: "MoreViewTableViewCell") as? MoreViewTableViewCell ?? MoreViewTableViewCell()
        cell.moreListLabel?.text = moreMenuItem[indexPath.row]
        cell.moreListImageView?.image = UIImage(named: moreIconList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "MoreOption", bundle: nil)
            guard let vc = storyboard.instantiateViewController(
                    withIdentifier: "MyProfileViewController") as? MyProfileViewController else { return }
            vc.userInfo = userInfo
            navigationController?.pushViewController(vc, animated: false)
        case 1:
            let storyboard = UIStoryboard(name: "MoreOption", bundle: nil)
            guard let vc = storyboard.instantiateViewController(
                    withIdentifier: "DocumentsViewController") as? DocumentsViewController else { return }
            navigationController?.pushViewController(vc, animated: false)
        case 2:
            let storyboard = UIStoryboard(name: "MoreOption", bundle: nil)
            guard let vc = storyboard.instantiateViewController(
                    withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else { return }
            navigationController?.pushViewController(vc, animated: false)
        case 3:
            guard let vc = self.storyboard?.instantiateViewController(
                    withIdentifier: "ChatViewController") as? ChatViewController else { return }
            navigationController?.pushViewController(vc, animated: false)
        case 4:
            let storyboard = UIStoryboard(name: "MoreOption", bundle: nil)
            guard let vc = storyboard.instantiateViewController(
                    withIdentifier: "NotificationsViewController") as? NotificationsViewController else { return }
            navigationController?.pushViewController(vc, animated: false)
        case 5:
            guard let vc = self.storyboard?.instantiateViewController(
                    withIdentifier: "CaseManagementViewController") as? CaseManagementViewController else { return }
            navigationController?.pushViewController(vc, animated: false)
        case 6:
            let alert = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                Utils.removeUserInfo()
                AppDelegate.shared?.setupLogin()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default: break
        }
    }
}

// MARK: - API's
extension MoreViewController {
    
    func updateAvatar() {
        Utils.showSpinner()
        let param = ["imageblob": imageStringData]
        APIServices.updateAvatar(param: param as [String : Any]) { (message) in
            Utils.hideSpinner()
            Utils.showAlertMessage(message: message)
        }
    }
    
    func getUserInfo() {
        APIServices.getUserInfo {(list, code) in
            self.userInfo = list?.userinfo
            self.setUpUserInfo()
        }
    }

}
