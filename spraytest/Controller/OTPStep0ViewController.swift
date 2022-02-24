//
//  OTPStep0ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/28/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class OTPStep0ViewController: UIViewController, UITextFieldDelegate {
    
    var email: String = ""
    var action: String = ""
    
    var formValidation =   Validation()
    let customtextfield = CustomTextField()
    var setstatusbarbgcolor = StatusBarBackgroundColor()
    var encryptedAPIKey: String = ""
    var encryptedDeviceId: String = ""
    let device = Device()
    let encryptdecrypt = EncryptDecrpyt()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("launchOTPVerifyVC was called = \(action)")
        
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
        
        setstatusbarbgcolor.setBackground()
        self.emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(OTPStep0ViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
        //customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
        
        setNavigationBar()
    }
    

    @IBAction func continueBtnPressed(_ sender: Any) {
        //let email = emailTextField.text!
        guard let email = emailTextField.text else {
            return
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
        }
        
        
        if isValidateEmail == true {
            launchOTPGetCodeVC(email: email)
        }
        
        
    }
    
    /*turn status bar to white color*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    func verifyEmail(email: String) {
        let request = Request(path: "/api/Profile/phonecheck/\(email)", token: "", apiKey: encryptedAPIKey)
        
        print("request=\(request)")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
        case .success(let emailVerify):
            
            
            break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
        print(" DOMINIC B IGHEDOSA ERROR \(error.localizedDescription)")
                    
            }
                  
        }
    }
    func launchOTPGetCodeVC(email: String) {
        
        print("launchOTPVerifyVC was called = \(action)")
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep2ViewController") as! OTPStep2ViewController
        //nextVC.otpCode = otpCode
        nextVC.email = email
        nextVC.action = action
        //nextVC.flowType = flowType
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

        if text?.utf16.count==1{
            switch textField{
            case emailTextField:
                customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
            default:
                break
            }
        }else{

        }
    }
    func setNavigationBar() {
//        print("I was called")
//        let screenSize: CGRect = UIScreen.main.bounds
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
//        let navItem = UINavigationItem(title: "")
//        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
//        let doneItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(done))
//           navItem.leftBarButtonItem = doneItem
//           navBar.setItems([navItem], animated: false)
//           self.view.addSubview(navBar)
        
        
        print("I was called")
//        let screenSize: CGRect = UIScreen.main.bounds
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
//        let navItem = UINavigationItem(title: "")
//        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
//        let doneItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(done))
//           navItem.leftBarButtonItem = doneItem
//           navBar.setItems([navItem], animated: false)
//           self.view.addSubview(navBar)
        
        
        print("I was called")
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Password Reset")
        //let navItem2 = UINavigationItem(title: "Step 1 of 3")
        
       
        //let item =  UIBarButtonItem(customView: customView)
//        rbar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        //navigationItem.rightBarButtonItems = [rbar]
        
        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
        //let doneItem2 = UIBarButtonItem(barButtonSystemItem: , style: .plain, target: nil, action: #selector(done))
        let doneItem = UIBarButtonItem(image: UIImage(systemName: "xmark") , style: .plain, target: nil, action: #selector(done))
       // let doneItem2 = UIBarButtonItem(systemItem: .close, primaryAction: closeAction, menu: nil)
        //navItem.rightBarButtonItem  = doneItem2
        
        let rbar = UIBarButtonItem(title: "Step 1 of 3", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        rbar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        
        //navItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
