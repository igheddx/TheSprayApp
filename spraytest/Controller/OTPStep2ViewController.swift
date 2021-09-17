//
//  OTPStep2ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/1/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class OTPStep2ViewController: UIViewController {
    
    @IBOutlet weak var verifyBtn: MyCustomButton!
    var otpCode: String = ""
    var otpPhone: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var username: String?
    var password: String?
    var confirmPassword: String?
    var email: String = ""
    var phone: String = ""
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
    var action: String = ""
    var encryptedAPIKey: String = ""
    var encryptedDeviceId: String = ""
    let device = Device()
    let encryptdecrypt = EncryptDecrpyt()
    var setstatusbarbgcolor = StatusBarBackgroundColor()
    //var flowType: String =  ""
    
    
    
    @IBOutlet weak var otpTextField: OneTimeCodeTextField!
    //@IBOutlet weak var otpTextField1: OneTimeCodeTextField!
//    @IBOutlet weak var otpTextField2: UITextField!
//    @IBOutlet weak var otpTextField3: UITextField!
//    @IBOutlet weak var otpTextField4: UITextField!
//    @IBOutlet weak var otpTextField5: UITextField!
//
    //@IBOutlet weak var otpTextField6: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
        //encryptedDeviceId = device.getDeviceId(userName: "")
        
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
    @IBAction func verifyOTP(_ sender: Any) {
        //LoadingStart()
        print("otp button \(otpCode)")
        if action == "forgotPassword" {
            launchNextVC()
        } else {
            launchNextVC()
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
        requestOTPCode() 
    }
    
    func requestOTPCode() {
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
        
        if action == "createAccountQRScan" {
        
            print("launchCreateAccountVC was called")
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountQRScanViewController") as! CreateAccountQRScanViewController
            nextVC.eventName = eventName
            nextVC.eventDateTime = eventDateTime
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventCode = eventCode
            nextVC.eventType = eventType
            nextVC.otpCode = otpCode
            nextVC.email = email
            nextVC.encryptedAPIKey = encryptedAPIKey
            nextVC.encryptedDeviceId = encryptedDeviceId
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else if action == "createAccount" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
            nextVC.phoneFromOTP = otpPhone
            nextVC.otpCode = otpCode
            nextVC.email = email
            nextVC.encryptedAPIKey = encryptedAPIKey
            nextVC.encryptedDeviceId = encryptedDeviceId
            self.navigationController?.pushViewController(nextVC , animated: true)
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
