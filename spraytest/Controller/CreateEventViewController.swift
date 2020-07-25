//
//  CreateEventViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBOutlet weak var profileLable: UILabel!
    @IBOutlet weak var createEventLabel: UILabel!
    var createEventTitle: String?
    
    var profileId: Int64?
    var token: String?
    
    var activePickerViewTextField = UITextField()
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDateTextField: UITextField!
    @IBOutlet weak var eventAddress1TextField: UITextField!
    @IBOutlet weak var eventAddress2TextField: UITextField!
    @IBOutlet weak var eventCityTextField: UITextField!
    @IBOutlet weak var eventStateTextField: UITextField!
    @IBOutlet weak var eventZipCodeTextField: UITextField!
    @IBOutlet weak var eventCountryTextField: UITextField!
    
    var stateData: [String] = []
    var countryData: [String] = []
    
  
    //instantiate picker view objects
    var datePicker = UIDatePicker()
    var pickerView = UIPickerView()
    //var countryPickerView = UIPickerView()
    
    func createDatePicker(){
        
        eventDateTextField.textAlignment = .left
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneBtn], animated: true)
        //assign toolbar
        eventDateTextField.inputAccessoryView = toolbar
        
        eventDateTextField.inputView = datePicker
        
        datePicker.datePickerMode = .dateAndTime
    }
    
    @objc func donePressed() {
        
        
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
           eventDateTextField.text   = dateFormatter.string(from: datePicker.date)
           self.view.endEditing(true)
        
        
        //formatter
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
//
//        //eventDateTextField.text = "\(datePicker.date)"
//        eventDateTextField.text = formatter.string(from: datePicker.date)
//
        self.view.endEditing(true)
    }
//    @IBOutlet weak var eventNameTextField: UITextField!
//    @IBOutlet weak var eventDateTextField: UITextField!
//    @IBOutlet weak var eventTimeTextField: UITextField!
//    @IBOutlet weak var eventAddress1TextField: UITextField!
//    @IBOutlet weak var eventAddress2TextField: UITextField!
//    @IBOutlet weak var eventCityTextField: UITextField!
//
//    @IBOutlet weak var eventStateTextField: UITextField!
//
//    @IBOutlet weak var eventCountryTextField: UITextField!
    //@IBOutlet weak var eventCountryTextField: UITextField!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //data for the date picker
          stateData = ["Texas", "New York", "California"]
          countryData = ["USA", "England", "Nigeria", "Ghana"]
          
        pickerView.delegate = self
        pickerView.dataSource = self
//        statePickerView.delegate = self
//        statePickerView.dataSource = self
//        countryPickerView.delegate = self
//        countryPickerView.dataSource = self
        
        //set value of pickerview to text fiels
        //ccountTypeTextField.inputView = accountTypePickerView
//        eventCountryTextField.inputView = countryPickerView
//        eventStateTextField.inputView = statePickerView
        
        
//        statePickerView.delegate = self as! UIPickerViewDelegate
//        statePickerView.dataSource = self as! UIPickerViewDataSource
//
//        countryPickerView.delegate = self
//        countryPickerView.dataSource = self
//
        createDatePicker()
        
       // profileLable.text = String(profileId!)
        self.addBottomLineToTextField(textField: eventNameTextField)
        self.addBottomLineToTextField(textField: eventDateTextField)
        //self.addBottomLineToTextField(textField: eventTimeTextField)
        self.addBottomLineToTextField(textField: eventAddress1TextField)
        self.addBottomLineToTextField(textField: eventAddress2TextField)
        self.addBottomLineToTextField(textField: eventCityTextField)
        self.addBottomLineToTextField(textField: eventStateTextField)
        self.addBottomLineToTextField(textField: eventCountryTextField)
         self.addBottomLineToTextField(textField: eventZipCodeTextField)
       // createEventLabel.text = createEventTitle
        // Do any additional setup after loading the view.
    }
    private func addBottomLineToTextField(textField: UITextField) {
         
         let bottomLine = CALayer()
         bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
         bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
         //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
         textField.borderStyle = .none
         
         textField.layer.addSublayer(bottomLine)
         
     }
    
    
    //data format
    func getFormattedDate(date: Date, format: String) -> String {
               let dateformat = DateFormatter()
               dateformat.dateFormat = format
               return dateformat.string(from: date)
       }

    
    @IBAction func eventSaveButtonPressed(_ sender: Any) {
  
       
        
        eventName = eventNameTextField.text
        eventDateTime = eventDateTextField.text
        eventAddress1 = eventAddress1TextField.text
        eventAddress2 = eventAddress2TextField.text
        eventCity = eventCityTextField.text
        eventState = eventStateTextField.text
        eventCountry = eventCountryTextField.text
        eventZipCode = eventZipCodeTextField.text
        
        let formatedEventDateTime  = getFormattedDate(date: Date(), format: "yyyy-MM-dd HH:mm")
                       print("format event date\(formatedEventDateTime)")
        
//        print("Event Name \(eventName!)")
//        print("Event Date \(eventDateTime!)")
//        print("Event Time \(eventTime!)")
//        print("Event Address 1 \(eventAddress1!)")
//        print("Event Address 2 \(eventAddress2!)")
//        print("Event City \(eventCity!)")
//        print("Event State \(eventState!)")
//        print("Event Country \(eventCountry!)")
//
        
        let AddEvent = EventModel(ownerId: profileId!, name: eventName!, dateTime: eventDateTime!, address1: eventAddress1!, address2: eventAddress2!, city: eventCity!, zipCode: eventZipCode!, country: eventCountry!, state: eventState!, eventId: 0, isActive: true, eventState: 0)
        let request = PostRequest(path: "/api/Event/add", model: AddEvent, token: token!)
         
        
        
          Network.shared.send(request) { (result: Result<EventData, Error>)  in
             switch result {
             case .success(let event):
//                 self.token2pass = user.token!
//                 self.userdata = user
//                 self.profileId = String(user.profileId!)
//
//                 print(" this is dominic \(user)")
//
                self.eventCode = event.eventCode
                self.eventId = event.eventId
                self.createEventLabel.text = "Congratulations. Your event has been creeated. Your Event Code is:   \(self.eventCode!)"
                // self.performSegue(withIdentifier: "nextVC", sender: nil)
                 
                 //self.labelMessage.text = "Got an empty, successful result"
             
                //clear textbox
                self.eventNameTextField.text?.removeAll()
                self.eventDateTextField.text?.removeAll()
                self.eventZipCodeTextField.text?.removeAll()
                self.eventAddress1TextField.text?.removeAll()
                self.eventAddress2TextField.text?.removeAll()
                self.eventCityTextField.text?.removeAll()
                self.eventStateTextField.text?.removeAll()
                self.eventCountryTextField.text?.removeAll()
                 
             case .failure(let error):
                self.createEventLabel.text = error.localizedDescription
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

}

}


extension CreateEventViewController: UIPickerViewDataSource {
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activePickerViewTextField == eventStateTextField {
            return stateData.count
        } else if activePickerViewTextField == eventCountryTextField {
            return countryData.count
        } else {
        return 0
        }
    }
}

extension CreateEventViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if activePickerViewTextField == eventStateTextField {
                   return stateData[row]
               } else if activePickerViewTextField == eventCountryTextField {
                   return countryData[row]
        } else {
            return ""
        }
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activePickerViewTextField == eventStateTextField {
                   eventStateTextField.text = stateData[row]
            self.view.endEditing(true)
               } else if activePickerViewTextField == eventCountryTextField {
                  eventCountryTextField.text = countryData[row]
                self.view.endEditing(true)
        }
        
    }
}

extension CreateEventViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        activePickerViewTextField = textField
        if activePickerViewTextField == eventStateTextField {
            activePickerViewTextField.inputView = pickerView
        } else if activePickerViewTextField == eventCountryTextField {
            activePickerViewTextField.inputView = pickerView
        }
        
    }
}

