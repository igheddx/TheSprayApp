//
//  RegisterWithQRCodeViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class RegisterWithQRCodeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventCodeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!

    @IBOutlet weak var fullnameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordConfirmErrorLabel: UILabel!
    
    var token: String?
    var eventName: String?
    var eventCode: String?
    var eventDate: String?
    var eventTypeIcon: String?
    
    //declare register form variables
    var fullName: String?
    var username: String?
    var password: String?
    var confirmPassword: String?
    var email: String = ""
    var userdata: UserData?
    var token2pass: String?
    var profileId: String?
    var message: String?
    //instanciate the network object
   //let registrationManager = NetworkManager2()

    var formValidation =   Validation()
    let customtextfield = CustomTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameLabel.text = eventName
        eventDateLabel.text = eventDate
        eventImage.image = UIImage(named: eventTypeIcon!)
        eventCodeLabel.text = eventCode
        // Do any additional setup after loading the view.
        fullnameErrorLabel.text = ""
        emailErrorLabel.text = ""
        passwordErrorLabel.text = ""
        passwordConfirmErrorLabel.text = ""
        
        fullNameTextField.delegate = self
        //lastNameTextField.delegate = self
        emailTextField.delegate = self
        //phoneTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
        
        fullNameTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)

        emailTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                 for: .editingChanged)

        passwordTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                    for: .editingChanged)
        passwordConfirmTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                           for: .editingChanged)
        
        customtextfield.borderForTextField(textField: fullNameTextField, validationFlag: false)
        //customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
        //customtextfield.borderForTextField(textField: phoneTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)

        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

    func scroll2Top() {
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    //dismiss keyboard when return is selected
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        case passwordConfirmTextField:
            passwordConfirmTextField.resignFirstResponder()
        case fullNameTextField:
            fullNameTextField.resignFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==1{
                switch textField{
                case fullNameTextField:
                    customtextfield.borderForTextField(textField: fullNameTextField, validationFlag: false)
                    fullnameErrorLabel.text = ""
                case emailTextField:
                    customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
                    emailErrorLabel.text = ""
                case passwordTextField:
                    customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
                    passwordErrorLabel.text = ""
                case passwordConfirmTextField:
                    customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)
                    passwordConfirmErrorLabel.text = ""
                default:
                    break
                }
            }else{

            }
    }
    
    func authenticateUser(userName:String,password: String, phone: String, email: String,  eventCode: String) {
        //******************** After creating account; authenticating to get Token *****************************
        let authenticatedUserProfile = AuthenticateUser(username: userName, password: password)
        let request = PostRequest(path: "/api/Profile/authenticate", model: authenticatedUserProfile, token: "")



        Network.shared.send(request) { (result: Result<UserData, Error>)  in
            switch result {
            case .success(let user):
                self.token2pass = user.token!
                self.userdata = user
                self.profileId = String(user.profileId!)

                print(" this is dominic \(user)")

                //add user to event
                if self.eventCode != "" {
                    self.addToEvent(profileId: user.profileId!, email: self.email, phone: "", eventCode: eventCode, token: self.token2pass!)

                }

                self.performSegue(withIdentifier: "Reg2MenuTab", sender: nil)

                //self.labelMessage.text = "Got an empty, successful result"


            case .failure(let error):
                self.fullnameErrorLabel.text = error.localizedDescription
            }
        }

}

    func addToEvent(profileId: Int64, email: String, phone: String, eventCode: String, token: String) {

        let Invite =  JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])

        let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token)


        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let fullName = fullNameTextField.text,
        //let lastName = lastNameTextField.text,
        //let phone = phoneTextField.text,
        let password = passwordTextField.text,
        let confirmPassword = passwordConfirmTextField.text,
        let email = emailTextField.text else {
            return
        }
      
        username = emailTextField.text!

//        guard let name = validateNameTxtFld.text, let email = validateEmailTxtFld.text, let password = validatePasswordTxtFld.text,
//              let phone = validatePhoneTxtFld.text else {
//                 return
//              }
        
        let isValidateFirstName = self.formValidation.validateName2(name2: fullName).isValidate
        
        //let isValidateFirstName = self.formValidation.validateName2(name2: firstName)
        if (isValidateFirstName == false) {
            fullNameTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: fullNameTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            fullnameErrorLabel.text = "Incorrect Full Name"
            return
        } else {
            customtextfield.borderForTextField(textField: fullNameTextField, validationFlag: false)
            fullnameErrorLabel.text = ""
        }

//        let isValidateLastName = self.formValidation.validateName(name: lastName)
//        if (isValidateLastName == false) {
//            lastNameTextField.becomeFirstResponder()
//            self.borderForTextField(textField: lastNameTextField, validationFlag: true)
//            //print("Incorrect Last Name")
//            lastNameErrorLabel.text = "Incorrect Last Name"
//            loadingLabel.text = "Incorrect Last Name"
//         return
//        } else {
//            customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
//            lastNameErrorLabel.text = ""
//        }
       
        let isValidateEmail = self.formValidation.validateEmailId(emailID: email)
        if (isValidateEmail == false) {
            emailTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  emailTextField, validationFlag: true)
            //print("Incorrect Email")
            emailErrorLabel.text = "Incorrect Email Format"
            //loadingLabel.text = "Incorrect Email"
         return
        }else {
            customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
            emailErrorLabel.text = ""
        }


//        let isValidatePhone = self.formValidation.validaPhoneNumber(phoneNumber: phone)
//        if (isValidatePhone == false) {
//            phoneTextField.becomeFirstResponder()
//            customtextfield.borderForTextField(textField:  phoneTextField, validationFlag: true)
//        phoneErrorLabel.text = "Incorrect Phone"
//            loadingLabel.text = "Incorrect Phone"
//
//            return
//        } else {
//            customtextfield.borderForTextField(textField: phoneTextField, validationFlag: false)
//            phoneErrorLabel.text = ""
//        }

        let isValidatePass = self.formValidation.validatePassword(password: password)
        if (isValidatePass == false) {
            passwordTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  passwordTextField, validationFlag: true)
            //print("Incorrect Password")
            passwordErrorLabel.text = "Incorrect Password"
            //loadingLabel.text = "Incorrect Password"
            return
        } else {
            customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
            passwordErrorLabel.text = ""
        }

        var passwordMatch: Bool = false
        if password != confirmPassword {
        
            passwordMatch = false
            passwordConfirmTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  passwordConfirmTextField, validationFlag: true)
            passwordConfirmErrorLabel.text = "Incorrect Mismatch"
            //loadingLabel.text = "Password Mismatch"
        } else {
            passwordMatch = true
        }

        if (isValidateFirstName == true && isValidateEmail == true && isValidatePass == true && passwordMatch == true) {
                 print("All fields are correct")

            
           
            
            //let newUser = UserModel(id: 2, name: "Peter", username: "Livesey", email: "941ecfff8dc3@medium.com")
            let userData = UserModel(firstName: fullName, lastName: ".", username: username!, password: password, email: email, phone: ".")

            print(userData)
            let request = PostRequest(path: "/api/Profile/register", model: userData, token: "")
            Network.shared.send(request) { (result: Result<UserData, Error>) in
                switch result {
                case .success(let userdata):
                    self.userdata = userdata
                    print(userdata)
                    //call authentication func
                    self.authenticateUser(userName: self.username!, password: password, phone: "", email: email, eventCode: self.eventCode!)
                    
                    self.performSegue(withIdentifier: "fromQRRegisterToHomeScreen", sender: self)
//                    self.loadingLabel.text = "Registration was successful..."
                    //self.loadingLabel.textColor = UIColor(red: 82/256, green: 156/256, blue: 32/256, alpha: 1.0)
                    //self.loadingLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                    //self.loadingLabel.text = "Registration is complete."
                    //self.scroll2Top()
                case .failure(let error):
                    self.fullnameErrorLabel.text = error.localizedDescription
                }
            }
        }

        //let userProfileData = ProfileModel(firstName: firstName, lastName: lastName, username: username, password: password, email: email, phone: phone)

        //let postString = "firstName=Dom&lastName=Ighe&username=domu&password=abci12&email=myemai&phone=1234";
        //let postString = "[firstName="+firstName+"&lastName="+lastName+"&username="+username+"&password="+password+"&email="+email+"&phone="+phone"]

        // registrationManager.hitAPI(_for: //"https://projectxapiapp.azurewebsites.net/api/Profile/register", d)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromQRRegisterToHomeScreen"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass

        } else if(segue.identifier == "fromQRRegisterToQRLogin"){
            let NextVC = segue.destination as! JoinEventWithQRCodeViewController
            NextVC.eventCode = eventCode!
            NextVC.eventName = eventName!
            NextVC.eventTypeIcon = eventTypeIcon!
            NextVC.eventDate = eventDate!
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
