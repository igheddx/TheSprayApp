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
    var encryptedAPIKey: String = ""
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    
    @IBOutlet weak var receivedDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .black
        //self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.tintColor = UIColor.white
       
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        textLabel?.text = text
        firstnameLabel?.text = firstName
        lastnameLabel?.text = lastName
        tokenLabel?.text = token
        
        
        // Do any additional setup after loading the view.
        
        print("Dominic \(receivedDataLabel.text!)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(token!)
        AppUtility.lockOrientation(.portrait)
        
        if self.navigationController!.navigationBar.isHidden == true {
            
            print("navigation bar was hidden")
            navigationController?.setNavigationBarHidden(false, animated: animated)
        } else {
            print("No navigation bar was hidden")
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
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
        let request = Request(path: "api/Profile/all", token: token!, apiKey: encryptedAPIKey)
              
                Network.shared.send(request) { (result: Result<Data, Error>)  in
                   switch result {
                   case .success(let user2):
                    //print(user.self)
                    
                    self.parse(json: user2)
                       
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
