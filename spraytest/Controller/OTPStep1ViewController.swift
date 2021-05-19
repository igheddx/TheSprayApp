//
//  OTPStep1ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/1/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class OTPStep1ViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        self.phoneNumberTextField.delegate = self
       
        if let myImage = UIImage(named: "phone-icon") {
            phoneNumberTextField.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.lightGray, colorBorder: UIColor.black)
        }
       phoneNumberTextField.addTarget(self, action: #selector(OTPStep1ViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)

        // Do any additional setup after loading the view.
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
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
            presentUIAlert(alertMessage: "Incorrect Phone Number", alertTitle: "Missing Information", errorMessage: validationMessage, alertType: "formvalidation")
            return
        } else {
            customtextfield.borderForTextField(textField: phoneNumberTextField, validationFlag: false)
            
        }
        if isValidatePhone == true {
            getOTPCode()
        }
        
        
        
    }
    
    func getOTPCode() {
        print("get OTCode was called")
        let otpCode = 12345
        let phone = phoneNumberTextField.text!
        launchOTPVerifyVC(otpCode: otpCode, phone: phone)
    }
    func launchOTPVerifyVC(otpCode: Int, phone: String) {
        print("launchOTPVerifyVC was called")
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "OTPStep2ViewController") as! OTPStep2ViewController
        nextVC.otpCode = otpCode
        nextVC.otpPhone = phone
        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventTypeIcon = eventTypeIcon
        nextVC.eventCode = eventCode
        nextVC.eventType = eventType
        nextVC.action = action
        
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
