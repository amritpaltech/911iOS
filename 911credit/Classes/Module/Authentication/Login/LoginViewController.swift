//
//  LoginViewController.swift
//  911credit
//
//  Created by ideveloper5 on 29/06/21.
//

import UIKit

struct ViewerDetails {
    var title: String?
    var image: UIImage?
}

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var listing = [ViewerDetails]()
    var scrollChange: ((_ index: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - Methods
extension LoginViewController {
    func setupUI() {
    
        let list1 = ViewerDetails(title: Text.list1, image: #imageLiteral(resourceName: "911CreditLogo"))
        let list2 = ViewerDetails(title: Text.list2, image: #imageLiteral(resourceName: "911CreditLogo"))
        let list3 = ViewerDetails(title: Text.list3, image: #imageLiteral(resourceName: "911CreditLogo"))
        listing = [list1, list2, list3]
        setupCollectionView()
        
        forgotPasswordButton.setAttributedTitle("Forgot your password?".attributedUnderLineWithRedText, for: .normal)
    }
}

// MARK: - Actions
extension LoginViewController {
    
    @IBAction func getOTPAction(_ sender: Any) {
                loginRequest()
//                                AppDelegate.shared?.setupTabbar()
        
//                guard let vc = self.storyboard?.instantiateViewController(
//                        withIdentifier: "VerificationCodeViewController") as? VerificationCodeViewController else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(
                withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.hidesForSinglePage = true
        collectionView.register(UINib(nibName: ViewerCell.cellid, bundle: nil), forCellWithReuseIdentifier: ViewerCell.cellid)
        collectionView.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ScreenSize.screenWidth, height: collectionView.frame.height)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewerCell.cellid, for: indexPath) as? ViewerCell else { return UICollectionViewCell() }
        let item = listing[indexPath.row]
        cell.iconImageView.image = item.image
        cell.titleLabel.text = item.title ?? ""
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = collectionView else { return }
        let currentPage = Int(round(scrollView.contentOffset.x / ((collectionView.frame.size.width))))
        pageControl.currentPage = currentPage
        scrollChange?(currentPage)
    }
}

// MARK: - API's
extension LoginViewController {
    
    func loginRequest() {
        
        if let email = emailTextField.text, email.isEmpty {
            Utils.showAlertMessage(message: "Please enter email address")
        } else if let password = passwordTextField.text, password.isEmpty {
            Utils.showAlertMessage(message: "Please enter password")
        } else {
            Utils.showSpinner()
            let param = ["email": emailTextField.text, "password": passwordTextField.text]
            APIServices.loginRequest(param: param as [String: Any]) {
                Utils.hideSpinner()
                let info = Utils.getUserInfo()?.id
                let getStoreId = Utils.getDataFromUserDefault("storeId")
                if info == getStoreId as? Int {
                    if let info = Utils.getUserInfo()?.token2FaExpiry {
                        let dateString = info
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let expireDate = dateFormatter.date(from: dateString)
                        let currentDate = Date()
                        if expireDate! < currentDate {
                            guard let vc = self.storyboard?.instantiateViewController(
                                    withIdentifier: "VerificationCodeViewController") as? VerificationCodeViewController else { return }
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            
                            if Utils.getUserInfo()?.issecurityquestions == 1  {
                                AppDelegate.shared?.setupSecurityQuestion()
                            } else {
                                AppDelegate.shared?.setupTabbar()
                            }
                        }
                    }
                } else {
                    guard let vc = self.storyboard?.instantiateViewController(
                            withIdentifier: "VerificationCodeViewController") as? VerificationCodeViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
