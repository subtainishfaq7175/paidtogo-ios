//
//  ShareViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 7/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import Social

class ShareViewController: ViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var finishButtonView: UIView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var shareTextLabel: LocalizableLabel!
    @IBOutlet weak var shareTextLabelBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables and Constants
    
    var type: PoolTypeEnum?
    var docController = UIDocumentInteractionController()

    
    // MARK: - Super
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Functions
    
    private func initLayout() {
        setNavigationBarVisible(true)
        //        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        setPoolColor(backgroundColorView, type: type!)
        
        
        if Platform.DeviceType.IS_IPHONE_4_OR_LESS { // Device is iPhone 4s, 3.5 inches
            shareTextLabel.font = shareTextLabel.font.fontWithSize(12.0)
        }
        if Platform.DeviceType.IS_IPHONE_6_OR_GREATER {
//            shareTextLabelBottomConstraint.constant = 36
            shareTextLabel.font = shareTextLabel.font.fontWithSize(16.0)
        }
    }
    
    
    private func initViews() {
        //        goImageView.roundWholeView()
        self.title = "share_title".localize()
        finishButtonView.round()
    }
    
    
 
    
    
    // MARK: - Actions
    
    @IBAction func email(sender: AnyObject) {
    }
    @IBAction func twitter(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Share on Twitter")
            twitterSheet.addURL(NSURL(string: "www.paidtogo.com"))
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBAction func instagram(sender: AnyObject) {
//        
//        let instagramURL = NSURL(string: "instagram://app")
//        
//        if(UIApplication.sharedApplication().canOpenURL(instagramURL!)) {
//            let imagePost = UIImage(named: "posteo-01")
//            
//            let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
//
//            let fullPath = documentsFolderPath.URLByAppendingPathComponent("insta.igo")
//            let imageData = UIImagePNGRepresentation(imagePost!)!.writeToFile(fullPath, atomically: true)
//            let rect = CGRectMake(0, 0, 0, 0)
//            self.docController.UTI = "com.instagram.exclusivegram"
//            let igImageHookFile = NSURL(string: "file://\(fullPath)")
//            self.docController = UIDocumentInteractionController(URL: igImageHookFile!)
//            self.docController.annotation = ["InstagramCaption":"Text"]
//            self.docController.presentOpenInMenuFromRect(rect, inView: self.view, animated: true)
//            
//        } else {
//            print("no instagram found")
//        }
    }
    
    @IBAction func facebook(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
            facebookSheet.addURL(NSURL(string: "www.paidtogo.com"))
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func finish(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}
