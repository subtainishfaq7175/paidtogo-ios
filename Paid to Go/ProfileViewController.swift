//
//  ProfileViewController.swift
//  Paid to Go
//
//  Created by MacbookPro on 22/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import UIKit
import SnapKit

struct CheckmarkStruct {
    
    var options = [
        "I use PaidToGo for Exercise",
        "I use PaidToGo to Commute to Work ",
        "I am changing my commuting behaviour from driving a single passenger vehicle to an alternative because of PaidToGo"
    ]
    
    var commuteTypes = [
        "Walk/Run",
        "Bike",
        "Bus/Train",
        "Car Pool"
    ]
    
    var checked = [
        false,
        false,
        false
    ]
    
    var commuteTypesChecked = [
        false,
        false,
        false,
        true
    ]
    
    init() {
        // Update options state
        let user = User.currentUser!
        
        checked[0] = user.profileOption1
        checked[1] = user.profileOption2
        checked[2] = user.profileOption3
        
        commuteTypesChecked[0] = user.commuteTypeWalkRun
        commuteTypesChecked[1] = user.commuteTypeBike
        commuteTypesChecked[2] = user.commuteTypeBusTrain
        commuteTypesChecked[3] = user.commuteTypeCar
    }
    
    mutating func updateOptionState(index:Int) {
        let user = User.currentUser!
        
        checked[index] = checked[index] == false ? true : false
        
        switch index {
        case 0:
            user.profileOption1 = checked[index]
            break
        case 1:
            user.profileOption2 = checked[index]
            break
        default:
            user.profileOption3 = checked[index]
            break
        }
        
        User.currentUser = user
    }
    
    mutating func updateCommuteTypeState(index:Int) {
        let user = User.currentUser!
        
        commuteTypesChecked[index] = commuteTypesChecked[index] == false ? true : false
        
        switch index {
        case 0:
            user.commuteTypeWalkRun = commuteTypesChecked[index]
            break
        case 1:
            user.commuteTypeBike = commuteTypesChecked[index]
            break
        case 2:
            user.commuteTypeBusTrain = commuteTypesChecked[index]
            break
        default:
            user.commuteTypeCar = commuteTypesChecked[index]
            break
        }
        
        User.currentUser = user
    }
}

class ProfileViewController: MenuContentViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var paypalTextField: UITextField!
    
    @IBOutlet weak var checkmarksTableView: UITableView!
    
    @IBOutlet weak var checkbox1MarkLabel: UILabel!
    @IBOutlet weak var checkbox1Label: UILabel!
    
    @IBOutlet weak var signupButtonViewContainer: UIView!
    
    @IBOutlet weak var proUserLabel: UILabel!
    
    // MARK: - Variables and Constants -
    
    var checkmarksStruct = CheckmarkStruct()
    
    var profileImage: UIImage?
    var shouldEnterPayPalAccount = false
    
    // MARK: - Test
    
    var userIsPro = false
    
    // MARK: - Super -
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(true)
        self.title = "menu_profile".localize()
        setNavigationBarGreen()
        customizeNavigationBarWithMenu()
        
        if shouldEnterPayPalAccount {
            self.paypalTextField.becomeFirstResponder()
        }
        
        configureViewForProUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populateFields()
        
        self.signUpButtonShouldChange(false)
        
        self.configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    
    // MARK: - Functions -
    
    func configureTableView() {
        self.checkmarksTableView.dataSource = self
        self.checkmarksTableView.delegate = self
        self.checkmarksTableView.separatorStyle = .None
    }
    
    func configureViewForProUser() {
        
        let user = User.currentUser!
        
        if user.isPro() {
            // Pro User
            proUserLabel.hidden = false
        } else {
            proUserLabel.hidden = true
        }
        
    }
    
    private func initViews(){
        signupButtonViewContainer.round()
        proUserLabel.round()
        profileImageView.roundWholeView()
    }
    
    private func populateFields() {
        
        let currentUser         = User.currentUser!
        
        emailTextField.text     = currentUser.email
        firstNameTextField.text = currentUser.name
        lastNameTextField.text  = currentUser.lastName
        bioTextField.text       = currentUser.bio
        paypalTextField.text    = currentUser.paypalAccount
        
        if let currentProfilePicture = currentUser.profilePicture {
            
            print(currentProfilePicture)
            
            profileImageView.yy_setImageWithURL(NSURL(string: currentProfilePicture), placeholder: UIImage(named: "ic_profile_placeholder"))
        }
    }
    
    private func validate() -> Bool {
        
        if emailTextField.text! == "" {
            showAlert("Email field is empty")
            return false
        }
        if firstNameTextField.text! == "" {
            showAlert("First name field is empty")
            return false
        }
        if lastNameTextField.text! == "" {
            showAlert("Last Name field is empty")
            return false
        }
        
        if bioTextField.text! == "" {
            showAlert("Biography field is empty")
            return false
        }
        
        return true
    }
    
    func signUpButtonShouldChange(value: Bool) {
        if value == true {
            enableSignUpButton()
        } else {
            disableSignUpButton()
        }
    }
    
    func enableSignUpButton() {
        signupButtonViewContainer.alpha = CGFloat(1.0)
        signupButtonViewContainer.userInteractionEnabled = true
    }
    
    func disableSignUpButton() {
        signupButtonViewContainer.alpha = CGFloat(0.3)
        signupButtonViewContainer.userInteractionEnabled = false
    }
    
    // MARK: - Selectors -
    
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
    
    
    @IBAction func logout(sender: AnyObject) {
        
        User.logout()
        self.logoutAnimated()
        
    }
    
    @IBAction func submitAction(sender: AnyObject?){
        
        if validate() {
            
            self.showProgressHud()
            
            let userToSend: User!
            userToSend = User()
            
            userToSend.accessToken = User.currentUser?.accessToken
            userToSend.name = firstNameTextField.text
            userToSend.lastName = lastNameTextField.text
            userToSend.bio = bioTextField.text
            
            if let paypalAcount = self.paypalTextField.text where self.paypalTextField.text?.characters.count > 0 {
                userToSend.paypalAccount = paypalAcount
            }
            
            if let profileImage = profileImage {
                
                let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
                let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                let encodedImageWithPrefix = User.imagePrefix + base64String
                
                userToSend.profilePicture = encodedImageWithPrefix
            }
            
            DataProvider.sharedInstance.postUpdateProfile(userToSend) { (user, error) in
                
                self.dismissProgressHud()
                
                if let user = user { //success
                    
                    self.showAlert("profile_changes_submited".localize())
                    
//                    self.profileImageView.yy_setImageWithURL(NSURL(string: (User.currentUser?.profilePicture)!), options: .RefreshImageCache)
                    self.profileImageView.yy_setImageWithURL(NSURL(string: user.profilePicture!), placeholder: UIImage(named: "ic_profile_placeholder"))
                    
                    // We persist the user's personal options locally
                    user.profileOption1 = (User.currentUser?.profileOption1)!
                    user.profileOption2 = (User.currentUser?.profileOption2)!
                    user.profileOption3 = (User.currentUser?.profileOption3)!
                    
                    User.currentUser = user
                    
                    let notificationName = NotificationsHelper.UserProfileUpdated.rawValue
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: notificationName, object: nil))
                    
                    self.signUpButtonShouldChange(false)
                    
                    self.view.endEditing(true)
                    
                } else if let error = error {
                    
                    self.showAlert(error)
                }
            }
        }
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profileImage = image
        
        self.profileImageView.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil);
        
        self.signUpButtonShouldChange(true)
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
    
    @IBAction func editingChanged(sender: AnyObject) {
        if let textField = sender as? UITextField {
            if textField.text?.characters.count > 0 {
                self.signUpButtonShouldChange(true)
            } else {
                self.signUpButtonShouldChange(false)
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return checkmarksStruct.options.count
        } else {
            return checkmarksStruct.commuteTypes.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.selectionStyle = .None
        
        if indexPath.section == 0 {
            cell.textLabel?.text = checkmarksStruct.options[indexPath.row]
            if let font = UIFont(name: "Open Sans", size: 12.0) {
                cell.textLabel?.font = font
            } else {
                print("Font not found")
            }
            cell.textLabel?.numberOfLines = 0
            
            if checkmarksStruct.checked[indexPath.row] {
                cell.accessoryType = .Checkmark
                cell.textLabel?.textColor = UIColor.blueColor()
            } else {
                cell.accessoryType = .None
                cell.textLabel?.textColor = UIColor.darkTextColor()
            }
        } else {
            cell.textLabel?.text = checkmarksStruct.commuteTypes[indexPath.row]
            if let font = UIFont(name: "Open Sans", size: 12.0) {
                cell.textLabel?.font = font
            } else {
                print("Font not found")
            }
            cell.textLabel?.numberOfLines = 0
            
            if checkmarksStruct.commuteTypesChecked[indexPath.row] {
                cell.accessoryType = .Checkmark
                cell.textLabel?.textColor = UIColor.blueColor()
            } else {
                cell.accessoryType = .None
                cell.textLabel?.textColor = UIColor.darkTextColor()
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView.instanceFromNib()
        
        if section == 0 {
            sectionHeaderView.configureForCommutePreferencesSection()
        } else {
            sectionHeaderView.configureForCommuteTypesSection()
        }
        
        return sectionHeaderView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 2 && indexPath.section == 0 {
            return 60.0
        }
        
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.signUpButtonShouldChange(true)
        
        if indexPath.section == 0 {
            checkmarksStruct.updateOptionState(indexPath.row)
        } else {
            checkmarksStruct.updateCommuteTypeState(indexPath.row)
        }
        
        self.checkmarksTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
}
