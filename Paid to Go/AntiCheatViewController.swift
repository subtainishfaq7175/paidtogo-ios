//
//  AntiCheatViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 18/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class AntiCheatViewController: ViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Variables
    
    var imagePickerController: UIImagePickerController!
    var pool: Pool?
    
    // MARK: - Super
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBorderToView(view: subtitleLabel, color: CustomColors.NavbarTintColor().cgColor)
    }
    
    // MARK: - Functions
    
    private func initLayout() {
        setNavigationBarVisible(visible: true)
//        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        //        clearNavigationBarcolor()
    }
    
    private func initViews() {
        setPoolTitle(type: .Train)
    }
    
    // MARK: - Actions
    
    @IBAction func takePicture(sender: AnyObject) {
        if(Platform.isSimulator) {
            
            let photoActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            photoActionSheet.addAction(UIAlertAction(title: "auth_photo_camera_option".localize(), style: .default, handler: {
                action in
                
                self.takePhotoFromCamera()
            }))
            photoActionSheet.addAction(UIAlertAction(title: "auth_photo_library_option".localize(), style: .default, handler: {
                action in
                
                self.takePhotoFromGallery()
            }))
            
            photoActionSheet.addAction(UIAlertAction(title: "action_cancel".localize(), style: .cancel, handler: nil))
            self.present(photoActionSheet, animated: true, completion: nil)
        } else {
            self.takePhotoFromCamera()
        }
    }
    
    
    
    
}

extension AntiCheatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        
        picker.dismiss(animated: true, completion: nil)
        
        if let antiCheatImageViewController = StoryboardRouter.homeStoryboard().instantiateViewController(withIdentifier: "AntiCheatImageViewController") as? AntiCheatImageViewController {
            antiCheatImageViewController.image = image
            antiCheatImageViewController.pool = self.pool!
            self.show(antiCheatImageViewController, sender: nil)
        }
        
    }
    
    func takePhotoFromCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            
            let picker = UIImagePickerController();
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceType.camera;
            picker.allowsEditing = true;
            
            self.present(picker, animated: true, completion: nil);
        }
    }
    
    // DELETE
    func takePhotoFromGallery (){
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
            
            let picker = UIImagePickerController();
            picker.delegate = self;
            
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            picker.allowsEditing = true;
            
            self.present(picker, animated: true, completion: nil);
        }
    }
    
}
