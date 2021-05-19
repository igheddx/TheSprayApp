//
//  LoginQRScanViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/7/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//



import UIKit
import AVFoundation

class LoginQRScanViewController: UIViewController, UITextFieldDelegate {
    let customtextfield = CustomTextField()
    @IBOutlet weak var eventUIView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var rememberMeSwitch: Switch1!
    
    @IBOutlet weak var rememberMeLbl: UILabel!
    //@IBOutlet weak var rememberMeLbl: UILabel!
    
    @IBOutlet weak var dataToSendTextField: UILabel!
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateTimeLbl: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var signInBtn: MyCustomButton! //UIButton!
    
    @IBOutlet weak var signUpBtn: NoNActiveActionButton!
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
        
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
        
        print("LoginQR = \(encryptedAPIKey)")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        print("I WAS CALLED")
        eventNameLbl.text = eventName
        eventDateTimeLbl.text = eventDateTime
        eventImageView.image = UIImage(named: eventTypeIcon)
        //eventCodeLabel.text = eventCode
        
        rememberMeSwitch.isOn = false
        appInitilialization()

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
    
    @IBAction func rememberMeBtnPressed(_ sender: Any) {
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
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
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


//
//    func loadingIndicator() {
//          //self.dismiss(animated: true, completion: nil)
//
//                let alert = UIAlertController(title: nil, message: "Securely Logging In, Please Wait...", preferredStyle: .alert)
//
//                alert.view.tintColor = UIColor.black
//
//                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//                loadingIndicator.hidesWhenStopped = true
//                loadingIndicator.style = UIActivityIndicatorView.Style.medium
//                loadingIndicator.startAnimating();
//
//                alert.view.addSubview(loadingIndicator)
//                present(alert, animated: true, completion: nil)
//    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
   
    
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
           //loadingIndicator()
        
            signInBtn.loadIndicator(true)
            signInBtn.setTitle("Securely Logging In...", for: .normal)
            signInBtn.isEnabled = false
            //eventCode = eventCodeTextField.text!
            

            let authenticatedUserProfile = AuthenticateUser(username: self.username, password: self.password)
            let request = PostRequest(path: "/api/profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)
            
           print("the request =\(request)")
            //randomly generated phone number - to be changed later 
            //phone = ""//generatePhoneNumber()
            
            Network.shared.send(request) { [self] (result: Result<UserData, Error>)  in
                switch result {
                case .success(let user):
                    self.token2pass = user.token!
                    self.userdata = user
                    self.profileId = String(user.profileId!)
                    
                    print("before i call addToEvent")
                   
                    let encryptdecrypt = EncryptDecrpyt()
                    encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: self.username, action: "encrypt")
                    encryptedAPIKey = encryptedAPIKeyUserName
                    //add user to event
                   // if self.eventCode != "" {
                      //  self.getProfileData(profileId1: user.profileId!, token1: user.token!)
                        //self.addToEvent(profileId: user.profileId!, email: user.email!, phone: "", eventCode: eventCode, token: self.token2pass)
                    //} else {
                    self.getProfileData(profileId1: user.profileId!, token1: user.token!)
                        
                        //call payment initialization
                        //self.initializePayment(token: user.token!, profileId: user.profileId!, firstName: user.firstName!, lastName: user.lastName!, userName: user.email!, email: user.email!, phone: phone)
                        //call func to get payment record onfile
                        //self.getPaymentMethodRecord(profileId: user.profileId!, token: user.token!)
                        //capture profile data
                        
                    //}
                    
                    
                    print(" this is dominic \(user)")
                case .failure(let error):

                    self.theAlertView(alertType: "IncorrecUserNamePassword", message: error.localizedDescription)
                }
            }
            
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

        let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token, apiKey: encryptedAPIKey, deviceId: "")


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
 
    @IBAction func registerLinkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "RegistrationViewController", sender: self)
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep1ViewController") as! OTPStep1ViewController

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
