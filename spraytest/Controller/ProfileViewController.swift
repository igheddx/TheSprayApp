//
//  ProfileViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/27/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var myAvatar: UIImageView!
    //var myNewAvatar: UIImageView!
    //var myAvatar2 = UIImageView(frame: CGRectMake(0, 0, 100, 100))
    //var myAvatar2 = UIImageView(frame: CGRect(x: 137, y: 40, width: 100, height: 100))
    
    //let containView = UIView(frame: CGRect(x: 137, y: 40, width: 100, height: 100))
    //var myAvatar = UIImageView(frame: CGRect(x: 137, y: 40, width: 100, height: 100))
    
    var customView = UIView()
    
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var userNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    var profileId: Int64 = 0
    var token: String = ""
    var isNewAvatar: Bool = false
    var originalAvatar: String = ""
    var avatar: String = ""
    
    var customtextfield = CustomTextField()
    var formValidation =   Validation()
    

    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
   
        
        
//        myAvatar.image = UIImage(named: "dominic")
//        myAvatar.contentMode = UIView.ContentMode.scaleAspectFit
//        myAvatar.layer.cornerRadius = 20
//        myAvatar.layer.masksToBounds = true
//        myAvatar.layer.borderWidth = 1
//        myAvatar.layer.borderColor =  UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor //UIColor.black.cgColor
//        myAvatar.clipsToBounds = true
//
//        containView.addSubview(myAvatar)
//
        //myAvatar.RoundedImageView()
        firstNameTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        //firstNameTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                     //for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)),
                                    for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)),
                                 for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                for: .editingChanged)
        newPasswordTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)),
                                    for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)),
                                           for: .editingChanged)
        
        
//        firstNameLabel.isHidden = true
//        lastNameLabel.isHidden = true
//        emailLabel.isHidden = true
//        phoneLabel.isHidden = true
//        passwordLabel.isHidden = true
//        passwordConfirmLabel.isHidden = true
        customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: phoneTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: newPasswordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: confirmPasswordTextField, validationFlag: false)
        //customtextfield.borderForTextField(textField: eventCodeTextField, validationFlag: false)

        
        
//        self.borderForTextField(textField: firstNameTextField, validationFlag: false)
//        self.borderForTextField(textField: lastNameTextField, validationFlag: false)
//        self.borderForTextField(textField: userNameTextField, validationFlag: false)
//        self.borderForTextField(textField: emailTextField, validationFlag: false)
//        self.borderForTextField(textField: phoneTextField, validationFlag: false)
//        self.borderForTextField(textField: newPasswordTextField, validationFlag: false)
//        self.borderForTextField(textField: confirmPasswordTextField, validationFlag: false)
        
        firstNameErrorLabel.isHidden = true
        lastNameErrorLabel.isHidden = true
        userNameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        phoneErrorLabel.isHidden = true
        newPasswordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
        
        getProfileData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        //self.view.layoutIfNeeded()
        myAvatar.frame = CGRect.init(x: 137, y: 40, width: 100, height: 100)
        //myAvatar.backgroundColor = UIColor.black
        myAvatar.contentMode =  UIView.ContentMode.scaleToFill// ScaleToFill
        myAvatar.layoutIfNeeded()
        myAvatar.layer.borderWidth = 1
        myAvatar.layer.masksToBounds = false
        myAvatar.layer.borderColor =  UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor //UIColor.black.cgColor
        myAvatar.layer.cornerRadius = myAvatar.frame.height/2
        myAvatar.clipsToBounds = true

      //
        //customView.frame = CGRect.init(x: 137, y: 40, width: 100, height: 100)
        //myAvatar.backgroundColor = UIColor.black     //give color to the view
          // customView.center = self.view.center
           //self.view.addSubview(customView)
        
//        let containView = UIView(frame: CGRect(x: 137, y: 89, width: 100, height: 100))
//        let imageview = UIImageView(frame: CGRect(x: 137, y: 89, width: 100, height: 100))
//
//
   
        //let newView = UIView()
//        let newView = UIView()
//        newView.frame = CGRect.init(x: 137, y: 40, width: 100, height: 100)
//           newView.backgroundColor = UIColor.red
//           view.addSubview(newView)
//
//           newView.translatesAutoresizingMaskIntoConstraints = false
//           let horizontalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//           let verticalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
//           let widthConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
//           let heightConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        
//
       
        //imageview.contentMode =  UIViewContentModeScaleToFill;
//
                        //let rightBarButton = UIBarButtonItem(customView: containView)
                        //self.navigationItem.rightBarButtonItem = rightBarButton
        
//        myAvatar.layoutIfNeeded()
//        myAvatar.layer.borderWidth = 1
//        myAvatar.layer.masksToBounds = false
//        myAvatar.layer.borderColor = UIColor.black.cgColor
//        myAvatar.layer.cornerRadius = myAvatar.frame.height/2
//        myAvatar.clipsToBounds = true
        //myAvatar2.translatesAutoresizingMaskIntoConstraints = false
//        myAvatar.frame.size.height = 100
//        myAvatar.frame.size.width = 100
//
//            //= UIImageView(frame: CGRect(x: 137, y: 40, width: 100, height: 100))
//        myAvatar.layer.cornerRadius = myAvatar.frame.size.height/2
//        myAvatar.layer.borderWidth = 1
//        myAvatar.layer.borderColor =  UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor //UIColor.black.cgColor
//        myAvatar.clipsToBounds = true
        //view.addSubview(myAvatar2)
        
        
       
        
//                        let rightBarButton = UIBarButtonItem(customView: containView)
//                        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
       
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==1{
                switch textField{
                case firstNameTextField:
                    //firstNameLabel.isHidden = false
                    //firstNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: false)
                    firstNameErrorLabel.text = ""
//                    tf2.becomeFirstResponder()
              case lastNameTextField:
                customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
                lastNameErrorLabel.text = ""
//                    //lastNameLabel.isHidden = false
//                    //lastNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//                    customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
//                    lastNameErrorLabel.text = ""
                case emailTextField:
                    //emailLabel.isHidden = false
                    //emailLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
                    emailErrorLabel.text = ""
//                case phoneTextField:
//                   // phoneLabel.isHidden = false
//                   // phoneLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//                    customtextfield.borderForTextField(textField: phoneTextField, validationFlag: false)
//                    phoneErrorLabel.text = ""
                case newPasswordTextField:
                    //passwordLabel.isHidden = false
                    //passwordLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: newPasswordTextField, validationFlag: false)
                    newPasswordErrorLabel.text = ""
                case confirmPasswordTextField:   //passwordConfirmLabel.isHidden = false
                    //passwordConfirmLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: confirmPasswordTextField, validationFlag: false)
                    confirmPasswordErrorLabel.text = ""
                default:
                    break
                }
            }else{

            }
    }

//    private func borderForTextField(textField: UITextField, validationFlag: Bool) {
//
//        if validationFlag == false {
//            textField.layer.cornerRadius = 6.0
//            textField.layer.masksToBounds = true
//            textField.layer.borderColor = UIColor(red: 211/256, green: 211/256, blue: 211/256, alpha: 1.0 ).cgColor
//            textField.layer.borderWidth = 1.0
//        } else {
//            textField.layer.cornerRadius = 6.0
//            textField.layer.masksToBounds = true
//            textField.layer.borderColor = UIColor(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0 ).cgColor
//            textField.layer.borderWidth = 1.0
//        }
//
//
//        //textField.layer.addSublayer(bottomLine)
//
//    }
    
    func getProfileData() {
        let request = Request(path: "/api/Profile/41", token: token)
        
        print("request=\(request)")
        Network.shared.send(request) { [self] (result: Result<ProfileData2, Error>)  in
        switch result {
        case .success(let profileData):
            firstNameTextField.text = profileData.firstName
            lastNameTextField.text = profileData.lastName
            userNameTextField.text = profileData.userName
            emailTextField.text = profileData.email
            phoneTextField.text = profileData.phone
            let dataString = profileData.avatar!
            let dataURL = URL(string: dataString)
            let contents: String?
            do {
                contents = try String(contentsOf: dataURL!)
                //contents = try Data(contentsOf: someURL)
                print("image 1 = \(profileData.avatar!)")
                originalAvatar = profileData.avatar!
            } catch {
                contents = "dominic"
                print("image 2 = \(profileData.avatar!)")
                originalAvatar = profileData.avatar!
            }
            
            //let image = UIImage(data: data)
            
            //myAvatar.image = UIImage(named: contents!)
            
            let results = dataString.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
            for imageString in results {
                autoreleasepool {
                    
                    let image2 = imageString.base64ToImage()
                    myAvatar.image = image2

                }
            
            }
            
//            let imageData = Data.init(base64Encoded: profileData.avatar!, options: .init(rawValue: 0))
////               let image = UIImage(data: imageData!)
////               return image!
//            myAvatar.image = UIImage(data: imageData!)
            
            break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
        print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
                    
            }
                  
        }
         //print(profiledata)
    }
    
    @IBAction func updateProfileButtonPressed(_ sender: Any) {
        var isNewPasswordEntered: Bool = false
        var passwordMatch: Bool = false
        
        guard let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text,
        let phone = phoneTextField.text,
        let password = newPasswordTextField.text,
        let confirmPassword = confirmPasswordTextField.text,
        let email = emailTextField.text else {
            return
        }
        
        let isValidateFirstName = self.formValidation.validateName2(name2: firstName).isValidate
        
        //let isValidateFirstName = self.formValidation.validateName2(name2: firstName)
        if (isValidateFirstName == false) {
            firstNameTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            firstNameErrorLabel.text = "Incorrect First Name"
            return
        } else {
            customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: false)
            firstNameErrorLabel.text = ""
        }
        
        let isValidateEmail = self.formValidation.validateEmailId(emailID: email)
        if (isValidateEmail == false) {
            emailTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  emailTextField, validationFlag: true)
            //print("Incorrect Email")
            emailErrorLabel.text = "Incorrect Email"
            //loadingLabel.text = "Incorrect Email"
         return
        }else {
            customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
            emailErrorLabel.text = ""
        }
        
        if password != "" {
            isNewPasswordEntered = true
            let isValidatePass = self.formValidation.validatePassword(password: password)
            if (isValidatePass == false) {
                newPasswordTextField.becomeFirstResponder()
                customtextfield.borderForTextField(textField:  newPasswordTextField, validationFlag: true)
                //print("Incorrect Password")
                newPasswordErrorLabel.text = "Incorrect Password"
                //loadingLabel.text = "Incorrect Password"
                return
            } else {
                customtextfield.borderForTextField(textField: newPasswordTextField, validationFlag: false)
                newPasswordErrorLabel.text = ""
            }

            
            if password != confirmPassword {
            
                passwordMatch = false
                confirmPasswordTextField.becomeFirstResponder()
                customtextfield.borderForTextField(textField:  confirmPasswordTextField, validationFlag: true)
                confirmPasswordErrorLabel.text = "Incorrect Mismatch"
                //loadingLabel.text = "Password Mismatch"
            } else {
                passwordMatch = true
            }
        }
        
        
        if isNewPasswordEntered == true {
            if (isValidateFirstName == true && isValidateEmail == true) {
               var profileData = ProfileAvatar(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: email, email: email, phone: phone, avatar: phone, success: true)
                
                //let newImageStr = convertImageToBase64String (img: myAvatar.image!)
            }
        } else {
            if (isValidateFirstName == true && isValidateEmail == true) {
                     print("update fields that does NOT includs password")
            }
        }
        if (isValidateFirstName == true && isValidateEmail == true) {
            
            if isNewAvatar == true {
                avatar = convertImageToBase64String (img: myAvatar.image!)
            } else {
                avatar = originalAvatar // convertImageToBase64String (img: myNewAvatar.image!)
            }
            
           let profileData = ProfileAvatar(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: email, email: email, phone: phone, avatar: avatar, success: true)
           
            print("profileData =\(profileData)")
            let request = PostRequest(path: "/api/Profile/avatar", model: profileData, token: token)
            Network.shared.send(request) { (result: Result<ProfileAvatar, Error>) in
                switch result {
                case .success(let userdata):
                   // print("avatar \(userdata.avatar)")
                    break
           case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }


        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func chooseProfilePicBtnClicked(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.openCamera(UIImagePickerController.SourceType.camera)
            }
            let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.openCamera(UIImagePickerController.SourceType.photoLibrary)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }

            // Add the actions
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
    }
    func openCamera(_ sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
//    func openCamera(){
//        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
//            picker.sourceType = UIImagePickerController.SourceType.camera
//            self .present(picker, animated: true, completion: nil)
//        }else{
//            print("You don't have camera")
////            let alert = UIAlertView()
////            alert.title = "Warning"
////            alert.message = "You don't have camera"
////            alert.addButton(withTitle: "OK")
////            alert.show()
//        }
//    }
//    func openGallary(){
//        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
//        self.present(picker, animated: true, completion: nil)
//    }
    //MARK:UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        myAvatar.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        isNewAvatar = true
       //myNewAvatar.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        //print("new image =\(convertImageToBase64String(img: myAvatar.image!))")
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerController cancel")
    }

    //Encoding Base64 Image
    func convertImageToBase64String (img: UIImage) -> String {
        //return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        let strBase64 =  img.pngData()?.base64EncodedString()
            return strBase64!
        
        //data.base64EncodedStringWithOptions([])
    }
    
    //Decoding Base64 Image
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
}
extension String {
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
            return image
        }
        return nil
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range:  NSRange(self.startIndex..., in: self))
            return results.map {
                //self.substring(with: Range($0.range, in: self)!)
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

