//
//  EditPlayerViewController+Photos.swift
//  GameCountHelper
//
//  Created by Vlad on 5/31/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

extension EditPlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @available(iOS 10.0, *)
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo infoArray: Dictionary<UIImagePickerController.InfoKey, Any>) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = infoArray[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        avatarView.imageView.image = image
        self.image = image
    }
    
    func avatarButtonPressed(sender: UIButton) {
        view.endEditing(true)
        let photosButton = SkinButton.newAutoLayout()
        photosButton.setTitle("Load from Gallery".ls, for: .normal)
        photosButton.onClick = {  [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
            self.checkPhotosAccess()
        }
        let cameraButton = SkinButton.newAutoLayout()
        cameraButton.setTitle("Take photo from Camera".ls, for: .normal)
        cameraButton.onClick = {  [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
            self.checkCameraAccess()
        }
        let removeButton = SkinButton.newAutoLayout()
        removeButton.setTitle("Clear image".ls, for: .normal)
        removeButton.onClick = {  [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
            self.image = nil
            self.avatarView.imageView.image = self.profileImage
        }
        showDropMenuItems([photosButton, cameraButton, removeButton], sender: sender, offset: CGPoint(0.0, -40.0))
    }
    
    func checkPhotosAccess() {
        let access = PHPhotoLibrary.authorizationStatus()
        if (access == .notDetermined) || (access == .restricted)  {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    DispatchQueue.main.async {
                        self.showImagePickerController(source: .photoLibrary)
                    }
                }
            })
        } else if access == .authorized {
            showImagePickerController(source: .photoLibrary)
        }
    }
    
    func checkCameraAccess() {
        let access = AVCaptureDevice.authorizationStatus(for: .video)
        if (access == .notDetermined) || (access == .restricted) {
            AVCaptureDevice.requestAccess(for: .video) {status in
                if status {
                    DispatchQueue.main.async {
                        self.showImagePickerController(source: .camera)
                    }
                }
            }
        } else if access == .authorized {
            showImagePickerController(source: .camera)
        }
    }
    
    func showImagePickerController(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        self.present(pickerController, animated: true, completion: nil)
    }

}
