//
//  OTPStep2ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/1/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class OTPStep2ViewController: UIViewController {

    var otpCode: Int = 0
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
    //var flowType: String =  ""
    
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var otpTextField5: UITextField!
    
    @IBOutlet weak var otpTextField6: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        self.otpTextField1.delegate = self
        self.otpTextField2.delegate = self
        self.otpTextField3.delegate = self
        self.otpTextField4.delegate = self
        self.otpTextField5.delegate = self
        self.otpTextField6.delegate = self
        
        self.otpTextField1.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.otpTextField2.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.otpTextField3.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.otpTextField4.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        self.otpTextField5.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        
        self.otpTextField6.addTarget(self, action: #selector(self.changeCharacter), for: .editingChanged)
        
        otpTextField1.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        print("OTP = \(otpCode)")
        print("otp phone = \(otpPhone)")
        // Do any additional setup after loading the view.
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
    @objc func changeCharacter(textField: UITextField) {
        if textField.text?.utf8.count == 1 {
            switch textField {
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField5.becomeFirstResponder()
            case otpTextField5:
                otpTextField6.becomeFirstResponder()
            case otpTextField6:
                //otpTextField2.becomeFirstResponder()
                print("print value")
            default:
                break
            }
        } else {
            switch textField {
            case otpTextField6:
                otpTextField5.becomeFirstResponder()
            case otpTextField5:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField1.becomeFirstResponder()
          
                //otpTextField2.becomeFirstResponder()
                print("print value")
            default:
                break
            }
        }
    }
    @IBAction func verifyOTP(_ sender: Any) {
        verifyOTPCode(otpcode: otpCode)
    }
    func verifyOTPCode(otpcode: Int) {
        print("OTP was verified")
        
        
        launchNextVC()
    
        
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
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else if action == "createAccount" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
            nextVC.phoneFromOTP = otpPhone
            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if action == "forgotPassword" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
            nextVC.phoneFromOTP = otpPhone
            nextVC.action = action 
            self.navigationController?.pushViewController(nextVC , animated: true)
        }
    }
}

extension OTPStep2ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.utf16.count == 1 && !string.isEmpty {
            return false
        } else {
            return true
        }
    }
}
