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
    
    var localUser = User.currentUser!
    
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
//        let user = User.currentUser!
        
        checked[0] = localUser.profileOption1
        checked[1] = localUser.profileOption2
        checked[2] = localUser.profileOption3
        
        commuteTypesChecked[0] = localUser.commuteTypeWalkRun
        commuteTypesChecked[1] = localUser.commuteTypeBike
        commuteTypesChecked[2] = localUser.commuteTypeBusTrain
        commuteTypesChecked[3] = localUser.commuteTypeCar
    }
    
    mutating func updateOptionState(index:Int) {
//        user = User.currentUser!
        
        checked[index] = checked[index] == false ? true : false
        
        switch index {
        case 0:
            localUser.profileOption1 = checked[index]
            break
        case 1:
            localUser.profileOption2 = checked[index]
            break
        default:
            localUser.profileOption3 = checked[index]
            break
        }
        
//        User.currentUser = user
    }
    
    mutating func updateCommuteTypeState(index:Int) {
//        localUser = User.currentUser!
        
        commuteTypesChecked[index] = commuteTypesChecked[index] == false ? true : false
        
        switch index {
        case 0:
            localUser.commuteTypeWalkRun = commuteTypesChecked[index]
            break
        case 1:
            localUser.commuteTypeBike = commuteTypesChecked[index]
            break
        case 2:
            localUser.commuteTypeBusTrain = commuteTypesChecked[index]
            break
        default:
            localUser.commuteTypeCar = commuteTypesChecked[index]
            break
        }
        
//        User.currentUser = user
    }
    
    mutating func updateUserLocally() {
        
        let user = User.currentUser!
        
        user.profileOption1 = localUser.profileOption1
        user.profileOption2 = localUser.profileOption2
        user.profileOption3 = localUser.profileOption3
        user.commuteTypeWalkRun = localUser.commuteTypeWalkRun
        user.commuteTypeBike = localUser.commuteTypeBike
        user.commuteTypeBusTrain = localUser.commuteTypeBusTrain
        user.commuteTypeCar = localUser.commuteTypeCar
        
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
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(visible: true)
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
        addLogoutButton()
        self.populateFields()
        
        self.signUpButtonShouldChange(value: false)
        
        self.configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initViews()
    }
    
    
    // MARK: - Functions -
    func addLogoutButton() {
        
        let menuButtonImage = #imageLiteral(resourceName: "ic_sync_p4").withRenderingMode(.alwaysTemplate)
        
        let menuButton = UIBarButtonItem(
            image: menuButtonImage,
            style: .done,
            target: self,
            action: #selector(logout(sender:)) // "menuButtonAction:"
        )
        
        menuButton.tintColor = UIColor.black
        menuButton.isEnabled = true
        
        self.navigationItem.rightBarButtonItem = menuButton
    }
    func configureTableView() {
        self.checkmarksTableView.dataSource = self
        self.checkmarksTableView.delegate = self
        self.checkmarksTableView.separatorStyle = .none
    }
    
    func configureViewForProUser() {
        
        let user = User.currentUser!
        
        if user.isPro() {
            // Pro User
            proUserLabel.isHidden = false
        } else {
            proUserLabel.isHidden = true
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
        ageTextField.text       = currentUser.age
        genderTextField.text    = currentUser.gender
        
        if let currentProfilePicture = currentUser.profilePicture {
            
            print(currentProfilePicture)
            
            profileImageView.yy_setImage(with: URL(string: currentProfilePicture) , placeholder: UIImage(named: "ic_profile_placeholder"))
        }
    }
    
    private func validate() -> Bool {
        
        if emailTextField.text! == "" {
            showAlert(text: "Email field is empty")
            return false
        }
        if firstNameTextField.text! == "" {
            showAlert(text: "First name field is empty")
            return false
        }
        if lastNameTextField.text! == "" {
            showAlert(text: "Last Name field is empty")
            return false
        }
        
//        if bioTextField.text! == "" {
//            showAlert("Biography field is empty")
//            return false
//        }
        
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
        signupButtonViewContainer.isUserInteractionEnabled = true
    }
    
    func disableSignUpButton() {
        signupButtonViewContainer.alpha = CGFloat(0.3)
        signupButtonViewContainer.isUserInteractionEnabled = false
    }
    
    // MARK: - Selectors -
    
    @IBAction func photoTapAction(sender: AnyObject) {
        
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
            
            if let paypalAcount = self.paypalTextField.text, self.paypalTextField.text != "" {
                userToSend.paypalAccount = paypalAcount
            }
            
//            if let profileImage = profileImage {
//                
//                let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
////                (.Encoding64CharacterLineLength)
//                let base64String = imageData!.base64EncodedData(options: .encoding64CharacterLineLength)
//                let encodedImageWithPrefix = User.imagePrefix + base64String
//                
//                userToSend.profilePicture = encodedImageWithPrefix
//            }
            
//            DataProvider.sharedInstance.postUpdateProfile(userToSend) { (user, error) in
//
//                self.dismissProgressHud()
//
//                if let user = user { //success
//
//                    self.showAlert("profile_changes_submited".localize())
//
//                    self.profileImageView.yy_setImageWithURL(NSURL(string: user.profilePicture!), placeholder: UIImage(named: "ic_profile_placeholder"))
//
//                    // We persist the user's personal options locally
////                    user.profileOption1 = (User.currentUser?.profileOption1)!
////                    user.profileOption2 = (User.currentUser?.profileOption2)!
////                    user.profileOption3 = (User.currentUser?.profileOption3)!
//
//                    if let age = self.ageTextField.text where !age.isEmpty {
//                        user.age = age
//                    }
//
//                    if let gender = self.genderTextField.text where !gender.isEmpty {
//                        user.gender = gender
//                    }
//
//                    User.currentUser = user
//                    self.checkmarksStruct.updateUserLocally()
//
//                    let notificationName = NotificationsHelper.UserProfileUpdated.rawValue
//                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: notificationName, object: nil))
//
//                    self.signUpButtonShouldChange(false)
//
//                    self.view.endEditing(true)
//
//                } else if let error = error {
//
//                    self.showAlert(error)
//                }
//            }
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profileImage = image
        
        self.profileImageView.image = image
        
        picker.dismiss(animated: true, completion: nil);
        
        self.signUpButtonShouldChange(value: true)
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
    
    @IBAction func editingChanged(sender: AnyObject) {
        if let textField = sender as? UITextField {
            if textField.text != "" {
                self.signUpButtonShouldChange(value: true)
            } else {
                self.signUpButtonShouldChange(value: false)
            }
        }
    }
}

// MARK: - TableView DataSource and Delegate

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return checkmarksStruct.options.count
        } else {
            return checkmarksStruct.commuteTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.textLabel?.text = checkmarksStruct.options[indexPath.row]
            if let font = UIFont(name: "Open Sans", size: 12.0) {
                cell.textLabel?.font = font
            } else {
                print("Font not found")
            }
            cell.textLabel?.numberOfLines = 0
            
            if checkmarksStruct.checked[indexPath.row] {
                cell.accessoryType = .checkmark
                cell.textLabel?.textColor = UIColor.blue
            } else {
                cell.accessoryType = .none
                cell.textLabel?.textColor = UIColor.darkText
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
                cell.accessoryType = .checkmark
                cell.textLabel?.textColor = UIColor.blue
            } else {
                cell.accessoryType = .none
                cell.textLabel?.textColor = UIColor.darkText
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView.instanceFromNib()
        
        if section == 0 {
            sectionHeaderView.configureForCommutePreferencesSection()
        } else {
            sectionHeaderView.configureForCommuteTypesSection()
        }
        
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 2 && indexPath.section == 0 {
            return 60.0
        }
        
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.signUpButtonShouldChange(value: true)
        
        if indexPath.section == 0 {
            checkmarksStruct.updateOptionState(index: indexPath.row)
        } else {
            checkmarksStruct.updateCommuteTypeState(index: indexPath.row)
        }
        
        self.checkmarksTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
    }
    
}
