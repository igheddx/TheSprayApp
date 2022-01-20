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
    
    @IBOutlet weak var phoneNumberTextField: CustomTextField2!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var termsConditionSwitch: Switch1!
    
    @IBOutlet weak var termsConditionLbl: UILabel!
    
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
    var eventCode: String = ""
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
    var setstatusbarbgcolor = StatusBarBackgroundColor()
    var encryptedAPIKeyUserName: String = ""
    //let decrypt = EncryptDecrpyt()
    
    var isBiometricEnabled: Bool = false
    var isKeyChainInUse: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        setNavigationBar()
    
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Step 1 of 3", style: .plain, target: nil, action: nil)
        
       
        
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt") //encryptData(value: apiKeyValue)
        
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        
        print("phone number = \(phone)")
        print("phone number from OTP \(phoneFromOTP)")
        //toggleTorch(on: true)
        //navigationItem.hidesBackButton = false
        //navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        
        
        
        
        initializationTasks()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        setstatusbarbgcolor.setBackground()
       
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    @IBAction func termConditionBtnPressed(_ sender: Any) {
    }
    func initializationTasks() {
        phoneNumberTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
        emailTextField.text = email
        
        termsConditionSwitch.isOn = false
        
        nameTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                 for: .editingChanged)

        passwordTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                    for: .editingChanged)
        passwordConfirmTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                           for: .editingChanged)
        
        phoneNumberTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        customtextfield.borderForTextField(textField: phoneNumberTextField, validationFlag: false)
        
        customtextfield.borderForTextField(textField: nameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)
    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        let text = textField.text
//
//
//    }
    
    func convertPhoneToString(phone: String) -> String {
        let phonestr1 = phone.replacingOccurrences(of: "[\\(\\)^^+-]", with: "", options: .regularExpression, range: nil)
        let phonestr2 = "+1\(phonestr1.replacingOccurrences(of: " ", with: ""))"
        return phonestr2
    }
    
    
    func setNavigationBar() {
        print("I was called")
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Registration")
        //let navItem2 = UINavigationItem(title: "Step 1 of 3")
        
       
        //let item =  UIBarButtonItem(customView: customView)
//        rbar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        //navigationItem.rightBarButtonItems = [rbar]
        
        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
        //let doneItem2 = UIBarButtonItem(barButtonSystemItem: , style: .plain, target: nil, action: #selector(done))
        let doneItem = UIBarButtonItem(image: UIImage(systemName: "xmark") , style: .plain, target: nil, action: #selector(done))
       // let doneItem2 = UIBarButtonItem(systemItem: .close, primaryAction: closeAction, menu: nil)
        //navItem.rightBarButtonItem  = doneItem2
        
        let rbar = UIBarButtonItem(title: "Step 1 of 2", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        rbar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        
        //navItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        
        navItem.leftBarButtonItem = doneItem
    
        navItem.rightBarButtonItem  = rbar
           navBar.setItems([navItem], animated: false)
           self.view.addSubview(navBar)
    }
    
//    let closeAction = UIAction(handler: { [weak self] _ in
//               //perform action here
//            })
    
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
            case phoneNumberTextField:
                phoneNumberTextField.resignFirstResponder()
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
                 
                case phoneNumberTextField:
                    customtextfield.borderForTextField(textField: phoneNumberTextField, validationFlag: false)
                  
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
            phoneNumberTextField.isEnabled = false
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
            phoneNumberTextField.isEnabled = true
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
            phoneNumberTextField.isEnabled = true
            passwordTextField.isEnabled = true
            passwordConfirmTextField.isEnabled = true
            //self.loginButton.loadIndicator(false)
            signUpBtn.loadIndicator(false)
        }
    }
    @IBAction func signInBtnPressed(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        
        callLoginScreen()
//        let nextVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    func callLoginScreen() {
        self.navigationController!.viewControllers.removeAll()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        let window = UIApplication.shared.windows.first

        loginVC?.logout = true
        
        // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
        let nav = UINavigationController(rootViewController: loginVC!)
        window?.rootViewController = nav
        
       self.navigationController?.popToRootViewController(animated: true)

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
        self.phoneNumberTextField.isEnabled = true
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
        let phone2 = phoneNumberTextField.text,
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
            print("USER NAME FOR DEVICE = \(self.username!)")
            encryptedDeviceId = device.getDeviceId(userName: self.username!)
          
            print("I CALLED DEVICE")
            device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
            
        }

        let isValidatePhone = self.formValidation.validatePhoneNumber(phoneNumber: phone2).isValidate
        let validationMessage = self.formValidation.validatePhoneNumber(phoneNumber: phone2).errorMsg
        
        print("isValidatePhone \(isValidatePhone)")
        if (isValidatePhone == false) {
            //LoadingStop()
            phoneNumberTextField.becomeFirstResponder()
            phoneNumberTextField.isEnabled = true
            customtextfield.borderForTextField(textField:  phoneNumberTextField, validationFlag: true)
            
            self.presentUIAlert(alertMessage: "Incorrect Phone Number", alertTitle: "Missing Information", errorMessage: validationMessage, alertType: "formvalidation")
            return
        } else {
            customtextfield.borderForTextField(textField: phoneNumberTextField, validationFlag: false)
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
            let phone = convertPhoneToString(phone: phoneNumberTextField.text!)
            
            KeychainWrapper.standard.set(password, forKey: "registrationPasswordKeyChain")
           
            launchOTPVerifyVC(firstName: firstname, lastName: lastname, username: username!, phone: phone)
        }
    }
    
    
    func launchOTPVerifyVC(firstName: String, lastName: String, username: String, phone: String) {
       
       
   
            
        print("launchOTPVerifyVC was called")
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep2ViewController") as! OTPStep2ViewController
        //nextVC.otpCode = otpCode
        nextVC.firstName = firstName
        nextVC.lastName = lastName
        nextVC.username = username
        nextVC.email = username
        nextVC.otpPhone = phone
        //nextVC.eventName = eventName
        //nextVC.eventDateTime = eventDateTime
        //nextVC.eventTypeIcon = eventTypeIcon
        nextVC.eventCode = eventCode
        //nextVC.eventType = eventType
        nextVC.action = "createAccount"
        //nextVC.email = email
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.encryptedDeviceId = encryptedDeviceId
        //nextVC.flowType = flowType
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let text = textField.text
        //if text?.utf16.count==1{
            switch textField{
            case phoneNumberTextField:
                let currentCharacterCount = textField.text?.count ?? 0
                if range.length + range.location > currentCharacterCount {
                    return false
                } else {
                    guard let text = textField.text else { return false }
                    textField.text = text.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#")

                }
                
                let newLength = currentCharacterCount + string.count - range.length
                return newLength <= 14
                
                
            default:

                break
            }
        //}else{
           // returnFlag = false
        //}
        print(string)
        return true
        //phoneNumberTextField.text = textField.text?.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
       
       
       
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


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
