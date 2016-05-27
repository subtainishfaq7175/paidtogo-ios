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
        super.viewWillAppear(animated)
        setPoolTitle(.Train)
        startButtonView.round()
        setBorderToView(subtitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        
        photoImageView.image = image
    }
    
    @IBAction func startPool(sender: AnyObject) {
        
        self.showProgressHud()
        
        DataProvider.sharedInstance.getPoolType(.Train) { (poolType, error) in
            
            self.dismissProgressHud()
            
            if let error = error {
                self.showAlert(error)
                return
            }
            
            if let poolType = poolType {
                self.showPoolViewController(.Train, poolType: poolType, pool: self.pool!, sender: nil)
            }
            
        }
        
    }
}
