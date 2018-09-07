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
import FBSDKShareKit

protocol SocialShareDelegate : MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    var shareText : String { get }
    
    func facebookShare()
    func instagramShare()
    func twitterShare()
    func mailShare()
}

class ShareViewController: ViewController {
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var finishButtonView: UIView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var shareTextLabel: LocalizableLabel!
    @IBOutlet weak var shareTextLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var constraintBtnsViewAspect: NSLayoutConstraint!
    
    // MARK: - Variables and Constants -
    
    var type: PoolTypeEnum?
    var docController = UIDocumentInteractionController()

    var shareInstagram : CMDocumentShare?
    var documentInteractor : UIDocumentInteractionController?
    
    var screenshot : UIImage?
    var screenshotData : NSData?
    
    // MARK: - View life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    // MARK: - Functions -
    
    private func initLayout() {
        setNavigationBarVisible(visible: true)
        //        setBorderToView(headerTitleLabel, color: CustomColors.NavbarTintColor().CGColor)
        setPoolColor(view: backgroundColorView, type: type!)
        
        
        if Platform.DeviceType.IS_IPHONE_4_OR_LESS { // Device is iPhone 4s, 3.5 inches
            shareTextLabel.font = shareTextLabel.font.withSize(12.0)
        }
        if Platform.DeviceType.IS_IPHONE_6_OR_GREATER {
//            shareTextLabelBottomConstraint.constant = 36
            shareTextLabel.font = shareTextLabel.font.withSize(16.0)
        }
    }
    
    private func initViews() {
        //        goImageView.roundWholeView()
        self.title = "share_title".localize()
        finishButtonView.round()
    }
    
    // MARK: - IBActions -
    
    @IBAction func email(sender: AnyObject) {
        self.mailShare()
    }
    
    @IBAction func twitter(sender: AnyObject) {
        self.twitterShare()
    }
    
    @IBAction func instagram(sender: AnyObject) {
        self.instagramShare()
    }
    
    @IBAction func facebook(sender: AnyObject) {
        self.facebookShare()
    }
    
    @IBAction func finish(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    func documentsPathForFileName(name: String) -> String {
        
        var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
       return documentsPath + name
//        return documentsPath.app
//        return documentsPath.append(name)
    }
    
    func socialShare(sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text as AnyObject)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print,UIActivityType.saveToCameraRoll,UIActivityType.postToWeibo]
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension ShareViewController: SocialShareDelegate {
    
    var shareText : String { return "Hey, i just completed a pool! Check out my stats and download the app at" }
    
    func facebookShare() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            print("- Facebook Share -")
            
            // Activity view controller: No anda...
//            if let image = self.screenshot {
//                if let url = NSURL(string: "fbauth2://") {
//                    self.socialShare("Test Paid to Go Share", sharingImage: image, sharingURL: url)
//                }
//            }
            
            // Image with no text
            let content = FBSDKSharePhotoContent()
            
            if let image = self.screenshot {
                let shareImage = FBSDKSharePhoto(image: image, userGenerated: true)
                
                content.photos = [shareImage]
                
                FBSDKShareDialog.show(from: self, with: content, delegate: self)
            }
            
            /// Problema con FBSDKShareDialog()
            /// cuando le asigno mi content (FBSDKShareLinkContent) a la property dialog.shareContent (protocol FBSDKSharingContent), pierdo los campos contentTitle y contentDescription.
            /// Bah, en realidad come el contentDescription y deja el contentTitle
            
//            let content = FBSDKShareLinkContent()
//
//            if let url = NSURL(string: "https://www.paidtogo.com") { //https://www.paidtogo.com
//                if UIApplication.sharedApplication().canOpenURL(url) {
//                    content.contentURL = url
//                }
//            }

//            content.contentTitle = "Paid to Go"
//            content.contentDescription = "Hey! I just completed a pool, check out my stats"

//            content.contentTitle = "Hey! I just completed a pool on Paid to Go, check out my stats"
//
//            let dialog = FBSDKShareDialog()
//
//            if let url = NSURL(string: "fbauth2://") {
//                if UIApplication.sharedApplication().canOpenURL(url) {
//                    dialog.mode = FBSDKShareDialogMode.Native
//                } else {
//                    dialog.mode = FBSDKShareDialogMode.Browser
//                }
//            } else {
//                print("Error with Facebook app")
//                return
//            }
//
//
//            dialog.shareContent = content
//            dialog.delegate = self
//            dialog.fromViewController = self
//            dialog.show()
            
            // Share image 1: no funca
//            let homeDirectory = NSHomeDirectory()
//            let savePath = homeDirectory.stringByAppendingPathComponent("Documents/image.igo")
//
//            print("savePath -> \(savePath)")
//
//            if let image = self.screenshot {
//                if let imgData = UIImageJPEGRepresentation(image, 0.1) {
//                    do {
//                        try imgData.writeToFile(savePath, options: NSDataWritingOptions.AtomicWrite)
//                    } catch {
//                        print("Something went wrong!")
//                    }
//
//                    let theFileURL = NSURL(fileURLWithPath: savePath)
//
//                    content.imageURL = theFileURL
//                }
//            }
            
            // Share image 2: no funca
//            if let screenshot = self.screenshot {
//                if let data = UIImageJPEGRepresentation(screenshot, 0.1) {
//                    let filePath = self.documentsPathForFileName("/image.jpg")
//
//                    do {
//
//                        let result = try Bool(data.writeToFile(filePath, options: NSDataWritingOptions.DataWritingAtomic))
//                        print("result: \(result)")
//
//                        let filePathURL = NSURL(fileURLWithPath: filePath)
//                        
//                        content.imageURL = filePathURL
//                        
//                    }
//                    catch let error as NSError {
//                        print(error.localizedDescription)
//                    }
//                    
//                }
//            }
            
        } else {
            self.showAlert(text: "Please login to a Facebook account to share.")
        }
    }
    
    func instagramShare() {
        let instagramURL = URL(string: "instagram://app")
        if !UIApplication.shared.canOpenURL(instagramURL!) {
            print("SIN INSTAGRAM")
            
            self.showAlert(text: "Please login to an Instagram account to share.")
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to an Instagram account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if self.shareInstagram == nil {
            self.shareInstagram = CMDocumentShare()
        }
        
        self.shareInstagramImage(image: self.screenshot!)
        
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
    
    func shareInstagramImage(image : UIImage) {
        print("SHARE ON INSTAGRAM")
        
        let homeDirectory = NSHomeDirectory()
        let savePath = homeDirectory.stringByAppendingPathComponent(path: "Documents/StudAppPic.igo")
        
        print("savePath -> \(savePath)")
        
        let imgData = UIImageJPEGRepresentation(image, 0.1)
        
        do {
//            WritingOptions.AtomicWrite
            try imgData?.write(to: URL(string: savePath)!, options: NSData.WritingOptions.atomicWrite)
        } catch {
            print("Something went wrong!")
        }
        
        let theFileURL = URL(fileURLWithPath: savePath)
        
        self.documentInteractor = UIDocumentInteractionController(url:theFileURL)
        self.documentInteractor?.delegate = self
        self.documentInteractor?.name = "PaidToGo"
        self.documentInteractor?.annotation = ["InstagramCaption":"My statistics!!"]
        self.documentInteractor?.uti = "com.instagram.exclusivegram"
        
        let presented = self.documentInteractor?.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
        
        if presented == false {
            print("SIN INSTAGRAM EN EL DISPOSITIVO")
        }
    }

    
    func twitterShare() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            print("- Twitter Share -")
            
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            let initialTextSet = twitterSheet.setInitialText(shareText)
            if initialTextSet {
                print("Initial Text OK")
            } else {
                print("Initial Text FAILED")
            }
            
            if let url = URL(string: "www.paidtogo.com") {
                if UIApplication.shared.canOpenURL(url) {
                    let urlAdded = twitterSheet.add(url)
                    
                    if urlAdded {
                        print("URL OK")
                    } else {
                        print("URL FAILED")
                    }
                } else {
                    let urlAdded = twitterSheet.add(URL(string: "www.paidtogo.com"))
                    
                    if urlAdded {
                        print("URL OK")
                    } else {
                        print("URL FAILED")
                    }
                }
            }
            
            if let image = self.screenshot {
                let imageAdded = twitterSheet.add(image)
                
                if imageAdded {
                    print("Image OK")
                } else {
                    print("Image FAILED")
                }
            }
            
            twitterSheet.completionHandler = {
                result -> Void in
                
                let getResult = result as SLComposeViewControllerResult;
                
                switch(getResult.rawValue) {
                    
                case SLComposeViewControllerResult.cancelled.rawValue:
                        print("- Twitter Share Cancelled -")
                        self.dismiss(animated: true, completion: nil)
                    break
                    
                case SLComposeViewControllerResult.done.rawValue:
                        print("- Twitter Share Ok -")
                        self.dismiss(animated: true, completion: {
                            self.showAlert(text: "Twitter share successfull!!")
                        })
                    break
                    
                default:
                    print("- Twitter Share Error -")
                    self.dismiss(animated: true, completion: nil)
                    break
                }
            }
            
            self.showProgressHud()
            self.present(twitterSheet, animated: true, completion: {
                self.dismissProgressHud()
            })
            
        } else {
            self.showAlert(text: "Please login to a Twitter account to share.")
        }
    }
    
    
    
    func mailShare() {
        if !MFMailComposeViewController.canSendMail() {
            
            self.showAlert(text: "Unable to share by mail. There's no email account configured")
            return
            
        } else {
            print("- Mail Share -")
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            composeVC.setSubject("Paidtogo")
            
            if let image = self.screenshot {
                 composeVC.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(0.1))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
            }
            
            var htmlString = "<html><body><p>\(shareText)</p></body></html>"
            composeVC.setMessageBody(htmlString, isHTML: true)
            
            if let url = NSURL(string: "www.paidtogo.com") {
                htmlString = "<html><body><p>\(shareText)</p><a href=\(url)>www.paidtogo.com</a></body></html>"
                composeVC.setMessageBody(htmlString, isHTML: true)
            }
            
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if let error = error {
            print("- Mail Share Error -\n\(error.description))")
            controller.dismiss(animated: true, completion: nil)
        } else {
            print("- Mail Share Ok -")
            
            if result == MFMailComposeResult.sent {
                controller.dismiss(animated: true, completion: {
                    self.showAlert(text: "Email sent successfully!!")
                })
            }
            
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
}

// MARK: - Facebook Share Dialog Delegate -

extension ShareViewController: FBSDKSharingDelegate {
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("- Facebook Share Ok -")

    }

    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("- Facebook Share Error -")
        print(error.localizedDescription)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
}


