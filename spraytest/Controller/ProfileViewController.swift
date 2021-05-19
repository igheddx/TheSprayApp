//
//  ProfileViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/27/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

class ProfileViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var myAvatar: UIImageView!
    //var myNewAvatar: UIImageView!
    //var myAvatar2 = UIImageView(frame: CGRectMake(0, 0, 100, 100))
    //var myAvatar2 = UIImageView(frame: CGRect(x: 137, y: 40, width: 100, height: 100))
    
    //let containView = UIView(frame: CGRect(x: 137, y: 40, width: 100, height: 100))
    //var myAvatar = UIImageView(frame: CGRect(x: 137, y: 40, width: 100, height: 100))
    
    var customView = UIView()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
//    @IBOutlet weak var firstNameErrorLabel: UILabel!
//    @IBOutlet weak var lastNameErrorLabel: UILabel!
//    @IBOutlet weak var userNameErrorLabel: UILabel!
//    @IBOutlet weak var emailErrorLabel: UILabel!
//    @IBOutlet weak var phoneErrorLabel: UILabel!
//    @IBOutlet weak var newPasswordErrorLabel: UILabel!
//    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    var profileId: Int64 = 0
    var token: String = ""
    var isNewAvatar: Bool = false
    var originalAvatar: String = ""
    var avatar: String = ""
    
    var customtextfield = CustomTextField()
    var formValidation =   Validation()
    
    var paymentCustomerId: String?
    var paymentConnectedActId: String?
//    var success: Bool
    var returnUrl: String?
    var refreshUrl: String?
    var hasValidPaymentMethod: Bool?
    var defaultPaymentMethod: Int = 0
    var defaultPaymentMethodCustomName: String =  ""
//
    let imagePicker = UIImagePickerController()
    
    var encryptedAPIKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //use to keep keyboard down
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
   
        
        self.navigationItem.title = "Profile"
       
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
       
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        userNameTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
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
        
        userNameTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        emailTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)),
                                 for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)),
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
        customtextfield.borderForTextField(textField: userNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: phoneTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: newPasswordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: confirmPasswordTextField, validationFlag: false)
        //customtextfield.borderForTextField(textField: eventCodeTextField, validationFlag: false)
        
        userNameTextField.isEnabled = false
        
        
//        self.borderForTextField(textField: firstNameTextField, validationFlag: false)
//        self.borderForTextField(textField: lastNameTextField, validationFlag: false)
//        self.borderForTextField(textField: userNameTextField, validationFlag: false)
//        self.borderForTextField(textField: emailTextField, validationFlag: false)
//        self.borderForTextField(textField: phoneTextField, validationFlag: false)
//        self.borderForTextField(textField: newPasswordTextField, validationFlag: false)
//        self.borderForTextField(textField: confirmPasswordTextField, validationFlag: false)
        
//        firstNameErrorLabel.isHidden = true
//        lastNameErrorLabel.isHidden = true
//        userNameErrorLabel.isHidden = true
//        emailErrorLabel.isHidden = true
//        phoneErrorLabel.isHidden = true
//        newPasswordErrorLabel.isHidden = true
//        confirmPasswordErrorLabel.isHidden = true
        
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
        myAvatar.layer.borderColor =  UIColor.black.cgColor //UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor //UIColor.black.cgColor
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
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock
            // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        scroll2Top()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    func scroll2Top() {
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
            case firstNameTextField:
                firstNameTextField.resignFirstResponder()
            case lastNameTextField:
                lastNameTextField.resignFirstResponder()
            case emailTextField:
                emailTextField.resignFirstResponder()
            case newPasswordTextField:
                newPasswordTextField.resignFirstResponder()
            case confirmPasswordTextField:   //passwordConfirmLabel.isHidden = false
                confirmPasswordTextField.resignFirstResponder()
            default:
                break
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==1{
                switch textField{
                case firstNameTextField:
                    //firstNameLabel.isHidden = false
                    //firstNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: false)
                    //firstNameErrorLabel.text = ""
//                    tf2.becomeFirstResponder()
              case lastNameTextField:
                customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
                //lastNameErrorLabel.text = ""
//                    //lastNameLabel.isHidden = false
//                    //lastNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//                    customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
//                    lastNameErrorLabel.text = ""
                case emailTextField:
                    //emailLabel.isHidden = false
                    //emailLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
                    //emailErrorLabel.text = ""
//                case phoneTextField:
//                   // phoneLabel.isHidden = false
//                   // phoneLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//                    customtextfield.borderForTextField(textField: phoneTextField, validationFlag: false)
//                    phoneErrorLabel.text = ""
                case newPasswordTextField:
                    //passwordLabel.isHidden = false
                    //passwordLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: newPasswordTextField, validationFlag: false)
                   // newPasswordErrorLabel.text = ""
                case confirmPasswordTextField:   //passwordConfirmLabel.isHidden = false
                    //passwordConfirmLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: confirmPasswordTextField, validationFlag: false)
                   // confirmPasswordErrorLabel.text = ""
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
    //set textfield focus and highlight border set
    func textFieldFocus(textField: UITextField) {
        textField.becomeFirstResponder()
        customtextfield.borderForTextField(textField: textField, validationFlag: true)
    }
    func displayAlertMessage(displayMessage: String, textField: UITextField) {
        let alert2 = UIAlertController(title: "Missing Information", message: displayMessage, preferredStyle: .alert)
        //alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] (action) in self.textFieldFocus(textField: textField)}))
        
        self.present(alert2, animated: true)
        
    }
    
    func displayAlertMessage2(displayMessage: String, completionAction:String) {
        
        if completionAction == "success" {
            let alert2 = UIAlertController(title: "Information", message: displayMessage, preferredStyle: .alert)

            //alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: nil))
            alert2.addAction(UIAlertAction(title: "Done. Return Home ", style: .default, handler: { (action) in self.launchVC(vcName: "home")}))
            alert2.addAction(UIAlertAction(title: "Make More Changes", style: .cancel, handler: nil))
         
            self.present(alert2, animated: true)
        } else if completionAction == "error" {
            let alert2 = UIAlertController(title: "Error", message: displayMessage, preferredStyle: .alert)
            //alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            alert2.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            
            self.present(alert2, animated: true)
        }
    }
    
    func launchVC(vcName:String) {
        if vcName == "home" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
      
            nextVC.profileId = profileId
            nextVC.token = token
            nextVC.encryptedAPIKey = encryptedAPIKey
           self.navigationController?.pushViewController(nextVC , animated: true)
        }
        
    }
    func getProfileData() {
        let request = Request(path: "/api/Profile/\(profileId)", token: token, apiKey: encryptedAPIKey)
        
        print("request=\(request)")
        Network.shared.send(request) { [self] (result: Result<ProfileData2, Error>)  in
        switch result {
        case .success(let profileData):
            firstNameTextField.text = profileData.firstName
            lastNameTextField.text = profileData.lastName
            userNameTextField.text = profileData.userName
            emailTextField.text = profileData.email
            phoneTextField.text = profileData.phone
           
            paymentCustomerId = profileData.paymentCustomerId!
            //paymentConnectedActId = profileData.paymentConnectedActId!
            
            //var paymentConnectedActId: String = ""
            if let connectedActId = profileData.paymentConnectedActId  {
                paymentConnectedActId = connectedActId
            } else {
                paymentConnectedActId = ""
            }
            
            //var returnUrl: String = ""
            if let url1 = profileData.returnUrl {
                returnUrl = url1
            } else {
                returnUrl = ""
            }
            
            //var refreshUrl: String = ""
            if let url2 = profileData.refreshUrl{
                refreshUrl = url2
            } else {
                refreshUrl = ""
            }
            
            //avatar = profileData.avatar!
            
            //var defaultPaymentMethodCustomName: String = ""
            if let customName = profileData.defaultPaymentMethodCustomName {
                defaultPaymentMethodCustomName = customName
            } else {
                defaultPaymentMethodCustomName = ""
            }
            
            //defaultPaymentMethodCustomName = profileData.paymentCustomerId!
            //print("paymentConnectedActId \(paymentConnectedActId)")
            hasValidPaymentMethod = profileData.hasValidPaymentMethod
            defaultPaymentMethod = profileData.defaultPaymentMethod
            
            if let myAvatar2 = profileData.avatar {
                
                myAvatar.image = convertBase64StringToImage(imageBase64String: myAvatar2)
            } else {
                myAvatar.image = UIImage(named: "userprofile")
            }
            
//            if let iAvatar = profileData.avatar  {
//                let dataString = iAvatar
//
//                let dataURL = URL(string: dataString)
//                let contents: String?
//                do {
//                    contents = try String(contentsOf: dataURL!)
//                    //contents = try Data(contentsOf: someURL)
//                    //print("image 1 = \(profileData.avatar)")
//                    originalAvatar = profileData.avatar!
//                } catch {
//                    contents = "dominic"
//                    //print("image 2 = \(profileData.avatar)")
//                    originalAvatar = profileData.avatar!
//                }
//
//                //let image = UIImage(data: data)
//
//                //myAvatar.image = UIImage(named: contents!)
//
//                let results = dataString.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
//                for imageString in results {
//                    autoreleasepool {
//
//                        let image2 = imageString.base64ToImage()
//                        myAvatar.image = image2
//
//                    }
//
//                }
//
//            } else {
//                myAvatar.image = UIImage(named: "userprofile")
//            }
//
           
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
        self.LoadingStart()
        var isNewPasswordEntered: Bool = false
        var passwordMatch: Bool = false
        
        guard let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text,
        let userName = userNameTextField.text,
        let phone = phoneTextField.text,
        let password = newPasswordTextField.text,
        let confirmPassword = confirmPasswordTextField.text,
        let email = emailTextField.text else {
            return
        }
        
        let isValidateFirstName = self.formValidation.validateName2(name2: firstName).isValidate
        
        let isValidateLastName = self.formValidation.validateName2(name2: lastName).isValidate
        //let isValidateFirstName = self.formValidation.validateName2(name2: firstName)
        if (isValidateFirstName == false) {
            let message = "FirstName Is Required"
            //eventCountryTextField.becomeFirstResponder()
            displayAlertMessage(displayMessage: message, textField: firstNameTextField)
            return
        } else {
            customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: false)
        }
        
        if (isValidateLastName == false) {
            let message = "Last Name Is Required"
            //eventCountryTextField.becomeFirstResponder()
            displayAlertMessage(displayMessage: message, textField: lastNameTextField)
            return
        } else {
            customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
        }
        
        let isValidateEmail = self.formValidation.validateEmailId(emailID: email)
        if (isValidateEmail == false) {
          
            let message = "Email Is Required"
            //eventCountryTextField.becomeFirstResponder()
            displayAlertMessage(displayMessage: message, textField: emailTextField)
         return
        }else {
            customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
            
        }
        
        if password != "" {
            isNewPasswordEntered = true
            let isValidatePass = self.formValidation.validatePassword(password: password)
            if (isValidatePass == false) {
//                newPasswordTextField.becomeFirstResponder()
//                customtextfield.borderForTextField(textField:  newPasswordTextField, validationFlag: true)
//                //print("Incorrect Password")
//                newPasswordErrorLabel.text = "Incorrect Password"
                //loadingLabel.text = "Incorrect Password"
                
                let message = "Incorrect Password"
                //eventCountryTextField.becomeFirstResponder()
                displayAlertMessage(displayMessage: message, textField: newPasswordTextField)
                
                return
            } else {
                customtextfield.borderForTextField(textField: newPasswordTextField, validationFlag: false)
                //newPasswordErrorLabel.text = ""
            }

            
            if password != confirmPassword {
            
                passwordMatch = false
//                confirmPasswordTextField.becomeFirstResponder()
//                customtextfield.borderForTextField(textField:  confirmPasswordTextField, validationFlag: true)
//                confirmPasswordErrorLabel.text = "Incorrect Mismatch"
//
                let message = "Password Mismatch"
                //eventCountryTextField.becomeFirstResponder()
                displayAlertMessage(displayMessage: message, textField: confirmPasswordTextField)
                //loadingLabel.text = "Password Mismatch"
            } else {
                passwordMatch = true
                customtextfield.borderForTextField(textField: confirmPasswordTextField, validationFlag: false)
            }
        }
        
        
        if isNewPasswordEntered == true {
            if (isValidateFirstName == true && isValidateLastName == true && isValidateEmail == true && passwordMatch == true) {
               //var profileData = ProfileAvatar(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: email, email: email, phone: phone, avatar: phone, success: true)
                
                //let newImageStr = convertImageToBase64String (img: myAvatar.image!)
                updateProfile(firstName: firstName, lastName: lastName, userName: userName, phone: phone, newPassword: "", oldPassword: "")
            }
        } else {
            if (isValidateFirstName == true && isValidateLastName == true && isValidateEmail == true ) {
//                updateProfile(firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone, avatar: avatar)
//                     print("update fields that does NOT includs password")
                
                if isNewAvatar == true {
                    print("This is a new image convert to base64")
                    avatar = convertImageToBase64String (img: myAvatar.image!)
                    //print(avatar)
                } else {
                    print("orignal image")
                    let im = "data:image/jpeg;base64"
                    print(im)
                    avatar = "data:image/jpg;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADIAQAAAACFI5MzAAAB9klEQVR42u2YQYorMQxEBbqWQFc36FoG/6pyOpNZ/J20mGGaTiftF2hbLpWU2PnfYX/k55Jl5vhUVTu8luUdaCeFcydejjdwDUyQ5XV2JOcSZnkHZgiejusK51QGycrl2yIR1BwjjKivSFz8YC7fY91GKIj6PL5pp4/wWL54t3MHt/AjFxoJwmkYwosbh6/UEHE817hvi/vGex8gEkTdVRo1/55BM7kjUIgpoMW1DxB6kD+GtCX4PUFws40OwcUm0/lRYjOB3pG9YcguBFQuO0ISJ9UIrUP5CKy/MriXHDkETYmLDax1+RkgWBglQgUyq6T/HCAHBq7iJHd9KWWAlIKoGpiLc6HNDhDkETNYwqeVhym72snKKxA6BJL4UPM5QPYtgGwZeNZ5O0UvgSb0VGdcmVfJCQwQrM+pRiGnYJ497SUlv2NOYfOCX3qU2Equ7W3JAslsN7oDBDWWojcZq+KbEwQRdRYl1wD3ML52rpGc6w24qCXaKh4DRHWJbUPemqtEGyBMKC4Q/QmWiDWzRxkgO1UtSLh3svMaILeDpEGwrwvZ4Bkg9LynK1Y1LJWQdqKGnm3K7VTCz7vS9hIuUyYRd/xKcYRIHGqAViisQ4S/Uozmqo41Pn6bNRI1xS/fk2fMEKpDZYkpjP6B1T0HyN9/Nb+M/AORXDdE4Lb/mQAAAABJRU5ErkJggg=="
                    //originalAvatar // convertImageToBase64String (img: myNewAvatar.image!)
                }
                
                updateProfile(firstName: firstName, lastName: lastName, userName: userName, phone: phone, newPassword: "", oldPassword: "")
                     print("update fields that does NOT includs password")
            }
        }
//        if (isValidateFirstName == true && isValidateLastName == true && isValidateEmail == true) {
//
//            if isNewAvatar == true {
//                print("This is a new image convert to base64")
//                avatar = convertImageToBase64String (img: myAvatar.image!)
//                print(avatar)
//            } else {
//                print("orignal image")
//                avatar = "default" //originalAvatar // convertImageToBase64String (img: myNewAvatar.image!)
//            }
//
//            updateProfile(firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone, avatar: avatar)
//                 print("update fields that does NOT includs password")
////
//        }


        
    }
    
    func updateProfile(firstName: String, lastName: String, userName: String,  phone: String, newPassword: String, oldPassword: String){
        let profileData = UserUpdateModel(firstName: firstName, lastName: lastName, userName: userName, phone: phone, newPassword: newPassword, oldPassword: oldPassword)
     
           //print("profileData =\(profileData)")
           let request = PostRequest(path: "/api/Profile/\(profileId)", model: profileData, token: token, apiKey: encryptedAPIKey, deviceId: "")
           Network.shared.send(request) { (result: Result<Data, Error>) in
               switch result {
               case .success(let userdata):
                self.LoadingStop()
                  // print("avatar \(userdata.avatar)")
               // print(userdata.firstName)
                   break
          case .failure(let error):
                   print(error.localizedDescription)
            self.LoadingStop()
               }
           }
    }
    
    
    func updateAvatar(avatar: UIImage){
        
        var newAvatarImage: String = ""
        
        do {
                    try avatar.compressImage(100, completion: { (image, compressRatio) in
                        print("image size = \(image.size)")
                        let imageData = image.jpegData(compressionQuality: compressRatio)
                        let base64data = imageData?.base64EncodedString()
                        newAvatarImage =  (imageData?.base64EncodedString())!
                        print("base64data dominic\(base64data)")

                    })
                } catch {
                         print("Error")
                }
        
        //newAvatarImage = convertImageToBase64String(img: myAvatar.image!)
        let avatarData = ProfileAvatar(token: token, profileId: profileId, firstName: "", lastName: "", userName: "", email: "", phone: "", avatar: newAvatarImage, paymentCustomerId: paymentCustomerId, paymentConnectedActId: paymentConnectedActId, success: true, returnUrl: returnUrl!, refreshUrl: refreshUrl!, hasValidPaymentMethod: hasValidPaymentMethod!,defaultPaymentMethod: defaultPaymentMethod, defaultPaymentMethodCustomName: defaultPaymentMethodCustomName)
   
        //print("profileData =\(avatarData)")
        print("updateAvatar was called... doing something")
           let request = PostRequest(path: "/api/Profile/avatar", model: avatarData, token: token, apiKey: encryptedAPIKey, deviceId: "")
           Network.shared.send(request) { (result: Result<ProfileAvatar, Error>) in
               switch result {
               case .success(let avatardata):
                print("Avatar update was successful")
                self.LoadingStop()
                  // print("avatar \(userdata.avatar)")
                print(avatardata.firstName)
                   break
          case .failure(let error):
                   print(error.localizedDescription)
            self.LoadingStop()
               }
           }
    }
    
//    func loading() {
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.UIActivityIndicatorView.Style.medium
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        present(alert, animated: true, completion: nil)
//    }
    
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
        print("new image was assigned")
       //myNewAvatar.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        
        print("Image size \(myAvatar.image?.getSizeIn(.megabyte)) mb")
        
        // max 300kb
        var dimage: UIImage?
       // var base64data: String = ""
        myAvatar.image!.resizeByByte(maxByte: 800000) { (resizedData) in
            //print("image size: \(resizedData.count)")
            //dimage = resizedData
        }
        
      
        
        //myAvatar.image?.mediumQualityJPEGNSData
        /*hold this for now*/
        imagePicker.dismiss(animated: true, completion: { [self] in action(myimage: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)})
        //imagePicker.dismiss(animated: true, completion: { [self] in action(myimage: myAvatar.image!.mediumQualityJPEGNSData)})
        
        //imagePicker.dismiss(animated: true, completion: { [self] in action(myimage: dimage)})
        
        print("i called updateAvata")
        
        //print("new image =\(convertImageToBase64String(img: myAvatar.image!))")
      
        
    }
    @objc func action(myimage: UIImage) {
         print("action")
        self.LoadingStart()
        updateAvatar(avatar: myimage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerController cancel")
    }

    //Encoding Base64 Image
    func convertImageToBase64String (img: UIImage) -> String {
        //return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        //let strBase64 =  img.pngData()?.base64EncodedString()
        //return strBase64!
        
        let imageData: Data? = img.jpegData(compressionQuality: 0.4)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        print(imageStr,"imageString")
        return imageStr //strBase64!
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

extension ProfileViewController{
   func LoadingStart(){
        ProgressDialog.alert = UIAlertController(title: nil, message: "Processing...", preferredStyle: .alert)
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating();

    ProgressDialog.alert.view.addSubview(loadingIndicator)
    present(ProgressDialog.alert, animated: true, completion: nil)
  }

  func LoadingStop(){
    ProgressDialog.alert.dismiss(animated: true, completion: nil)
  }
}

extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits)-> String {

        guard let data = self.pngData() else {
            return ""
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }

        return String(format: "%.2f", size)
    }
}

extension UIImage {
    
    func resizeByByte(maxByte: Int, completion: @escaping (Data) -> Void) {
        var compressQuality: CGFloat = 1
        var imageData = Data()
        var imageByte = self.jpegData(compressionQuality: 1)?.count
        
        while imageByte! > maxByte {
            imageData = self.jpegData(compressionQuality: compressQuality)!
            imageByte = self.jpegData(compressionQuality: compressQuality)?.count
            compressQuality -= 0.1
        }
        
        if maxByte > imageByte! {
            completion(imageData)
        } else {
            completion(self.jpegData(compressionQuality: 1)!)
        }
    }
    
    var highestQualityJPEGNSData: Data { return self.jpegData(compressionQuality: 1.0)! }
       var highQualityJPEGNSData: Data    { return self.jpegData(compressionQuality: 0.75)!}
       var mediumQualityJPEGNSData: Data  { return self.jpegData(compressionQuality: 0.5)! }
       var lowQualityJPEGNSData: Data     { return self.jpegData(compressionQuality: 0.25)!}
       var lowestQualityJPEGNSData: Data  { return self.jpegData(compressionQuality: 0.0)! }
}

//5/2 this is what i am using
extension UIImage {

    enum CompressImageErrors: Error {
        case invalidExSize
        case sizeImpossibleToReach
    }
    func compressImage(_ expectedSizeKb: Int, completion : (UIImage,CGFloat) -> Void ) throws {

        let minimalCompressRate :CGFloat = 0.4 // min compressRate to be checked later

        if expectedSizeKb == 0 {
            throw CompressImageErrors.invalidExSize // if the size is equal to zero throws
        }

        let expectedSizeBytes = expectedSizeKb * 1024
        let imageToBeHandled: UIImage = self
        var actualHeight : CGFloat = self.size.height
        var actualWidth : CGFloat = self.size.width
        var maxHeight : CGFloat = 841 //A4 default size I'm thinking about a document
        var maxWidth : CGFloat = 594
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 1
        var imageData:Data = imageToBeHandled.jpegData(compressionQuality: compressionQuality)!
        while imageData.count > expectedSizeBytes {

            if (actualHeight > maxHeight || actualWidth > maxWidth){
                if(imgRatio < maxRatio){
                    imgRatio = maxHeight / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = maxHeight;
                }
                else if(imgRatio > maxRatio){
                    imgRatio = maxWidth / actualWidth;
                    actualHeight = imgRatio * actualHeight;
                    actualWidth = maxWidth;
                }
                else{
                    actualHeight = maxHeight;
                    actualWidth = maxWidth;
                    compressionQuality = 1;
                }
            }
            let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
            UIGraphicsBeginImageContext(rect.size);
            imageToBeHandled.draw(in: rect)
            let img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if let imgData = img!.jpegData(compressionQuality: compressionQuality) {
                if imgData.count > expectedSizeBytes {
                    if compressionQuality > minimalCompressRate {
                        compressionQuality -= 0.1
                    } else {
                        maxHeight = maxHeight * 0.9
                        maxWidth = maxWidth * 0.9
                    }
                }
                imageData = imgData
            }


        }

        completion(UIImage(data: imageData)!, compressionQuality)
    }


}
