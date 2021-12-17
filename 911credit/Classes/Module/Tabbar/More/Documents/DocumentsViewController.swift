//
//  DocumentsViewController.swift
//  911credit
//
//  Created by ideveloper5 on 05/07/21.
//

import UIKit
import WeScan
import MobileCoreServices
enum DocumentSection:Int, CaseIterable {
    case requiredDocument, otherDocument
    func getTitle()->String {
        switch self {
        case .requiredDocument:
            return "Required Document"
        case .otherDocument:
            return "Other Document"
        }
    }
}
class DocumentsViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    var document:Documents?
    let types: [String] = [
        kUTTypeJPEG as String,
        kUTTypePNG as String,
        "com.microsoft.word.doc",
        "org.openxmlformats.wordprocessingml.document",
        kUTTypeRTF as String,
        "com.microsoft.powerpoint.​ppt",
        "org.openxmlformats.presentationml.presentation",
        kUTTypePlainText as String,
        "com.microsoft.excel.xls",
        "org.openxmlformats.spreadsheetml.sheet",
        kUTTypePDF as String,
    ]

    
    @IBOutlet weak var tableView: UITableView!
    var selectedDoc : Document?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Documents")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination.isKind(of: SignatureViewController.self) {
            
            if let vc = segue.destination as? SignatureViewController {
                vc.document = sender as? Document
                vc.delegate = self
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
}

// MARK: - Methods
extension DocumentsViewController {
    func setupUI() {
        getDoc()
    }
    
    func getDoc() {
        Utils.showSpinner()
        APIServices.getDocList{doc in
            Utils.hideSpinner()
            //load dashboard data
            self.document = doc
            self.tableView.reloadData()
        }
    }

    
    func uploadDoc(url:URL) {
        Utils.showSpinner()
        guard let obj = self.selectedDoc else {
            return
        }
        let params = [
            "document__id": obj.docId ?? 0,
            "title": obj.label ?? "",
            "doc_type": obj.documentType ?? "",
            "case_id": obj.caseId ?? 0,
            "fk_documentrequest_id": 0,
            "notes": ""
        ] as [String : AnyObject]
        APIServices.uploadDocument(param: params,fileUrl: url as NSURL, complition: {response in
            Utils.hideSpinner()
            self.document = response
            self.tableView.reloadData()
            self.getDoc()
        })
    }

}

extension DocumentsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return DocumentSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let docSection = DocumentSection(rawValue: section){
            switch docSection {
            case .requiredDocument:
                return document?.required?.count ?? 0
            case .otherDocument:
                return document?.other?.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentSectionCell") as? DocumentSectionCell
        cell?.titleLbl.text = DocumentSection(rawValue: section)?.getTitle()
        cell?.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let docSection = DocumentSection(rawValue: indexPath.section) {
            switch docSection {
            case .requiredDocument:
                return requiredDocTableView(tableView, cellForRowAt: indexPath)
            case .otherDocument:
                return otherDocTableView(tableView, cellForRowAt: indexPath)
            }
        }
        return UITableViewCell()
    }
    
    func requiredDocTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as? DocumentCell else {
            return UITableViewCell()
        }
        if let obj = self.document?.required?[indexPath.row] {
            cell.initCellForRequired(obj)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func otherDocTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as? DocumentCell else {
            return UITableViewCell()
        }
        if let obj = self.document?.other?[indexPath.row] {
            cell.initCellForOther(obj)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let docSection = DocumentSection(rawValue: indexPath.section) {
            switch docSection {
            case .requiredDocument:
                if let obj = self.document?.required?[indexPath.row] {
                    
                    if obj.documentType == "agreement" {
                        if obj.status == "missing" {
                            self.performSegue(withIdentifier: "signatureSegue", sender: obj)
                        } else if obj.status == "pending" {
                            Utils.showAlertMessage(message: "Please wait until we verify your document")
                        } else if obj.status == "approved" {
                            Utils.showAlertMessage(message: "Your document is verified")
                        } else if obj.status == "rejected" {
                            Utils.showAlertMessage(message: "Document you provided is rejected")
                        }
                    } else {
                        showPickerAndAlertByStatus(obj.status ?? "",obj)
                    }
                }
            case .otherDocument:
                if let obj = self.document?.other?[indexPath.row] {
                    showPickerAndAlertByStatus(obj.status ?? "",obj)
                }
            }
        }
    }
    
    func showPickerAndAlertByStatus(_ status:String,_ doc:Document){
        if status == "missing" {
            self.selectedDoc = doc
            self.documentPicker()
        } else if status == "pending" {
            Utils.showAlertMessage(message: "Please wait until we verify your document")
        } else if status == "approved" {
            Utils.showAlertMessage(message: "Your document is verified")
        } else if status == "rejected" {
            Utils.showAlertMessage(message: "Document you provided is rejected")
        }
    }
    
}

// MARK: - Actions
extension DocumentsViewController {
    
    func scanImage() {
        let scannerViewController = ImageScannerController(delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            scannerViewController.navigationBar.tintColor = .label
        } else {
            scannerViewController.navigationBar.tintColor = .black
        }
        present(scannerViewController, animated: true)
    }

    
    
    func documentPicker() {
        
        let alert = UIAlertController(title: "Choose Option", message: "Please Select an Option", preferredStyle: .actionSheet)
                
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_ UIAlertAction)in
            self.scanImage()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_ UIAlertAction)in
            print("User click Gallery button")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))

        alert.addAction(UIAlertAction(title: "Documents", style: .default, handler: { (_ UIAlertAction)in
            print("User click Documents button")
            let documentPicker = UIDocumentPickerViewController(documentTypes: self.types, in: .import)
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_ UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        present(scannerViewController, animated: true)

    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            //            // Get Url Path
            if let url = urls.first{
                self.uploadDoc(url: url)
            }
        }
    }
        
}

extension DocumentsViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        assertionFailure("Error occurred: \(error)")
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true, completion: nil)
        let imgData : NSData = results.croppedScan.image.jpegData(compressionQuality: 0.5)! as NSData

        if let url = FileDownloader.saveFile(with: "\(selectedDoc?.docId ?? 0).jpeg", fileData: imgData as Data),let nsURL = NSURL(string: url.absoluteString){
            self.uploadDoc(url: url)
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
   }
    
}

// MARK: - SignatureDelegate
extension DocumentsViewController: SignatureDelegate {
    
    func uploadSignParams(param: [String: Any]) {
        
        self.navigationController?.popViewController(animated: false)
        
        Utils.showSpinner()
        APIServices.uploadSignature(param: param) { (message) in
            Utils.hideSpinner()
            self.document = message
            self.tableView.reloadData()
        }
    }
}
