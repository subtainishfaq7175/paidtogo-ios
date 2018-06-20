//
//  UserProfileVC.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 17/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
@objc protocol ProfileDelegate {
    @objc optional func profile(photo image:UIImage)
}
class UserProfileVC: MenuContentViewController {
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var profilePhotoView: GenCustomView!
    @IBOutlet weak var editView: GenCustomView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var childSV: UIScrollView!
    @IBOutlet weak var parentSV: UIScrollView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var tabContainerView: UIView!
    //    tab buttons and their bottom views
    @IBOutlet weak var accountBottomView: UIView!
    @IBAction func accountAction(_ sender: Any) {
        selectedBtn(accountOL)
        childSV.setContentOffset(CGPoint(x: consShared.ZERO_INT.toCGFloat, y: consShared.ZERO_INT.toCGFloat), animated: true)
    }
    @IBOutlet weak var accountOL: UIButton!
    @IBOutlet weak var organizationBottomView: UIView!
    @IBOutlet weak var organizationsOL: UIButton!
    @IBAction func organizationsAction(_ sender: Any) {
        selectedBtn(organizationsOL)
        childSV.setContentOffset(CGPoint(x: self.view.frame.size.width, y: consShared.ZERO_INT.toCGFloat), animated: true)
    }
    var layoutCounter:Int = Constants.consShared.ZERO_INT
    var scrollDelegate:ChildScollDelegate?
    var profilePicDelegate:ProfileDelegate?

//    Old variables
    var profileImage: UIImage?
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarVisible(visible: true)
        self.title = "menu_profile".localize()
//        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabContainerView.cardView()
        config()
        setUIData()
        addLogoutButton()
    }
    func addLogoutButton() {
        
        let menuButtonImage = #imageLiteral(resourceName: "logout").withRenderingMode(.alwaysTemplate)
        
        let menuButton = UIBarButtonItem(
            image: menuButtonImage,
            style: .done,
            target: self,
            action: #selector(gestureListener(_:))
        )
        
        menuButton.tintColor = UIColor.black
        menuButton.isEnabled = true
        
        self.navigationItem.rightBarButtonItem = menuButton
    }
    override func logoutAnimated() {
        if let window = self.view.window {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc func gestureListener(_ gesture:UIGestureRecognizer) {
        User.currentUser = nil
        logoutAnimated()
    }
    func config(){
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileUpdated), name: NSNotification.Name(rawValue: NotificationsHelper.UserProfileUpdated.rawValue), object: nil)
        editView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture)))

    }
//    update ui on profile update
    @objc private func userProfileUpdated() {
        
        let currentUser = User.currentUser!
        
        userNameLB.text = currentUser.fullName()
        
        if let currentProfilePicture = currentUser.profilePicture, currentUser.profilePicture != "" {
            
            profileIV.yy_setImage(with: URL(string: currentProfilePicture) , placeholder: #imageLiteral(resourceName: "ic_profile_placeholder"), options: .showNetworkActivity, completion: { (image, url, type, stage, error) in
                
                guard let img = image else {
                    self.profileIV.image = #imageLiteral(resourceName: "ic_profile_placeholder")
                    return
                }
                
                self.profileIV.image = img
            })
        } else {
            self.profileIV.image = #imageLiteral(resourceName: "ic_profile_placeholder")
        }
        
    }
    func setUIData()  {
        guard let user = User.currentUser else{
            return
        }
        if let currentProfilePicture = user.profilePicture {
            profileIV.yy_setImage(with: URL(string: currentProfilePicture) , placeholder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        }
        userNameLB.text = user.fullName()

    }
    override func viewDidLayoutSubviews() {
        
        if layoutCounter == consShared.ONE_INT {
            addTabs()
            self.profilePhotoView.addConstraint(NSLayoutConstraint(item: profilePhotoView, attribute: .bottom, relatedBy: .equal, toItem: editView, attribute: .bottom, multiplier: consShared.ONE_INT.toCGFloat, constant: -(editView.frame.size.height * 0.5)))
            profileIV.round()
            editView.round()
        }
        layoutCounter += consShared.ONE_INT
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    MARK: - Tab buttons makeup
    func selectedBtn(_ btn:UIButton)  {
        if btn == accountOL {
            selectedButton(btn, bottomView: accountBottomView)
            unselectedButton(organizationsOL, bottomView: organizationBottomView)
        }else {
            selectedButton(btn, bottomView: organizationBottomView)
            unselectedButton(accountOL, bottomView: accountBottomView)
        }
    }
    func selectedButton(_ btn:UIButton, bottomView:UIView)  {
        guard let titleLabel = btn.titleLabel else {
            return
        }
        titleLabel.font = UIFont(name: consShared.OPEN_SANS_SEMIBOLD, size: titleLabel.font.pointSize)
        bottomView.backgroundColor = colorShared.springGreen
        
    }
    func unselectedButton(_ btn:UIButton, bottomView:UIView)  {
        guard let titleLabel = btn.titleLabel else {
            return
        }
        titleLabel.font = UIFont(name: consShared.OPEN_SANS_LIGHT, size: titleLabel.font.pointSize)
        bottomView.backgroundColor = UIColor.white
        
        
    }
//    Handel tap gesture for all view
    @objc func handleGesture(_ gesture:UIGestureRecognizer){
        guard let tapedView = gesture.view else{
            return
        }
        switch tapedView {
        case editView:
            photoViewTaped()
            break
        default:
            break
        }
    }
    func photoViewTaped(){
        let photoActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        photoActionSheet.addAction(UIAlertAction(title: "auth_photo_camera_option".localize(), style: .default, handler: {
            action in
            
            self.takePhotoFromCamera()
        }))
        photoActionSheet.addAction(UIAlertAction(title: "auth_photo_library_option".localize(), style: .default, handler: {
            action in
            
            self.takePhotoFromGallery()
        }))
        photoActionSheet.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel, handler: nil))
        self.present(photoActionSheet, animated: true, completion: nil)
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
    
    func takePhotoFromGallery () {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
            
            let picker = UIImagePickerController();
            picker.delegate = self;
            
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            picker.allowsEditing = true;
            
            self.present(picker, animated: true, completion: nil);
        }
    }
    
    // MARK: - Tabs Navigation
    func createTabVC(_ vc:UIViewController,frame:CGRect){
        vc.view.frame = frame
        self.addChildViewController(vc);
        self.childSV!.addSubview(vc.view);
        vc.didMove(toParentViewController: self)
    }
    func addTabs(){
        let accountVC = StoryboardRouter.profileStoryboard().instantiateViewController(withIdentifier: idConsShared.ACCOUNT_VC) as! AccountVC
        profilePicDelegate = accountVC
        createTabVC(accountVC, frame: CGRect(x: consShared.ZERO_INT.toCGFloat, y: consShared.ZERO_INT.toCGFloat, width: self.view.frame.size.width, height: childSV.frame.size.height))
        
        let myOrganization = StoryboardRouter.profileStoryboard().instantiateViewController(withIdentifier: idConsShared.MY_ORGANIZATIONS_VC) as! MyOrganizationsVC
        scrollDelegate = myOrganization
        createTabVC(myOrganization, frame: CGRect(x: self.view.frame.size.width, y: consShared.ZERO_INT.toCGFloat, width: self.view.frame.size.width, height: childSV.frame.size.height))
        self.childSV.contentSize = CGSize(width: view.frame.width * consShared.TWO_INT.toCGFloat, height: childSV.frame.size.height)
    }
}

extension UserProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profileImage = image
        
        self.profileIV.image = image
        if let delegate = profilePicDelegate {
            delegate.profile!(photo: image)
        }
        picker.dismiss(animated: true, completion: nil);
        
        //        self.signUpButtonShouldChange(value: true)
    }

}
extension UserProfileVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        Child scroll view tabs scrolling implementations
        self.view.endEditing(true)
        if scrollView == childSV {
            if scrollView.contentOffset.x == consShared.ZERO_INT.toCGFloat {
                selectedBtn(accountOL)
            }else if scrollView.contentOffset.x == self.view.frame.size.width {
                selectedBtn(organizationsOL)
            }
        }
        let yOffset = scrollView.contentOffset.y * 0.5
        self.topView.frame = CGRect(x: 0, y: yOffset, width: topView.frame.width, height: topView.frame.height)
        if yOffset == consShared.ZERO_INT.toCGFloat {
            topView.layer.opacity = consShared.ONE_INT.toFloat
            
        }else {
            topView.layer.opacity = consShared.ONE_INT.toFloat -  Float((yOffset / 100))
            
        }
        guard let delegate = scrollDelegate else {
            return
        }
        print("\(self.mainView.frame.size.height * 0.35), \(scrollView.contentOffset.y)")
        if (scrollView.contentOffset.y + 8)  >= (self.mainView.frame.size.height * 0.35){
            delegate.tableview!(should: true)
        }else {
            delegate.tableview!(should: false)
            
        }
    }
    
}

