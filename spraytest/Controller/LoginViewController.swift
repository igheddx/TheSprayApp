//
//  LoginViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController{
    


    
    var text: String = ""
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var dataToSendTextField: UILabel!
    
  
    @IBOutlet weak var eventCodeTextField: UITextField!
    
    //declare input variable
    var username: String = ""
    var password: String = ""
    var firstname2pass: String?
    var lastname2pass: String = ""
    var token2pass: String = ""
    var userdata: UserData?
    var profileId: String?
    var eventCode: String?
     var phone: String = "555-564-8580"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBottomLineToTextField(textField: usernameTextField)
        self.addBottomLineToTextField(textField: passwordTextField)
        self.addBottomLineToTextField(textField: eventCodeTextField)
        // Do any additional setup after loading the view.
    }
    
   
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
    
    @IBAction func loginButtonPressed(_ sender: Any)  {
        self.dismiss(animated: true, completion: nil)
        username = usernameTextField.text!
        password = passwordTextField.text!
        eventCode = eventCodeTextField.text!
        
        //firstname2pass = ""
        labelMessage.text = "Authenticating...please wait..."
        
        
        let authenticatedUserProfile = AuthenticateUser(username: self.username, password: self.password)
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
                    self.addToEvent(profileId: user.profileId!, email: user.email!, phone: self.phone, eventCode: self.eventCode!, token: self.token2pass)
                                    
                   }
                
                self.performSegue(withIdentifier: "nextVC", sender: nil)
                
                //self.labelMessage.text = "Got an empty, successful result"
            
                
            case .failure(let error):
                self.labelMessage.text = error.localizedDescription
            }
            
           
        }
        
       //print(self.user.firstName)
        //print(UserData.init(token: user.token, profileId: <#T##Int64?#>, firstName: <#T##String#>, lastName: <#T##String#>, userName: <#T##String?#>, email: <#T##String?#>))
      
        

//
//
//         }
//     }
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
    
    
 
    @IBAction func registerLinkButtonPressed(_ sender: Any) {
        //self.performSegue(withIdentifier: "RegistrationViewController", sender: self)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
        //**************** good code hold ***********************
//          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//             if(segue.identifier == "nextVC"){
//                 let displayVC = segue.destination as! HomeScreenViewController
//                displayVC.firstName = "Dominic"
//                displayVC.token = token2pass
//                displayVC.userdata = userdata
//            }
        //**************** good code hold ***********************
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                       if(segue.identifier == "nextVC"){
                           let NextVC = segue.destination as! MenuTabViewController
                        NextVC.profileId = Int64(profileId!)
                        NextVC.token = token2pass
//                          displayVC.token = token2pass
//                          displayVC.userdata = userdata
                      }
            
    }
    
    
   
}
