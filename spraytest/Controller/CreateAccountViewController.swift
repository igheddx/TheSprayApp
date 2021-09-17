//
//  CreateAccountViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/6/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import LocalAuthentication
import SwiftKeychainWrapper
class CreateAccountViewController: UIViewController, UINavigationBarDelegate, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var signUpBtn: MyCustomButton!
    @IBOutlet weak var signInBtn: NoNActiveActionButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var termsConditionSwitch: Switch1!
    //declare register form variables
    var firstName: String?
    var lastName: String?
    var username: String?
    var password: String?
    var confirmPassword: String?
    var email: String = ""
    var phone: String?
    var phoneFromOTP: String = ""
    var otpCode: String =  ""
    var userdata: UserData?
    var token2pass: String?
    var profileId: String?
    var eventCode: String?
    var message: String?
    var paymentClientToken: String = ""
    //instanciate the network object
   //let registrationManager = NetworkManager2()

    var formValidation =   Validation()
    let customtextfield = CustomTextField()
    var myprofiledata: [MyProfile] = []
    var encryptedAPIKey: String = ""
    var encryptedDeviceId: String = ""
    let device = Device()
    var encryptdecrypt = EncryptDecrpyt()
    var encryptedAPIKeyUserName: String = ""
    //let decrypt = EncryptDecrpyt()
    
    var isBiometricEnabled: Bool = false
    var isKeyChainInUse: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt") //encryptData(value: apiKeyValue)
        
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        
        //toggleTorch(on: true)
        //navigationItem.hidesBackButton = false
        //navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        
        initializationTasks()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    @IBAction func termConditionBtnPressed(_ sender: Any) {
    }
    func initializationTasks() {
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
        emailTextField.text = email
        
        termsConditionSwitch.isOn = false
        
        nameTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                 for: .editingChanged)

        passwordTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                    for: .editingChanged)
        passwordConfirmTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                           for: .editingChanged)
        
        customtextfield.borderForTextField(textField: nameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)
    }
    
    func setNavigationBar() {
        print("I was called")
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Registration")
        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
        let doneItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(done))
           navItem.leftBarButtonItem = doneItem
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
            case nameTextField:
                nameTextField.resignFirstResponder()
            case emailTextField:
                emailTextField.resignFirstResponder()
            case passwordTextField:
                passwordTextField.resignFirstResponder()
            case passwordConfirmTextField:   //passwordConfirmLabel.isHidden = false
                passwordConfirmTextField.resignFirstResponder()
            default:
                break
        }
        return true
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==1{
                switch textField{
                case nameTextField:
                    //firstNameLabel.isHidden = false
                    //firstNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: nameTextField, validationFlag: false)
                    //firstNameErrorLabel.text = ""
//                    tf2.becomeFirstResponder()
//                case lastNameTextField:
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
                case passwordTextField:
                    //passwordLabel.isHidden = false
                    //passwordLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
                    //passwordErrorLabel.text = ""
                case passwordConfirmTextField:   //passwordConfirmLabel.isHidden = false
                    //passwordConfirmLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)
                   // passwordConfirmErrorLabel.text = ""
                default:
                    break
                }
            }else{

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
        if actionType == "displayloadingmsg" {
            nameTextField.isEnabled = false
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            passwordConfirmTextField.isEnabled = false
            signInBtn.isEnabled = false
            termsConditionSwitch.isEnabled  = false
            signUpBtn.loadIndicator(true)
            signUpBtn.setTitle("Process...", for: .normal)
            signUpBtn.isEnabled = false
            signInBtn.isEnabled = false
        } else if actionType == "error" {
            signUpBtn.isEnabled = true
            signInBtn.isEnabled = true
            signUpBtn.setTitle("Sign Up", for: .normal)
            nameTextField.isEnabled = true
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            passwordConfirmTextField.isEnabled = true
            //self.loginButton.loadIndicator(false)
            signUpBtn.loadIndicator(false)
    
        } else if actionType == "done" {
            signUpBtn.isEnabled = true
            signInBtn.isEnabled = true
            signUpBtn.setTitle("Sign Up", for: .normal)
            nameTextField.isEnabled = true
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            passwordConfirmTextField.isEnabled = true
            //self.loginButton.loadIndicator(false)
            signUpBtn.loadIndicator(false)
        }
    }
    @IBAction func signInBtnPressed(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.navigationController?.pushViewController(nextVC, animated: true)
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
        self.signUpBtn.isEnabled = true
        self.signUpBtn.setTitle("Sign Up", for: .normal)
        //self.usernameTextField.isEnabled = true
        self.nameTextField.isEnabled = true
        self.emailTextField.isEnabled = true
        self.passwordTextField.isEnabled = true
        self.passwordConfirmTextField.isEnabled = true
        self.termsConditionSwitch.isEnabled = true
        //self.loginButton.loadIndicator(false)
        self.signUpBtn.loadIndicator(false)
        
        let alert2 = UIAlertController(title: alertTitle, message: "\(alertMessage) \n \(message)", preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
     
        self.present(alert2, animated: true)
    
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        guard let name = nameTextField.text,
        let password = passwordTextField.text,
        let confirmPassword = passwordConfirmTextField.text,
        let email = emailTextField.text else {
            return
        }
        //eventCode = eventCodeTextField.text!
        username = emailTextField.text!

        let isValidateName = self.formValidation.validateName2(name2: name).isValidate

        if (isValidateName == false) {
            nameTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: nameTextField, validationFlag: true)
            //print("Incorrect First Name")
            //call UI Alert
            nameTextField.isEnabled = true
            presentUIAlert(alertMessage: "Incorrect Name", alertTitle: "Missing Information", errorMessage: "", alertType: "formvalidation")
            return
        } else {
            customtextfield.borderForTextField(textField: nameTextField, validationFlag: false)
        }

       
        let isValidateEmail = self.formValidation.validateEmailId(emailID: email)
        if (isValidateEmail == false) {
            emailTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  emailTextField, validationFlag: true)
            //print("Incorrect Email")
            emailTextField.isEnabled = true
            presentUIAlert(alertMessage: "Email Is Incorrect", alertTitle: "Missing Information", errorMessage: "", alertType: "formvalidation")
            
         return
        }else {
            customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
            //emailErrorLabel.text = ""
            encryptedDeviceId = device.getDeviceId(userName: self.username!)
          
            print("I CALLED DEVICE")
            device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
            
        }

        let isValidatePass = self.formValidation.validatePassword(password: password)
        if (isValidatePass == false) {
            passwordTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  passwordTextField, validationFlag: true)
            //print("Incorrect Password")
            passwordTextField.isEnabled = true
            presentUIAlert(alertMessage: "Incorrect Password", alertTitle: "Missing Information", errorMessage: "", alertType: "formvalidation")
            return
        } else {
            customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
           // passwordErrorLabel.text = ""
        }

        var passwordMatch: Bool = false
        if password != confirmPassword {
        
            passwordMatch = false
            passwordConfirmTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  passwordConfirmTextField, validationFlag: true)
            passwordConfirmTextField.isEnabled = true
            presentUIAlert(alertMessage: "The password you entered does not match", alertTitle: "Missing Information", errorMessage: "", alertType: "formvalidation")
        } else {
            passwordMatch = true
        }
        
        var termsCondition: Bool = false
        if termsConditionSwitch.isOn == false {
            termsConditionSwitch.isEnabled = true
            presentUIAlert(alertMessage: "Please review and agree to our Terms of Service and Privacy Policy", alertTitle: "Missing Information", errorMessage: "", alertType: "formvalidation")
            termsCondition  = false
        } else {
            termsCondition  = true
        }
        if (isValidateName == true && isValidateEmail == true && isValidatePass == true && passwordMatch == true && termsCondition == true) {
                 print("All fields are correct")
            
            
            //eventCode = eventCodeTextField.text!
            self.loadingIndicatorAction(actionType: "displayloadingmsg")
            
            //estract first/lastname from name feidl
            let str = name
            let trimmedStr = str.trimmingCharacters(in: .whitespacesAndNewlines)
            var firstname: String = ""
            var lastname: String = ""
            let nameComponents = trimmedStr.components(separatedBy: " ")
            if nameComponents.count > 1 {
                if nameComponents.count == 2 {
                    firstname = nameComponents[0]
                    lastname = nameComponents[1]
                } else {
                    firstname = nameComponents[0] + " " + nameComponents[1]
                    lastname = nameComponents[2]
                }
            }
            
            //default phone number - to be changed later
            phone = ""
            
            let userData = UserModel(firstName: firstname, lastName: lastname, username: username!, password: password, email: email, phone: phoneFromOTP)

            print(userData)
            let request = PostRequest(path: "/api/profile/register", model: userData, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
            Network.shared.send(request) { [self] (result: Result<UserData, Error>) in
                switch result {
                case .success(let userdata):
                    self.userdata = userdata
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
                        let password = passwordTextField.text
                        
                        let alert = UIAlertController(title: "Biometric Authentication", message: "Would you like to enable \(biometricType) for the Spray App?", preferredStyle: .actionSheet)

                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) in removeCredentialFromKeyChain(userName: self.username!, password: password!)}))
                        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { [self] (action) in self.authenticateUser(userName: self.username!, password: password!)}))
                        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                        self.present(alert, animated: true)
                        
                    } else {
                        self.authenticateUser(userName: self.username!, password: password)
                    }
                    print(userdata)
                    //call authentication func
                   

                case .failure(let error):
                    self.presentUIAlert(alertMessage: "", alertTitle: "", errorMessage: error.localizedDescription, alertType: "systemError")
                    self.loadingIndicatorAction(actionType: "error")
                }
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
        //******************** After creating account; authenticating to get Token *****************************
        let authenticatedUserProfile = AuthenticateUser(username: userName, password: password)
        let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

        Network.shared.send(request) { [self] (result: Result<UserData, Error>)  in
            switch result {
            case .success(let user):
                self.token2pass = user.token!
                self.userdata = user
                self.profileId = String(user.profileId!)
                
                var encryptdecrypt = EncryptDecrpyt()
                encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: userName, action: "encrypt")
                encryptedAPIKey = encryptedAPIKeyUserName
                
                print(" this is dominic \(user)")
                
                //capture profile data
                self.getProfileData(profileId1: user.profileId!, token1: user.token!)
                
                //add user to event
//                if self.eventCode != "" {
//                    self.addToEvent(profileId: user.profileId!, email: self.email, phone: "", eventCode: eventCode, token: self.token2pass!)
//                }

                //self.labelMessage.text = "Got an empty, successful result"

            case .failure(let error):
                self.presentUIAlert(alertMessage: "", alertTitle: "", errorMessage: error.localizedDescription, alertType: "systemError")
                self.loadingIndicatorAction(actionType: "error")
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
            
            self.initializePayment(token: self.token2pass!, profileId: profileData.profileId, firstName: profileData.firstName, lastName: profileData.lastName, userName: profileData.email, email: profileData.email, phone: profileData.phone)
            
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
                self.performSegue(withIdentifier: "Reg2MenuTab", sender: nil)
                
                
             case .failure(let error):
                 //self.labelMessage.text = error.localizedDescription
                self.theAlertView(alertType: "InitializeError", message: error.localizedDescription)
             }
             
            
         }
        
        //closing loading
        self.dismiss(animated: false, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Reg2MenuTab"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass
            NextVC.encryptedAPIKey = encryptedAPIKey
            NextVC.myProfileData = myprofiledata
            NextVC.paymentClientToken = paymentClientToken
            
            //                          displayVC.token = token2pass
            //                          displayVC.userdata = userdata
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
    

}
