//
//  ForgotPasswordViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/22/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var resetPasswordBtn: MyCustomButton!
    var username: String?
    var email: String = ""
    var formValidation =   Validation()
    let customtextfield = CustomTextField()
    var phoneFromOTP: String = ""
    var otpCode: String = ""
    var action: String = ""
    var token2pass: String = ""
    var paymentClientToken: String = ""
    let device = Device()
    var encryptedAPIKey: String = ""
    var encryptedDeviceId: String = ""
    let encryptdecrypt = EncryptDecrpyt()
    var encryptedAPIKeyUserName: String = ""
    var userdata: UserData?
    var profileId: String?
    var myprofiledata: [MyProfile] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        initializationTasks()
        // Do any additional setup after loading the view.
    }
    
    func initializationTasks() {
        //encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)),
                                 for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)),
                                    for: .editingChanged)
        passwordConfirmTextField.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)),
                                           for: .editingChanged)
    
        customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)
        
        emailTextField.text = email
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
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
    
    
    func setNavigationBar() {
        print("I was called")
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
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
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==1{
                switch textField{
                case emailTextField:
                    customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
                case passwordTextField:
                    customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
                case passwordConfirmTextField:   //passwordConfirmLabel.isHidden = false
                    customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)
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
      
    }
    func loadingIndicator() {
        let alert = UIAlertController(title: nil, message: "Processing..., Please Wait...", preferredStyle: .alert)

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
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            passwordConfirmTextField.isEnabled = false

            resetPasswordBtn.loadIndicator(true)
            resetPasswordBtn.setTitle("Process...", for: .normal)
            resetPasswordBtn.isEnabled = false
            resetPasswordBtn.isEnabled = false
        } else if actionType == "error" {
            resetPasswordBtn.isEnabled = true
            resetPasswordBtn.isEnabled = true
            resetPasswordBtn.setTitle("Sign Up", for: .normal)
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            passwordConfirmTextField.isEnabled = true
            //self.loginButton.loadIndicator(false)
            resetPasswordBtn.loadIndicator(false)
    
        } else if actionType == "done" {
            resetPasswordBtn.isEnabled = true
            resetPasswordBtn.isEnabled = true
            resetPasswordBtn.setTitle("Sign Up", for: .normal)
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            passwordConfirmTextField.isEnabled = true
            //self.loginButton.loadIndicator(false)
            resetPasswordBtn.loadIndicator(false)
        }
    }
    
    @IBAction func resetPasswordBtnPressed(_ sender: Any) {
        guard let password = passwordTextField.text,
        let confirmPassword = passwordConfirmTextField.text,
        let email = emailTextField.text else {
            return
        }
     
        username = emailTextField.text!
        
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
            encryptedDeviceId = device.getDeviceId(userName: "")
          
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
        
        
        if isValidateEmail == true && isValidatePass == true && passwordMatch == true  {
            encryptedDeviceId = device.getDeviceId(userName: self.username!)
            
            spinerTaskStart()
            
            
            let resetPasswordModel = ProfileResetModel(email: email, phone: phoneFromOTP, code: otpCode, password: password)
            print("resetPasswordModel \(resetPasswordModel)")
            let request = PostRequest(path: "/api/profile/reset", model: resetPasswordModel, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
            
        
            print("request \(request)")
            Network.shared.send(request) { [self] (result: Result<OTPData, Error>)  in
            switch result {
            case .success(let resetdata):
                if resetdata.success == true {
                    //LoadingStop()
                    authenticate(userName: username!, password: password)
                    print("success")
                    print("Message: \(resetdata.errorMessage)")
                    
                    print("Message: \(resetdata.errorCode)")
                } else  {
                    //LoadingStop()
                    print("Message: \(resetdata.errorMessage)")
                    
                    print("Message: \(resetdata.errorCode)")
                    
                    spinerTaskEnd()
                  
                    
                    theAlertView(alertType: "otpcode2", message: resetdata.errorMessage!)
                    print("failed")
                }
               
            case .failure(let error):
                //LoadingStart()
                spinerTaskEnd()
                theAlertView(alertType: "otpcode", message: error.localizedDescription)
                }
            }
            
        } else {
            spinerTaskEnd()
            theAlertView(alertType: "MissingFields", message: "")
        }
  
    
        if (isValidateEmail == true && isValidatePass == true && passwordMatch == true ) {
                 print("All fields are correct")
            
            
            //eventCode = eventCodeTextField.text!
           // self.loadingIndicatorAction(actionType: "displayloadingmsg")
            

            //default phone number - to be changed later
            
            
//            let userData = UserModel(firstName: firstname, lastName: lastname, username: username!, password: password, email: email, phone: phoneFromOTP)
//
//            print(userData)
//            let request = PostRequest(path: "/api/profile/register", model: userData, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
//            Network.shared.send(request) { [self] (result: Result<UserData, Error>) in
//                switch result {
//                case .success(let userdata):
//                    self.userdata = userdata
//                    print(userdata)
//                    //call authentication func
//                    self.authenticateUser(userName: self.username!, password: password)
//
//                case .failure(let error):
//                    self.presentUIAlert(alertMessage: "", alertTitle: "", errorMessage: error.localizedDescription, alertType: "systemError")
//                    self.loadingIndicatorAction(actionType: "error")
//                }
//            }
        }
    }
    
    //call this function to perform task when spiner start
    func spinerTaskStart() {
        
        resetPasswordBtn.loadIndicator(true)
        resetPasswordBtn.setTitle("Processing...", for: .normal)
        resetPasswordBtn.isEnabled = false
        self.emailTextField.isEnabled = false
        self.passwordTextField.isEnabled = false
        self.passwordConfirmTextField.isEnabled = false
        
    }
    
    //call this function to perform task when spiner ends
    func spinerTaskEnd() {
        self.resetPasswordBtn.loadIndicator(false)
        self.resetPasswordBtn.isEnabled = true
        self.resetPasswordBtn.setTitle("Reset Password ", for: .normal)
        self.emailTextField.isEnabled = true
        self.passwordTextField.isEnabled = true
        self.passwordConfirmTextField.isEnabled = true
        
    }
    func authenticate(userName: String, password: String) {
        let authenticatedUserProfile = AuthenticateUser(username: userName, password: password)
        let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

        print("authenticatedUserProfile = \(authenticatedUserProfile)")
        print("request \(request)")
        Network.shared.send(request) { [self] (result: Result<UserData, Error>)  in
            switch result {
            case .success(let user):
                
                if let thetoken = user.token {
                    self.token2pass = thetoken
                    
                    self.userdata = user
                    self.profileId = String(user.profileId!)
                    
                    let encryptdecrypt = EncryptDecrpyt()
                    encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: self.username!, action: "encrypt")
                    
                    print("encryptedAPIKeyUserName DOMINIC \(encryptedAPIKeyUserName)")
                    //encryptData(value: "\(user.userName)|\(apiKeyValue)")
                    
                    //call payment initialization
                    self.initializePayment(token: user.token!, profileId: user.profileId!, firstName: user.firstName!, lastName: user.lastName!, userName: user.email!, email: user.email!, phone: "")
                   
                    
                    //call func to get payment record onfile
                    //self.getPaymentMethodRecord(profileId: user.profileId!, token: user.token!)
                    
                    //capture profile data
                    self.getProfileData(profileId1: user.profileId!, token1: user.token!)
                    
                    print(" this is dominic \(user)")
                } else {
                    spinerTaskEnd()
                    theAlertView(alertType: "MissingFields", message: "")
                }
          
                
            case .failure(let error):
                spinerTaskEnd()
                self.theAlertView(alertType: "IncorrecUserNamePassword", message: error.localizedDescription)
            }
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
//        self.loginButton.isEnabled = true
//        self.loginButton.setTitle("Sign In", for: .normal)
//        self.usernameTextField.isEnabled = true
//        self.passwordTextField.isEnabled = true
        //self.loginButton.loadIndicator(false)
        self.resetPasswordBtn.loadIndicator(false)
        
        let alert2 = UIAlertController(title: alertTitle, message: "\(alertMessage) \n \(message)", preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert2, animated: true)
    }
    
    
    func getProfileData(profileId1: Int64, token1: String) {
            let request = Request(path: "/api/profile/\(profileId1)", token: token1, apiKey: encryptedAPIKeyUserName)
        
        print("getProfileData was called")
        print("request=\(request)")
        Network.shared.send(request) { [self] (result: Result<ProfileData2, Error>)  in
        switch result {
        case .success(let profileData):
            
            print(" I have profile Data")
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
            print("my profile data = \(data1)")
            
            print("name =\(profileData.firstName) hasvalidpayment method =\(profileData.hasValidPaymentMethod) paymentCustomerId = \(profileData.paymentCustomerId)")
            
    //            if let data = jsonString.data(using: .utf8)
    //             {
    //                 let decoder = JSONDecoder()
    //                 let result = try? decoder.decode(Result.self, from: data) //Use Result.self here
    //                 print(result)
    //             }
            
            break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
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
            //failure something goes wrong
            
            print("myprofile.firstName \(myprofile.firstName)")

        }
        
        myReturnUrl = "https://projectxclientapp.azurewebsites.net/stripe/Index?profileid=\(myProfileId)&status=success&token=\(token2pass)"
        myRefreshUrl = "https://projectxclientapp.azurewebsites.net/stripe/Index?profileid=\(myProfileId)&status=failed&token=\(token2pass)"
        
        let onboardingProfile = ProfileOnboarding(token: token2pass, profileId: myProfileId, firstName: myName, lastName: myLastName, userName: myusername, email: myEmail, phone: myPhone, avatar: myAvatar, paymentCustomerId: myPaymentCustomerId, paymentConnectedActId: myPaymentConnectedActId, success: true, returnUrl: myReturnUrl, refreshUrl: myRefreshUrl)
       
        print("onboardingProfile =\(onboardingProfile)")
        //let encryptedAPIKey = myEmail + "|" + self.encryptedAPIKey
        let request = PostRequest(path: "/api/profile/addaccount", model: onboardingProfile, token: token2pass, apiKey: encryptedAPIKeyUserName, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>) in
            switch result {
            case .success(let urldata):
                print("avatar \(urldata)")
                print("SUCCESS")
                
                print(String(data: urldata, encoding: .utf8) ?? "*")
                
                let m = URL(string: String(data: urldata, encoding: .utf8) ?? "*")
                print("m \(m)")
                //print(URL(string: data: urldata, encoding: .utf8) ?? "*"))
                let redirectUrl = String(data: urldata, encoding: .utf8) ?? "*"
                
                print("redirectUrl before \(redirectUrl)")
                
                let redirectURL2 = redirectUrl.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
              
                let jsonData = redirectURL2.data(using: .utf8)!
                let connectedaccount: ConnectedAccount = try! JSONDecoder().decode(ConnectedAccount.self, from: jsonData)
                
               // print("MY URL IS \(connectedaccount.url!)")
                print("IS ACCOUNT CONNECTED \(connectedaccount.isAccountConnected)")
                
                UserDefaults.standard.set(connectedaccount.isAccountConnected, forKey: "isAccountConnected")
                break

            case .failure(let error):
                UserDefaults.standard.set(false, forKey: "isAccountConnected")
            print(" DOMINIC H IGHEDOSA 1 ERROR \(error.localizedDescription)")
        }
    }

    }
    

    //Initialize payment
    func initializePayment(token: String, profileId: Int64, firstName: String, lastName: String, userName: String, email: String, phone: String) {
        let initPayment = InitializePaymentModel(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone)
        print("InitializePaymentModel \(initPayment)")
        
        //let encryptedAPIKey = userName + "|" + self.encryptedAPIKey
        let request = PostRequest(path: "/api/Profile/initialize", model: initPayment, token: token, apiKey: encryptedAPIKeyUserName, deviceId: "")
         
          Network.shared.send(request) { (result: Result<InitializePaymentData, Error>)  in
             switch result {
             case .success(let paymentInit):
                self.paymentClientToken = paymentInit.clientToken!
                
                print("paymentClientToken = \(self.paymentClientToken)")
                
               self.performSegue(withIdentifier: "nextVC", sender: nil)
             case .failure(let error):
                 //self.labelMessage.text = error.localizedDescription
                self.theAlertView(alertType: "InitializeError", message: error.localizedDescription)
             }
         }
        //closing loading
        self.dismiss(animated: false, completion: nil)
    }
    
    
    //**************** good code hold ***********************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //closing loading
        self.dismiss(animated: false, completion: nil)
               
        if(segue.identifier == "passwordReset2MenuTab"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass
            NextVC.paymentClientToken = paymentClientToken
            NextVC.myProfileData = myprofiledata
            NextVC.encryptedAPIKey = encryptedAPIKeyUserName
            print("I was in Seque Identifier")
        } else if(segue.identifier == "goToReg") {
            let NextVC = segue.destination as! RegistrationViewController
            NextVC.message  = ""
            NextVC.encryptedAPIKey = encryptedAPIKeyUserName
        } else if(segue.identifier == "goToLoginWithCode") {
            let NextVC = segue.destination as! JoinWithEventCodeViewController
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
