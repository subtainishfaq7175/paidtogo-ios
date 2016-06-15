//
//  ShareViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 7/4/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ShareViewController: ViewController, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var finishButtonView: UIView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var shareTextLabel: LocalizableLabel!
    @IBOutlet weak var shareTextLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var constraintBtnsViewAspect: NSLayoutConstraint!
    
    // MARK: - Variables and Constants
    
    var type: PoolTypeEnum?
    var docController = UIDocumentInteractionController()

    var shareInstagram : CMDocumentShare?
    var documentInteractor : UIDocumentInteractionController?
    
    var screenshot : UIImage?
    
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
        
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        } else {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            //composeVC.setToRecipients(["address@example.com"])
            composeVC.setSubject("Share by Mail")
            let stringURL = NSURL(string: "www.paidtogo.com")
            composeVC.setMessageBody((stringURL?.absoluteString)!, isHTML: false)
            
            // Present the view controller modally.
            self.presentViewController(composeVC, animated: true, completion: nil)
        }
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
        
        let instagramURL = NSURL(string: "instagram://app")
        if !UIApplication.sharedApplication().canOpenURL(instagramURL!) {
            print("SIN INSTAGRAM")
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to an Instagram account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if self.shareInstagram == nil {
            self.shareInstagram = CMDocumentShare()
        }
        
//        guard let screenshot = self.screenShotMethod() as UIImage? else {
//            print("NO SE PUDO SACAR EL SCREENSHOT")
//            return
//        }
        
        self.shareInstagramImage(self.screenshot!)
        
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
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareInstagramImage(image : UIImage) {
        print("SHARE ON INSTAGRAM")
        
        let homeDirectory = NSHomeDirectory()
        let savePath = homeDirectory.stringByAppendingPathComponent("Documents/StudAppPic.igo")
        
        print("savePath -> \(savePath)")
        
        let imgData = UIImageJPEGRepresentation(image, 1)
        
        do {
            try imgData?.writeToFile(savePath, options: NSDataWritingOptions.AtomicWrite)
        } catch {
            print("Something went wrong!")
        }
        
        let theFileURL = NSURL(fileURLWithPath: savePath)
        
        self.documentInteractor = UIDocumentInteractionController(URL: theFileURL)
        self.documentInteractor?.delegate = self
        self.documentInteractor?.name = "PaidToGo"
        self.documentInteractor?.annotation = ["InstagramCaption":"My statistics!!"]
        self.documentInteractor?.UTI = "com.instagram.exclusivegram"
        
        let presented = self.documentInteractor?.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true)
        
        if presented == false {
            print("SIN INSTAGRAM EN EL DISPOSITIVO")
        }
    }
    
    func screenShotMethod() -> UIImage? {
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
}



