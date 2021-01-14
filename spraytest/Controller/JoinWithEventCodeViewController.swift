//
//  JoinWithEventCodeViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 8/16/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class JoinWithEventCodeViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eventCodeTextField: UITextField!
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var dataToSendTextField: UILabel!
    
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    //declare input variable
    var username: String = ""
    var password: String = ""
    var eventCode: String = ""
    var message: String = ""
    
    var firstname2pass: String?
    var lastname2pass: String = ""
    var token2pass: String = ""
    var paymentClientToken: String = ""
    var userdata: UserData?
    var profileId: String?
    var phone: String = ""
    let customtextfield = CustomTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.title = "Login And Join With Event Code"
//
//        navigationItem.backBarButtonItem = UIBarButtonItem(
//            title: "Back", style: .plain, target: nil, action: nil)
        
        customtextfield.borderForTextField(textField: usernameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: passwordTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventCodeTextField, validationFlag: false)
              // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        loginErrorLabel.text = ""
        passwordErrorLabel.text = ""
        labelMessage.text = ""
        
        setNavigationBar()
    }
    func setNavigationBar() {
        //let height = navigationController?.navigationBar.frame.maxY
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 0))
        let navItem = UINavigationItem(title: "Login With Event Code")
        //let back = UIImage(named: "gobackicon")?.withRenderingMode(.alwaysOriginal)
            //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: back, style:.plain, target: nil, action: nil)
        //let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.s, target: <#T##Any?#>, action: <#T##Selector?#>)
        //let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(done))
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
               //set image for button
        button.setImage(UIImage(named: "gobackicon"), for: UIControl.State.normal)
               //add function for button
        button.addTarget(self, action: #selector(done), for: UIControl.Event.touchUpInside)
               //set frame
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 0)

               let barButton = UIBarButtonItem(customView: button)
               //assign button to navigationbar
               //self.navigationItem.rightBarButtonItem = barButton
        
        navItem.leftBarButtonItem = barButton
        navBar.setItems([navItem], animated: true)
        self.view.addSubview(navBar)
        
        //create a new button
        
        
//        let imageView = UIImageView(image: UIImage(named: "backicon"))
//        let buttonItem = UIBarButtonItem(customView: imageView)
//        self.navigationItem.leftBarButtonItem = buttonItem
        
//        let back = UIImage(named: "backicon")?.withRenderingMode(.alwaysOriginal)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: back, style:.plain, target: nil, action: nil)
//
        
//        let button = UIButton(type: UIButton.ButtonType.custom)
//        button.setImage(UIImage(named: "gobackicon"), for: .normal)
//        button.addTarget(self, action:#selector(done), for: .touchDragInside)
//        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        let barButton = UIBarButtonItem(customView: button)
//        self.navigationItem.leftBarButtonItems = [barButton]
        
//        let backbutton = UIButton(type: .custom)
//        backbutton.setImage(UIImage(named: "gobackicon.png"), for: .normal) // Image can be downloaded from here below link
//        backbutton.setTitle("Back", for: .normal)
//        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
//        backbutton.addTarget(self, action: Selector(("backAction")), for: .touchUpInside)
//        navItem.leftBarButtonItem = backbutton
//
       //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
           //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    @objc func done() { // remove @objc for Swift 3
        self.navigationController?.popViewController(animated: true)
    }
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
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
//    private func borderForTextField(textField: UITextField, validationFlag: Bool) {
//
//        if validationFlag == false {
//            textField.layer.cornerRadius = 6.0
//            textField.layer.masksToBounds = true
//            textField.layer.borderColor = UIColor(red: 211/256, green: 211/256, blue: 211/256, alpha: 1.0 ).cgColor
//            textField.layer.borderWidth = 1.0
//        } else {
//            textField.layer.cornerRadius = 6.0
//            textField.layer.masksToBounds = true
//            textField.layer.borderColor = UIColor(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0 ).cgColor
//            textField.layer.borderWidth = 1.0
//        }
//
//
//        //textField.layer.addSublayer(bottomLine)
//
//    }

     
    @IBAction func loginButtonPressed(_ sender: Any) {
        username = usernameTextField.text!
        password = passwordTextField.text!
        eventCode = eventCodeTextField.text!
        
        if username == "" {
            loginErrorLabel.text = "Log In field cannot be empty."
        }
        if password == "" {
            passwordErrorLabel.text = "Password field cannot be empty."
        }
        if eventCode == "" {
            labelMessage.text = "Event Code field cannot be empty."
        }
        
        if (username != "" && password != "" &&  eventCode != "" ) {
            let authenticatedUserProfile = AuthenticateUser(username: self.username, password: self.password)
            let request = PostRequest(path: "/api/Profile/authenticate", model: authenticatedUserProfile, token: "")
                   
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
                   self.labelMessage.text = error.localizedDescription
               }
               
              
           }
                   
        }
        
        
    }
    
    
    //Initialize payment
       func initializePayment(token: String, profileId: Int64, firstName: String, lastName: String, userName: String, email: String, phone: String) {
           let initPayment = InitializePaymentModel(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone)
            let request = PostRequest(path: "/api/Profile/initialize", model: initPayment, token: token)
            
           
           
             Network.shared.send(request) { (result: Result<InitializePaymentData, Error>)  in
                switch result {
                case .success(let paymentInit):
                   self.paymentClientToken = paymentInit.clientToken!
                   
                   print("paymentClientToken = \(self.paymentClientToken)")

                    self.performSegue(withIdentifier: "login2Home", sender: nil)
                case .failure(let error):
                    self.labelMessage.text = error.localizedDescription
                }
                
               
            }
           
       }
      
      func addToEvent(profileId: Int64, email: String, phone: String, eventCode: String, token: String) {

             let Invite = JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])
             
             let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token)
             
             
             Network.shared.send(request) { (result: Result<Data, Error>)  in
                 switch result {
                 case .success( _): break
                 case .failure(let error):
                     print(error.localizedDescription)
                 }
             }
                        
         }
       
       
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           if(segue.identifier == "nextVC"){
//                let NextVC = segue.destination as! MenuTabViewController
//                NextVC.profileId = Int64(profileId!)
//                NextVC.token = token2pass
//                NextVC.paymentClientToken = paymentClientToken
//    //                          displayVC.token = token2pass
//    //                          displayVC.userdata = userdata
//           } else if(segue.identifier == "goToReg") {
//
//                let NextVC = segue.destination as! RegistrationViewController
//                NextVC.message  = ""
//           } else if
        if(segue.identifier == "login2Home"){
                let NextVC = segue.destination as! MenuTabViewController
                NextVC.profileId = Int64(profileId!)
                NextVC.token = token2pass
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
