//
//  Class.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/10/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit
  
struct Device {
    
    func getDeviceId(userName: String) -> String {
        // Do any additional setup after loading the view, typically from a nib.
        let udid = UIDevice.current.identifierForVendor?.uuidString
        let name = UIDevice.current.name
        //let version = UIDevice.current.systemVersion
        let modelName = UIDevice.current.model

        let deviceUID = udid! + name + modelName + "|" + userName //old hold this for now 5/26
        //let deviceUID = udid! + name + modelName //does not include userName
        print("device \(deviceUID)")
        
        let encryptdecrypt =  EncryptDecrpyt()
        let encryptedDeviceId = encryptdecrypt.encryptData(value: deviceUID)
        return encryptedDeviceId
    }
    
    func sendDeviceInfo(encryptedAPIKey: String, encryptedDeviceId: String) {
        let myDeviceId = DeviceInfoId(deviceUniqueId: encryptedDeviceId)
        print("myDeviceId \(myDeviceId)")
        let request = PostRequest(path: "/api/device/add", model: myDeviceId, token: "", apiKey: encryptedAPIKey, deviceId: "")

        print("Device - sendDeviceInfo - I was called from an object")
        Network.shared.send(request) { [self] (result: Result<DeviceInfoData, Error>)  in
            switch result {
            case .success(let deviceId):
                //deviceId.sucess
                print(deviceId)
               print("DEVICE ID \(encryptedDeviceId) WAS SENT")
                
            case .failure(let error):
                print(error.localizedDescription)
                //self.theAlertView(alertType: "Error", message: error.localizedDescription)
                break
            }
        }
    }

}

struct EncryptDecrpyt {
    
    let key128   = "1234567890123456"                   // 16 bytes for AES128
    let key256   = "CHqcPp7MN3mTY3nF6TWHdG8dHPVSgJBj"   // 32 bytes for AES256
    let iv       = "F5cEUty4UwQL2EyW"                   // 16 bytes for AES128

    func encryptData(value: String) ->String {
        let inputValue = value //"UserPassword1!"
        
        do {
            //let aes128 = AES(key: key128, iv: iv)
            let aes256 = AES(key: key256, iv: iv)

//            let encryptedInputValue128 = aes128?.encrypt(string: inputValue)
//            aes128?.decrypt(data: encryptedInputValue128)

            let encryptedInputValue256 = aes256?.encrypt(string: inputValue)
            //aes256?.decrypt(data: encryptedInputValue256)
            
            
            //print(encryptedInputValue256?.base64EncodedString())
    //            let encryptedInputValue256 = aes256?.encrypt(string: inputValue)
            return (encryptedInputValue256?.base64EncodedString())!

        } catch {
            var errMsg: String = "Something went wrong: \(error)"
            print("Something went wrong: \(error)")
            return errMsg
        }
    }
    
    func decryptData(value: Data) ->String {
        let inputValue = value //"UserPassword1!"
        
        do {
            //let aes128 = AES(key: key128, iv: iv)
            let aes256 = AES(key: key256, iv: iv)

            //let encryptedInputValue128 = aes128?.encrypt(string: inputValue)
            //aes128?.decrypt(data: encryptedInputValue128)

            //let encryptedInputValue256 = aes256?.encrypt(string: inputValue)
           // let decryptedInputValue256 = aes256?.decrypt(data: inputValue)
            
            //let decryptedData: String = try aes25?.decrypt(inputValue)
            
            //print(encryptedInputValue256?.base64EncodedString())
    //            let encryptedInputValue256 = aes256?.encrypt(string: inputValue)
            
            let data = Data("wr/YeiR6I2ZkB+hmCarcvq5nGE10ApfzwqFUnXkQGftQ2t/uf6IuyBl1RgEwqY7uI6D7d5O0vyPnLQRqNZ0EPg==".utf8)
            
            let decryptedData = aes256?.decrypt(data: data)
            //let str = String(decoding: decryptedData!, as: UTF8.self)
            
            //let a: String = try aes.decrypt(encryptedData)
            
            
            print("decryptedDate = \(decryptedData?.utf8)")
            return "Dom"

        } catch {
            var errMsg: String = "Something went wrong: \(error)"
            print("Something went wrong: \(error)")
            return errMsg
        }
    }
    
    func encryptDecryptAPIKey(type: String, value: String, action:String) ->String {
        var inputValue: String = ""
        var outputValue: String = ""
        
        if type == "username" {
            inputValue = "\(value)|9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A" //value
        } else {
            inputValue = "9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A" //value //"UserPassword1!"
        }
        
        let key128   = "1234567890123456"                   // 16 bytes for AES128
        let key256   = "CHqcPp7MN3mTY3nF6TWHdG8dHPVSgJBj"   // 32 bytes for AES256
        let iv       = "F5cEUty4UwQL2EyW"                   // 16 bytes for AES128
        do {
           
            let aes256 = AES(key: key256, iv: iv)
            
            let encryptedInputValue256 = aes256?.encrypt(string: inputValue)
            return (encryptedInputValue256?.base64EncodedString())!
 
        } catch {
            var errMsg: String = "Something went wrong: \(error)"
            print("Something went wrong: \(error)")
            return errMsg
        }
    }

}


struct EncryptAPIKey {
    func encryptData(value: String) ->String {
        if value == "username" {
            let inputValue = "9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A" //value //"UserPassword1!"
        } else {
            let inputValue = "9D8ED11F-CD8A-4E47-B1AC-B188AA8C032A" //value //"UserPassword1!"
        }
        
        let key128   = "1234567890123456"                   // 16 bytes for AES128
        let key256   = "CHqcPp7MN3mTY3nF6TWHdG8dHPVSgJBj"   // 32 bytes for AES256
        let iv       = "F5cEUty4UwQL2EyW"                   // 16 bytes for AES128

        
        do {
            let aes128 = AES(key: key128, iv: iv)
            let aes256 = AES(key: key256, iv: iv)

            let encryptedInputValue128 = aes128?.encrypt(string: value)
            aes128?.decrypt(data: encryptedInputValue128)

            let encryptedInputValue256 = aes256?.encrypt(string: value)
            aes256?.decrypt(data: encryptedInputValue256)
            
            
            //print(encryptedInputValue256?.base64EncodedString())
    //            let encryptedInputValue256 = aes256?.encrypt(string: inputValue)
            return (encryptedInputValue256?.base64EncodedString())!
    //
    //            let aes = try AES(keyString: key256)
    //
    //            let stringToEncrypt: String = inputValue
    //            print("String to encrypt:\t\t\t\(stringToEncrypt)")6t
    //
    //            let encryptedData: Data = try aes.encrypt(stringToEncrypt)
    //            print("String encrypted (base64):\t\(encryptedData.base64EncodedString())")
    //
    //            let decryptedData: String = try aes.decrypt(encryptedData)
    //            print("String decrypted:\t\t\t\(decryptedData)")

        } catch {
            var errMsg: String = "Something went wrong: \(error)"
            print("Something went wrong: \(error)")
            return errMsg
        }
    }

}




