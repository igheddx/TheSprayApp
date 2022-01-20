//
//  ErrorMessageViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/17/22.
//  Copyright © 2022 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import UIKit
import LocalAuthentication
import SwiftKeychainWrapper
class ErrorMessageViewController: UIViewController {



    @IBOutlet weak var signBtn: MyCustomButton!
    
    //@IBOutlet weak var verifyBtn: MyCustomButton!
    var otpCode: String = ""
    var otpPhone: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var username: String = ""
    var password: String = ""
    var confirmPassword: String?
    var email: String = ""
    var phone: String = ""
    var token: String = ""
    var userdata: UserData?
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
    
    //@IBOutlet weak var otpTextField: OneTimeCodeTextField!
    
    //@IBOutlet weak var verificationLbl: UILabel!
    //@IBOutlet weak var otpTextField1: OneTimeCodeTextField!
//    @IBOutlet weak var otpTextField2: UITextField!
//    @IBOutlet weak var otpTextField3: UITextField!
//    @IBOutlet weak var otpTextField4: UITextField!
//    @IBOutlet weak var otpTextField5: UITextField!
//
    //@IBOutlet weak var otpTextField6: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //verificationLbl.text = "We have sent a text to phone number ***-***-1234. Please enter the 6-digit verification and continue."
        
        print("BIG D \(firstName) \(lastName) \(username) \(password)")
        //encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
        //encryptedDeviceId = device.getDeviceId(userName: "")
        
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt") //encryptData(value: apiKeyValue)
        
      
        
        setstatusbarbgcolor.setBackground()
       
        setNavigationBar()
    }
    
    @IBAction func signIn(_ sender: Any) {
        callLoginScreen()
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
            titleStep = ""
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
    
    
    func sendEmail(toEmail:String, toFirstName: String, toLastName: String, subject: String, message: String, ccList: [String]) {
        
        let sendEmailData = SendEmail(toEmail: toEmail, toFirstName: toFirstName, toLastName: toLastName, subject: subject, message: message, ccList: ccList)
        
        print("sendEmailData \(sendEmailData)")
        let request = PostRequest(path: "/api/Profile/email", model: sendEmailData, token: token, apiKey: encryptedAPIKey, deviceId: "")
    
        
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
