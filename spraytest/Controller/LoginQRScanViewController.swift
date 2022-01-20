//
//  LoginQRScanViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/7/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//



import UIKit
import AVFoundation
import LocalAuthentication
import CommonCrypto
import SwiftKeychainWrapper

class LoginQRScanViewController: UIViewController, UITextFieldDelegate {
    let customtextfield = CustomTextField()
    @IBOutlet weak var eventUIView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

   // @IBOutlet weak var rememberMeSwitch: Switch1!
    
    @IBOutlet weak var rememberMeLbl: UILabel!
    //@IBOutlet weak var rememberMeLbl: UILabel!
    
    @IBOutlet weak var dataToSendTextField: UILabel!
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateTimeLbl: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var signInBtn: MyCustomButton! //UIButton!
    
    //@IBOutlet weak var signUpBtn: NoNActiveActionButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var biometricLbl2: UILabel!
   
    @IBOutlet weak var biometricSwitchBtn2: UISwitch!
    
    @IBOutlet weak var biometricIcon: UIImageView!
    
    let defaults = UserDefaults.standard
   // @IBOutlet weak var eventCodeTextField: UITextField!
    
    //declare input variable
    var eventId: Int64 = 0
    var ownerId: Int64 = 0
    var username: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var firstname2pass: String?
    var lastname2pass: String = ""
    var labelMessageInput: String = ""
    var token2pass: String = ""
    var paymentClientToken: String = ""
    var userdata: UserData?
    var profileId: String?
    var phone: String = ""
    var logout: Bool = false
    var usernameFieldIsEmpty: Bool = true
    var passwordFieldIsEmpty: Bool = true
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventTypeIcon: String = ""
    var eventCode: String = ""
    var eventType: String = ""
    var formValidation =   Validation()
    
    
    var db:DBHelper = DBHelper()
    var senderspraybalance: [SenderSprayBalance] = []
    var spraytransaction: [SprayTransaction] = []
    var myprofiledata: [MyProfile] = []
    var balance: Int = 0
    var deviceUID: String = ""
    var encryptedAPIKey: String = "" //"9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A"//"CHqcPp7MN3mTY3nF6TWHdG8dHPVSgJBj"
    var encryptedAPIKeyUserName: String = ""
    var encryptedDeviceId: String = ""
    var apiKeyValue: String = "9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A" //this needs to come from a secured location"
    let device = Device()
    var encryptdecrypt = EncryptDecrpyt()
    var isBiometricEnabled: Bool = false
    var setupUsernamePasswordKeychain: Bool = false
    var isKeyChainInUse: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MY 2 EVENT CODE \(eventCode)")
        setNavigationBar()
        
        signInBtn.isEnabled = false //disabled until data is entered
       
        //navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let context = LAContext()
        CheckIfBiometricEnabled()
        if isBiometricEnabled == true {
          
            //launch auto biometric if not logout and keychainInUse = true
            let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
            
            if ( context.biometryType == .touchID ) {
                 print("touch Id enabled")
                if isKeyChainInUse == true {
                    biometricLbl2.text = "Touch ID is Enabled"
                    biometricSwitchBtn2.isHidden = true
                } else {
                    biometricLbl2.text = "Enable Touch ID"
                    biometricSwitchBtn2.isHidden = false
                    biometricSwitchBtn2.isOn = false
                }
                
                biometricIcon.image = UIImage(named: "touchid_icon")
                //displayBiometricSelection(imageName: "touchid_icon")
            } else if  ( context.biometryType == .faceID) {
                if isKeyChainInUse == true {
                    biometricLbl2.text = "Face ID is Enabled"
                    biometricSwitchBtn2.isHidden = true
                } else  {
                    biometricLbl2.text = "Enable Face ID"
                    biometricSwitchBtn2.isHidden = false
                    biometricSwitchBtn2.isOn = false
                }
                
                biometricIcon.image = UIImage(named: "faceid_icon")
                //displayBiometricSelection(imageName: "faceid_icon")
                print("face Id is enabled")
            } else {
                print("stone age")
                biometricLbl2.text = ""
                biometricSwitchBtn2.isHidden = true
                biometricIcon.isHidden = true
            }
            
            
            if isKeyChainInUse == true && logout == false {
                
               
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
//            } else  {
//                biometricLbl2.text = "Enable Biometric"
//                biometricSwitchBtn2.isHidden = false
//                biometricSwitchBtn2.isOn = false
            }
        
        
        } else  {
//            biometricLbl.text = "Enable Biometric"
//            biometricSwitchBtn2.isHidden = false
//            biometricSwitchBtn2.isOn = false
            //don't show it if it is not enabled
            biometricLbl2.text = ""
            biometricSwitchBtn2.isHidden = true
            biometricIcon.isHidden = true
//            displayBiometricSelection(imageName: "")
//            displayRememberMeSelection()
        }
        
        //preset biometric and remember swiftch based option biometric from setting
        //let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
        
        let checkEnableBiometricNextLogin = isKeyPresentInUserDefaults(key: "isEnablebiometricNextLogin")
        if checkEnableBiometricNextLogin == true {
            let isEnableBiometricNextLogin =
                KeychainWrapper.standard.set(true, forKey: "isEnablebiometricNextLogin")
            if isEnableBiometricNextLogin == true {
                biometricSwitchBtn2.isOn = true
//                rememberMeSwitch.isOn = true
//                rememberMeSwitch.isEnabled = false
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
        
        print("LoginQR = \(encryptedAPIKey)")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        print("I WAS CALLED")
        let newEventNameStr = eventName.replacingOccurrences(of: "&apos;", with: "'")
        eventNameLbl.text = newEventNameStr //eventName
        eventDateTimeLbl.text = eventDateTime
        eventImageView.image = UIImage(named: eventTypeIcon)
        //eventCodeLabel.text = eventCode
        
        //rememberMeSwitch.isOn = false
        appInitilialization()
        
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
        
        eventUIView.layer.borderColor  = UIColor.lightGray.cgColor
        eventUIView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        eventUIView.layer.shadowOpacity  = 2.0
        eventUIView.layer.masksToBounds = false
        //eventUIView.layer.cornerRadius = 8.0
        
        //navigationItem.hidesBackButton = true
//        navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        
        usernameTextField.text = ""
        passwordTextField.text = ""

        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
    
        
        passwordTextField.addTarget(self, action: #selector(LoginQRScanViewController.textFieldDidChange(textField:)),
                                  for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(LoginQRScanViewController.textFieldDidChange(textField:)),
                                  for: .editingChanged)
        
        //self.eventCodeTextField.delegate = self
        
        //toggleTorch(on: true)
//        navigationItem.hidesBackButton = true
//        navigationController?.setNavigationBarHidden(true, animated: true)
//
    
        print("MY EVENT CODE = \(eventCode)")
        //style button
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)

        if logout == true {
            logoutCleanUp()
        }
    }
    

//

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
                        
                        self?.signInBtn.loadIndicator(true)
                        self?.signInBtn.setTitle("Securely Logging In...", for: .normal)
                        self?.signInBtn.isEnabled = false
                        
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
    
    func disableBiometric() {
        removeCredentialFromKeyChain()
        usernameTextField.text =  ""
        usernameTextField.isEnabled = true
        passwordTextField.isEnabled = true
        biometricLbl2.text = "Enable Biometric"
        biometricSwitchBtn2.isHidden = false
        biometricSwitchBtn2.isOn = false
        
//        displayRememberMeSelection()
//        displayBiometricSelection(imageName: "")
        print("disableBiometric was called")
    }
    
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
    @objc func textFieldDidChange(textField: UITextField) {
     
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            signInBtn.isEnabled = false

        } else {
            signInBtn.isEnabled = true

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

    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @IBAction func privacyPolicyBtnPressed(_ sender: Any) {
        launchPrivacyPolicyTermsConditions()
    }
    
    @IBAction func termOfUseBtnPressed(_ sender: Any) {
        launchPrivacyPolicyTermsConditions()
    }
    
    func setNavigationBar() {
        print("I was called")
        /*let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Join Event")
     
        
        navItem.largeTitleDisplayMode = .automatic
        //navigationController?.navigationBar.prefersLargeTitles = true
        navBar.prefersLargeTitles = true
        
        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
        let doneItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(done))
           navItem.leftBarButtonItem = doneItem
           navBar.setItems([navItem], animated: false)
           self.view.addSubview(navBar) */
        
        print("I was called")
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Join Event")
        //let navItem2 = UINavigationItem(title: "Step 1 of 3")
        
       
        //let item =  UIBarButtonItem(customView: customView)
//        rbar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        //navigationItem.rightBarButtonItems = [rbar]
        
        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
        //let doneItem2 = UIBarButtonItem(barButtonSystemItem: , style: .plain, target: nil, action: #selector(done))
        let doneItem = UIBarButtonItem(image: UIImage(systemName: "xmark") , style: .plain, target: nil, action: #selector(done))
       // let doneItem2 = UIBarButtonItem(systemItem: .close, primaryAction: closeAction, menu: nil)
        //navItem.rightBarButtonItem  = doneItem2
        
        let rbar = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        rbar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        
        //navItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        
        navItem.leftBarButtonItem = doneItem
    
        navItem.rightBarButtonItem  = rbar
           navBar.setItems([navItem], animated: false)
           self.view.addSubview(navBar)
    }
    
    //returns user to login when back button is pressed
    @objc func done() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        let window = UIApplication.shared.windows.first

        // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
        let nav = UINavigationController(rootViewController: loginVC!)
        window?.rootViewController = nav

       self.navigationController?.popToRootViewController(animated: true)
    }
    
    func launchPrivacyPolicyTermsConditions() {
      
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyTermsConditionsViewController") as! PrivacyPolicyTermsConditionsViewController

        nextVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        nextVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext

        self.present(nextVC, animated: true, completion: nil)

    }
    //1/25/21 hold this func for now... we may move it somewhere else
    func  appInitilialization() {
        //reset default value of certain default user data
        defaults.set(false, forKey: "isEditEventSettingRefresh")  //indicates that a refresh should be performed after returing to spray select attendee vc
        defaults.set(false, forKey: "isEditEventSettingRefreshSprayVC") //indicates that a refresh should be performed after returing to spray vc
        defaults.set(false, forKey: "isContinueAutoReplenish") //when auto replish is enabled while using app
    }


    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        if logout == true {
            logoutCleanUp()
        }
        
        //labelMessage.text = labelMessageInput - hold this 1/16/2021
        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock
            // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
  
        //self.tabBarController?.tabBar.isHidden = true

        

        var eventDateTime: String = "Wed, 19 Aug 2020 08:02 AM"
        var incomingDate: String?
                   incomingDate = eventDateTime
               let index = incomingDate!.lastIndex(of: " ") ?? incomingDate!.endIndex
               let finalDate = incomingDate![..<index]
               print("finalDate= \(finalDate)")

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a"
        let date = dateFormatter.date(from:String(eventDateTime))!


        let formatedEventDateTime  = getFormattedDate(date: date, format: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        print("formatedEventDateTime = \(formatedEventDateTime )")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    
    //need to remove this method later 1/16/2021
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { print("Torch isn't available"); return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            // Optional thing you may want when the torch it's on, is to manipulate the level of the torch
            if on { try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel.significand) }
            device.unlockForConfiguration()
        } catch {
            print("Torch can't be used")
        }
    }
    func getFormattedDate(date: Date, format: String) -> String {
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            return dateformat.string(from: date)
    }
    func loadingIndicator() {
        let alert = UIAlertController(title: nil, message: "Securely Logging In, Please Wait...", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black


        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    func loadingIndicatorAction(actionType: String){
        if actionType == "displayloadingmsg" {
            usernameTextField.isEnabled = false
            passwordTextField.isEnabled = false

            signInBtn.loadIndicator(true)
            signInBtn.setTitle("Processing...", for: .normal)
            signInBtn.isEnabled = false
            signUpBtn.isEnabled = false
        } else if actionType == "error" {
            signInBtn.isEnabled = true
            signUpBtn.isEnabled = true
            signInBtn.setTitle("Sign In", for: .normal)
            usernameTextField.isEnabled = true
//            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            //passwordConfirmTextField.isEnabled = true
            //self.loginButton.loadIndicator(false)
            signInBtn.loadIndicator(false)
    
        } else if actionType == "done" {
            signInBtn.isEnabled = true
            signUpBtn.isEnabled = true
            signInBtn.setTitle("Sign Up", for: .normal)
            usernameTextField.isEnabled = true
            //emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            //passwordConfirmTextField.isEnabled = true
            //self.loginButton.loadIndicator(false)
            signInBtn.loadIndicator(false)
        }
    }
    
    func logoutCleanUp() {
        token2pass = ""
        paymentClientToken = ""
        profileId = ""
        eventCode = ""
        
    }
    
    
    func generatePhoneNumber() -> String {
        let str1 =  Int.random(in: 100...999)
        let str2 =  Int.random(in: 100...999)
        let str3 =  Int.random(in: 1000...9999)
        
        let phonenumber = String(str1) + "-" + String(str2) + "-" + String(str3)
        return phonenumber
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
            self.signInBtn.loadIndicator(false)
            self.signInBtn.isEnabled = true
            self.signInBtn.setTitle("Sign In", for: .normal)
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
            
            startAuthentication(username: username!, password: password!)

        }

    }

    func startAuthentication(username: String, password: String) {
        signInBtn.loadIndicator(true)
        signInBtn.setTitle("Securely Logging In...", for: .normal)
        signInBtn.isEnabled = false

        let authenticatedUserProfile = AuthenticateUser(username: username, password: password)
        let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
        print("REQUEST = \(request)")
        print("USERNAME OUTSIDE = \(username)")
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
                        
                        print("old API Key = \(encryptedAPIKey)")
                        
                        print("USERNAME = \(username)")
                        var encryptdecrypt = EncryptDecrpyt()
                        encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: username, action: "encrypt")

                        encryptedAPIKey = encryptedAPIKeyUserName
                       
                        //call func to get payment record onfile
                       
                        self.getProfileData(profileId1: authUser.profileId!, token1: authUser.token!)
                        
                        //call payment initialization
//                        self.initializePayment(token: authUser.token!, profileId: authUser.profileId!, firstName: authUser.firstName!, lastName: authUser.lastName!, userName: authUser.email!, email: authUser.email!, phone: "")


                    } else {
                        self.signInBtn.loadIndicator(false)
                        self.signInBtn.isEnabled = true
                        self.signInBtn.setTitle("Sign In", for: .normal)
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
        
       
        let isEnableBiometricNextLoginExist = isKeyPresentInUserDefaults(key: "isEnablebiometricNextLogin")
        if isEnableBiometricNextLoginExist == true {
            KeychainWrapper.standard.removeObject(forKey: "isEnablebiometricNextLogin")
        }
    
        
        isKeyChainInUse = false
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("SHINJA")
//        encryptedAPIKey = ""
//        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
//        
//        usernameTextField.isEnabled = false
//        passwordTextField.isEnabled = false
//       
//        
//        username = usernameTextField.text!
//        password = passwordTextField.text!
//        
//      
//        if username != "" {
//            encryptedDeviceId = device.getDeviceId(userName: username)
//            //encryptedDeviceId = device.getDeviceId(userName: self.username!)
//            //device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
//            
//    
//            print("I send device DEVICE")
//            /*5/29 this code will be removed before production. no need to sendDevice Info during loing
//            this is already establishe dwhen account was created */
//            device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
//            
//            print("username Encrypted = \(encryptedAPIKey)")
//            usernameFieldIsEmpty = false
//            //usernameErrorLabel.text = ""
//        } else {
//            usernameFieldIsEmpty = true
//            usernameTextField.isEnabled = true
//            usernameTextField.becomeFirstResponder()
//            //theAlertView(alertType: "MissingFields", message: "")
//        }
//        
//        if password != "" {
//            passwordFieldIsEmpty = false
//           // passwordErrorLabel.text = ""
//        } else {
//            passwordFieldIsEmpty = true
//            passwordTextField.isEnabled = true
//            passwordTextField.becomeFirstResponder()
//            //userNamePasswordAlert()
//            //theAlertView(alertType: "MissingFields", message: "")
//           
//        }
//        
//        if passwordFieldIsEmpty == false && usernameFieldIsEmpty == false {
//           // encryptedDeviceId = device.getDeviceId(userName: username)
//           //loadingIndicator()
//        
//            signInBtn.loadIndicator(true)
//            signInBtn.setTitle("Securely Logging In...", for: .normal)
//            signInBtn.isEnabled = false
//            //eventCode = eventCodeTextField.text!
//            
//
//            let authenticatedUserProfile = AuthenticateUser(username: self.username, password: self.password)
//            let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
//            
//            print("encryptedAPIKey inside request = \(encryptedAPIKey)")
//           print("the request =\(request)")
//            //randomly generated phone number - to be changed later 
//            //phone = ""//generatePhoneNumber()
//            
//            Network.shared.send(request) { [self] (result: Result<UserData, Error>)  in
//                switch result {
//                case .success(let user):
//                    self.token2pass = user.token!
//                    self.userdata = user
//                    self.profileId = String(user.profileId!)
//                    
//                    print("before i call addToEvent")
//                   
//                    var encryptdecrypt = EncryptDecrpyt()
//                    encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: username, action: "encrypt")
//                    encryptedAPIKey = encryptedAPIKeyUserName
//                    
//                    
////                    let encryptdecrypt = EncryptDecrpyt()
////                    encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: self.username, action: "encrypt")
////                    encryptedAPIKey = encryptedAPIKeyUserName
//                    
//                  
//                    
//                    
//                    //add user to event
//                   // if self.eventCode != "" {
//                      //  self.getProfileData(profileId1: user.profileId!, token1: user.token!)
//                        //self.addToEvent(profileId: user.profileId!, email: user.email!, phone: "", eventCode: eventCode, token: self.token2pass)
//                    //} else {
//                    self.getProfileData(profileId1: user.profileId!, token1: user.token!)
//                        
//                        //call payment initialization
//                        //self.initializePayment(token: user.token!, profileId: user.profileId!, firstName: user.firstName!, lastName: user.lastName!, userName: user.email!, email: user.email!, phone: phone)
//                        //call func to get payment record onfile
//                        //self.getPaymentMethodRecord(profileId: user.profileId!, token: user.token!)
//                        //capture profile data
//                        
//                    //}
//                    
//                    
//                    print(" this is dominic \(user)")
//                case .failure(let error):
//
//                    self.theAlertView(alertType: "IncorrecUserNamePassword", message: error.localizedDescription)
//                }
//            }
//            
//        } else {
//            theAlertView(alertType: "MissingFields", message: "")
//        }
//        
        
        
        
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
            print("SHINJA2")
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
        
        print("SHINJA3 - \(usernameFieldIsEmpty)")
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
            if biometricSwitchBtn2.isOn == true  {
                print("B--")
                print("biometricSwitchBtn2.isOn == true ")
                
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
    
    func theAlertView(alertType: String, message: String){
        var alertTitle: String = ""
        var alertMessage: String = ""
        if alertType == "IncorrecUserNamePassword" {
            alertTitle = "Login Error"
            alertMessage = "You entered an invalid login ID or Password. \n"
            
            
            
        } else if alertType == "MissingFields" {
            alertTitle = "Login Error"
            alertMessage = "You entered an invalid login ID or Password. \n"
        } else if alertType == "InitializeError" {
            alertTitle = "Login Error"
            alertMessage = "Something went wrong with the initialization. Please try again. \n"
        }
        //self.dismiss(animated: true, completion: nil)
        self.signInBtn.isEnabled = true
        self.signInBtn.setTitle("Sign In", for: .normal)
        self.usernameTextField.isEnabled = true
        self.passwordTextField.isEnabled = true
        //self.loginButton.loadIndicator(false)
        self.signInBtn.loadIndicator(false)
        
        let alert2 = UIAlertController(title: alertTitle, message: "\(alertMessage) \n \(message)", preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
     
        self.present(alert2, animated: true)
    
    }
    
    
    //Initialize payment
    func initializePayment(token: String, profileId: Int64, firstName: String, lastName: String, userName: String, email: String, phone: String) {
        let initPayment = InitializePaymentModel(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone)
        print("InitializePaymentModel \(initPayment)")
         let request = PostRequest(path: "/api/Profile/initialize", model: initPayment, token: token, apiKey: encryptedAPIKey, deviceId: "")
         
        
        
          Network.shared.send(request) { (result: Result<InitializePaymentData, Error>)  in
             switch result {
             case .success(let paymentInit):
                self.paymentClientToken = paymentInit.clientToken!
                
                print("paymentClientToken = \(self.paymentClientToken)")
                
                //self.performSegue(withIdentifier: "nextVC", sender: nil)
                self.loadingIndicatorAction(actionType: "done")
                self.performSegue(withIdentifier: "nextVC", sender: nil)
                
             case .failure(let error):
                 //self.labelMessage.text = error.localizedDescription
                self.theAlertView(alertType: "InitializeError", message: error.localizedDescription)
             }
             
            
         }
        
        //closing loading
        self.dismiss(animated: false, completion: nil)
    }
   
    func addToEvent(profileId: Int64, email: String, phone: String, eventCode: String, token: String) {

        let Invite =  JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])

        let request = PostRequest(path: "/api/event/joinevent", model: Invite, token: token, apiKey: encryptedAPIKey, deviceId: "")


        print("request = \(request)")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success( _):
                self.initializePayment(token: self.token2pass, profileId: profileId, firstName: firstName, lastName: lastName, userName: email, email: email, phone: phone)
                break
            case .failure(let error):
                //print(error.localizedDescription)
                self.theAlertView(alertType: "AddEventError", message: error.localizedDescription)
            }
        }

    }
    
    func getProfileData(profileId1: Int64, token1: String) {
        let request = Request(path: "/api/profile/\(profileId1)", token: token1, apiKey: encryptedAPIKey)
        
        print("getProfileData was called")
        print("request=\(request)")
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
            print("my profile data = \(data1)")
            
            firstName = profileData.firstName
            lastName = profileData.lastName
            
            checkOnboardingStatus()
            
            if self.eventCode != "" {
                self.addToEvent(profileId: profileData.profileId, email: profileData.email, phone: profileData.phone, eventCode: eventCode, token: self.token2pass)
           
               
                //self.getPaymentMethodRecord(profileId: user.profileId!, token: user.token!)
                //capture profile data
            } else  {
                //call payment initialization
                self.initializePayment(token: self.token2pass, profileId: profileData.profileId, firstName: profileData.firstName, lastName: profileData.lastName, userName: profileData.email, email: profileData.email, phone: profileData.phone)
                //call func to get payment record onfile
            }
            break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
            print(" DOMINIC B IGHEDOSA ERROR \(error.localizedDescription)")
            self.theAlertView(alertType: "AddEventError", message: error.localizedDescription)
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
       
        let request = PostRequest(path: "/api/profile/addaccount", model: onboardingProfile, token: token2pass, apiKey: encryptedAPIKey, deviceId: "")
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
                //self.performSegue(withIdentifier: "nextVC", sender: nil)
                //break

            case .failure(let error):
                UserDefaults.standard.set(false, forKey: "isAccountConnected")
                self.theAlertView(alertType: "GenericError", message: error.localizedDescription + " - /api/profile/addaccount ")
                print(" DOMINIC H IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func registerLinkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "RegistrationViewController", sender: self)
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountQRScanViewController") as! CreateAccountQRScanViewController

        print("MY 1 EVENT CODE \(eventCode)")
        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventTypeIcon = eventTypeIcon
        nextVC.eventCode = eventCode
        nextVC.eventType = eventType
        nextVC.action = "createAccountQRScan"
        nextVC.encryptedAPIKey = encryptedAPIKey
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
//    let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountQRScanViewController") as! CreateAccountQRScanViewController
//
//    nextVC.eventName = eventName
//    nextVC.eventDateTime = eventDateTime
//    nextVC.eventTypeIcon = eventTypeIcon
//    nextVC.eventCode = eventCode
//    nextVC.eventType = eventType
//    self.navigationController?.pushViewController(nextVC , animated: true)
//
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
        //**************** good code hold ***********************
//          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//             if(segue.identifier == "nextVC"){
//                 let displayVC = segue.destination as! HomeScreenViewController
//                displayVC.firstName = "Dominic"
//                displayVC.token = token2pass
//                displayVC.userdata = userdata
//            }
    
    func getPaymentMethodRecord(profileId: Int64, token: String) {
        let request = Request(path: "/api/PaymentMethod/all/\(profileId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
        switch result {
            case .success(let paymentmethod1):
                       //self.parse(json: event)
                let decoder = JSONDecoder()
                do {
                    let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                        
                    //check if user has paymentmethod onfile - at least 1
                    print("paymentJson.count = \(paymentJson.count)")
                    if paymentJson.count > 0 {
                        UserDefaults.standard.set(true, forKey: "isPaymentMethodAvailable")
                    } else {
                        UserDefaults.standard.set(false, forKey: "isPaymentMethodAvailable")
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }
    
    
    /*may need to move this to initialization - app start once we figure it out
    1/25/2020 */
    func cleanUserDefaults() {
        // Remove Key-Value Pair
        UserDefaults.standard.removeObject(forKey: "isPaymentMethodAvailable")
    }
    //**************** good code hold ***********************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //closing loading
        self.dismiss(animated: false, completion: nil)
               
        if(segue.identifier == "nextVC"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass
            NextVC.encryptedAPIKey = encryptedAPIKey
            NextVC.paymentClientToken = paymentClientToken
            NextVC.eventId = eventId
            NextVC.eventType = eventType
            NextVC.eventTypeIcon = eventTypeIcon
            NextVC.myProfileData = myprofiledata
            
        } else if(segue.identifier == "goToReg") {
            let NextVC = segue.destination as! RegistrationViewController
            NextVC.message  = ""
            NextVC.encryptedAPIKey = encryptedAPIKey
        } else if(segue.identifier == "goToLoginWithCode") {
            let NextVC = segue.destination as! JoinWithEventCodeViewController
            NextVC.encryptedAPIKey = encryptedAPIKey
        }
    }
    
    
   
}
