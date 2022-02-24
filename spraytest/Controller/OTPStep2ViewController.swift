//
//  OTPStep2ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/1/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//


import UIKit
import LocalAuthentication
import SwiftKeychainWrapper
class OTPStep2ViewController: UIViewController {
    
    @IBOutlet weak var verifyBtn: MyCustomButton!
    var otpCode: String = ""
    var otpPhone: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var username: String = ""
    var password: String = ""
    var confirmPassword: String?
    var email: String = ""
    var phone: String = ""
    var userdata: UserData?
    var profiledata: ProfileData2?
    
    var token2pass: String?
    var profileId: String?
    var eventCode: String = ""

    var message: String?
    var paymentClientToken: String = ""
    
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventTypeIcon: String = ""
    var eventType: String =  ""
    var action: String = ""
    var encryptedAPIKey: String = ""
    var encryptedDeviceId: String = ""
    let device = Device()
    let encryptdecrypt = EncryptDecrpyt()
    var setstatusbarbgcolor = StatusBarBackgroundColor()
    var encryptedAPIKeyUserName: String = ""
    //var flowType: String =  ""
    var isBiometricEnabled: Bool = false
    var isKeyChainInUse: Bool = false
    var regPassword: String = ""
    var myprofiledata: [MyProfile] = []
    
    @IBOutlet weak var otpTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var verificationLbl: UILabel!
    //@IBOutlet weak var otpTextField1: OneTimeCodeTextField!
//    @IBOutlet weak var otpTextField2: UITextField!
//    @IBOutlet weak var otpTextField3: UITextField!
//    @IBOutlet weak var otpTextField4: UITextField!
//    @IBOutlet weak var otpTextField5: UITextField!
//
    //@IBOutlet weak var otpTextField6: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verificationLbl.text = "We have sent a text to phone number ***-***-1234. Please enter the 6-digit verification and continue."
        
        print("BIG D \(firstName) \(lastName) \(username) \(password)")
        //encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
        //encryptedDeviceId = device.getDeviceId(userName: "")
        
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt") //encryptData(value: apiKeyValue)
        
        verifyBtn.isEnabled = false
        otpTextField.configure()
        
        otpTextField.didEnterLastDigit = { [weak self] code in
            print("printed the OTP code \(code)")
            
            print("counter =\(self?.otpCode.count)")
            if code.count == 6 {
                self?.otpCode = code
                self?.verifyBtn.isEnabled = true
            } else {
                self?.verifyBtn.isEnabled = false
            }
//            guard let alert = self?.alert.successMessage(with: code) else { return}
//            self?.present(alert, animated: true)
        }
        
        setstatusbarbgcolor.setBackground()
       
        setNavigationBar()
        
       // self.otpTextField1.delegate = self
//        self.otpTextField2.delegate = self
//        self.otpTextField3.delegate = self
//        self.otpTextField4.delegate = self
//        self.otpTextField5.delegate = self
//        self.otpTextField6.delegate = self
//
//        self.otpTextField1.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
//        self.otpTextField2.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
//        self.otpTextField3.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
//        self.otpTextField4.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
//        self.otpTextField5.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
//
//        self.otpTextField6.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
//
//        otpTextField1.becomeFirstResponder()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
//        
        print("OTP = \(otpCode)")
        print("otp phone = \(otpPhone)")
        // Do any additional setup after loading the view.
    }
    

//    @objc func keyboardWillShow(sender: NSNotification) {
//         self.view.frame.origin.y = -150 // Move view 150 points upward
//    }
//
//    @objc func keyboardWillHide(sender: NSNotification) {
//         self.view.frame.origin.y = 0 // Move view to original position
//    }
//
    /*turn status bar to white color*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setNavigationBar() {
        print("I was called")

        
        print("I was called")
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Verification")

        
        var titleStep: String = ""
        if action == "forgotPassword" {
            titleStep = "Step 2 of 3"
        } else {
            titleStep = "Step 2 of 2"
        }
        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
        //let doneItem2 = UIBarButtonItem(barButtonSystemItem: , style: .plain, target: nil, action: #selector(done))
        let doneItem = UIBarButtonItem(image: UIImage(systemName: "xmark") , style: .plain, target: nil, action: #selector(done))
       // let doneItem2 = UIBarButtonItem(systemItem: .close, primaryAction: closeAction, menu: nil)
        //navItem.rightBarButtonItem  = doneItem2
        
        let rbar = UIBarButtonItem(title: titleStep, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        rbar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        

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
//    @objc func changeCharacter(textField: UITextField) {
//        if textField.text?.utf8.count == 1 {
//            switch textField {
//            case otpTextField1:
//                otpTextField2.becomeFirstResponder()
//            case otpTextField2:
//                otpTextField3.becomeFirstResponder()
//            case otpTextField3:
//                otpTextField4.becomeFirstResponder()
//            case otpTextField4:
//                otpTextField5.becomeFirstResponder()
//            case otpTextField5:
//                otpTextField6.becomeFirstResponder()
//            case otpTextField6:
//                //otpTextField2.becomeFirstResponder()
//                print("print value")
//            default:
//                break
//            }
//        } else {
//            switch textField {
//            case otpTextField6:
//                otpTextField5.becomeFirstResponder()
//            case otpTextField5:
//                otpTextField4.becomeFirstResponder()
//            case otpTextField4:
//                otpTextField3.becomeFirstResponder()
//            case otpTextField3:
//                otpTextField2.becomeFirstResponder()
//            case otpTextField2:
//                otpTextField1.becomeFirstResponder()
//
//                //otpTextField2.becomeFirstResponder()
//                print("print value")
//            default:
//                break
//            }
//        }
//    }

    /*requestOTP code2 is bypass for OTP during testing 9/29/2021*/
    func requestOTPCode2() {
        //launchOTPVerifyVC(phone: phone)
        if action == "forgetpassword" {
            
        } else {
            print("Master String = \(firstName) \(lastName) \(username) \(password) \(email)\(otpPhone)")
            
            //registerUser ()
            
            launchNextVC()
            
        }
       
    }
    func requestOTPCode() {
        print("get OTCode was called")
        //let phone = phoneNumberTextField.text!
        //launchOTPVerifyVC(otpCode: otpCode, phone: phone)
        
        //let phone = convertPhoneToString(phone: phoneNumberTextField.text!)
        
        let otpModel = OTPModel(phone: phone, email: "", code: "", message: "", profileId: 0)
        let request = PostRequest(path: "/api/otpverify/add", model: otpModel, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

        print("request \(request)")
        Network.shared.send(request) { [self] (result: Result<OTPData, Error>)  in
        switch result {
        case .success(let otpdata):
            if otpdata.success == true {
                //launchOTPVerifyVC(phone: phone)
                if action == "forgotpassword" {
                    //call screen to change password
                } else {
                    //call register user
                }
//                if self.presentedViewController == nil {
//                   // do your presentation of the UIAlertController
//                   // ...
//                } else {
//                   // either the Alert is already presented, or any other view controller
//                   // is active (e.g. a PopOver)
//                   // ...
//
//                   let thePresentedVC : UIViewController? = self.presentedViewController as UIViewController?
//
//                   if thePresentedVC != nil {
//                      if let thePresentedVCAsAlertController : UIAlertController = thePresentedVC as? UIAlertController {
//                         // nothing to do , AlertController already active
//                         // ...
//                        LoadingStop()
//                        launchOTPVerifyVC(phone: phone)
//                         print("Alert not necessary, already on the screen !")
//
//                      } else {
//                         // there is another ViewController presented
//                         // but it is not an UIAlertController, so do
//                         // your UIAlertController-Presentation with
//                         // this (presented) ViewController
//                         // ...
//                         //thePresentedVC!.presentViewController(...)
//
//                         print("Alert comes up via another presented VC, e.g. a PopOver")
//                      }
//                  }
//                }
                
                
            } else  {
                //LoadingStop()
                theAlertView(alertType: "otpcode", message: "")
            }
            print("success")
        case .failure(let error):
            //LoadingStop()
            theAlertView(alertType: "otpcode", message: error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func verifyOTP(_ sender: Any) {
        //LoadingStart()
        print("otp button \(otpCode)")
        if action == "forgotPassword" {
            launchNextVC()
        } else {
            //launchNextVC()
            requestOTPCode2() //change this to requestOTPCode() in the future 10/11
            //verifyOTPCode(otpcode: otpCode)
            
            /*   7/30/2021 - going to diable this for now while testing - will enable before publishing to store
            let otpModel = OTPModel(phone: otpPhone, email: "", code: otpCode, message: "", profileId: 0)
            let request = PostRequest(path: "/api/otpverify/check", model: otpModel, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

            print("request \(request)")
            Network.shared.send(request) { [self] (result: Result<OTPData, Error>)  in
            switch result {
            case .success(let otpdata):
                if otpdata.success == true {
                    //LoadingStop()
                    launchNextVC()
                    print("success")
                } else  {
                    //LoadingStop()
                    theAlertView(alertType: "otpcode2", message: "")
                    print("failed")
                }
               
            case .failure(let error):
                //LoadingStart()
                theAlertView(alertType: "otpcode", message: error.localizedDescription)
                }
            }*/
        }
       
    }
    func verifyOTPCode(otpcode: Int) {
        print("OTP was verified")
        launchNextVC()
    }
    
    
    @IBAction func resentOTP(_ sender: Any) {
        requestOTPCode2()
    }
    
    func requestOTPCodeOld() {
        print("get OTCode was called")
        //let phone = phoneNumberTextField.text!
        //launchOTPVerifyVC(otpCode: otpCode, phone: phone)
        
        //let phone = convertPhoneToString(phone: phoneNumberTextField.text!)
        
        /*
         7/30/2021 - going to diable this for now while testing - will enable before publishing to store
         let otpModel = OTPModel(phone: otpPhone, email: "", code: "", message: "", profileId: 0)
        let request = PostRequest(path: "/api/otpverify/add", model: otpModel, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

        print("request \(request)")
        Network.shared.send(request) { [self] (result: Result<OTPData, Error>)  in
        switch result {
        case .success(let otpdata):
            if otpdata.success == true {
                //launchOTPVerifyVC(phone: phone)
                theAlertView(alertType: "otpcode3", message: "")
            } else  {
                //LoadingStop()
                theAlertView(alertType: "otpcode", message: "")
            }
            print("success")
        case .failure(let error):
            //LoadingStop()
            theAlertView(alertType: "otpcode", message: error.localizedDescription)
            }
        } */
        
    }
    
    func callNextVCRegistration() {
        if action == "forgotpassword" {
            
        } else  {

            let nextVC = storyboard?.instantiateViewController(withIdentifier: "MenuTabViewController") as! MenuTabViewController
            nextVC.profileId = Int64(profileId!)
            nextVC.token = token2pass
            nextVC.encryptedAPIKey = encryptedAPIKey
            nextVC.myProfileData = myprofiledata
            nextVC.paymentClientToken = paymentClientToken
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func callErrMessage(messageCode: String) {
        if action == "forgotpassword" {
            
        } else  {

            let nextVC = storyboard?.instantiateViewController(withIdentifier: "ErrorMessageViewController") as! ErrorMessageViewController
//            nextVC.profileId = Int64(profileId!)
//            nextVC.token = token2pass
//            nextVC.encryptedAPIKey = encryptedAPIKey
//            nextVC.myProfileData = myprofiledata
//            nextVC.paymentClientToken = paymentClientToken
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    func callNextVCForgotPassword() {
        if action == "forgotpassword" {
            
        } else  {
            
        }
    }
    func registerUser() {
        //default phone number - to be changed later
        phone = ""
        regPassword = KeychainWrapper.standard.string(forKey: "registrationPasswordKeyChain")!
         
        let userData = UserModel(firstName: firstName, lastName: lastName, username: username, password: regPassword, email: email, phone: otpPhone)

        print("my user data = \(userData)")
        let request = PostRequest(path: "/api/profile/register", model: userData, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
        Network.shared.send(request) { [self] (result: Result<ProfileData2, Error>) in
            switch result {
            case .success(let profileData):
                self.profiledata = profileData
                print("REGISTER WAS SUCCESSFUL")
                
                /*if duplicate send a message*/
                if self.profiledata!.isDuplicate  == true {
                    callErrMessage(messageCode: "001") /*001 = duplicate account*/
                } else {
                    CheckIfBiometricEnabled()
                    
                    if isBiometricEnabled  == true {
                        //presentUIAlert(alertMessage: "Would like to enable Face Id or this profile?", alertTitle: "Biometric", errorMessage: "", alertType: "biometric")
                        var biometricType: String = ""
                        
                        //check if phone has touch of face Id
                        let context = LAContext()
                        if ( context.biometryType == .touchID ) {
                             print("touch Id enabled")
                            biometricType = "Touch Id"

                        }
                        if ( context.biometryType == .faceID) {
                            biometricType = "Face ID"
                            print("face Id is enabled")
                        } else {
                            print("stone age")
                        }
                        let password = password // passwordTextField.text
                        
                        let alert = UIAlertController(title: "Biometric Authentication", message: "Would you like to enable \(biometricType) for the Spray App?", preferredStyle: .actionSheet)

                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) in removeCredentialFromKeyChain(userName: self.username, password: password)}))
                        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { [self] (action) in self.authenticateUser(userName: self.username, password: password)}))
                        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                        self.present(alert, animated: true)
                        
                    } else {
                        self.authenticateUser(userName: self.username, password: password)
                    }
                    print("SHINJA = \(userdata)")
                    //call authentication func
                }
                
               
               

            case .failure(let error):
                
                callErrMessage(messageCode: "004")
                
                /* comment this out while i test
                 out handling duplicate account...
                 i will return 1/17/2022
                self.presentUIAlert(alertMessage: "", alertTitle: "", errorMessage: error.localizedDescription, alertType: "systemError")
                self.loadingIndicatorAction(actionType: "error") */
            }
        }
    }
    
    func storeCredentialInKeyChain(userName: String, password: String) {
        print("storeCredentialInKeyChain was called")
        KeychainWrapper.standard.set(userName, forKey: "usernameKeyChain")
        KeychainWrapper.standard.set(password, forKey: "passwordKeyChain")
        KeychainWrapper.standard.set(true, forKey: "isKeyChainInUse")
        //(true, forKey: "isKeyChainInUse")
        processEnableBiometric(userName: userName, password: password)
    }
    func removeCredentialFromKeyChain(userName: String, password: String){
        print("removeCredentialFromKeyChainwas called")
        KeychainWrapper.standard.removeObject(forKey: "usernameKeyChain")
        KeychainWrapper.standard.removeObject(forKey: "passwordKeyChain")
        KeychainWrapper.standard.removeObject(forKey: "isKeyChainInUse")
        
       
        let isEnableBiometricNextLoginExist = isKeyPresentInUserDefaults(key: "isEnablebiometricNextLogin")
        if isEnableBiometricNextLoginExist == true {
            KeychainWrapper.standard.removeObject(forKey: "isEnablebiometricNextLogin")
        }
    
        
        isKeyChainInUse = false
        storeCredentialInKeyChain(userName: userName, password: password)
    }
    func  isKeyPresentInUserDefaults(key: String) -> Bool {
        guard let _ = KeychainWrapper.standard.object(forKey: key) else {
         return false;
        }

       return true;
    }
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
    func processEnableBiometric(userName: String, password: String) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, authenticationError in
                DispatchQueue.main.async { [self] in
                    if success {
                        self?.authenticateUser(userName: userName, password: password)
                        print("i called authenticationUser")
                        print("II--")
                        //self?.loginButton.loadIndicator(true)
//                        self?.loginButton.loadIndicator(true)
//                        self?.loginButton.setTitle("Securely Logging In...", for: .normal)
//                        self?.loginButton.isEnabled = false
//
//                        self?.authenticateUser()
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
    func authenticateUser(userName:String,password: String) {
        print("Inside authenticate = \(username)")
        print("Inside authenticate = \(password)")
      
        print("regPassword =\(regPassword)")
        //******************** After creating account; authenticating to get Token *****************************
        let authenticatedUserProfile = AuthenticateUser(username: userName, password: regPassword)
        print("authenticatedUserProfile \(authenticatedUserProfile)")
        let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

        Network.shared.send(request) { [self] (result: Result<UserData, Error>)  in
            switch result {
            case .success(let user):
                
                if let usertoken = user.token {
                    self.token2pass = usertoken
                } else {
                    print("we have a problem")
                }
                //self.token2pass = token3
                self.userdata = user
                self.profileId = String(user.profileId!)
                
                var encryptdecrypt = EncryptDecrpyt()
                encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: userName, action: "encrypt")
                encryptedAPIKey = encryptedAPIKeyUserName
                
                print(" this is dominic \(user)")
                
                //capture profile data
                self.getProfileData(profileId1: user.profileId!, token1: user.token!)
                
                /*remove password from reg*/
                KeychainWrapper.standard.removeObject(forKey: "registrationPasswordKeyChain")
                
               

                
                //add user to event
//                if self.eventCode != "" {
//                    self.addToEvent(profileId: user.profileId!, email: self.email, phone: "", eventCode: eventCode, token: self.token2pass!)
//                }

                //self.labelMessage.text = "Got an empty, successful result"

            case .failure(let error):
                self.presentUIAlert(alertMessage: "", alertTitle: "", errorMessage: error.localizedDescription, alertType: "systemError")
                
                /* not needed self.loadingIndicatorAction(actionType: "error") */
            }
        }
    }
    
    func addToEvent(profileId: Int64, email: String, phone: String, eventCode: String, token: String) {

        let Invite =  JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])

        let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token, apiKey: encryptedAPIKey, deviceId: "")


        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let addtoEvent):
                //if self.eventCode != "" {
                    self.initializePayment(token: self.token2pass!, profileId: profileId, firstName: firstName, lastName: lastName, userName: email, email: email, phone: phone)
                    //self.performSegue(withIdentifier: "Reg2MenuTab", sender: nil)
                //}
                //break
            case .failure(let error):
                //print(error.localizedDescription)
                self.theAlertView(alertType: "AddEventError", message: error.localizedDescription)
            }
        }

    }
    
    func presentUIAlert(alertMessage: String, alertTitle: String, errorMessage: String, alertType: String) {
        
        if alertType == "systemError" {
            let alert2 = UIAlertController(title: "Feature is unavailable", message: "This feature is temporarily unavailble. Please contact The Spray App at 1-800-000-0000 for assistance.\n \(errorMessage)", preferredStyle: .alert)

            alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert2, animated: true)
           
        } else if alertType == "formvalidation" {
            let alert2 = UIAlertController(title: alertTitle, message: "\(alertMessage) \n \(errorMessage)", preferredStyle: .alert)

            alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert2, animated: true)
       }
            //else if alertType == "biometric" {
//            let alert2 = UIAlertController(title: alertTitle, message: "\(alertMessage) \n \(errorMessage)", preferredStyle: .alert)
//
//            alert2.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) in self.authenticateUser(userName: <#T##String#>, password: <#T##String#>)}))
//            alert2.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
//
////            alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: { [self] (action) in self.launchEventPaymentScreen(eventId2: eventId, eventName2: eventName, eventDateTime2: eventDateTime, completionAction: "gotospray", eventTypeIcon: eventTypeIcon2, isPaymentMethodAvailable: false, hasPaymentMethod: false, isRsvprequired: false, isSingleReceiver: isSingleReceiverEvent!, defaultEventPaymentMethod: generalPaymentMethodId, defaultEventPaymentCustomName: generalDefaultPaymentCustomName)}))
////            alert2.addAction(UIAlertAction(title: "No, Not Yet", style: .cancel, handler: nil))
////
////            self.present(alert2, animated: true)
//
//
//            self.present(alert2, animated: true)
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
    
    func loadingIndicatorAction(actionType: String){
//        if actionType == "displayloadingmsg" {
//            nameTextField.isEnabled = false
//            emailTextField.isEnabled = false
//            passwordTextField.isEnabled = false
//            passwordConfirmTextField.isEnabled = false
//            signInBtn.isEnabled = false
//            termsConditionSwitch.isEnabled  = false
//            signUpBtn.loadIndicator(true)
//            signUpBtn.setTitle("Process...", for: .normal)
//            signUpBtn.isEnabled = false
//            signInBtn.isEnabled = false
//        } else if actionType == "error" {
//            signUpBtn.isEnabled = true
//            signInBtn.isEnabled = true
//            signUpBtn.setTitle("Sign Up", for: .normal)
//            nameTextField.isEnabled = true
//            emailTextField.isEnabled = true
//            passwordTextField.isEnabled = true
//            passwordConfirmTextField.isEnabled = true
//            //self.loginButton.loadIndicator(false)
//            signUpBtn.loadIndicator(false)
//
//        } else if actionType == "done" {
//            signUpBtn.isEnabled = true
//            signInBtn.isEnabled = true
//            signUpBtn.setTitle("Sign Up", for: .normal)
//            nameTextField.isEnabled = true
//            emailTextField.isEnabled = true
//            passwordTextField.isEnabled = true
//            passwordConfirmTextField.isEnabled = true
//            //self.loginButton.loadIndicator(false)
//            signUpBtn.loadIndicator(false)
//        }
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
            
            /*chk if eventcode is available*/
            if self.eventCode != "" {
                self.addToEvent(profileId: profileData.profileId, email: profileData.email, phone:  profileData.phone, eventCode: eventCode, token: self.token2pass!)
            } else  {
                self.initializePayment(token: self.token2pass!, profileId: profileData.profileId, firstName: profileData.firstName, lastName: profileData.lastName, userName: profileData.email, email: profileData.email, phone: profileData.phone)
                //self.loadingIndicatorAction(actionType: "done")
                //self.performSegue(withIdentifier: "Reg2MenuTab", sender: nil)
            }
            
            //self.initializePayment(token: self.token2pass!, profileId: profileData.profileId, firstName: profileData.firstName, lastName: profileData.lastName, userName: profileData.email, email: profileData.email, phone: profileData.phone)
            
            print("my profile data = \(data1)")
            break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
        print(" DOMINIC B IGHEDOSA ERROR \(error.localizedDescription)")
                    
            }
                  
        }
    }
    
    //Initialize payment
    func initializePayment(token: String, profileId: Int64, firstName: String, lastName: String, userName: String, email: String, phone: String) {
        let initPayment = InitializePaymentModel(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone)
        print("InitializePaymentModel \(initPayment)")
         let request = PostRequest(path: "/api/profile/initialize", model: initPayment, token: token, apiKey: encryptedAPIKey, deviceId: "")
         
        
        
          Network.shared.send(request) { (result: Result<InitializePaymentData, Error>)  in
             switch result {
             case .success(let paymentInit):
                self.paymentClientToken = paymentInit.clientToken!
                
                print("paymentClientToken = \(self.paymentClientToken)")
                self.loadingIndicatorAction(actionType: "done")
                //self.performSegue(withIdentifier: "Reg2MenuTab", sender: nil)
                
                 //self.launchOTPVerifyVC(phone: phone)
                 self.callNextVCRegistration()
             case .failure(let error):
                 //self.labelMessage.text = error.localizedDescription
                self.theAlertView(alertType: "InitializeError", message: error.localizedDescription)
             }
             
            
         }
        
        //closing loading
        self.dismiss(animated: false, completion: nil)
    }
    
    

    func theAlertView(alertType: String, message: String){
        var alertTitle: String = ""
        var alertMessage: String = ""
        if alertType == "otpcode" {
            alertTitle = "OTP"
            alertMessage = "Something went wrong with the OTP Code. Please try again."
        } else if alertType == "otpcode2" {
            alertTitle = "OTP"
            alertMessage = "The code you entered is not valid or has expired."
        } else if alertType == "otpcode3" {
            alertTitle = "OTP"
            alertMessage = "Code has been sent."

        } else if alertType == "MissingFields" {
            alertTitle = "Login Error"
            alertMessage = "You entered an invalid login ID or Password. \n"
        } else if alertType == "InitializeError" {
            alertTitle = "Login Error"
            alertMessage = "Something went wrong with the initialization. Please try again. \n"
        }
        //self.dismiss(animated: true, completion: nil)
//        self.loginButton.isEnabled = true
//        self.loginButton.setTitle("Sign In", for: .normal)
//        self.usernameTextField.isEnabled = true
//        self.passwordTextField.isEnabled = true
//        //self.loginButton.loadIndicator(false)
//        self.loginButton.loadIndicator(false)
        
        let alert2 = UIAlertController(title: alertTitle, message: "\(alertMessage) \n \(message)", preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert2, animated: true)
    }
       
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func launchNextVC() {
        
//        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep1ViewController") as! OTPStep1ViewController
//
//        nextVC.eventName = eventName
//        nextVC.eventDateTime = eventDateTime
//        nextVC.eventTypeIcon = eventTypeIcon
//        nextVC.eventCode = eventCode
//        nextVC.eventType = eventType
//        nextVC.action = "createAccount"
//        self.navigationController?.pushViewController(nextVC , animated: true)
        
        if action == "createAccountQRScan" ||  action == "createAccount"{
            
            registerUser()
//            print("launchCreateAccountVC was called")
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountQRScanViewController") as! CreateAccountQRScanViewController
//            nextVC.eventName = eventName
//            nextVC.eventDateTime = eventDateTime
//            nextVC.eventTypeIcon = eventTypeIcon
//            nextVC.eventCode = eventCode
//            nextVC.eventType = eventType
//            nextVC.otpCode = otpCode
//            nextVC.email = email
//            nextVC.encryptedAPIKey = encryptedAPIKey
//            nextVC.encryptedDeviceId = encryptedDeviceId
//            self.navigationController?.pushViewController(nextVC, animated: true)
        //} else if action == "createAccount" {
            
          //  registerUser()
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
//            print("phoneFromOTP from CreateAccountViewController = \(otpPhone)")
//            nextVC.phoneFromOTP = otpPhone
//            nextVC.otpCode = otpCode
//            nextVC.email = email
//            nextVC.encryptedAPIKey = encryptedAPIKey
//            nextVC.encryptedDeviceId = encryptedDeviceId
//            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if action == "forgotPassword" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
            nextVC.phoneFromOTP = otpPhone
            nextVC.action = action
            nextVC.otpCode = otpCode
            nextVC.email = email
            nextVC.encryptedAPIKey = encryptedAPIKey
            nextVC.encryptedDeviceId = encryptedDeviceId
            self.navigationController?.pushViewController(nextVC , animated: true)
        }
        
        print("no value for action")
    }
    
    
    
}
//
//extension OTPStep2ViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.text!.utf16.count == 1 && !string.isEmpty {
//            return false
//        } else {
//            return true
//        }
//    }
//}
extension OTPStep2ViewController {
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
