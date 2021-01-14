//
//  LoginViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import AVFoundation

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
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var dataToSendTextField: UILabel!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var loginButton: MyCustomButton! //UIButton!
    
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
    
    var balance: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reeet all default values
        appInitilialization()
        //DispatchQueue.global().async {
           // loadingIndicator()
           //fetchData()
//            DispatchQueue.main.sync {
//             
//                fetchBigData()
//                self.dismiss(animated: true, completion: nil)
//            }
        //}
        //fetchData()
        //R:49, G:132, B:181
        //loginButton.backgroundColor = UIColor(red: 49/256, green: 132/256, blue: 181/256, alpha: 1.0)
        usernameTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)),
                                     for: .editingChanged)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
        
        usernameErrorLabel.text = ""
        passwordErrorLabel.text = ""
        labelMessage.text = ""
        
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        
        //toggleTorch(on: true)
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //green message RGB = red: 82/256, green: 156/256, blue: 32/256, alpha: 1.0
        // red message RGD = red: 204/256, green: 0/256, blue: 0/256, alpha: 1.0
        //labelMessage.textColor = UIColor(red: 82/256, green: 156/256, blue: 32/256, alpha: 1.0)
        //labelMessage.textColor = UIColor(red: 204/256, green: 0/256, blue: 0/256, alpha: 1.0)
        //labelMessage.font = UIFont.boldSystemFont(ofSize: 17.0)
        //labelMessage.text = "Dominic Ighedosa "
        
        spraytransaction = db.readSprayTransaction()
        if spraytransaction.count > 0 {
            for st in spraytransaction {
                balance = st.receiverAmountReceived
                print("ReceiverId = \(st.receiverId) ---- Receiver Amount Received = \(st.receiverAmountReceived)")
               // print("sender amount remainings when not getting getEventPreference = \(s.senderAmountRemaining)")
          }
        }
        
        senderspraybalance = db.readSenderSprayBalanceById(eventId: 5, senderId: 41)
        
       if senderspraybalance.count > 0 {
            for s in senderspraybalance {
                balance = s.senderAmountRemaining
                print("sender amount remaining when not getting getEventPreference = \(s.senderAmountRemaining)")
          }
        }
    
        //style button
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
        
//        self.addBottomLineToTextField(textField: usernameTextField)
//        self.addBottomLineToTextField(textField: passwordTextField)
        ///self.addBottomLineToTextField(textField: eventCodeTextField)
        // Do any additional setup after loading the view.
        //navigationItem.hidesBackButton = true
        if logout == true {
            logoutCleanUp()
        }
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
    func  appInitilialization() {
        //reset default value of certain default user data
        defaults.set(false, forKey: "isEditEventSettingRefresh")  //indicates that a refresh should be performed after returing to spray select attendee vc
        defaults.set(false, forKey: "isEditEventSettingRefreshSprayVC") //indicates that a refresh should be performed after returing to spray vc
        defaults.set(false, forKey: "isContinueAutoReplenish") //when auto replish is enabled while using app
    }
    func loadPaymentPref() -> ([PaymentPref]) {
        let data1 = PaymentPref(paymentId: 1, profileId: 1, paymentName: "Visa")
        paymentpref.append(data1)
        let data2 = PaymentPref(paymentId: 2, profileId: 1, paymentName: "Master")
        paymentpref.append(data2)
        let data3 = PaymentPref(paymentId: 3, profileId: 1, paymentName: "Amex")
        paymentpref.append(data3)
        return paymentpref
    }

    func loadEventPref() -> ([EventPref]) {
        let data1 = EventPref(eventId: 5, profileId: 1, paymentId: 1, amount: 50)
        eventpref.append(data1)
        let data2 = EventPref(eventId: 6, profileId: 1, paymentId: 2, amount: 50)
        eventpref.append(data2)
        let data3 = EventPref(eventId: 7, profileId: 1, paymentId: 3, amount: 50)
        eventpref.append(data3)
        
        return eventpref
    }

   
    func fetchBigData(){
        for index in 1...1000 {
            print("Dominic \(index)")
        }
        
        print("ok, I am done")
    }
    func fetchData(closure:()->Void) {
        
   
        
        var eventpref2: [EventPref] = []
        var paymentpref2 : [PaymentPref] =  []
        
        eventpref2  = loadEventPref()
        paymentpref2 = loadPaymentPref()
        
    //
    //    DispatchQueue.global().async {
    //        guard let d = loadEventPref() != nil else {return}
    //        DispatchQueue.main.async {
    //            let lp = loadPaymentPref()
    //
    //            print(lp)
    //        }    }
    //
        
        
        for i in eventpref2 {
            for j in paymentpref2 {
                if (i.profileId == j.profileId && i.paymentId == j.paymentId && i.eventId == 5) {
                    print("my event Id =\(i.eventId) paymentId = \(j.paymentId)")
                }
                print()
            }
            print("profile = \(i.profileId) eventId = \(i.eventId) amount = \(i.amount)")
        }
        closure()
        print("I am fetching date")
    }
    

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        if logout == true {
                 logoutCleanUp()
            
        }
        
        labelMessage.text = labelMessageInput
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
    
//    private func borderForTextField(textField: UITextField, validationFlag: Bool) {
//
//        if validationFlag == false {
//            textField.layer.cornerRadius = 6.0
//            textField.layer.masksToBounds = true
//            textField.layer.borderColor = UIColor(red: 211/256, green: 211/256, blue: 211/256, alpha: 1.0 ).cgColor
//            textField.layer.borderWidth = 1.0
//            textField.borderStyle = .none
//        } else {
//            textField.layer.cornerRadius = 6.0
//            textField.layer.masksToBounds = true
//            textField.layer.borderColor = UIColor(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0 ).cgColor
//            textField.layer.borderWidth = 1.0
//            textField.borderStyle = .none
//        }
//
//
//        //textField.layer.addSublayer(bottomLine)
//
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==1{
                switch textField{
                case usernameTextField:
                    usernameErrorLabel.text = ""
                    
                    customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
                case passwordTextField:
                    passwordErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
                default:
                    break
                }
            }else{

            }
    }
    private func addBottomLineToTextField(textField: UITextField) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 2/3, green: 2/3, blue: 2/3, alpha: 1.0).cgColor
        //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
        textField.borderStyle = .none
        
        textField.layer.addSublayer(bottomLine)
        
        //        let border = CALayer()
        //          let borderWidth = CGFloat(1.0)
        //          border.borderColor = UIColor.white.cgColor
        //          border.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.size.width, height: 2)
        //          border.borderWidth = borderWidth
        //          textField.layer.addSublayer(border)
        //          textField.layer.masksToBounds = true
    }
    
    
    func logoutCleanUp() {
        token2pass = ""
        paymentClientToken = ""
        profileId = ""
        eventCode = ""
        
    }
    
    
    @IBAction func launchScanner(_ sender: Any) {
    }
    
    //not going to use this remove
    @IBAction func joinEventWithCodeButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "goToLoginWithCode", sender: self)
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "JoinWithEventCodeViewController") as! JoinWithEventCodeViewController
    
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    func loadingIndicator() {
          self.dismiss(animated: true, completion: nil)
                
                let alert = UIAlertController(title: nil, message: "Securely Logging In, Please Wait...", preferredStyle: .alert)

                alert.view.tintColor = UIColor.black
        //        l//et loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        //        loadingIndicator.hidesWhenStopped = true
        //        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        //        loadingIndicator.startAnimating();
        //
        //        alert.view.addSubview(loadingIndicator)
        //        present(alert, animated: true, completion: nil)
        //
                
                
                //_ = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.medium
                loadingIndicator.startAnimating();

                alert.view.addSubview(loadingIndicator)
                present(alert, animated: true, completion: nil)
    }
    @IBAction func loginButtonPressed(_ sender: Any)  {
        
        
       
     
        loginButton.setTitle("Loging In...", for: .normal)
        loginButton.isEnabled = false
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false
       
        
        username = usernameTextField.text!
        password = passwordTextField.text!
        
      
        if username != "" {
            usernameFieldIsEmpty = false
            usernameErrorLabel.text = ""
        } else {
            usernameTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: usernameTextField, validationFlag: true)
            
            usernameFieldIsEmpty = true
            usernameErrorLabel.text = "Missing Username"
            usernameTextField.isEnabled = true
            
        }
        
        if password != "" {
            passwordFieldIsEmpty = false
            passwordErrorLabel.text = ""
        } else {
            passwordTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: passwordTextField, validationFlag: true)
            passwordFieldIsEmpty = true
            passwordErrorLabel.text = "Missing Password"
            passwordTextField.isEnabled = true
        }
        
        if passwordFieldIsEmpty == false && usernameFieldIsEmpty == false {
            
            loadingIndicator()
            
            //eventCode = eventCodeTextField.text!
            
            //firstname2pass = ""
            labelMessage.text = ""
            
            
            let authenticatedUserProfile = AuthenticateUser(username: self.username, password: self.password)
            let request = PostRequest(path: "/api/Profile/authenticate", model: authenticatedUserProfile, token: "")
            
           
           
             Network.shared.send(request) { (result: Result<UserData, Error>)  in
                switch result {
                case .success(let user):
                    self.token2pass = user.token!
                    self.userdata = user
                    self.profileId = String(user.profileId!)
                    
                    //call payment initialization
                    self.initializePayment(token: user.token!, profileId: user.profileId!, firstName: user.firstName!, lastName: user.lastName!, userName: "", email: user.email!, phone: "")
                    
                   
                    
                    print(" this is dominic \(user)")
                    //add user to event
    //                   if self.eventCode != "" {
    //                    self.addToEvent(profileId: user.profileId!, email: user.email!, phone: self.phone, eventCode: self.eventCode!, token: self.token2pass)
    //
    //                   }
                    
                    
                    
                    
                    
                    //self.labelMessage.text = "Got an empty, successful result"
                
                    
                case .failure(let error):
    //                if self.eventCode != "" {
    //                    //                                  self.addToEvent(profileId: user.profileId!, email: user.email!, phone: self.phone, eventCode:       self.eventCode!, token: self.token2pass)
    //                    let goToNextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
    //                    goToNextVC.eventCode = self.eventCode
    //                    goToNextVC.message = "Please register to continue..."
    //                         //nextVC.eventName = eventName
    //                         //nextVC.eventId = eventId
    //                         //nextVC.profileId = profileId
    //                         //nextVC.token = token
    //                         //nextVC.paymentClientToken  =  paymentClientToken
    //
    //                    self.navigationController?.pushViewController(goToNextVC , animated: true)
                    //}
                    //closing loading
                    self.dismiss(animated: false, completion: nil)
                    self.labelMessage.text = "Login ID / Password is incorrect. Please try again." //error.localizedDescription
                    self.loginButton.isEnabled = true
                    self.usernameTextField.isEnabled = true
                    self.passwordTextField.isEnabled = true
                   
                }
                
               
            }
            
           //print(self.user.firstName)
            //print(UserData.init(token: user.token, profileId: <#T##Int64?#>, firstName: <#T##String#>, lastName: <#T##String#>, userName: <#T##String?#>, email: <#T##String?#>))
          
            

    //
    //
    //         }
    //     }
            
        }
        
        
    }
    //Initialize payment
    func initializePayment(token: String, profileId: Int64, firstName: String, lastName: String, userName: String, email: String, phone: String) {
        let initPayment = InitializePaymentModel(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone)
        print("InitializePaymentModel \(initPayment)")
         let request = PostRequest(path: "/api/Profile/initialize", model: initPayment, token: token)
         
        
        
          Network.shared.send(request) { (result: Result<InitializePaymentData, Error>)  in
             switch result {
             case .success(let paymentInit):
                self.paymentClientToken = paymentInit.clientToken!
                
                print("paymentClientToken = \(self.paymentClientToken)")

                 self.performSegue(withIdentifier: "nextVC", sender: nil)
             case .failure(let error):
                 self.labelMessage.text = error.localizedDescription
             }
             
            
         }
        
        //closing loading
        self.dismiss(animated: false, completion: nil)
    }
   
//   func addToEvent(profileId: Int64, email: String, phone: String, eventCode: String, token: String) {
//
//          let Invite = SendInvite(profileId: profileId, email: email, phone: phone, eventCode: eventCode)
//          
//          let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token)
//          
//          
//          Network.shared.send(request) { (result: Result<Data, Error>)  in
//              switch result {
//              case .success( _): break
//              case .failure(let error):
//                  print(error.localizedDescription)
//              }
//          }
//                     
//      }
    
    
 
    @IBAction func registerLinkButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "RegistrationViewController", sender: self)
    }
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
        //**************** good code hold ***********************
            
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //closing loading
        self.dismiss(animated: false, completion: nil)
               
        if(segue.identifier == "nextVC"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass
            NextVC.paymentClientToken = paymentClientToken
        } else if(segue.identifier == "goToReg") {
            let NextVC = segue.destination as! RegistrationViewController
            NextVC.message  = ""
        } else if(segue.identifier == "goToLoginWithCode") {
            let NextVC = segue.destination as! JoinWithEventCodeViewController
        }
    }
    
    
   
}
