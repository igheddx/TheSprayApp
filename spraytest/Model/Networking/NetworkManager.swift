
//
//  NetworkManager.swift
//  spray
//
//  Created by Ighedosa, Dominic on 4/5/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

//import Foundation
//class NetworkManager {
//    func loadQuestions(withCompletion completion: @escaping ([Question]?) -> Void) {
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//        let url = URL(string: "https://api.stackexchange.com/2.2/questions?order=desc&sort=votes&site=stackoverflow")!
//        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            let wrapper = try? JSONDecoder().decode(Wrapper.self, from: data)
//            completion(wrapper?.items)
//        })
//        task.resume()
//    }
//}

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct NetworkManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=bd42dd98dbcda2b55fa82bee2fc42026&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatehr(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        
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
                        self.delegate?.didUpdateWeather(weather: weather)
                        
//                        let weatherVC = LoginViewController()
//                        weatherVC.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
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
