//
//  SignatureViewController.swift
//  911credit
//
//  Created by mac on 12/16/21.
//

import UIKit
import WeScan
import MobileCoreServices

protocol SignatureDelegate {
    func uploadSignParams(param: [String: Any])
}

class SignatureViewController: UIViewController {
    
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var signShadowView: UIView!
    @IBOutlet weak var agreementTextView: UITextView!
    
    @IBOutlet weak var signViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var signViewLowConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var signViewRightConstraint: NSLayoutConstraint!
    
    
    var document: Document?
    var delegate: SignatureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Place your Signature")
        AppDelegate.shared?.restrictRotation = true
        
        shadowView.setupShadow(color: .darkGray, opacity: 0.3, radius: 8, offset: CGSize(width: 3, height: 3))
        signShadowView.setupShadow(color: .darkGray, opacity: 0.3, radius: 8, offset: CGSize(width: 3, height: 3))
        
        let htmlData = ("<center>\(self.document?.agreement! ?? "")</center>" ).data(using: .unicode)


        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: htmlData!, options: options, documentAttributes: nil) else {
            agreementTextView.text = ""
            return
        }
        
        agreementTextView.attributedText = attributedString
        agreementTextView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        agreementTextView.isScrollEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.shared?.restrictRotation = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            
            signViewLeftConstraint.constant = 0
            signViewRightConstraint.constant = 0
            signViewTopConstraint.priority = UILayoutPriority(999)
            signViewLowConstraint.priority = UILayoutPriority(250)
            self.navigationController?.isNavigationBarHidden = true
        } else {
            signViewLeftConstraint.constant = 16
            signViewRightConstraint.constant = 16
            signViewTopConstraint.priority = UILayoutPriority(250)
            signViewLowConstraint.priority = UILayoutPriority(999)
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 0.5)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

// MARK: - Actions
extension SignatureViewController {
    
    @IBAction func clearAction(_ sender: Any) {
        
        self.signatureView.clear()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
     
        if let image = self.signatureView.getSignature() {
            
            /*let scannerViewController = ImageScannerController(image: image, delegate: self)
            present(scannerViewController, animated: true)*/
            
            guard let obj = self.document else {
                return
            }

            let params = [
                "title": obj.label ?? "",
                "document__id": obj.docId ?? 0,
                "doc_type": obj.documentType ?? "",
                "case_id": obj.caseId ?? 0,
                "fk_documentrequest_id": 0,
                "notes": "hi this is tesr",
                "signatureimage": self.convertImageToBase64(image: image)
            ] as [String : AnyObject]
            
            if let delegate = self.delegate {
                delegate.uploadSignParams(param: params)
            }
        }
    }
}

// MARK: - Methods

// MARK: - ImageScannerController Delegates
extension SignatureViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        assertionFailure("Error occurred: \(error)")
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true, completion: nil)
        
        guard let obj = self.document else {
            return
        }

        let params = [
            "title": obj.label ?? "",
            "document__id": obj.docId ?? 0,
            "doc_type": obj.documentType ?? "",
            "case_id": obj.caseId ?? 0,
            "fk_documentrequest_id": 0,
            "notes": "hi this is tesr",
            "signatureimage": self.convertImageToBase64(image: results.croppedScan.image)
        ] as [String : AnyObject]
        
        if let delegate = self.delegate {
            delegate.uploadSignParams(param: params)
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
   }
    
}
