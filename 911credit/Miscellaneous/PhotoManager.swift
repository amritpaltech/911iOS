//
//  PhotoManager.swift
//  TemApp
//
//  Created by Sourav on 2/15/19.
//  Copyright © 2019 Capovela LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

typealias PhotoTakingHelperCallback = ((UIImage?) -> Void)
typealias CallbackwithURL = ((UIImage?) -> Void)

enum ImagePickerOptions: Int {
    case camera
    case gallery
}

private struct Constant {
    static let actionTitle = "Choose From"
    static let actionMessage = "Please select an option to choose image"
    static let cameraBtnTitle = "Take Picture"
    static let galeryBtnTitle = "Select From Gallery"
    static let cancelBtnTitle = "Cancel"
    
    static let enablePermission = "Can't access contact, Please go to Settings -> MyApp to enable contact permission"
    static let fetchError:String = "Fetch contact error"
    static let defaultuserName:String = "No name"
    static let photoPermissionTitle:String = "Error"
    static let photoPermissionMessage:String = "Chuzi app is not authorized to use gallery.Please enable camera permission from settings."
    static let didNotSelectPhoto:String  = "Please select your photo first."
    static let cameraNotAuthorised = "Chuzi app is not authorized to use camera.Please enable camera permission from settings."
    
}

@objc class PhotoManager:NSObject {
    
    let imagePicker = UIImagePickerController()
    internal var navController: UINavigationController!
    internal var callback: PhotoTakingHelperCallback!
    var allowEditing: Bool
    
    /*
     Intialize the navController from give reference of navigationcontroller while creating Photomanager class object.
     Callback: Callback will be call after the picking image.
     */
    init(navigationController:UINavigationController, allowEditing:Bool , callback:@escaping PhotoTakingHelperCallback) {
        
        self.navController = navigationController
        self.callback = callback
        self.allowEditing = allowEditing
        super.init()
        
        self.presentActionSheet()
        
    }
    //MARK: ImagePicker Custom Functions
    /// Presenting sheet with option to select image source
    private func presentActionSheet() {
        
        let alertController = UIAlertController(title: Constant.actionTitle, message: Constant.actionMessage, preferredStyle: .actionSheet)
        
        //For Gallery.....
        
        let  galleryButton = UIAlertAction(title: Constant.galeryBtnTitle, style: .default, handler: { (action) -> Void in

            self.checkPhotoLibraryPermission()
        })
        alertController.addAction(galleryButton)
        //
        
        //For Camera.....
        let  cameraButton = UIAlertAction(title: Constant.cameraBtnTitle, style: .default, handler: { (action) -> Void in
            
            self.checkCameraPermission()
        })
        alertController.addAction(cameraButton)
        //
        
        //For Cancel....
        
        let cancelButton = UIAlertAction(title: Constant.cancelBtnTitle, style: .cancel, handler: { (action) -> Void in
            
        })
        alertController.addAction(cancelButton)
        
        //
        navController.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //This Function will check the Camera permission.....
    
    private func checkCameraPermission() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.presentUIimagePicker(type: .camera)
                    } else {
                        self.showAlertViewWithAction(title:Constant.photoPermissionTitle, message: Constant.cameraNotAuthorised)
                    }
                }
            }
            
        case .authorized:
            self.presentUIimagePicker(type: .camera)
            break
            
        case .denied, .restricted:
            self.showAlertViewWithAction(title: Constant.photoPermissionTitle, message: Constant.cameraNotAuthorised)
            
        @unknown default:
            break
        }
    }
    
    //This Fucntion will check the Photo Permission....
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.presentUIimagePicker(type: .photoLibrary)
            break
            
        case .denied, .restricted :
            self.showAlertViewWithAction(title: Constant.photoPermissionTitle, message: Constant.photoPermissionMessage)
            break
            
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        self.presentUIimagePicker(type: .photoLibrary)
                        break
                    case .denied, .restricted , .notDetermined:
                        self.showAlertViewWithAction(title: Constant.photoPermissionTitle, message: Constant.photoPermissionMessage)
                    @unknown default:
                        break
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    func showAlertViewWithAction(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            //Open Setting....
            self.openSetting()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Don't Allow", style: .cancel, handler: { (action) in
            //        cancelCall
        }))
        self.navController.present(alert, animated: true, completion: nil)
        
    }
    
    //This Fucntion will open the setting to give permission
    
    private func openSetting() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            } else {
                UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                // Fallback on earlier versions
            }
        }
    }
    
    /*
     presentUIimagePicker will present the UIImagePicker with give type
     type: Camera or Gallery
     controller: UINavigationcontroller, navigationcontroller on with uiimagepicker will present.
     */
    private func presentUIimagePicker(type: UIImagePickerController.SourceType){
        
        imagePicker.allowsEditing = self.allowEditing
        imagePicker.sourceType = type
        imagePicker.delegate = self
        
        navController.present(imagePicker, animated: true, completion: nil)
    }
    
}
//MARK: ------------------------Class End------------------------------------



//MARK: ------------------------Class Extension------------------------------------

/*Extension for UIImagePickerControllerDelegate & UINavigationControllerDelegate
 
 
 */
extension PhotoManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if(allowEditing) {
            guard let pickedEditedImage = info[.editedImage] as? UIImage else {
                return
            }
            callback(pickedEditedImage)
        } else {
            guard let pickedOriginalImg = info[.originalImage] as? UIImage else {
                return
            }
            callback(pickedOriginalImg)
        }
        navController.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        navController.dismiss(animated: true, completion: nil)
    }
}

