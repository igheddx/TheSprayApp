//
//  ViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 4/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherManagerDelegate {

    @IBOutlet weak var userIdText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var completedText: UITextField!
    
    
    @IBOutlet weak var firstnameText: UITextField!
    @IBOutlet weak var lastnameText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    
    var theUserId: Int = 0
    var theTitle: String = ""
    var theCompleted: Bool = false
    
  var firstName: String = ""
  var lastName: String = ""
  var username: String = ""
  var password: String = ""
  var email: String = ""
  var phone: String = ""
    
     var weatherManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        // Do any additional setup after loading the view.
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
    func didUpdateWeather(weather: WeatherModel){
          print(weather)
      }
    
  
    @IBAction func myDataButtonPressed(_ sender: UIButton) {
        var searchTextbox: String
        let weatherManager = NetworkManager()
              
        searchTextbox = firstnameText.text!
        weatherManager.fetchWeatehr(cityName: searchTextbox )
    }
    
    @IBAction func sprayPostDataButtonPressed(_ sender: UIButton) {
        
        
        
        firstName = firstnameText.text!
              lastName = lastnameText.text!
              username = usernameText.text!
              password = passwordText.text!
              email = emailText.text!
              phone = phoneText.text!
        
        
        struct RegisterPostModel: Codable {
            //var profileId: Int?
            var firstName: String
            var lastName: String
            var username: String
            var password: String?
            var email: String
            var phone: String?
            
        }
        
        struct RegisterResponseModel: Codable {
            var token: String?
            var profileId: Int64
            var firstName: String
            var lastName: String
            var userName: String
            //var password: String?
            var email: String
            //var phone: String?
            
        }
        
        let url = URL(string: "https://projectxapi-dev.azurewebsites.net/api/Profile/register")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


//        firstName = "Dominic" //firstnameText.text!
//        lastName = "Ighedosa" //lastnameText.text!
//        username = "dominic" //userIdText.text!
//        password = "test123" //passwordText.text!
//        email = "my@gmai.com" //emailText.text!
//        phone = "12334" //honeText.text!

      
        
        print(phone)
       let userProfileData = RegisterPostModel(firstName: firstName, lastName: lastName, username: username, password: password, email: email, phone: phone)
        //let postString = "firstName=Dom&lastName=Ighe&username=domu&password=abci12&email=myemai&phone=1234";
        //let postString = "[firstName="+firstName+"&lastName="+lastName+"&username="+username+"&password="+password+"&email="+email+"&phone="+phone"]
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let jsonData = try! encoder.encode(userProfileData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
             print(jsonData)
             request.httpBody = jsonData
        }
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
//            print(data)
//            print(response)
//            print(error)
            
            //let profileData = profilePost(firstName: "Dom", lastName: "Ighedosa")
            
          
            
            
//            if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
//            {
//                print(json)
//            }

            if let error = error {
                //print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            //print(data)
            do {
                
                let profileJsonData = try decoder.decode(RegisterResponseModel.self, from: data)
                print(profileJsonData)
                print("My First Name is : \(profileJsonData.firstName)")
                
            } catch let jsonErr {
                print(jsonErr)
            }
            
            
//                do{
//                  let todoItemModel = try JSONDecoder().decode(RegisterModel.self, from: data)
//                  print("this is my data \n \(data)")
//                    print("Response data:\n \(todoItemModel)")
//                   // print("todoItemModel Title: \(todoItemModel.firstName)")
//                    //print("todoItemModel id: \(todoItemModel.lastName)")
//                }catch let jsonErr{
//                    print(jsonErr)
//               }

        }
        task.resume()
        
        
        
        //let jsonData = try! JSONEncoder().encode(user)
        //let jsonString = String(data: jsonData, encoding: .utf8)!
//
//              request.httpBody = jsonData
//                print(firstName)
                  
        
        
//        // Set HTTP Request Body
//        request.httpBody = postString.data(using: String.Encoding.utf8);
//        // Perform HTTP Request
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//                // Check for Error
//                if let error = error {
//                    print("Error took place \(error)")
//                    return
//                }
//
//                // Convert HTTP Response Data to a String
//                if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                    print("Response data string:\n \(dataString)")
//                }
//        }
//        task.resume()
              
        
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid

        //let parameters = ["id": 13, "name": "jack"]
//        let parameters = ["firstName:"+firstName+", lastName:"+lastName+", username: "+username+", password: "+password+",email: "+email+", phone:"+phone]
//
//
//        //create the url with URL
//        let url = URL(string: "Https://projectxapiapp.azurewebsites.net/api/Profile/register")! //change the url
//
//        //create the session object
//        let session = URLSession.shared
//
//        //now create the URLRequest object using the url object
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST" //set http method as POST
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//        } catch let error {
//            print(error.localizedDescription)
//        }
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        //create dataTask using the session object to send data to the server
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//            guard error == nil else {
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                //create json object from data
//                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                    print(json)
//                    // handle json...
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        })
//        task.resume()
    }
    
    @IBAction func sprayGetDataButtonPressed(_ sender: UIButton) {
        
      struct profilePost: Codable  {
            var firstName: String
            var lastName: String
        
//        func toDictionary() -> [String: Any] {
//            return ["firsName": self.firstName, "lastName":self.lastName]
//        }
        }
        
      struct profileResponse: Codable  {
          var firstName: String
          var lastName: String
      }
      
        
        let profileData = profilePost(firstName: "Dom", lastName: "Ighedosa")
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let encoded = try encoder.encode(profileData)
            let string = String(data: encoded, encoding: .utf8)!
             print(string)
            
            
            let obj = try? decoder.decode(profileResponse.self, from: encoded)
            print(obj!)
        }
        catch {
            print(error)
        }
        
     
       
       
    }
    
    //
    func postRequest(username: String, password: String, completion: @escaping ([String: Any]?, Error?) -> Void) {

        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["name": username, "password": password]

        //create the url with NSURL
        let url = URL(string: "https://www.myserver.com/api/login")!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print(json)
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })

        task.resume()
    }

    @objc func submitAction(_ sender: UIButton) {
        //call postRequest with username and password parameters
        postRequest(username: "username", password: "password") { (result, error) in
        if let result = result {
            print("success: \(result)")
        } else if let error = error {
            print("error: \(error.localizedDescription)")
        }
    }
  
//        struct RegisterModel: Codable {
//
//        let token: String?
//        let profileId: Int?
//        let firstName: String
//        let lastName: String
//        let userName: String
//        let password: String?
//        let email: String
//        let phone: String?
//        }
        /* GET REQUEST EXAMPLE
        let url = URL(string: "https://projectxapiapp.azurewebsites.net/api/Event/myevents?profileid=7")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
        }
        task.resume() */
        
        
        //POST REQUEST EXAMPLE
        /*let url = URL(string: "https://projectxapiapp.azurewebsites.net/api/Profile/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("There is data data: \(dataString)")
                }
            }
        }
        task.resume() */
         
       
    }

}
