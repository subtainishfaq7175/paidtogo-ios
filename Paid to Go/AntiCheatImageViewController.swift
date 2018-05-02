//
//  AntiCheatImageViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 18/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit

class AntiCheatImageViewController: ViewController {
    
    @IBOutlet weak var startButtonView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var image: UIImage?
    var pool: Pool?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated: animated)
        setPoolTitle(type: .Train)
//        startButtonView.round()
//        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        
        photoImageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startButtonView.round()
        setBorderToView(view: subtitleLabel, color: CustomColors.NavbarTintColor().cgColor)
    }
    
    @IBAction func startPool(sender: AnyObject) {
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.getPoolType(poolTypeEnum: .Train) { (poolType, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(text: error)
                return
            }
            
            if let poolType = poolType, let pool = self.pool {
                
//                if let image = self.image {
//                    
//                    let imageData = UIImageJPEGRepresentation(image, 0.1)
//                    let base64String = imageData!.base64EncodedData(options: .)
//                    let validationPhoto = User.imagePrefix + base64String
//                    
//                    self.showPoolViewControllerWithAntiCheatPhoto(.Train, poolType: poolType, pool: pool, validationPhoto: validationPhoto, sender: nil)
////                    self.showPoolViewController(.Train, poolType: poolType, pool: pool, sender: nil)
//                }
                
            }
            
        }
        
    }
}
