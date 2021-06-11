//
//  CreateAccountQRScanViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/7/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//



import UIKit

class CreateAccountQRScanViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var signInBtn: NoNActiveActionButton!
    
    @IBOutlet weak var signUpBtn: MyCustomButton!
    @IBOutlet weak var termsConditionSwitch: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var eventUIView: UIView!
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateTimeLbl: UILabel!
    //@IBOutlet weak var eventDateTimeLbl: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    //@IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var emailTextField: UITextField!
    //@IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet weak var passwordConfirmTextField: UITextField!
    //@IBOutlet weak var signUpBtn: MyCustomButton!
    //@IBOutlet weak var signInBtn: NoNActiveActionButton!
    
    //@IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var termsConditionSwitch: Switch1!
    //declare register form variables
    var firstName: String = ""
    var lastName: String = ""
    var username: String?
    var password: String?
    var confirmPassword: String?
    var email: String = ""
    var phone: String = ""
    var phoneFromOTP: String = ""
    var otpCode: String =  ""
    var userdata: UserData?
    var token2pass: String?
    var profileId: String?
    var eventCode: String?
    var message: String?
    var paymentClientToken: String = ""
    
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventTypeIcon: String = ""
    var eventType: String =  ""
    
    //instanciate the network object
   //let registrationManager = NetworkManager2()

    var formValidation =   Validation()
    let customtextfield = CustomTextField()
    var myprofiledata: [MyProfile] = []
    var encryptedAPIKey: String = ""
    var encryptedAPIKeyUserName: String = ""
    var encryptedDeviceId: String = ""

    let device = Device()
    let encryptdecrypt = EncryptDecrpyt()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        //encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt") //encryptData(value: apiKeyValue)
        //let devicedata = DeviceData()
//        let encryptdecrypt = EncryptDecrpyt()
//        let device = Device()
//
//        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt") //encryptData(value: apiKeyValue)
//        encryptedDeviceId = device.getDeviceId()
//        device.sendDeviceInfo(encryptedAPIKey: self.encryptedAPIKey, encryptedDeviceId: self.encryptedDeviceId)
//
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        
        eventNameLbl.text = eventName
        eventDateTimeLbl.text = eventDateTime
        eventImageView.image = UIImage(named: eventTypeIcon)
        
        //toggleTorch(on: true)
//        navigationItem.hidesBackButton = false
//        navigationController?.setNavigationBarHidden(false, animated: true)
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
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
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
    
    func initializationTasks() {
        termsConditionSwitch.isOn = false
        emailTextField.text = email
        
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
            nameTextField.isEnabled = false
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            passwordConfirmTextField.isEnabled = false
            signInBtn.isEnabled = false
            termsConditionSwitch.isEnabled  = false
            signUpBtn.loadIndicator(true)
            signUpBtn.setTitle("Processing...", for: .normal)
            signUpBtn.isEnabled = false
            signInBtn.isEnabled = false
        } else if actionType == "error" {
            signUpBtn.isEnabled = true
            signInBtn.isEnabled = true
            signUpBtn.setTitle("Sign Up", for: .normal)
            termsConditionSwitch.isEnabled  = true
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
            termsConditionSwitch.isEnabled  = true
            passwordTextField.isEnabled = true
            passwordConfirmTextField.isEnabled = true
            //self.loginButton.loadIndicator(false)
            signUpBtn.loadIndicator(false)
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
    
        
        //closing loading
        self.dismiss(animated: false, completion: nil)
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "LoginQRScanViewController") as! LoginQRScanViewController

        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventTypeIcon = eventTypeIcon
        nextVC.eventCode = eventCode!
                   
        self.navigationController?.pushViewController(nextVC , animated: true)

    }
    func generatePhoneNumber() -> String {
        let str1 =  Int.random(in: 100...999)
        let str2 =  Int.random(in: 100...999)
        let str3 =  Int.random(in: 1000...9999)
        
        let phonenumber = String(str1) + "-" + String(str2) + "-" + String(str3)
        return phonenumber
    }
    @IBAction func signUpBtnPressed(_ sender: Any) {
    
        nameTextField.isEnabled = false
        emailTextField.isEnabled = false
        passwordConfirmTextField.isEnabled = false
        passwordTextField.isEnabled = false
        termsConditionSwitch.isEnabled = false
        
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
            //device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
            
    
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
            
            
            let str = name
            let trimmedStr = str.trimmingCharacters(in: .whitespacesAndNewlines)
            //var firstname: String = ""
            //var lastname: String = ""
            let nameComponents = trimmedStr.components(separatedBy: " ")
            if nameComponents.count > 1 {
                if nameComponents.count == 2 {
                    firstName = nameComponents[0]
                    lastName = nameComponents[1]
                } else {
                    firstName = nameComponents[0] + " " + nameComponents[1]
                    lastName = nameComponents[2]
                }
            }
            
            //randomly generated phone number - to be changed later
            phone = ""//generatePhoneNumber()
            
            let userData = UserModel(firstName: firstName, lastName: lastName, username: username!, password: password, email: email, phone: phoneFromOTP)

            print(userData)
            let request = PostRequest(path: "/api/profile/register", model: userData, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
            Network.shared.send(request) { [self] (result: Result<UserData, Error>) in
                switch result {
                case .success(let userdata):
                    self.userdata = userdata
                    print(userdata)
                    //call authentication func
                    self.authenticateUser(userName: self.username!, password: password, phone: phoneFromOTP, email: email, eventCode: eventCode!)

                case .failure(let error):
                    self.presentUIAlert(alertMessage: "", alertTitle: "", errorMessage: error.localizedDescription, alertType: "systemError")
                    self.loadingIndicatorAction(actionType: "error")
                }
            }
        }
    }
    func authenticateUser(userName:String,password: String, phone: String, email: String,  eventCode: String) {
        //******************** After creating account; authenticating to get Token *****************************
        let authenticatedUserProfile = AuthenticateUser(username: userName, password: password)
        
//        let encryptedAPIKey = EncryptDecrpyt()
//        let encryptedAPIKeyData = encryptedAPIKey.encryptData(value: <#T##String#>)
        let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

        print("request from createAccount QR =\(request)")

        Network.shared.send(request) { [self] (result: Result<UserData, Error>)  in
            switch result {
            case .success(let user):
                if let res =  user.token { // to unwrap the optional value
                  // check textfield is not nil
                    self.token2pass = res
                }
                else {
                    self.token2pass = ""
                }
                
                //self.token2pass = user.token!
                self.userdata = user
                self.profileId = String(user.profileId!)

                print(" this is dominic \(user)")
                
                let encryptdecrypt = EncryptDecrpyt()
                encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: userName, action: "encrypt")
                encryptedAPIKey = encryptedAPIKeyUserName
                //capture profile data
                self.getProfileData(profileId1: user.profileId!, token1: user.token!)
                
                //add user to event
             
                
//                self.navigationItem.hidesBackButton = true
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
               
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
            print("my profile data = \(data1)")
            
            if self.eventCode != "" {
                self.addToEvent(profileId: profileData.profileId, email: profileData.email, phone:  profileData.phone, eventCode: eventCode!, token: self.token2pass!)
            } else  {
                self.initializePayment(token: self.token2pass!, profileId: profileData.profileId, firstName: profileData.firstName, lastName: profileData.lastName, userName: profileData.email, email: profileData.email, phone: profileData.phone)
                //self.loadingIndicatorAction(actionType: "done")
                //self.performSegue(withIdentifier: "Reg2MenuTab", sender: nil)
            }

            
            break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
            print(" DOMINIC B IGHEDOSA ERROR \(error.localizedDescription)")
            self.theAlertView(alertType: "GetProfileError", message: error.localizedDescription)
                    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Reg2MenuTab"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass
            NextVC.encryptedAPIKey = encryptedAPIKey
            NextVC.eventType = eventType
            NextVC.eventTypeIcon = eventTypeIcon
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
