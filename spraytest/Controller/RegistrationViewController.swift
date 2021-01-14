//
//  RegistrationViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
//    var eventCode: String?
//    var message: String?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!

    @IBOutlet weak var eventCodeTextField: UITextField!

    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordConfirmLabel: UILabel!

    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordConfirmErrorLabel: UILabel!

    //declare register form variables
    var firstName: String?
    var lastName: String?
    var username: String?
    var password: String?
    var confirmPassword: String?
    var email: String = ""
    var phone: String?
    var userdata: UserData?
    var token2pass: String?
    var profileId: String?
    var eventCode: String?
    var message: String?
    //instanciate the network object
   //let registrationManager = NetworkManager2()

    var formValidation =   Validation()
    let customtextfield = CustomTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameErrorLabel.text = ""
        lastNameErrorLabel.text = ""
        emailErrorLabel.text = ""
        //phoneErrorLabel.text = ""
        passwordErrorLabel.text = ""
        passwordConfirmErrorLabel.text = ""
        loadingLabel.text = ""
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        //phoneTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
//        firstNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            
        firstNameTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        //firstNameTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                     //for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                    for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                 for: .editingChanged)
//        phoneTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
//                                 for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                    for: .editingChanged)
        passwordConfirmTextField.addTarget(self, action: #selector(RegistrationViewController.textFieldDidChange(_:)),
                                           for: .editingChanged)
        
        
//        firstNameLabel.isHidden = true
//        lastNameLabel.isHidden = true
//        emailLabel.isHidden = true
//        phoneLabel.isHidden = true
//        passwordLabel.isHidden = true
//        passwordConfirmLabel.isHidden = true
        customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
        //customtextfield.borderForTextField(textField: phoneTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventCodeTextField, validationFlag: false)




       // loadingLabel.text! = message!

        // Do any additional setup after loading the view.
//        navigationItem.hidesBackButton = false
//        navigationController?.setNavigationBarHidden(true, animated: true)
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
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==1{
                switch textField{
                case firstNameTextField:
                    //firstNameLabel.isHidden = false
                    //firstNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: false)
                    firstNameErrorLabel.text = ""
//                    tf2.becomeFirstResponder()
                case lastNameTextField:
                    //lastNameLabel.isHidden = false
                    //lastNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
                    lastNameErrorLabel.text = ""
                case emailTextField:
                    //emailLabel.isHidden = false
                    //emailLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: emailTextField, validationFlag: false)
                    emailErrorLabel.text = ""
//                case phoneTextField:
//                   // phoneLabel.isHidden = false
//                   // phoneLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//                    customtextfield.borderForTextField(textField: phoneTextField, validationFlag: false)
//                    phoneErrorLabel.text = ""
                case passwordTextField:
                    //passwordLabel.isHidden = false
                    //passwordLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
                    passwordErrorLabel.text = ""
                case passwordConfirmTextField:   //passwordConfirmLabel.isHidden = false
                    //passwordConfirmLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
                    customtextfield.borderForTextField(textField: passwordConfirmTextField, validationFlag: false)
                    passwordConfirmErrorLabel.text = ""
                default:
                    break
                }
            }else{

            }
    }

    
//    @IBAction func firstNameEdit(_ sender: Any) {
//        //firstNameTextField.placeholder = ""
//        firstNameLabel.isHidden = false
//        firstNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//    }
//
//    @IBAction func lastNameEdit(_ sender: Any) {
//        lastNameLabel.isHidden = false
//        lastNameLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//    }
//
//
//    @IBAction func emailEdit(_ sender: Any) {
//        emailLabel.isHidden = false
//        emailLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//    }
//
//    @IBAction func phoneEdit(_ sender: Any) {
//        phoneLabel.isHidden = false
//        phoneLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//    }
//
//
//    @IBAction func passwordEdit(_ sender: Any) {
//        passwordLabel.isHidden = false
//        passwordLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//    }
//
//    @IBAction func passwordConfirmEdit(_ sender: Any) {
//        passwordConfirmLabel.isHidden = false
//        passwordConfirmLabel.textColor = UIColor(red: 0/256, green: 128/256, blue: 128/256, alpha: 1.0)
//    }



    //    @IBAction func postRequestButtonPressed(_ sender: UIButton) {
//
//        loadingLabel.text = "Loading..."
//
//        let newUser = User(id: 2, name: "Peter", username: "Livesey", email: "941ecfff8dc3@medium.com")
//        let request = PostRequest(path: "/users", model: newUser)
//        Network.shared.send(request) { (result: Result<Empty, Error>) in
//            switch result {
//            case .success:
//                self.loadingLabel.text = "Got an empty, successful result"
//            case .failure(let error):
//                self.loadingLabel.text = error.localizedDescription
//            }
//        }
//    }




//
//    @IBAction func getRequestButtonPressed(_ sender: UIButton) {
//
//        loadingLabel.text = "Loading..."
//
//        let request = Request(path: "users/1",token: "")
//        Network.shared.send(request) { (result: Result<User, Error>) in
//            switch result {
//            case .success(let user):
//                self.loadingLabel.text = "Dominic Ighedosa = \(user)"
//                print(user)
//            case .failure(let error):
//                self.loadingLabel.text = error.localizedDescription
//            }
//        }
//
//    }

    private func borderForTextField(textField: UITextField, validationFlag: Bool) {

        if validationFlag == false {
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 211/256, green: 211/256, blue: 211/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
        } else {
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
        }


        //textField.layer.addSublayer(bottomLine)

    }
    private func addBottomLineToTextField(textField: UITextField, validationFlag: Bool) {

            let bottomLine = CALayer()
           bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width - 1, height: 1)

        if validationFlag == true {
            bottomLine.backgroundColor = UIColor.init(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0).cgColor
        } else {
            bottomLine.backgroundColor = UIColor.init(red: 211/256, green: 211/256, blue: 211/256, alpha: 1.0).cgColor
        }

        //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
        textField.borderStyle = .none

        textField.layer.addSublayer(bottomLine)
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
                self.loadingLabel.text = error.localizedDescription
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
    @IBAction func registerButtonPressed(_ sender: UIButton) {

        guard let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text,
        //let phone = phoneTextField.text,
        let password = passwordTextField.text,
        let confirmPassword = passwordConfirmTextField.text,
        let email = emailTextField.text else {
            return
        }
        eventCode = eventCodeTextField.text!
        username = emailTextField.text!

//        guard let name = validateNameTxtFld.text, let email = validateEmailTxtFld.text, let password = validatePasswordTxtFld.text,
//              let phone = validatePhoneTxtFld.text else {
//                 return
//              }
        
        let isValidateFirstName = self.formValidation.validateName2(name2: firstName).isValidate
        
        //let isValidateFirstName = self.formValidation.validateName2(name2: firstName)
        if (isValidateFirstName == false) {
            firstNameTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: true)
            //print("Incorrect First Name")
            loadingLabel.text = "Incorrect First Name"
            firstNameErrorLabel.text = "Incorrect First Name"
            return
        } else {
            customtextfield.borderForTextField(textField: firstNameTextField, validationFlag: false)
            firstNameErrorLabel.text = ""
        }

        let isValidateLastName = self.formValidation.validateName(name: lastName)
        if (isValidateLastName == false) {
            lastNameTextField.becomeFirstResponder()
            self.borderForTextField(textField: lastNameTextField, validationFlag: true)
            //print("Incorrect Last Name")
            lastNameErrorLabel.text = "Incorrect Last Name"
            loadingLabel.text = "Incorrect Last Name"
         return
        } else {
            customtextfield.borderForTextField(textField: lastNameTextField, validationFlag: false)
            lastNameErrorLabel.text = ""
        }
       
        let isValidateEmail = self.formValidation.validateEmailId(emailID: email)
        if (isValidateEmail == false) {
            emailTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField:  emailTextField, validationFlag: true)
            //print("Incorrect Email")
            emailErrorLabel.text = "Incorrect Email"
            loadingLabel.text = "Incorrect Email"
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
            loadingLabel.text = "Incorrect Password"
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
            loadingLabel.text = "Password Mismatch"
        } else {
            passwordMatch = true
        }

        if (isValidateFirstName == true && isValidateLastName == true && isValidateEmail == true && isValidatePass == true && passwordMatch == true) {
                 print("All fields are correct")

            
           
            
            //let newUser = UserModel(id: 2, name: "Peter", username: "Livesey", email: "941ecfff8dc3@medium.com")
            let userData = UserModel(firstName: firstName, lastName: lastName, username: username!, password: password, email: email, phone: ".")

            print(userData)
            let request = PostRequest(path: "/api/Profile/register", model: userData, token: "")
            Network.shared.send(request) { (result: Result<UserData, Error>) in
                switch result {
                case .success(let userdata):
                    self.userdata = userdata
                    print(userdata)
                    //call authentication func
                    self.authenticateUser(userName: self.username!, password: password, phone: "", email: email, eventCode: self.eventCode!)
//                    self.loadingLabel.text = "Registration was successful..."
                    self.loadingLabel.textColor = UIColor(red: 82/256, green: 156/256, blue: 32/256, alpha: 1.0)
                    self.loadingLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                    self.loadingLabel.text = "Registration is complete."
                    self.scroll2Top()
                case .failure(let error):
                    self.loadingLabel.text = error.localizedDescription
                }
            }
        }

        //let userProfileData = ProfileModel(firstName: firstName, lastName: lastName, username: username, password: password, email: email, phone: phone)

        //let postString = "firstName=Dom&lastName=Ighe&username=domu&password=abci12&email=myemai&phone=1234";
        //let postString = "[firstName="+firstName+"&lastName="+lastName+"&username="+username+"&password="+password+"&email="+email+"&phone="+phone"]

        // registrationManager.hitAPI(_for: //"https://projectxapiapp.azurewebsites.net/api/Profile/register", d)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Reg2MenuTab"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass
            //                          displayVC.token = token2pass
            //                          displayVC.userdata = userdata
        }

    }
    @IBOutlet var label: UILabel!

//       @IBAction func sendGETRequest() {
//           label.text = "Loading..."
//
//           let request = Request(path: "users/1", token: "")
//           Network.shared.send(request) { (result: Result<User, Error>) in
//               switch result {
//               case .success(let user):
//                   self.label.text = "\(user)"
//               case .failure(let error):
//                   self.label.text = error.localizedDescription
//               }
//           }
//       }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
