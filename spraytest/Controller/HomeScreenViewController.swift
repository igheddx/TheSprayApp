//
//  HomeScreenViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/12/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit


class HomeScreenViewController: UIViewController {


 
   
    var profiledata = [UserData]()
    
    var text:String = ""
    var name: String?
    var firstName: String?
    var lastName: String?
    var token: String?
    var userdata: UserModel?
    //var userdata2: UserData2?
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    
    @IBOutlet weak var receivedDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         textLabel?.text = text
        firstnameLabel?.text = firstName
        lastnameLabel?.text = lastName
        tokenLabel?.text = token
        
        
        // Do any additional setup after loading the view.
        
        print("Dominic \(receivedDataLabel.text!)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(token!)
      
    }
 
  func parse(json: Data) {
      let decoder = JSONDecoder()

      if let jsonProfileData = try? decoder.decode(ProfileData.self, from: json) {
        profiledata = jsonProfileData.result
        //print(profiledata)
          //tableView.reloadData()
      }
  }
    
    @IBAction func getDataButtonPressed(_ sender: UIButton) {
        print(token!)
       
        //let authenticatedUserProfile = AuthenticateUser(username: //self.username, password: self.password)
        let request = Request(path: "api/Profile/all", token: token!)
              
                Network.shared.send(request) { (result: Result<Data, Error>)  in
                   switch result {
                   case .success(let user2):
                    //print(user.self)
                    
                    self.parse(json: user2)
                // print("result = \(result)")
                 //print("userdata = \(user2.description)")
                   // print("")
                 
//                 do {
//                 let decoder = JSONDecoder()
//                 let beers = try decoder.decode([[String:ProfileAll]].self, from: (user2.description)
//
//                 }
//                 dump(beers)
                //let data = Data(user2.utf8)
                   // print(user2)
//                let profileResult = user2.startIndex
//                    print(profileResult)
                    
//
//                do {
//                    let json = try? JSONSerialization.jsonObject(with: user2, options: [])
//                } catch let parsingError {
//                    print("Error", parsingError)
//                    }
//                let jsonData = Data(user2.utf8)
//                    let data = user2
//                    print(data)
                
//                    do{
//                        let json = try JSONSerialization.jsonObject(with: user2, options: []) as! [[String:AnyObject]]
//                        print("JSON IS ",json)
//                    }catch {
//                        print("failed ",error.localizedDescription)
//                    }
//
                    
                    
                    
                    
                    
                //Data option - this is good ****************************************
//                let decoder = JSONDecoder()
//                do {
//                    let profilejson = try decoder.decode(ProfileModel.self, from: user2)
//                    print(profilejson)
//
//
//                } catch  {
//                    print(error.self)
//                }
                //*****************************************************
        
                    
                    
                    
                    
//                let decoder = JSONDecoder()
//                do {
//                    let profilejson = try decoder.decode(ProfileModel.self, from: user2)
//                    print(profilejson)
////                    for mydata in profilejson.result {
////                        let profiledatall = [ProfileData](token: mydata.token,
////                                                          profileId: mydata.profileId,
////                                                          firstName: mydata.firstName,
////                                                          lastName: mydata.lastName,
////                                                          userName: mydata.userName,
////                                                          email: mydata.email)
////
////
////                        profiledata.append(profiledatall)
////                        print(mydata.firstName + "   " + mydata.lastName)
////
//////
//////                        let token: String?
//////                        let profileId: Int64?
//////                        let firstName: String
//////                        let lastName: String
//////                        let userName: String?
//////                        let email: String?
////
////                    }
//
//                } catch  {
//                    print(error.self)
//                }
//
//                 do {
//
//                 // make sure this JSON is in the format we expect
//                 if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                     // try to read out a string array
//
//                    print(json)
//                     if let names = json["names"] as? [String] {
//
//                         print(names)
//                     }
//
//                 }
//                    } catch let error as NSError {
//                        print("Failed to load: \(error.localizedDescription)")
//                    }
                    
              
//                 do {
//                          //here dataResponse received from a network request
//                          let decoder = JSONDecoder()
//                    let model = try decoder.decode([ProfileAll].self, from: user2.description) //Decode JSON Response Data
//                          print(model)
//                      } catch let parsingError {
//                          print("Error", parsingError)
//                      }
                 
                                        //print(user)
                       //self.performSegue(withIdentifier: "nextVC", sender: nil)
                       
                       //self.labelMessage.text = "Got an empty, successful result"
                   
                       
                   case .failure(let error):
                       self.textLabel.text = error.localizedDescription
                    print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
                    
                   }
                   
                  
               }
        
     
         print(profiledata)
      
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "getDataSegue" {
//            let secondVC: LoginViewController = segue.destination as! LoginViewController
//            secondVC.delegate = self
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
}
