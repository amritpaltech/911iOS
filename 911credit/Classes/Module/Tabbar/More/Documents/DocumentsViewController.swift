//
//  DocumentsViewController.swift
//  911credit
//
//  Created by ideveloper5 on 05/07/21.
//

import UIKit

enum Compass {
    case drivingLicenceFront
    case drivingLicenceBack
    case socialSecurityNumber
    case residenceProof
    case otherDocument1
    case otherDocument2
}

class DocumentsViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    @IBOutlet weak var tasksCompletedLabel: UILabel!
    
    @IBOutlet weak var drivingLicenceFrontView: UIView!
    @IBOutlet weak var drivingLicenceBackView: UIView!
    @IBOutlet weak var socialSecurityNumberView: UIView!
    @IBOutlet weak var residenceProofView: UIView!
    @IBOutlet weak var otherDocument1View: UIView!
    @IBOutlet weak var otherDocument2View: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignedNavigationItemTitle(text: "Documents")
        setupTapGesture()
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
extension DocumentsViewController {
    func setupUI() {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - Methods
extension DocumentsViewController {
    
    func setupTapGesture() {
        
        let gestureOne = UITapGestureRecognizer(target: self, action: #selector(self.drivingLicenceFrontAction))
        drivingLicenceFrontView.addGestureRecognizer(gestureOne)
        
        let gestureTwo = UITapGestureRecognizer(target: self, action: #selector(self.drivingLicenceBackAction))
        drivingLicenceBackView.addGestureRecognizer(gestureTwo)
        
        let gestureThree = UITapGestureRecognizer(target: self, action: #selector(self.socialSecurityNumberAction))
        socialSecurityNumberView.addGestureRecognizer(gestureThree)
        
        let gestureFour = UITapGestureRecognizer(target: self, action: #selector(self.residenceProofAction))
        residenceProofView.addGestureRecognizer(gestureFour)
        
        let gestureFive = UITapGestureRecognizer(target: self, action: #selector(self.otherDocument1Action))
        otherDocument1View.addGestureRecognizer(gestureFive)
        
        let gestureSix = UITapGestureRecognizer(target: self, action: #selector(self.otherDocument2Action))
        otherDocument2View.addGestureRecognizer(gestureSix)
    }
}

// MARK: - Actions
extension DocumentsViewController {
    
    @objc func drivingLicenceFrontAction(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Choose Option", message: "Please Select an Option", preferredStyle: .actionSheet)
                
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_ UIAlertAction)in
            print("User click Camera button")
            
            // MARK: - Take_image
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_ UIAlertAction)in
            print("User click Gallery button")
            
            // MARK: - Take_Gallery
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
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.pdf"], in: .import)
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
        let _ = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            //            // Get Url Path
        }
    }
    
    @objc func drivingLicenceBackAction(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Choose Option", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_ UIAlertAction)in
            print("User click Camera button")
            
            // MARK: - Take_image
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_ UIAlertAction)in
            print("User click Gallery button")
            
            // MARK: - Take_Gallery
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
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.pdf"], in: .import)
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
    
    @objc func socialSecurityNumberAction(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Choose Option", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_ UIAlertAction)in
            print("User click Camera button")
            
            // MARK: - Take_image
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_ UIAlertAction)in
            print("User click Gallery button")
            
            // MARK: - Take_Gallery
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
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.pdf"], in: .import)
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
    
    @objc func residenceProofAction(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Choose Option", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_ UIAlertAction)in
            print("User click Camera button")
            
            // MARK: - Take_image
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_ UIAlertAction)in
            print("User click Gallery button")
            
            // MARK: - Take_Gallery
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
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.pdf"], in: .import)
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
    
    @objc func otherDocument1Action(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Choose Option", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_ UIAlertAction)in
            print("User click Camera button")
            
            // MARK: - Take_image
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_ UIAlertAction)in
            print("User click Gallery button")
            
            // MARK: - Take_Gallery
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
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.pdf"], in: .import)
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
    
    @objc func otherDocument2Action(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Choose Option", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_ UIAlertAction)in
            print("User click Camera button")
            
            // MARK: - Take_image
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_ UIAlertAction)in
            print("User click Gallery button")
            
            // MARK: - Take_Gallery
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
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.pdf"], in: .import)
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
}
