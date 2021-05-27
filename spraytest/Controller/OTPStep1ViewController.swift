//
//  OTPStep1ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/1/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class OTPStep1ViewController: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    var formValidation =   Validation()
    let customtextfield = CustomTextField()
    
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
    //let navBackButton = BackButtonOnNavBar()
    //var flowType: String =  ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        encryptedAPIKey = encryptdecrypt.encryptDecryptAPIKey(type: "", value: "", action: "encrypt")
        encryptedDeviceId = device.getDeviceId(userName: "")
        
        
        //navBackButton.currentVC
        
        
//        let backButtonImage = UIImage(named: "backicon")?.withRenderingMode(.alwaysTemplate)
//
//            let backButton = UIButton(type: .custom)
//            backButton.setImage(backButtonImage, for: .normal)
//            backButton.tintColor = .white
//            backButton.setTitle("  Back", for: .normal)
//            backButton.setTitleColor(.white, for: .normal)
//        backButton.addTarget(self, action: Selector(("backAction")), for: .touchUpInside)
//
//
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        if action == "forgotPassword" {
            screenTitle.text = "Reset Password - Let's Do Verification"
        } else {
            screenTitle.text = "Let's Do Verification"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        self.phoneNumberTextField.delegate = self
       
//        if let myImage = UIImage(named: "phone-icon") {
//            phoneNumberTextField.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.lightGray, colorBorder: UIColor.black)
//        }
        
       phoneNumberTextField.addTarget(self, action: #selector(OTPStep1ViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)

        // Do any additional setup after loading the view.
        
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
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setNavigationBar()
    }
    @IBAction func privacyPolicyBtnPressed(_ sender: Any) {
        launchPrivacyPolicyTermsConditions()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

        if text?.utf16.count==1{
            switch textField{
            case phoneNumberTextField:
                customtextfield.borderForTextField(textField: phoneNumberTextField, validationFlag: false)
            default:
                break
            }
        }else{

        }
    }

    func launchPrivacyPolicyTermsConditions() {
      
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyTermsConditionsViewController") as! PrivacyPolicyTermsConditionsViewController

        nextVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        nextVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext

        self.present(nextVC, animated: true, completion: nil)

    }
    @IBAction func getVerificationCode(_ sender: Any) {
        guard let phone = phoneNumberTextField.text else {
            return
        }
        
        let isValidatePhone = self.formValidation.validatePhoneNumber(phoneNumber: phone).isValidate
        let validationMessage = self.formValidation.validatePhoneNumber(phoneNumber: phone).errorMsg
        
        
        print("isValidatePhone \(isValidatePhone)")
        if (isValidatePhone == false) {
            phoneNumberTextField.becomeFirstResponder()
           //phoneNumberTextField.borderForTextField(textField: nameTextField, validationFlag: true)
            //print("Incorrect First Name")
            //call UI Alert
            phoneNumberTextField.isEnabled = true
            //self.presentUIAlert(alertMessage: "Incorrect Phone Number", alertTitle: "Missing Information", errorMessage: validationMessage, alertType: "formvalidation")
            
        
            return
        } else {
            customtextfield.borderForTextField(textField: phoneNumberTextField, validationFlag: false)
            
        }
        if isValidatePhone == true {
            requestOTPCode()
        }
    }
    
    func convertPhoneToString(phone: String) -> String {
        let phonestr1 = phone.replacingOccurrences(of: "[\\(\\)^^+-]", with: "", options: .regularExpression, range: nil)
        let phonestr2 = "+ \(phonestr1.replacingOccurrences(of: " ", with: ""))"
        return phonestr2
    }


    func requestOTPCode() {
        print("get OTCode was called")
        //let phone = phoneNumberTextField.text!
        //launchOTPVerifyVC(otpCode: otpCode, phone: phone)
        
        let phone = convertPhoneToString(phone: phoneNumberTextField.text!)
        
        let otpModel = OTPModel(phone: phone, email: "", code: "", message: "", profileId: 0)
        let request = PostRequest(path: "/api/otpverify/add", model: otpModel, token: "", apiKey: encryptedAPIKey, deviceId: encryptedDeviceId)

        print("request \(request)")
        Network.shared.send(request) { [self] (result: Result<OTPData, Error>)  in
        switch result {
        case .success(let otpdata):
            if otpdata.success == true {
                launchOTPVerifyVC(phone: phone)
            } else  {
                theAlertView(alertType: "otpcode", message: "")
            }
            print("success")
        case .failure(let error):

            theAlertView(alertType: "otpcode", message: error.localizedDescription)
            }
        }
        
    }
    
    func theAlertView(alertType: String, message: String){
        var alertTitle: String = ""
        var alertMessage: String = ""
        if alertType == "otpcode" {
            alertTitle = "OTP"
            alertMessage = "Something went wrong with the OTP Code. Please try again."
            
            
            
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
        
    func launchOTPVerifyVC(phone: String) {
        print("launchOTPVerifyVC was called")
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep2ViewController") as! OTPStep2ViewController
        //nextVC.otpCode = otpCode
        nextVC.otpPhone = phone
        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventTypeIcon = eventTypeIcon
        nextVC.eventCode = eventCode
        nextVC.eventType = eventType
        nextVC.action = action
        //nextVC.flowType = flowType
        self.navigationController?.pushViewController(nextVC, animated: true)
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
extension String {

    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

extension OTPStep1ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(string)
        //phoneNumberTextField.text = textField.text?.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
       
        let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            } else {
                guard let text = textField.text else { return false }
                textField.text = text.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#")
                //original with country code - will visit this later
                //textField.text = text.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 14
//        let maxLength = 17
//           let currentString: NSString = textField.text! as NSString
//           let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
//           return newString.length <= maxLength
        return true
    }
}

extension UITextField {

enum Direction {
    case Left
    case Right
}

// add image to textfield
func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
    mainView.layer.cornerRadius = 5

    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
    view.backgroundColor = .white
    view.clipsToBounds = true
    view.layer.cornerRadius = 5
    view.layer.borderWidth = CGFloat(0.0)
    view.layer.borderColor = colorBorder.cgColor
    mainView.addSubview(view)

    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
    view.addSubview(imageView)

    let seperatorView = UIView()
    seperatorView.backgroundColor = colorSeparator
    mainView.addSubview(seperatorView)

    if(Direction.Left == direction){ // image left
        seperatorView.frame = CGRect(x: 45, y: 0, width: 1, height: 45)
        self.leftViewMode = .always
        self.leftView = mainView
    } else { // image right
        seperatorView.frame = CGRect(x: 0, y: 0, width: 1, height: 45)
        self.rightViewMode = .always
        self.rightView = mainView
    }

    self.layer.borderColor = colorBorder.cgColor
    self.layer.borderWidth = CGFloat(0.5)
    self.layer.cornerRadius = 5
}

}
