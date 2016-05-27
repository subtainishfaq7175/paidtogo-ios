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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            initViews()
    }
    
    // MARK: - Functions
    
    private func initLayout() {
        setNavigationBarVisible(true)
        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        //        clearNavigationBarcolor()
    }
    
    private func initViews() {
        setPoolTitle(.Train)
    }
    
    // MARK: - Actions
    
    @IBAction func takePicture(sender: AnyObject) {
        if(Platform.isSimulator) {
            
            let photoActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            photoActionSheet.addAction(UIAlertAction(title: "auth_photo_camera_option".localize(), style: .Default, handler: {
                action in
                
                self.takePhotoFromCamera()
            }))
            photoActionSheet.addAction(UIAlertAction(title: "auth_photo_library_option".localize(), style: .Default, handler: {
                action in
                
                self.takePhotoFromGallery()
            }))
            
            photoActionSheet.addAction(UIAlertAction(title: "action_cancel".localize(), style: .Cancel, handler: nil))
            self.presentViewController(photoActionSheet, animated: true, completion: nil)
        } else {
            self.takePhotoFromCamera()
        }
    }
    
    
    
    
}

extension AntiCheatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let antiCheatImageViewController = StoryboardRouter.homeStoryboard().instantiateViewControllerWithIdentifier("AntiCheatImageViewController") as? AntiCheatImageViewController {
            antiCheatImageViewController.image = image
            antiCheatImageViewController.pool = self.pool!
            self.showViewController(antiCheatImageViewController, sender: nil)
        }
        
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
    
    // DELETE
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
