//
//  RegistrationViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var eventCodeTextField: UITextField!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    //declare register form variables
    var firstName: String?
    var lastName: String?
    var username: String?
    var password: String?
    var confirmPassword: String?
    var email: String?
    var phone: String?
    var userdata: UserData?
    var token2pass: String?
    var profileId: String?
    var eventCode: String?
    
    //instanciate the network object
   //let registrationManager = NetworkManager2()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBottomLineToTextField(textField: firstNameTextField)
        self.addBottomLineToTextField(textField: lastNameTextField)
        self.addBottomLineToTextField(textField: emailTextField)
        self.addBottomLineToTextField(textField: phoneTextField)
        self.addBottomLineToTextField(textField: passwordTextField)
        self.addBottomLineToTextField(textField: passwordConfirmTextField)
        
        // Do any additional setup after loading the view.
    }
    

    
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

    private func addBottomLineToTextField(textField: UITextField) {
             
            let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
        textField.borderStyle = .none
        
        textField.layer.addSublayer(bottomLine)
        
    //        let border = CALayer()
    //          let borderWidth = CGFloat(1.0)
    //          border.borderColor = UIColor.white.cgColor
    //          border.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.size.width, height: 2)
    //          border.borderWidth = borderWidth
    //          textField.layer.addSublayer(border)
    //          textField.layer.masksToBounds = true
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
                    self.addToEvent(profileId: user.profileId!, email: self.email!, phone: phone, eventCode: eventCode, token: self.token2pass!)
                                 
                }
             
                self.performSegue(withIdentifier: "Reg2MenuTab", sender: nil)
                
                //self.labelMessage.text = "Got an empty, successful result"
                
                
            case .failure(let error):
                self.loadingLabel.text = error.localizedDescription
            }
        }
     
}
    
    func addToEvent(profileId: Int64, email: String, phone: String, eventCode: String, token: String) {

        let Invite = SendInvite(profileId: profileId, email: email, phone: phone, eventCode: eventCode)
        
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
        
        //let userProfileData = ProfileModel(firstName: firstName, lastName: lastName, username: username, password: password, email: email, phone: phone)
        
        //let postString = "firstName=Dom&lastName=Ighe&username=domu&password=abci12&email=myemai&phone=1234";
        //let postString = "[firstName="+firstName+"&lastName="+lastName+"&username="+username+"&password="+password+"&email="+email+"&phone="+phone"]
        
        // registrationManager.hitAPI(_for: //"https://projectxapiapp.azurewebsites.net/api/Profile/register", d)
        firstName = firstNameTextField.text!
        lastName = lastNameTextField.text!
        username = emailTextField.text!
        password = passwordTextField.text!
        confirmPassword = passwordConfirmTextField.text
        email = emailTextField.text!
        phone = phoneTextField.text!
        eventCode = eventCodeTextField.text!
        
        
        print(firstName!)
        print(lastName!)
        print(username!)
        print(password!)
        print(phone!)
        print(email!)
        print(confirmPassword!)
        //data validation
        if password != confirmPassword {
            loadingLabel.text = "Password must match"
        } else {
            
            
            
            
            loadingLabel.text = "Registration is in progress..."
            
            //let newUser = UserModel(id: 2, name: "Peter", username: "Livesey", email: "941ecfff8dc3@medium.com")
            let userData = UserModel(firstName: firstName!, lastName: lastName!, username: username!, password: password!, email: email!, phone: phone!)
            
            print(userData)
            let request = PostRequest(path: "/api/Profile/register", model: userData, token: "")
            Network.shared.send(request) { (result: Result<UserData, Error>) in
                switch result {
                case .success(let userdata):
                    self.userdata = userdata
                    print(userdata)
                    //call authentication func
                    self.authenticateUser(userName: self.username!, password: self.password!, phone: self.phone!, email: self.email!, eventCode: self.eventCode!)
                    self.loadingLabel.text = "Registration was successful..."
                case .failure(let error):
                    self.loadingLabel.text = error.localizedDescription
                }
                
                
            }
            
        }
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
