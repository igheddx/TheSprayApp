//
//  LoginViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import AVFoundation
import LocalAuthentication
import CommonCrypto
import SwiftKeychainWrapper


class LoginViewController: UIViewController, UITextFieldDelegate {
    let customtextfield = CustomTextField()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet weak var rememberMeSwitch: Switch1!
    //@IBOutlet weak var rememberMeLbl: UILabel!
    //@IBOutlet weak var biometricLbl: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var dataToSendTextField: UILabel!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: MyCustomButton! //UIButton!
    @IBOutlet weak var signUpBtn: NoNActiveActionButton!
    
    @IBOutlet weak var biometricUIView: UIView!
    @IBOutlet weak var biometricUIViewLbl: UIView!
    @IBOutlet weak var rememberMeUIView: UIView!
    @IBOutlet weak var rememberMeUIViewLbl: UIView!
    
    //@IBOutlet weak var biometricSwitchBtn: UISwitch!
    
    //@IBOutlet weak var rememberMeSwitchBtn: UISwitch!
    let rememberMeSwitch = Switch1(frame:CGRect(x:0, y: 4, width: 0, height: 0))
    let biometricLbl = UILabel(frame:CGRect(x: 0, y: 0, width: 92, height: 45))
    let biometricSwitchBtn = Switch1(frame:CGRect(x: 0, y: 4, width: 0, height: 0))
    let rememberMeLbl = UILabel(frame:CGRect(x: 0, y: 0, width: 95, height: 45))
    let biometricBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    let defaults = UserDefaults.standard

    //declare input variable
    var username: String = ""
    var password: String = ""
    var firstname2pass: String?
    var lastname2pass: String = ""
    var labelMessageInput: String = ""
    var token2pass: String = ""
    var paymentClientToken: String = ""
    var userdata: UserData?
    var profileId: String?
    var eventCode: String?
    var phone: String = ""
    var logout: Bool = false
    var usernameFieldIsEmpty: Bool = true
    var passwordFieldIsEmpty: Bool = true
    
   
    
    var db:DBHelper = DBHelper()
    var senderspraybalance: [SenderSprayBalance] = []
    var spraytransaction: [SprayTransaction] = []
    var myprofiledata: [MyProfile] = []
    var formValidation =   Validation()
    
    var balance: Int = 0
    var deviceUID: String = ""
    var encryptedAPIKey: String = "" //"9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A"//"CHqcPp7MN3mTY3nF6TWHdG8dHPVSgJBj"
    var encryptedAPIKeyUserName: String = ""
    var encryptedDeviceId: String = ""
    var apiKeyValue: String = "9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A" //this needs to come from a secured location"
    let device = Device()
    let encryptdecrypt = EncryptDecrpyt()
    var isBiometricEnabled: Bool = false
    var setupUsernamePasswordKeychain: Bool = false
    var isKeyChainInUse: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //reeet all default values
        
        var runCount = 0

        
        appInitilialization()

        print("my keychain user = \(KeychainWrapper.standard.string(forKey: "usernameKeyChain"))")
        print("my keychain user = \(KeychainWrapper.standard.string(forKey: "passwordKeyChain"))")
   
        //addBiometricImage()
       // localAuthentication2()
        //processEnableBiometric()
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt") //encryptData(value: apiKeyValue)

       
       
            
        let context = LAContext()
        CheckIfBiometricEnabled()
        if isBiometricEnabled == true {
          
            //launch auto biometric if not logout and keychainInUse = true
            let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
            if isKeyChainInUse == true && logout == false {
                
                if ( context.biometryType == .touchID ) {
                     print("touch Id enabled")
                    biometricLbl.text = "Login With Touch Id"
                    displayBiometricSelection(imageName: "touchid_icon")
                }
                if ( context.biometryType == .faceID) {
                    biometricLbl.text = "Login With Face ID"
                    displayBiometricSelection(imageName: "faceid_icon")
                    print("face Id is enabled")
                } else {
                    print("stone age")
                }
                
                self.isKeyChainInUse = KeychainWrapper.standard.bool(forKey: "isKeyChainInUse")!
                print("iskeychaininuse \(self.isKeyChainInUse )")
                if (self.isKeyChainInUse  == true) {
                    let usernamekeychainToDisplay = KeychainWrapper.standard.string(forKey: "usernameKeyChain")
                    let username =  KeychainWrapper.standard.string(forKey: "usernameKeyChain")
                    let password =  KeychainWrapper.standard.string(forKey: "passwordKeyChain")
                    
                    print("USERNAME =\(username)")
                    print("USERNAME =\(password)")
                    
                    let value = redactUsername(username: usernamekeychainToDisplay!)
                    print("value =\(value)")
                    usernameTextField.text = redactUsername(username: usernamekeychainToDisplay!)
                    usernameTextField.isEnabled = false
                    processEnableBiometric()
                }
            } else  {
                biometricLbl.text = "Enable Biometric"
                displayBiometricSelection(imageName: "")
                displayRememberMeSelection()
                
            }
        
        
        } else  {
            biometricLbl.text = "Enable Biometric"
            displayBiometricSelection(imageName: "")
            displayRememberMeSelection()
        }
        
        //preset biometric and remember swiftch based option biometric from setting
        //let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
        
        let checkEnableBiometricNextLogin = isKeyPresentInUserDefaults(key: "isEnablebiometricNextLogin")
        if checkEnableBiometricNextLogin == true {
            let isEnableBiometricNextLogin =
                KeychainWrapper.standard.set(true, forKey: "isEnablebiometricNextLogin")
            if isEnableBiometricNextLogin == true {
                biometricSwitchBtn.isOn = true
                rememberMeSwitch.isOn = true
                rememberMeSwitch.isEnabled = false
            }
        }
        
        var error: NSError?
       if #available(iOS 13, *) {
           print("this supported")
           if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
               //this is for success
            print("this is for success")
           }else{
              //error.description for type error LAError.biometryLockout, .biometryNotEnrolled and other errors
            print("error detaisl = \(LAError.biometryLockout) \(LAError.biometryNotEnrolled)")
            print("this is for failure -")
           }
       }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
      
       
       
        

        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        
        passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(textField:)),
                                  for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(textField:)),
                                  for: .editingChanged)
        
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        
        //style button
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
        if logout == true {
            logoutCleanUp()
        }
    }
    
    func  calledByTimer() {
        print("I WAS CALLED BY TIMER")
    }
    func localAuthentication2() -> Void {

        print("i am inside local authentication")
       let laContext = LAContext()
       var error: NSError? = nil
       let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics

       if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            print("A - authenication")
           if let laError = error {
               print("laError - \(laError)")
            print("B - authenication")
               return
           }

           var localizedReason = "Unlock device"
           if #available(iOS 13.2, *) {
               if (laContext.biometryType == LABiometryType.faceID) {
                   localizedReason = "Unlock using Face ID"
                   print("FaceId support")
               } else if (laContext.biometryType == LABiometryType.touchID) {
                   localizedReason = "Unlock using Touch ID"
                   print("TouchId support")
               } else {
                   print("No Biometric support")
               }
           } else {
               // Fallback on earlier versions
                print("Fallback on earlier versions")
           }


           laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in

               DispatchQueue.main.async(execute: {

                   if let laError = error {
                       print("laError is not work - \(laError)")
                    print("c - authenication")
                   } else {
                       if isSuccess {
                           print("sucess - Dominic")
                        print("d - authenication")
                            self.authenticateUser()
                       } else {
                           print("failure - Dominic ")
                        print("f - authenication")
                       }
                   }

               })
           })
       }
    }
    
    
    func getFormattedDateToDate(dateinput: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from:dateinput)!
        return date
    }
    
    func addBiometricImage() {

    }
    
    
    func displayRememberMeSelection(){
        rememberMeLbl.textAlignment = NSTextAlignment.center
        rememberMeLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        rememberMeLbl.numberOfLines = 3
        rememberMeLbl.text = "Remember My Login"
        rememberMeLbl.font = UIFont(name: "HelveticaNeue", size: 12)
        
        self.rememberMeUIViewLbl.addSubview(rememberMeLbl)
        
        //let rememberMeSwitchBtn = Switch1(frame:CGRect(x:0, y: 4, width: 0, height: 0))
        rememberMeSwitch.isOn = false
        rememberMeSwitch.setOn(false, animated: false)
        rememberMeSwitch.onTintColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        rememberMeSwitch.tintColor = .lightGray
        rememberMeSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        self.rememberMeUIView.addSubview(rememberMeSwitch)
    }
    func displayBiometricSelection(imageName: String) {
        //let imageName = "faceid_icon"
       
        //image.frame = CGRect(x: 0, y: 0, width:60, height: 60)
        //let button:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        //button.backgroundColor = .black
        biometricLbl.textAlignment = NSTextAlignment.right
        //biometricLbl.text = "Enable Face ID"
        biometricLbl.font = UIFont(name: "HelveticaNeue", size: 12)
        biometricLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        biometricLbl.numberOfLines = 3
        //self.removeFromSuperview()
        //self.biometricUIViewLbl.clearsContextBeforeDrawing(biometricUIViewLbl)
        self.biometricUIViewLbl.addSubview(biometricLbl)
        
        
        if imageName == "" {
            print("I am inside displayBiometricSelection image = ''")
            biometricSwitchBtn.isOn = false
            biometricSwitchBtn.setOn(false, animated: false)
            biometricSwitchBtn.onTintColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
            biometricSwitchBtn.tintColor = .lightGray
            biometricSwitchBtn.addTarget(self, action: #selector(biometricSwitchPressed(_:)), for: .valueChanged)
            //self.biometricUIView.removeFromSuperview()
            biometricBtn.isHidden = true
            self.biometricUIView.addSubview(biometricSwitchBtn)
            
//            for v in view.subviews{
//               if v is UILabel{
//                  v.removeFromSuperview()
//               }
//            }
        } else {
            let image = UIImage(named: imageName)
            let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width:50, height: 50))
            imageView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            imageView.tintColor = .black
            
            print("biometricBtn Image has image" )
            biometricBtn.setImage(image, for: .normal)
            biometricBtn.imageView?.contentMode = .scaleAspectFit
            biometricBtn.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 10.0, right: 0.0)
            biometricBtn.setTitle("", for: .normal)
            biometricBtn.addTarget(self, action:#selector(self.biometricAuthentication), for: .touchUpInside)
            
            //self.biometricUIViewLbl.removeFromSuperview()
            self.biometricUIView.addSubview(biometricBtn)
        }
    }
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        if (sender.isOn){
            print("on")
        }
        else{
            print("off")
        }
    }
    
    @objc func biometricAuthentication() {
        print("Button Clicked")
        processEnableBiometric()
    }
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        
        switch textField{
        case passwordTextField:
           
            if isKeyChainInUse == true {
                self.view.endEditing(true)
                //if passwordTextField.isFirstR
                print("isKeyChainInUse = UNA 222 \(isKeyChainInUse)") //esponder == true {
                    let alert = UIAlertController(title: "Please Confirm", message: "You are about to disable your Face ID. If you continue, to use these features again, you will need to re-enroll", preferredStyle: .actionSheet)

                    //alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [self] (action) in }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [self] (action) in disableBiometric()}))

                    self.present(alert, animated: true)

                //}
            }

        default:
            break
        }
    //        }else{

    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
////        print("isKeyChainInUse = UNA \(isKeyChainInUse)")
////
////        let text = textField.text
////
////
////
////        //if text?.utf16.count==0{
////            switch textField{
//////            case usernameTextField:
//////                customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
////            case passwordTextField:
////                if isKeyChainInUse == true {
////                    //if passwordTextField.isFirstR
////                    print("isKeyChainInUse = UNA 222 \(isKeyChainInUse)") //esponder == true {
////                        let alert = UIAlertController(title: "Please Confirm", message: "You are about to disable your Face ID. If you continue, to use these features again, you will need to re-enroll", preferredStyle: .actionSheet)
////
////                        //alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [self] (action) in }))
////                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
////                        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [self] (action) in disableBiometric()}))
////
////                        self.present(alert, animated: true)
////
////                    //}
////                }
////
////            default:
////                break
////            }
//////        }else{
//////
//////        }
//       return false
//    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            return true
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            
            return true
        default:
            break
        }
        return true
    }
    
    //1/25/21 hold this func for now... we may move it somewhere else
    func  appInitilialization() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        biometricUIView.backgroundColor = UIColor.white
        biometricUIViewLbl.backgroundColor = UIColor.white
        rememberMeUIView.backgroundColor = UIColor.white
        rememberMeUIViewLbl.backgroundColor = UIColor.white
        
        loginButton.isEnabled = false
        rememberMeSwitch.isOn = false
        biometricSwitchBtn.isOn = false
        
//        rememberMeSwitch.isEnabled = false
//        biometricSwitchBtn.isEnabled = false
        
        //removing existing data from object
        myprofiledata.removeAll()
        cleanUserDefaults()
    }

    override func viewWillAppear(_ animated: Bool) {
     
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        if logout == true {
            logoutCleanUp()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        AppUtility.lockOrientation(.portrait)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(.all)
    }
    
    func check2EnableLoginButtonField() {
       
    }
    @objc func textFieldDidChange(textField: UITextField) {
     
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            loginButton.isEnabled = false

        } else {
            loginButton.isEnabled = true

        }
        let text = textField.text
        
      
       
        if text?.utf16.count==1{
            switch textField{
            case usernameTextField:
                customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
            case passwordTextField:
                customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
 
            default:
                break
            }
        }else{

        }
        
//   //commenting this logic out for now... doing something different 6/2/2021
//        //only enable the rememberMe option if username field is populated and validated
//        if usernameTextField.text!.isEmpty == false {
//            let isValidateUserName = self.formValidation.validateEmailId(emailID: usernameTextField.text!)
//            if (isValidateUserName == false) {
//                rememberMeSwitch.isEnabled = false
//                biometricSwitchBtn.isEnabled = false
//            } else {
//                rememberMeSwitch.isEnabled = true
//                biometricSwitchBtn.isEnabled = true
//            }
//        } else {
//            rememberMeSwitch.isEnabled = false
//            biometricSwitchBtn.isEnabled = false
//        }
    }
    
    func disableBiometric() {
        removeCredentialFromKeyChain()
        usernameTextField.text =  ""
        usernameTextField.isEnabled = true
        passwordTextField.isEnabled = true
        biometricLbl.text = "Enable Biometric"
        displayRememberMeSelection()
        displayBiometricSelection(imageName: "")
        print("disableBiometric was called")
    }

//    @IBAction func biometricSwitchPressed(_ sender: Any) {
//        if biometricSwitchBtn.isOn == true {
//            rememberMeSwitch.isOn = true
//            rememberMeSwitch.isEnabled  = false
//        } else {
//            rememberMeSwitch.isOn = false
//        }
//    }
    
    @objc func biometricSwitchPressed(_ sender: UISwitch!) {
        if (sender.isOn){
            print("on")
        }
        else{
            print("off")
        }
        
        if biometricSwitchBtn.isOn == true {
            rememberMeSwitch.isOn = true
            rememberMeSwitch.isEnabled  = false
        } else {
            rememberMeSwitch.isOn = false
            rememberMeSwitch.isEnabled  = true
        }
    }
    
    @IBAction func rememberMeBtnPressed(_ sender: Any) {
        print("remember me was selected")
    }
    func logoutCleanUp() {
        token2pass = ""
        paymentClientToken = ""
        profileId = ""
        eventCode = ""
        myprofiledata.removeAll()
        cleanUserDefaults()
    }
    
    //biometric authentication
    //@IBAction func loginWithBiometric(_ sender: Any)
    func CheckIfBiometricEnabled() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.isBiometricEnabled = true
            print("isBiometricEnabled = true")
        } else {
            //no biometric
            self.isBiometricEnabled = false
            print("isBiometricEnabled = false")
        }
    }
    func processEnableBiometric2() {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate with Face or Touch Id"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        print("Failed to authenticate - Try again")
                        //failed
                        return
                    }
                    
                    //show other screen
                    //success
                    print("This is successful")
                }
                
                //show sother
            }
        } else {
            //cannot use
            print("not available - you cant use this feature")
        }
            
    }
        
    func processEnableBiometric() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("i called authenticationUser")
                        print("II--")
                        //self?.loginButton.loadIndicator(true)
                        self?.loginButton.loadIndicator(true)
                        self?.loginButton.setTitle("Securely Logging In...", for: .normal)
                        self?.loginButton.isEnabled = false
                        
                        self?.authenticateUser()
                    } else {
                        //error
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified, please try again.", preferredStyle: .alert)
                        
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(ac, animated: true)                    }
                }
            }
             
        } else {
            //no biometric
            let ac = UIAlertController(title: "Biometric unavailalbe", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func launchScanner(_ sender: Any) {
    }
    
    @IBAction func privacyPolicyBtnPressed(_ sender: Any) {
        launchPrivacyPolicyTermsConditions()
    }
    
    @IBAction func termOfUseBtnPressed(_ sender: Any) {
        launchPrivacyPolicyTermsConditions()
    }
    
    func storeCredentialInKeyChain() {
        KeychainWrapper.standard.set(usernameTextField.text!, forKey: "usernameKeyChain")
        KeychainWrapper.standard.set(passwordTextField.text!, forKey: "passwordKeyChain")
        KeychainWrapper.standard.set(true, forKey: "isKeyChainInUse")
        //(true, forKey: "isKeyChainInUse")
    }
    
    func removeCredentialFromKeyChain(){
        KeychainWrapper.standard.removeObject(forKey: "usernameKeyChain")
        KeychainWrapper.standard.removeObject(forKey: "passwordKeyChain")
        KeychainWrapper.standard.removeObject(forKey: "isKeyChainInUse")
        isKeyChainInUse = false
    }
    
//    func isKeyPresentInUserDefaults(key: String) -> Bool {
//         return KeychainWrapper.standard.object(forKey: key) != nil
//    }
    
    func  isKeyPresentInUserDefaults(key: String) -> Bool {
        guard let _ = KeychainWrapper.standard.object(forKey: key) else {
         return false;
        }

       return true;
    }
    
    func redactUsername(username: String) -> String {
        //let email = "asdfg.hjkl@gmail.com"
        let atSign = username.firstIndex(of: "@") ?? username.endIndex
        let userID = username[..<atSign]
        let hiddenUserID = userID.replacingOccurrences(of: "(?<!^)[^.]", with: "*", options: .regularExpression)
        return hiddenUserID
        //print(hiddenUserID + email.suffix(from: atSign)) // a****.****@gmail.com
    }
    func authenticateUser() {
        
        print("func authentication")
        var proceedWithBiometricAuthentication: Bool = false
        let usernameKeyChain = KeychainWrapper.standard.valueExists(forKey: "usernameKeyChain") //valueExists(forKey: "usernameKeyChain") //isKeyPresentInUserDefaults(key: "usernameKeyChain")
        let passwordKeyChain =  KeychainWrapper.standard.valueExists(forKey: "passwordKeyChain") //KeychainWrapper.valueExists(forKey: "passwordKeyChain") //isKeyPresentInUserDefaults(key: "passwordKeyChain")
        
        print("usernameKeyChain = \(usernameKeyChain)")
        print("passwordKeyChain = \(passwordKeyChain)")
        
        let username =  KeychainWrapper.standard.string(forKey: "usernameKeyChain")
        let password =  KeychainWrapper.standard.string(forKey: "passwordKeyChain")
        
        print("keychain username =\(username)")
        print("keychain password =\(password)")
//        if(isKeyPresentInUserDefaults(key: "KeyToCheck")) {
//        // exists
//        }else {
//        // doesn't exists
//        }
        if username != nil {
          //Key exists
            print("key chain exist")
            proceedWithBiometricAuthentication = true
        }
        if proceedWithBiometricAuthentication == false {
            print("proceedWithBiometricAuthentication = false")
            self.loginButton.loadIndicator(false)
            self.loginButton.isEnabled = true
            self.loginButton.setTitle("Sign In", for: .normal)
            self.usernameTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            usernameTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  usernameTextField, validationFlag: true)
            //print("Incorrect Email")
//            emailErrorLabel.text = "Incorrect Email"
//            loadingLabel.text = "Incorrect Email"
            let message = "Please login with your email and password to complete biometric setup."
            //displayAlertMessage(displayMessage: message, textField: eventNameTextField)
            self.theAlertView(alertType: "GenericError2", message: message)
            setupUsernamePasswordKeychain = true
            print("my setupUsernamePasswordKeychain = true")
        } else {
            print("proceedWithBiometricAuthentication = true")
            let username =  KeychainWrapper.standard.string(forKey: "usernameKeyChain")
            let password =  KeychainWrapper.standard.string(forKey: "passwordKeyChain")
            
            usernameTextField.text = redactUsername(username: username!)
            
    
            encryptedDeviceId = device.getDeviceId(userName: username!)
            device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
            
            usernameFieldIsEmpty = false
            
//            let udid = UIDevice.current.identifierForVendor?.uuidString
//            let name = UIDevice.current.name
//            //let version = UIDevice.current.systemVersion
//            let modelName = UIDevice.current.model
//
//            let deviceUID = udid! + name + modelName + "|" + username!
//
            startAuthentication(username: username!, password: password!)
//            print("I made it here")
//            loginButton.loadIndicator(true)
//            loginButton.setTitle("Securely Logging In...", for: .normal)
//            loginButton.isEnabled = false
//
//            let authenticatedUserProfile = AuthenticateUser(username: username!, password: password!)
//            let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
//
//            print("request \(request)")
//            Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
//                switch result {
//                case .success(let user):
//                    //processEnableBiometric()
//                    let decoder = JSONDecoder()
//                    do {
//                        let authUser = try decoder.decode(UserData.self, from: user)
//                        if let thetoken = authUser.token {
//                            self.token2pass = thetoken
//
//                            //self.userdata = user
//                            self.profileId = String(authUser.profileId!)
//
//                            let encryptdecrypt = EncryptDecrpyt()
//                            encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: username!, action: "encrypt")
//
//                            //capture profile data
//                            self.getProfileData(profileId1: authUser.profileId!, token1: authUser.token!)
//
//                            //call payment initialization
//                            self.initializePayment(token: authUser.token!, profileId: authUser.profileId!, firstName: authUser.firstName!, lastName: authUser.lastName!, userName: authUser.email!, email: authUser.email!, phone: "")
//
//
//                        } else {
//                            self.loginButton.loadIndicator(false)
//                            self.loginButton.isEnabled = true
//                            self.loginButton.setTitle("Sign In", for: .normal)
//                            self.usernameTextField.isEnabled = true
//                            self.passwordTextField.isEnabled = true
//
//                            theAlertView(alertType: "MissingFields", message: "")
//                        }
//                    } catch {
//                    }
//
//
//
//                case .failure(let error):
//                    self.theAlertView(alertType: "IncorrecUserNamePassword", message: error.localizedDescription + " - /api/profile/authenticate")
//                }
//            }
        }
        
//        if username != "" {
//            self.username = username
//            encryptedDeviceId = device.getDeviceId(userName: username)
//            device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
//
//            usernameFieldIsEmpty = false
//
//            let udid = UIDevice.current.identifierForVendor?.uuidString
//            let name = UIDevice.current.name
//            //let version = UIDevice.current.systemVersion
//            let modelName = UIDevice.current.model
//
//            let deviceUID = udid! + name + modelName + "|" + username //old hold this for now 5/26
//            //let deviceUID = udid! + name + modelName //does not include userName
//            //print("device \(deviceUID)")
//
//        } else {
//            usernameFieldIsEmpty = true
//            usernameTextField.isEnabled = true
//            usernameTextField.becomeFirstResponder()
//        }
//
//        self.username = username
//        self.password = password
//        if username != "" && password != "" {
////            if biometricSwitchBtn.isOn == true {
////                processEnableBiometric()
////            }
//            usernameTextField.text = username
//
//            loginButton.loadIndicator(true)
//            loginButton.setTitle("Securely Logging In...", for: .normal)
//            loginButton.isEnabled = false
//
//            let authenticatedUserProfile = AuthenticateUser(username: self.username, password: self.password)
//            let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
//
//            print("request \(request)")
//            Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
//                switch result {
//                case .success(let user):
//                    //processEnableBiometric()
//                    let decoder = JSONDecoder()
//                    do {
//                        let authUser = try decoder.decode(UserData.self, from: user)
//                        if let thetoken = authUser.token {
//                            self.token2pass = thetoken
//
//                            //self.userdata = user
//                            self.profileId = String(authUser.profileId!)
//
//                            let encryptdecrypt = EncryptDecrpyt()
//                            encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: self.username, action: "encrypt")
//
//                            //capture profile data
//                            self.getProfileData(profileId1: authUser.profileId!, token1: authUser.token!)
//
//                            //call payment initialization
//                            self.initializePayment(token: authUser.token!, profileId: authUser.profileId!, firstName: authUser.firstName!, lastName: authUser.lastName!, userName: authUser.email!, email: authUser.email!, phone: "")
//
//
//                        } else {
//                            self.loginButton.loadIndicator(false)
//                            self.loginButton.isEnabled = true
//                            self.loginButton.setTitle("Sign In", for: .normal)
//                            self.usernameTextField.isEnabled = true
//                            self.passwordTextField.isEnabled = true
//
//                            theAlertView(alertType: "MissingFields", message: "")
//                        }
//                    } catch {
//                    }
//
//
//
//                case .failure(let error):
//                    self.theAlertView(alertType: "IncorrecUserNamePassword", message: error.localizedDescription + " - /api/profile/authenticate")
//                }
//            }
//        } else {
//            theAlertView(alertType: "MissingFields", message: "")
//        }
    }
    func loadingIndicator() {
        let alert = UIAlertController(title: nil, message: "Logging In, Please Wait...", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black


        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func loginButtonPressed(_ sender: Any)  {
        
        guard let  username = usernameTextField.text else {
            return
        }
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false

        
        let isValidateUserName = self.formValidation.validateEmailId(emailID: username)
        if (isValidateUserName == false) {
            usernameTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  usernameTextField, validationFlag: true)
            //print("Incorrect Email")
//            emailErrorLabel.text = "Incorrect Email"
//            loadingLabel.text = "Incorrect Email"
            let message = "Please correct email address format"
            //displayAlertMessage(displayMessage: message, textField: eventNameTextField)
            self.theAlertView(alertType: "GenericError2", message: message)
         return
        }else {
            customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
            
        }
        
       
        password = passwordTextField.text!
        
        if username != "" {
            self.username = username
            encryptedDeviceId = device.getDeviceId(userName: username)
            device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
            
            usernameFieldIsEmpty = false
            
            let udid = UIDevice.current.identifierForVendor?.uuidString
            let name = UIDevice.current.name
            //let version = UIDevice.current.systemVersion
            let modelName = UIDevice.current.model

            let deviceUID = udid! + name + modelName + "|" + username //old hold this for now 5/26
            //let deviceUID = udid! + name + modelName //does not include userName
            //print("device \(deviceUID)")
            
        } else {
            usernameFieldIsEmpty = true
            usernameTextField.isEnabled = true
            usernameTextField.becomeFirstResponder()
        }
        
        if password != "" {
            passwordFieldIsEmpty = false
           // passwordErrorLabel.text = ""
        } else {
            passwordFieldIsEmpty = true
            passwordTextField.isEnabled = true
            passwordTextField.becomeFirstResponder()
        }
        
        if passwordFieldIsEmpty == false && usernameFieldIsEmpty == false {
            print("A--")
            if biometricSwitchBtn.isOn == true  {
                print("B--")
                print("biometricSwitchBtn.isOn == true ")
                
                //if setupUsernamePasswordKeychain == true {
                    print("setupUsernamePasswordKeychain == true")
                storeCredentialInKeyChain()
                //}
                
                if isBiometricEnabled == false {
                    print("C--")
                    processEnableBiometric()
                } else {
                    print("D--")
                    startAuthentication(username:  self.username, password: self.password)
                }
                //
                //self.localAuthentication2()
                
                //self.processEnableBiometric()
            } else {
                print("E--")
                    print("setup inside authentication = \(setupUsernamePasswordKeychain)")
                    startAuthentication(username:  self.username, password: self.password)
            }
            
//                if setupUsernamePasswordKeychain == true {
//                    print("setupUsernamePasswordKeychain == true")
//                   storeCredentialInKeyChain()
//                }
                
              
            //}
            
        } else {
            theAlertView(alertType: "MissingFields", message: "")
        }
    }
    
    func startAuthentication(username: String, password: String) {
        loginButton.loadIndicator(true)
        loginButton.setTitle("Securely Logging In...", for: .normal)
        loginButton.isEnabled = false

        let authenticatedUserProfile = AuthenticateUser(username: username, password: password)
        let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

        print("G")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let user):
                print("HH")
                //processEnableBiometric()
                let decoder = JSONDecoder()
                do {
                    let authUser = try decoder.decode(UserData.self, from: user)
                    if let thetoken = authUser.token {
                        self.token2pass = thetoken

                        //self.userdata = user
                        self.profileId = String(authUser.profileId!)

                        let encryptdecrypt = EncryptDecrpyt()
                        encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: username, action: "encrypt")

                       
                        //call payment initialization
                        self.initializePayment(token: authUser.token!, profileId: authUser.profileId!, firstName: authUser.firstName!, lastName: authUser.lastName!, userName: authUser.email!, email: authUser.email!, phone: "")


                    } else {
                        self.loginButton.loadIndicator(false)
                        self.loginButton.isEnabled = true
                        self.loginButton.setTitle("Sign In", for: .normal)
                        self.usernameTextField.isEnabled = true
                        self.passwordTextField.isEnabled = true

                        theAlertView(alertType: "MissingFields", message: "")
                    }
                } catch {
                }



            case .failure(let error):
                self.theAlertView(alertType: "IncorrecUserNamePassword", message: error.localizedDescription + " - /api/profile/authenticate")
            }
        }
    }
    
    //Initialize payment
    func initializePayment(token: String, profileId: Int64, firstName: String, lastName: String, userName: String, email: String, phone: String) {
        let initPayment = InitializePaymentModel(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone)
  
        //let encryptedAPIKey = userName + "|" + self.encryptedAPIKey
        let request = PostRequest(path: "/api/profile/initialize", model: initPayment, token: token, apiKey: encryptedAPIKeyUserName, deviceId: "")
         
        print("request = \(request)")
        print("initPayment = \(initPayment)")
        
          Network.shared.send(request) { (result: Result<InitializePaymentData, Error>)  in
             switch result {
             case .success(let paymentInit):
                self.paymentClientToken = paymentInit.clientToken!
                
                //capture profile data
                self.getProfileData(profileId1: profileId, token1: token)

               
             case .failure(let error):
                 //self.labelMessage.text = error.localizedDescription
                self.theAlertView(alertType: "InitializeError", message: error.localizedDescription + " - /api/profile/initialize")
             }
         }
        //closing loading
        self.dismiss(animated: false, completion: nil)
    }
   
    func getProfileData(profileId1: Int64, token1: String) {
        let request = Request(path: "/api/profile/\(profileId1)", token: token1, apiKey: encryptedAPIKeyUserName)

        Network.shared.send(request) { [self] (result: Result<ProfileData2, Error>)  in
        switch result {
        case .success(let profileData):
            
            var defaultEventPaymentCustomName: String = ""
            if let custName = profileData.defaultPaymentMethodCustomName  {
                defaultEventPaymentCustomName = custName
            } else {
                defaultEventPaymentCustomName = ""
            }
            
        
            //add profile record into object to be used later
            let data1 = MyProfile(token: "", profileId: profileId1, firstName: profileData.firstName, lastName: profileData.lastName, userName: profileData.userName, email: profileData.email, phone: profileData.phone, avatar: profileData.avatar, paymentCustomerId: profileData.paymentCustomerId, paymentConnectedActId: profileData.paymentConnectedActId, success: true, returnUrl: "", refreshUrl: "",  hasValidPaymentMethod: profileData.hasValidPaymentMethod, defaultPaymentMethod: profileData.defaultPaymentMethod, defaultPaymentMethodCustomName: defaultEventPaymentCustomName)
            self.myprofiledata.append(data1)
            
            checkOnboardingStatus()
           
           // break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
            self.theAlertView(alertType: "GenericError", message: error.localizedDescription + " - /api/profile")
            print(" DOMINIC B IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }
    
    func checkOnboardingStatus() {
        var myName: String = ""
        var myLastName: String = ""
        var myusername: String = ""
        var myEmail: String = ""
        var myPhone: String = ""
        var myAvatar: String?
        var myPaymentCustomerId: String?
        var myPaymentConnectedActId: String?
        var myReturnUrl: String = ""
        var myRefreshUrl: String = ""
        var myProfileId: Int64 = 0
 
        for myprofile in myprofiledata {
            myProfileId = myprofile.profileId
            myName = myprofile.firstName
            myLastName = myprofile.lastName
            myusername = myprofile.email
            myEmail = myprofile.email
            myPhone = myprofile.phone
            myAvatar = myprofile.avatar
            myPaymentCustomerId = myprofile.paymentCustomerId
            myPaymentConnectedActId = myprofile.paymentConnectedActId
        }
        
        myReturnUrl = "https://projectxclientapp.azurewebsites.net/stripe/Index?profileid=\(myProfileId)&status=success&token=\(token2pass)"
        myRefreshUrl = "https://projectxclientapp.azurewebsites.net/stripe/Index?profileid=\(myProfileId)&status=failed&token=\(token2pass)"
        
        let onboardingProfile = ProfileOnboarding(token: token2pass, profileId: myProfileId, firstName: myName, lastName: myLastName, userName: myusername, email: myEmail, phone: myPhone, avatar: myAvatar, paymentCustomerId: myPaymentCustomerId, paymentConnectedActId: myPaymentConnectedActId, success: true, returnUrl: myReturnUrl, refreshUrl: myRefreshUrl)
       
        let request = PostRequest(path: "/api/profile/addaccount", model: onboardingProfile, token: token2pass, apiKey: encryptedAPIKeyUserName, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>) in
            switch result {
            case .success(let urldata):

                //let m = URL(string: String(data: urldata, encoding: .utf8) ?? "*")
                let redirectUrl = String(data: urldata, encoding: .utf8) ?? "*"
     
                let redirectURL2 = redirectUrl.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
              
                let jsonData = redirectURL2.data(using: .utf8)!
                let connectedaccount: ConnectedAccount = try! JSONDecoder().decode(ConnectedAccount.self, from: jsonData)
                
               // print("MY URL IS \(connectedaccount.url!)")
                print("IS ACCOUNT CONNECTED Login \(connectedaccount.isAccountConnected)")
                
                UserDefaults.standard.set(connectedaccount.isAccountConnected, forKey: "isAccountConnected")
                self.performSegue(withIdentifier: "nextVC", sender: nil)
                //break

            case .failure(let error):
                UserDefaults.standard.set(false, forKey: "isAccountConnected")
                self.theAlertView(alertType: "GenericError", message: error.localizedDescription + " - /api/profile/addaccount ")
                print(" DOMINIC H IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
    
    func launchPrivacyPolicyTermsConditions() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyTermsConditionsViewController") as! PrivacyPolicyTermsConditionsViewController
        nextVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        nextVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext

        self.present(nextVC, animated: true, completion: nil)
    }
    
   
    

    
    
    func theAlertView(alertType: String, message: String){
        var alertTitle: String = ""
        var alertMessage: String = ""
        if alertType == "IncorrecUserNamePassword" {
            alertTitle = "Login Error"
            alertMessage = "You entered an invalid login ID or Password 1. \n"
            
            
            
        } else if alertType == "MissingFields" {
            alertTitle = "Login Error"
            alertMessage = "You entered an invalid login ID or Password 2. \n"
        } else if alertType == "InitializeError" {
            alertTitle = "Login Error"
            alertMessage = "Something went wrong with the initialization. Please try again later. \n \(message)"
        } else if alertType == "GenericError" {
            alertTitle = "Error"
            alertMessage = "Something went wrong with the initialization. Please try again later. \n \(message)"
        }  else if alertType == "GenericError2" {
            alertTitle = "Error"
            alertMessage = message
        }
       
        
        
        self.loginButton.isEnabled = true
        self.loginButton.setTitle("Sign In", for: .normal)
        self.usernameTextField.isEnabled = true
        self.passwordTextField.isEnabled = true
        //self.loginButton.loadIndicator(false)
        self.loginButton.loadIndicator(false)
        
        let alert2 = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert2, animated: true)
    }
    
    
  
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep0ViewController") as! OTPStep0ViewController
        nextVC.action = "createAccount"
        self.navigationController?.pushViewController(nextVC , animated: true)
    }

    
    @IBAction func forgetPassword(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep0ViewController") as! OTPStep0ViewController
        nextVC.action = "forgotPassword"
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    /*may need to move this to initialization - app start once we figure it out
    1/25/2020 */
    func cleanUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "isAccountConnected")
        defaults.set(false, forKey: "isContinueAutoReplenish") //when auto replish is enabled
        UserDefaults.standard.removeObject(forKey: "userDisplayName")
        UserDefaults.standard.removeObject(forKey: "userProfileImage")

    }
    
    //**************** good code hold ***********************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //closing loading
        self.dismiss(animated: false, completion: nil)
               
        if(segue.identifier == "nextVC"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass
            NextVC.paymentClientToken = paymentClientToken
            NextVC.myProfileData = myprofiledata
            NextVC.encryptedAPIKey = encryptedAPIKeyUserName
        } else if(segue.identifier == "goToReg") {
            let NextVC = segue.destination as! RegistrationViewController
            NextVC.message  = ""
            NextVC.encryptedAPIKey = encryptedAPIKeyUserName
        } else if(segue.identifier == "goToLoginWithCode") {
            let NextVC = segue.destination as! JoinWithEventCodeViewController
        }
    }
}

extension Date {
 static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //"MM/dd/yyyy HH:mm:ss"
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //dateFormatter.locale = Locale.current
        return dateFormatter.string(from: Date())
    }
}

extension KeychainWrapper {

    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }

}
