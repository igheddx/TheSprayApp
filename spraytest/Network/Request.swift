//
//  Request.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

/**
 A protocol to wrap request objects. This gives us a better API over URLRequest.
 */
protocol Requestable {
    /**
     Generates a URLRequest from the request. This will be run on a background thread so model parsing is allowed.
     */
    func urlRequest() -> URLRequest
}

/**
 A simple request with no post data.
 */

//<Model: Decodable>: Requestable
struct Request: Requestable {
    let path: String
    let method: String
    let token: String
    let apiKey: String
    //let model: Model
    
    init(path: String, method: String = "GET", token: String, apiKey: String) {
        self.path = path
        self.method = method
        self.token = token
        self.apiKey = apiKey
        //self.model = model
    }


    func urlRequest() -> URLRequest {
        //guard let url = URL(string: "https://projectxapiapp.azurewebsites.net")?.appendingPathComponent(path) else {
        let url = URL(string: "https://projectxapi-dev.azurewebsites.net")
        let urlWithPath = url.flatMap { URL(string: $0.absoluteString + path) }
        
        guard let url2 = urlWithPath else {
        //guard let url = URL(string: "https://projectxapiapp-dev.azurewebsites.net")?.appendingPathComponent(path) else {
                
            Log.assertFailure("Failed to create base url")
            return URLRequest(url: URL(fileURLWithPath: ""))
        }

        var accessToken: String?
//
               if accessToken == "" && token != "" {
                    accessToken = token
               } else {
                   accessToken = ""
               }
              
        var urlRequest = URLRequest(url: url2)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
//
//        do {
//                   let encoder = JSONEncoder()
//                   let data = try encoder.encode(model)
                   //urlRequest.httpBody = data
//                   urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//               } catch let error {
//                   Log.assertFailure("Post request model parsing failed: \(error.localizedDescription)")
//               }
        
        return urlRequest
    }
}


struct RequestQR: Requestable {
    let path: String
    let method: String
    let token: String
    //let apiKey: String
    //let model: Model
    
    init(path: String, method: String = "GET", token: String) {
        self.path = path
        self.method = method
        self.token = token
        //self.apiKey = apiKey
        //self.model = model
    }

    func urlRequest() -> URLRequest {
        guard let url = URL(string: "https://chart.googleapis.com/")?.appendingPathComponent(path) else {
        //let url = URL(string: "https://projectxapiapp.azurewebsites.net")
        //let urlWithPath = url.flatMap { URL(string: $0.absoluteString + path) }
        
        //guard let url2 = urlWithPath else {
        //}
//        guard let url = URL(string: "https://projectxapiapp.azurewebsites.net")?.appendingPathComponent(path) else {
//
            Log.assertFailure("Failed to create base url")
            return URLRequest(url: URL(fileURLWithPath: ""))
        }

        var accessToken: String?
//
               if accessToken == "" && token != "" {
                    accessToken = token
               } else {
                   accessToken = ""
               }
              
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        //urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        //urlRequest.setValue(deviceId, forHTTPHeaderField: "X-DeviceId")
//
//        do {
//                   let encoder = JSONEncoder()
//                   let data = try encoder.encode(model)
                   //urlRequest.httpBody = data
//                   urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//               } catch let error {
//                   Log.assertFailure("Post request model parsing failed: \(error.localizedDescription)")
//               }
        
        return urlRequest
    }
}

/**
 A request which includes post data. This should be the form of an encodeable model.
 */
struct PostRequest<Model: Encodable>: Requestable {
    let path: String
    let model: Model
    let token: String
    let apiKey: String
    let deviceId: String
    

    func urlRequest() -> URLRequest {
        //https://projectxapiapp.azurewebsites.net old
        guard let url = URL(string: "https://projectxapi-dev.azurewebsites.net")?.appendingPathComponent(path) else {
            Log.assertFailure("Failed to create base url")
            return URLRequest(url: URL(fileURLWithPath: ""))
        }
//        var accessToken: String?
//
//        if accessToken == "" || token != "" {
//             accessToken = token
//        } else {
//            accessToken = ""
//        }
       
        print("apikey from request = \(apiKey)")
        print("deviceId from request = \(deviceId)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        urlRequest.setValue(deviceId, forHTTPHeaderField: "X-DeviceId")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(model)
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
        } catch let error {
            Log.assertFailure("Post request model parsing failed: \(error.localizedDescription)")
        }

        return urlRequest
    }
}


struct PutRequest<Model: Encodable>: Requestable {
    let path: String
    let model: Model
    let token: String
    let apiKey: String
    let deviceId: String
    

    func urlRequest() -> URLRequest {
        //https://projectxapiapp.azurewebsites.net old
        guard let url = URL(string: "https://projectxapi-dev.azurewebsites.net")?.appendingPathComponent(path) else {
            Log.assertFailure("Failed to create base url")
            return URLRequest(url: URL(fileURLWithPath: ""))
        }
//        var accessToken: String?
//
//        if accessToken == "" || token != "" {
//             accessToken = token
//        } else {
//            accessToken = ""
//        }
       
        print("apikey from request = \(apiKey)")
        print("deviceId from request = \(deviceId)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        urlRequest.setValue(deviceId, forHTTPHeaderField: "X-DeviceId")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(model)
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
        } catch let error {
            Log.assertFailure("PUT request model parsing failed: \(error.localizedDescription)")
        }

        return urlRequest
    }
}

/**
 Making URLRequest also conform to request so it can be used with our stack.
 */
extension URLRequest: Requestable {
    func urlRequest() -> URLRequest {
        return self
    }
}
