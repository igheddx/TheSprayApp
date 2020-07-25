//
//  EventUpdateViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 6/6/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class EventUpdateViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDateTimeTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var eventCodeTextField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    var activePickerViewTextField = UITextField()
    
    var stateData: [String] = []
    var countryData: [String] = []
    
    //instantiate picker view objects
    var datePicker = UIDatePicker()
    var pickerView = UIPickerView()
    
    
    func createDatePicker(){
         
         eventDateTimeTextField.textAlignment = .left
         
         let toolbar = UIToolbar()
         toolbar.sizeToFit()
         let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
         
         toolbar.setItems([doneBtn], animated: true)
         //assign toolbar
         eventDateTimeTextField.inputAccessoryView = toolbar
         
         eventDateTimeTextField.inputView = datePicker
         
         datePicker.datePickerMode = .dateAndTime
     }
     
     @objc func donePressed() {
         
         //formatter
//         let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//         formatter.timeStyle = .medium
         
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
           eventDateTimeTextField.text  = dateFormatter.string(from: datePicker.date)
           self.view.endEditing(true)
        
        
         //eventDateTextField.text = "\(datePicker.date)"
        // eventDateTimeTextField.text = formatter.string(from: datePicker.date)
         
        //print(eventDateTimeTextField.text)
         self.view.endEditing(true)
     }
    
    var eventName: String?
    var eventDateTime: String?
    var eventZipCode: String?
    var eventAddress1: String?
    var eventAddress2: String?
    var eventCity: String?
    var eventState: String?
    var eventCountry: String?
    var eventCode: String?
    var eventId: Int64?
    var profileId: Int64?
    var token: String?
    var isEventEdited: Bool = false
    
    //testing back button nav
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //code for passing data back to the previous screen
        navigationController?.delegate = self
        
        
        eventNameTextField.text = eventName
        print("This is the first event name \(eventName!)")
        eventDateTimeTextField.text = eventDateTime
        address1TextField.text = eventAddress1
        address2TextField.text = eventAddress2
        cityTextField.text = eventCity
        stateTextField.text = eventState
        zipCodeTextField.text = eventZipCode
        countryTextField.text = eventCountry
        eventCodeTextField.text = eventCode
        
        print(" view did load\(eventDateTime!)")
        //data for the date picker
          stateData = ["Texas", "New York", "California"]
          countryData = ["USA", "England", "Nigeria", "Ghana"]
          
        pickerView.delegate = self
        pickerView.dataSource = self
        
         createDatePicker()
        
        // Do any additional setup after loading the view.
        self.addBottomLineToTextField(textField: eventNameTextField)
        self.addBottomLineToTextField(textField: eventDateTimeTextField)
        self.addBottomLineToTextField(textField: address1TextField)
        self.addBottomLineToTextField(textField: address2TextField)
        self.addBottomLineToTextField(textField: cityTextField)
        self.addBottomLineToTextField(textField: stateTextField)
        self.addBottomLineToTextField(textField: zipCodeTextField)
        self.addBottomLineToTextField(textField: countryTextField)
        self.addBottomLineToTextField(textField: eventCodeTextField)
//
    }
    
  
    func dateFormatTime(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    
    func getFormattedDate(date: String, format: String) -> String {
                     let dateformat = DateFormatter()
                     dateformat.dateFormat = format
               
           
               let mydate = dateformat.date(from: date)!
                 
                 let date1 = mydate
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                 //var dateString = dateFormatter.string(from: date1)
               return dateFormatter.string(from: date1)
                 //println(dateString)
                 
                     //return dateformat.string(from: date)
             }
    
    @IBAction func saveEventButtonPressed(_ sender: Any) {
       
       

        
        eventName = eventNameTextField.text
        print("This is the second event name \(eventName!)")
        eventDateTime = eventDateTimeTextField.text
        eventAddress1 = address1TextField.text
        eventAddress2 = address2TextField.text
        eventCity = cityTextField.text
        eventState = stateTextField.text
        eventCountry = countryTextField.text
        eventZipCode = zipCodeTextField.text
        //print("address 2 \(eventAddress2!)")
        //print("token = \(token!)")
        //let date = Date()
        //let formate = date.getFormattedDate(format: eventDateTime!) // Set output formate
        
//        var dateString = eventDateTime!
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
//        var s = dateFormatter.date(from: dateString)
//        print("formatedEventDateTime = \(String(describing: s))")
       
        
//        let formatedEventDateTime  = getFormattedDate(date: eventDateTime!, format: "yyyy-MM-dd HH:mm")
//        print("format event date\(formatedEventDateTime.description)")

        print("event date time =\(eventDateTime!)")
        print("this is the 3rd event name \(eventName!)")
        //let newUser = UserModel(id: 2, name: "Peter", username: "Livesey", email: "941ecfff8dc3@medium.com")
        let eventData = EventModelEdit(ownerId: profileId!, name: eventName, dateTime: eventDateTime, address1: eventAddress1!, address2: eventAddress2!, city: eventCity!, zipCode: eventZipCode!, country: eventCountry!, state: eventState!, eventId: eventId!, isActive: true, eventState: 1)
                
                print(eventData)
                let request = PostRequest(path: "/api/Event/update", model: eventData, token: token!)
                Network.shared.send(request) { (result: Result<Empty, Error>) in
                    switch result {
                    case .success(let eventdata):
//                        self.userdata = userdata
                       print(eventdata)
//
                    self.messageLabel.text = "Event was updated successfully."
                    
                       self.isEventEdited = true
                        
                        //call authentication func
                        //self.authenticateUser(userName: self.username!, password: self.password!)
                        //self.loadingLabel.text = "Registration was successful..."
                    case .failure(let error):
                        print("ERROR = \(error.localizedDescription)")
                    }
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
}



extension EventUpdateViewController: UIPickerViewDataSource {
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activePickerViewTextField == stateTextField {
            return stateData.count
        } else if activePickerViewTextField == countryTextField {
            return countryData.count
        } else {
        return 0
        }
    }
}

extension EventUpdateViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if activePickerViewTextField == stateTextField {
                   return stateData[row]
               } else if activePickerViewTextField == countryTextField {
                   return countryData[row]
        } else {
            return ""
        }
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activePickerViewTextField == stateTextField {
                   stateTextField.text = stateData[row]
            self.view.endEditing(true)
               } else if activePickerViewTextField == countryTextField {
                  countryTextField.text = countryData[row]
                self.view.endEditing(true)
        }
        
    }
}

extension EventUpdateViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        activePickerViewTextField = textField
        if activePickerViewTextField == stateTextField {
            activePickerViewTextField.inputView = pickerView
        } else if activePickerViewTextField == countryTextField {
            activePickerViewTextField.inputView = pickerView
        }
        
    }
}


extension EventUpdateViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? HomeViewController)?.isEventEdited = isEventEdited // Here you pass the to your original view controller
    }
}

//extension Date {
//   func getFormattedDate(format: String) -> String {
//        let dateformat = DateFormatter()
//        dateformat.dateFormat = format
//        return dateformat.string(from: self)
//    }
//}
