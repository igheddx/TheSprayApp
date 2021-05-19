//
//  JoinEventWithQRCodeViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class JoinEventWithQRCodeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventCodeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!

    @IBOutlet weak var loginIdErrorLabel: UILabel!
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var token: String?
    var eventName: String = ""
    var eventCode: String = ""
    var eventDate: String = ""
    var eventTypeIcon: String?
    var username: String = ""
    var password: String = ""
    var token2pass: String = ""
    var paymentClientToken: String = ""
    var userdata: UserData?
    var profileId: String?
    var phone: String = ""
    let customtextfield = CustomTextField()
    var encryptedAPIKey: String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameLabel.text = eventName
        eventDateLabel.text = eventDate
        eventImage.image = UIImage(named: eventTypeIcon!)
        eventCodeLabel.text = eventCode
        // Do any additional setup after loading the view.
        loginIdErrorLabel.text = ""
        passwordErrorLabel.text = ""
        
        customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
     
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        case usernameTextField:
            usernameTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        username = usernameTextField.text!
        password = passwordTextField.text!
        //eventCode = eventCodeTextField.text!
        
        if username == "" {
            loginIdErrorLabel.text = "Log In field cannot be empty."
        }
        if password == "" {
            passwordErrorLabel.text = "Password field cannot be empty."
        }
   
        
        //let encryptedAPIKey = username + "|" + self.encryptedAPIKey
        if (username != "" && password != "" ) {
            let authenticatedUserProfile = AuthenticateUser(username: self.username, password: self.password)
            let request = PostRequest(path: "/api/Profile/authenticate", model: authenticatedUserProfile, token: "", apiKey: encryptedAPIKey, deviceId: "")
                   
            Network.shared.send(request) { (result: Result<UserData, Error>)  in
               switch result {
               case .success(let user):
                   self.token2pass = user.token!
                   self.userdata = user
                   self.profileId = String(user.profileId!)
                   self.phone = ""
                   
                   //call payment initialization
                   self.initializePayment(token: user.token!, profileId: user.profileId!, firstName: user.firstName!, lastName: user.lastName!, userName: "", email: user.email!, phone: "")
                   
                   print(" this is dominic \(user)")
                   //add user to event
                      if self.eventCode != "" {
                        self.addToEvent(profileId: user.profileId!, email: user.email!, phone: self.phone, eventCode: self.eventCode, token: self.token2pass)
      
                      }
                   
                   //self.labelMessage.text = "Got an empty, successful result"
               
                   
               case .failure(let error):
                   if self.eventCode != "" {
                       //                                  self.addToEvent(profileId: user.profileId!, email: user.email!, phone: self.phone, eventCode:       self.eventCode!, token: self.token2pass)
                       let goToNextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
                       goToNextVC.eventCode = self.eventCode
                       goToNextVC.message = "Please register to continue..."
                            //nextVC.eventName = eventName
                            //nextVC.eventId = eventId
                            //nextVC.profileId = profileId
                            //nextVC.token = token
                            //nextVC.paymentClientToken  =  paymentClientToken

                       self.navigationController?.pushViewController(goToNextVC , animated: true)
                   }
                   self.loginIdErrorLabel.text = error.localizedDescription
               }
               
              
           }
                   
        }
        
    }
    
    //Initialize payment
    func initializePayment(token: String, profileId: Int64, firstName: String, lastName: String, userName: String, email: String, phone: String) {
       let initPayment = InitializePaymentModel(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone)
        let request = PostRequest(path: "/api/Profile/initialize", model: initPayment, token: token, apiKey: encryptedAPIKey, deviceId: "")
        
       
       
         Network.shared.send(request) { (result: Result<InitializePaymentData, Error>)  in
            switch result {
            case .success(let paymentInit):
               self.paymentClientToken = paymentInit.clientToken!
               
               print("paymentClientToken = \(self.paymentClientToken)")

                self.performSegue(withIdentifier: "fromJoinWithQRToHomeScreen", sender: nil)
            case .failure(let error):
                self.loginIdErrorLabel.text = error.localizedDescription
            }
            
           
        }
       
   }
      
      func addToEvent(profileId: Int64, email: String, phone: String, eventCode: String, token: String) {

             let Invite = JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])
             
             let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token, apiKey: encryptedAPIKey, deviceId: "")
             
             
             Network.shared.send(request) { (result: Result<Data, Error>)  in
                 switch result {
                 case .success( _): break
                 case .failure(let error):
                     print(error.localizedDescription)
                 }
             }
                        
         }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //closing loading
    self.dismiss(animated: false, completion: nil)
           
        if(segue.identifier == "goToQRCodeRegister"){
            let NextVC = segue.destination as! RegisterWithQRCodeViewController
            NextVC.eventCode = eventCode
            NextVC.eventName = eventName
            NextVC.eventTypeIcon = eventTypeIcon!
            NextVC.eventDate = eventDate
        } else if(segue.identifier == "fromJoinWithQRToHomeScreen"){
            let NextVC = segue.destination as! MenuTabViewController
            NextVC.profileId = Int64(profileId!)
            NextVC.token = token2pass
            NextVC.encryptedAPIKey = encryptedAPIKey
            NextVC.paymentClientToken = paymentClientToken
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
