//
//  SignupViewController.swift
//  Paid to Go
//
//  Created by German Campagno on 16/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class SignupViewController: ViewController {
    
    @IBOutlet weak var signupButtonViewContainer: UIView!
    @IBOutlet weak var registerPhotoImageView: UIImageView!
    @IBOutlet weak var addImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisible(true)
        self.title = "Sign Up"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarGreen()
    }
    
    
    override func viewDidLayoutSubviews() {
        initViews()
    }
    
    private func initViews(){
        signupButtonViewContainer.round()
        registerPhotoImageView.roundWholeView()
    }

    
    // MARK: - Selectors
    @IBAction func photoTapAction(sender: AnyObject) {
        let photoActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        photoActionSheet.addAction(UIAlertAction(title: "auth_photo_camera_option".localize(), style: .Default, handler: {
            action in
            
            self.takePhotoFromCamera()
        }))
        photoActionSheet.addAction(UIAlertAction(title: "auth_photo_library_option".localize(), style: .Default, handler: {
            action in
            
            self.takePhotoFromGallery()
        }))
        photoActionSheet.addAction(UIAlertAction(title: "cancel".localize(), style: .Cancel, handler: nil))
        self.presentViewController(photoActionSheet, animated: true, completion: nil)
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.registerPhotoImageView.image = image
        self.addImageView.hidden = true
        picker.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    func takePhotoFromCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            let picker = UIImagePickerController();
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            picker.allowsEditing = true;
            
            self.presentViewController(picker, animated: true, completion: nil);
        }
    }
    
    func takePhotoFromGallery (){
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
            
            let picker = UIImagePickerController();
            picker.delegate = self;
            
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            picker.allowsEditing = true;
            
            self.presentViewController(picker, animated: true, completion: nil);
        }
    }
    
}