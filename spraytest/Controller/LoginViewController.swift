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
struct PaymentPref {
    let paymentId: Int
    let profileId: Int
    let paymentName: String
}

struct EventPref {
    let eventId: Int
    let profileId: Int
    let paymentId: Int
    let amount: Int
}


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var paymentpref: [PaymentPref] = []
    var eventpref: [EventPref] = []
    
    let customtextfield = CustomTextField()
    
    
    var text: String = ""
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //@IBOutlet weak var eventCodeTextField: UITextField!
    
    //@IBOutlet weak var signInWithCodeSwitch: Switch1!
    
    //@IBOutlet weak var signIntWithCodeLbl: UILabel!
    @IBOutlet weak var rememberMeSwitch: Switch1!
   
    @IBOutlet weak var rememberMeLbl: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var dataToSendTextField: UILabel!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var loginButton: MyCustomButton! //UIButton!
    
    @IBOutlet weak var signUpBtn: NoNActiveActionButton!
    let defaults = UserDefaults.standard
   // @IBOutlet weak var eventCodeTextField: UITextField!
    
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
    
    var balance: Int = 0
    var deviceUID: String = ""
    var encryptedAPIKey: String = "" //"9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A"//"CHqcPp7MN3mTY3nF6TWHdG8dHPVSgJBj"
    var encryptedAPIKeyUserName: String = ""
    var encryptedDeviceId: String = ""
    var apiKeyValue: String = "9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A" //this needs to come from a secured location"
    let device = Device()
    let encryptdecrypt = EncryptDecrpyt()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let decrypt = EncryptDecrpyt()
        
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt") //encryptData(value: apiKeyValue)
//        encryptedDeviceId = device.getDeviceId()
//      
//        device.sendDeviceInfo(encryptedAPIKey: encryptedAPIKey, encryptedDeviceId: encryptedDeviceId)
        //sendDeviceInfo(encryptedAPIKey: self.encryptedAPIKey, encryptedDeviceId: self.encryptedDeviceId)
        
//        let data2Decrypt: Data? = "wr/YeiR6I2ZkB+hmCarcvq5nGE10ApfzwqFUnXkQGftQ2t/uf6IuyBl1RgEwqY7uI6D7d5O0vyPnLQRqNZ0EPg==".data(using: .utf8) // non-nil
//        
//        print("DECRYPT = \(decrypt.decryptData(value:data2Decrypt!))")
//        
        
        print("encryptedAPIKey = \(encryptedAPIKey)")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        rememberMeSwitch.isOn = false

        //reeet all default values
        appInitilialization()

        usernameTextField.text = ""
        passwordTextField.text = ""
        

        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        //self.eventCodeTextField.delegate = self
        
        //toggleTorch(on: true)
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //style button
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
        if logout == true {
            logoutCleanUp()
        }
    }

    @IBAction func rememberMeBtnPressed(_ sender: Any) {
        
    }
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
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
    
    //1/25/21 hold this func for now... we may move it somewhere else
    func  appInitilialization() {
        //removing existing data from object
        myprofiledata.removeAll()
        
        //reset default value of certain default user data
        defaults.set(false, forKey: "isEditEventSettingRefresh")  //indicates that a refresh should be performed after returing to spray select attendee vc
        defaults.set(false, forKey: "isEditEventSettingRefreshSprayVC") //indicates that a refresh should be performed after returing to spray vc
        defaults.set(false, forKey: "isContinueAutoReplenish") //when auto replish is enabled while using app
        defaults.set(false, forKey: "isPaymentMethodAvailable") //at least 1 payment is available
        
        //reset the flag to continue autoreplenis
        defaults.set(false, forKey: "isContinueAutoReplenish")
        
        cleanUserDefaults()
    }
//    func getDeviceInfo() -> String{
//        // Do any additional setup after loading the view, typically from a nib.
//        let udid = UIDevice.current.identifierForVendor?.uuidString
//        let name = UIDevice.current.name
//        //let version = UIDevice.current.systemVersion
//        let modelName = UIDevice.current.model
//
//        deviceUID = udid! + name + modelName
//        print("device \(deviceUID)")
//        let encryptedDeviceId = encryptData(value: deviceUID)
//        return encryptedDeviceId
//    }
    
//    func encryptData(value: String) ->String {
//        let inputValue = value //"UserPassword1!"
//        let key128   = "1234567890123456"                   // 16 bytes for AES128
//        let key256   = "CHqcPp7MN3mTY3nF6TWHdG8dHPVSgJBj"   // 32 bytes for AES256
//        let iv       = "F5cEUty4UwQL2EyW"                   // 16 bytes for AES128
//
//
//        do {
//            let aes128 = AES(key: key128, iv: iv)
//            let aes256 = AES(key: key256, iv: iv)
//
//            let encryptedInputValue128 = aes128?.encrypt(string: inputValue)
//            aes128?.decrypt(data: encryptedInputValue128)
//
//            let encryptedInputValue256 = aes256?.encrypt(string: inputValue)
//            aes256?.decrypt(data: encryptedInputValue256)
//
//
//            //print(encryptedInputValue256?.base64EncodedString())
////            let encryptedInputValue256 = aes256?.encrypt(string: inputValue)
//            return (encryptedInputValue256?.base64EncodedString())!
////
////            let aes = try AES(keyString: key256)
////
////            let stringToEncrypt: String = inputValue
////            print("String to encrypt:\t\t\t\(stringToEncrypt)")6t
////
////            let encryptedData: Data = try aes.encrypt(stringToEncrypt)
////            print("String encrypted (base64):\t\(encryptedData.base64EncodedString())")
////
////            let decryptedData: String = try aes.decrypt(encryptedData)
////            print("String decrypted:\t\t\t\(decryptedData)")
//
//        } catch {
//            var errMsg: String = "Something went wrong: \(error)"
//            print("Something went wrong: \(error)")
//            return errMsg
//        }
//    }
//    
//    func sendDeviceInfoOLD(encryptedAPIKey: String, encryptedDeviceId: String) {
//        let myDeviceId = DeviceInfoId(deviceUniqueId: encryptedDeviceId)
//        print("myDeviceId \(myDeviceId)")
//        let request = PostRequest(path: "/api/device/add", model: myDeviceId, token: "", apiKey: encryptedAPIKey, deviceId: "")
//
//        Network.shared.send(request) { [self] (result: Result<DeviceInfoData, Error>)  in
//            switch result {
//            case .success(let deviceId):
//                //deviceId.sucess
//                print(deviceId)
//               print("it is good")
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//                //self.theAlertView(alertType: "Error", message: error.localizedDescription)
//                break
//            }
//        }
//    }

    
    func loadPaymentPref() -> ([PaymentPref]) {
        let data1 = PaymentPref(paymentId: 1, profileId: 1, paymentName: "Visa")
        paymentpref.append(data1)
        let data2 = PaymentPref(paymentId: 2, profileId: 1, paymentName: "Master")
        paymentpref.append(data2)
        let data3 = PaymentPref(paymentId: 3, profileId: 1, paymentName: "Amex")
        paymentpref.append(data3)
        return paymentpref
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        if logout == true {
                 logoutCleanUp()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        //labelMessage.text = labelMessageInput - hold this 1/16/2021
        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock

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
    func logoutCleanUp() {
        token2pass = ""
        paymentClientToken = ""
        profileId = ""
        eventCode = ""
        
    }
    
    //biometric authentication
    @IBAction func loginWithBiometric(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.biometricIsGood()
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
    
    //not going to use this remove
    @IBAction func joinEventWithCodeButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "goToLoginWithCode", sender: self)
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "JoinWithEventCodeViewController") as! JoinWithEventCodeViewController
    
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    func biometricIsGood() {
        print("Biometric faceId is working")
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
        
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false

        username = usernameTextField.text!
        password = passwordTextField.text!
        
        if username != "" {
            usernameFieldIsEmpty = false
            //usernameErrorLabel.text = ""
        } else {
            usernameFieldIsEmpty = true
            usernameTextField.isEnabled = true
            usernameTextField.becomeFirstResponder()
            //theAlertView(alertType: "MissingFields", message: "")
        }
        
        if password != "" {
            passwordFieldIsEmpty = false
           // passwordErrorLabel.text = ""
        } else {
            passwordFieldIsEmpty = true
            passwordTextField.isEnabled = true
            passwordTextField.becomeFirstResponder()
            //userNamePasswordAlert()
            //theAlertView(alertType: "MissingFields", message: "")
           
        }
        
        if passwordFieldIsEmpty == false && usernameFieldIsEmpty == false {
            encryptedDeviceId = device.getDeviceId(userName: username)
            
            loginButton.loadIndicator(true)
            loginButton.setTitle("Securely Logging In...", for: .normal)
            loginButton.isEnabled = false

            let authenticatedUserProfile = AuthenticateUser(username: self.username, password: self.password)
            let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

            print("request \(request)")
            Network.shared.send(request) { [self] (result: Result<UserData, Error>)  in
                switch result {
                case .success(let user):
                    
                    if let thetoken = user.token {
                        self.token2pass = thetoken
                        
                        self.userdata = user
                        self.profileId = String(user.profileId!)
                        
                        let encryptdecrypt = EncryptDecrpyt()
                        encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: self.username, action: "encrypt")
                        
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
                        self.loginButton.loadIndicator(false)
                        self.loginButton.isEnabled = true
                        self.loginButton.setTitle("Sign In", for: .normal)
                        self.usernameTextField.isEnabled = true
                        self.passwordTextField.isEnabled = true
                        //self.loginButton.loadIndicator(false)
                        
                        theAlertView(alertType: "MissingFields", message: "")
                    }
              
                    
                case .failure(let error):

                    self.theAlertView(alertType: "IncorrecUserNamePassword", message: error.localizedDescription)
                }
            }
        } else {
            theAlertView(alertType: "MissingFields", message: "")
        }
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
            
           // let decoder = JSONDecoder()
           //                do {
           //                    let urlJson: OnboardingUrl = try decoder.decode(OnboardingUrl.self, from: urldata)
           //                    //for url in urlJson {
           //                        //           url.redirectUrl
           //                        print("MY URL = \( urlJson.redirectUrl)")
           //                    //}
           //
           //                } catch {
           //                    print(error)
           //                }
            
            
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
        self.loginButton.isEnabled = true
        self.loginButton.setTitle("Sign In", for: .normal)
        self.usernameTextField.isEnabled = true
        self.passwordTextField.isEnabled = true
        //self.loginButton.loadIndicator(false)
        self.loginButton.loadIndicator(false)
        
        let alert2 = UIAlertController(title: alertTitle, message: "\(alertMessage) \n \(message)", preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert2, animated: true)
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
   
    @IBAction func registerLinkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "RegistrationViewController", sender: self)
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep1ViewController") as! OTPStep1ViewController
        nextVC.action = "createAccount"
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
        
        self.navigationController?.pushViewController(nextVC , animated: true)
    }

//    func getPaymentMethodRecord(profileId: Int64, token: String) {
//        let request = Request(path: "/api/PaymentMethod/all/\(profileId)", token: token)
//        Network.shared.send(request) { (result: Result<Data, Error>)  in
//        switch result {
//            case .success(let paymentmethod1):
//                       //self.parse(json: event)
//                let decoder = JSONDecoder()
//                do {
//                    let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
//                        
//                    //check if user has paymentmethod onfile - at least 1
//                    print("paymentJson.count = \(paymentJson.count)")
//                    if paymentJson.count > 0 {
//                        UserDefaults.standard.set(true, forKey: "isPaymentMethodAvailable")
//                    } else {
//                        UserDefaults.standard.set(false, forKey: "isPaymentMethodAvailable")
//                    }
//                } catch {
//                    print(error)
//                }
//            case .failure(let error):
//                print(" DOMINIC A IGHEDOSA ERROR \(error.localizedDescription)")
//            }
//        }
//    }
    
    /*may need to move this to initialization - app start once we figure it out
    1/25/2020 */
    func cleanUserDefaults() {
        // Remove Key-Value Pair
        //UserDefaults.standard.removeObject(forKey: "isPaymentMethodAvailable")
        
        UserDefaults.standard.removeObject(forKey: "isAccountConnected")
        
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
            print("I was in Seque Identifier")
        } else if(segue.identifier == "goToReg") {
            let NextVC = segue.destination as! RegistrationViewController
            NextVC.message  = ""
            NextVC.encryptedAPIKey = encryptedAPIKeyUserName
        } else if(segue.identifier == "goToLoginWithCode") {
            let NextVC = segue.destination as! JoinWithEventCodeViewController
        }
    }
}


extension String {

    func aesEncrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = self.data(using: String.Encoding.utf8),
            let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {


            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)



            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString


            }
            else {
                return nil
            }
        }
        return nil
    }

    func aesDecrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {

            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)

            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                return unencryptedMessage
            }
            else {
                return nil
            }
        }
        return nil
    }


}
