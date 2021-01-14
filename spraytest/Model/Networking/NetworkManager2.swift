//
//  NetworkManager2.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/10/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//reference
//https://www.tutorialspoint.com/how-to-make-an-http-post-request-on-ios-app-using-swift


import Foundation
struct NetworkManager2 {
    let generalUrl = "https://projectxapiapp.azurewebsites.net/api/Profile/register"
    
    func fetchEvent(eventId: Int){
        let urlString = "\(generalUrl)&eventId=\(eventId)"
        performRequest(urlString: urlString)
    }
    
    func hitAPI(_for URLString:String, dataModel: ProfileModel.Type) {
        
        
        let url = URL(string: "https://projectxapiapp.azurewebsites.net/api/Profile/register")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // firstName = "Dominic" //firstnameText.text!
        
       // print(phone)
        //let userProfileData = RegisterPostModel(firstName: firstName, lastName: lastName, username: username, password: password, email: email, phone: phone)
        //let postString = "firstName=Dom&lastName=Ighe&username=domu&password=abci12&email=myemai&phone=1234";
        //let postString = "[firstName="+firstName+"&lastName="+lastName+"&username="+username+"&password="+password+"&email="+email+"&phone="+phone"]
        
//        let encoder = JSONEncoder()
//        let decoder = JSONDecoder()
//
//        do {
//            let jsonData = try! encoder.encode(dataModel)
//            let jsonString = String(data: jsonData, encoding: .utf8)!
//            print(jsonData)
//            request.httpBody = jsonData
//        }
        
        
        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            
//            
//            if let error = error {
//                //print("Error took place \(error)")
//                return
//            }
//            guard let data = data else {return}
//            //print(data)
//            do {
//                
//                let profileJsonData = try decoder.decode(RegisterResponseModel.self, from: data)
//                print(profileJsonData)
//                print("My First Name is : \(profileJsonData.firstName)")
//                
//            } catch let jsonErr {
//                print(jsonErr)
//            }
//        }
//        task.resume()
        
//       let configuration = URLSessionConfiguration.default
//       let session = URLSession(configuration: configuration)
//       let url = URL(string: URLString)
//       //let url = NSURL(string: urlString as String)
//       var request : URLRequest = URLRequest(url: url!)
//       request.httpMethod = "POST"
//       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//       request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//
//        let dataTask = session.dataTask(with: url!) {
//          data,response,error in
//          // 1: Check HTTP Response for successful GET request
//          guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
//          else {
//             print("error: not a valid http response")
//             return
//          }
//          switch (httpResponse.statusCode) {
//             case 200:
//                //success response.
//                break
//             case 400:
//                break
//             default:
//                break
//          }
//       }
//       dataTask.resume()
    }
    
    
//
//    let url = URL(string: "https://projectxapiapp.azurewebsites.net/api/Profile/register")
//    guard let requestUrl = url else { fatalError() }
//    var request = URLRequest(url: requestUrl)
//    request.httpMethod = "POST"
//    // Set HTTP Request Header
//    request.setValue("application/json", forHTTPHeaderField: "Accept")
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
    
    func performRequest(urlString: String){
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            //let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            JSONEncode(modelDataString: "")
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString)
                    if let weather = self.parseJSON(weatherData: safeData) {
                        //send weather object back to weather view controller
                      //  self.delegate?.didUpdateWeather(weather: weather)
                        
                        //                        let weatherVC = LoginViewController()
                        //                        weatherVC.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func performRequest2(urlString: String){
          
          if let url = URL(string: urlString) {
              
              let session = URLSession(configuration: .default)
              //let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
              let task = session.dataTask(with: url) { (data, response, error) in
                  if error != nil {
                      print(error)
                      return
                  }
                  
                  if let safeData = data {
                      //let dataString = String(data: safeData, encoding: .utf8)
                      //print(dataString)
                      if let weather = self.parseJSON(weatherData: safeData) {
                          //send weather object back to weather view controller
                         // self.delegate?.didUpdateWeather(weather: weather)
                          
                          //                        let weatherVC = LoginViewController()
                          //                        weatherVC.didUpdateWeather(weather: weather)
                      }
                  }
              }
              task.resume()
          }
      }
    
    func JSONEncode(modelDataString: String) {
        let encoder = JSONEncoder()
              let decoder = JSONDecoder()
              
              do {
                  let jsonData = try! encoder.encode(modelDataString)
                  let jsonString = String(data: jsonData, encoding: .utf8)!
                   print(jsonData)
                   //request.httpBody = jsonData
              }
              
    }
    func parseJSON2(weatherData: Data) -> WeatherModel? {
             let decoder = JSONDecoder()
             do {
                 let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                 let id = decodedData.weather[0].id
                 let temp = decodedData.main.temp
                 let name = decodedData.name
                 
                 
                 let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                 
                 //print(weather.getConditionName(weatherId: id))
                 print(weather.conditionName)
                 print(weather.temperatureString)
     //
     //            print(decodedData.weather[0].description)
     //            print(decodedData.weather[0].Id)
     //            print(decodedData.name)
             } catch {
                 
                 print(error)
                 //no object to reutn
                 return nil
             }
             
             return nil
         }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let id = decodedData.weather[0].id
                let temp = decodedData.main.temp
                let name = decodedData.name
                
                
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                
                //print(weather.getConditionName(weatherId: id))
                print(weather.conditionName)
                print(weather.temperatureString)
    //
    //            print(decodedData.weather[0].description)
    //            print(decodedData.weather[0].Id)
    //            print(decodedData.name)
            } catch {
                
                print(error)
                //no object to reutn
                return nil
            }
            
            return nil
        }
    
 
       
}

