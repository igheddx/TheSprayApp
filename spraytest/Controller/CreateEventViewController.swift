//
//  CreateEventViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileLable: UILabel!
    @IBOutlet weak var createEventLabel: UILabel!
    var createEventTitle: String?
    
    var profileId: Int64?
    var token: String?
    var paymentClientToken: String?
    
    var activePickerViewTextField = UITextField()
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDateTextField: UITextField!
    @IBOutlet weak var eventAddress1TextField: UITextField!
    @IBOutlet weak var eventAddress2TextField: UITextField!
    @IBOutlet weak var eventCityTextField: UITextField!
    @IBOutlet weak var eventStateTextField: UITextField!
    @IBOutlet weak var eventZipCodeTextField: UITextField!
    @IBOutlet weak var eventCountryTextField: UITextField!
    @IBOutlet weak var eventTypeTextField: UITextField!
    
    @IBOutlet weak var eventNameErrorLabel: UILabel!
    @IBOutlet weak var eventDateTimeErrorLabel: UILabel!
    @IBOutlet weak var eventTypeErrorLabel: UILabel!
    @IBOutlet weak var address1ErrorLabel: UILabel!
    @IBOutlet weak var address2ErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var stateErrorLabel: UILabel!
    @IBOutlet weak var zipcodeErrorLabel: UILabel!
    @IBOutlet weak var countryErrorLabel: UILabel!
    
    var customtextfield = CustomTextField()
    
    var stateData: [String] = []
    var countryData: [String] = []
    var eventtypeData: [EventTypeData] = []
    
    var formValidation =   Validation()
    //instantiate picker view objects
    var datePicker = UIDatePicker()
    var pickerView = UIPickerView()

    var eventName: String?
    var eventDateTime: String?
    var eventZipCode: String?
    var eventAddress1: String?
    var eventAddress2: String?
    var eventCity: String?
    var eventState: String?
    var eventType: String?
    var eventCountry: String?
    var eventCode: String?
    var eventId: Int64?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Event"
        //data for the date picker
        stateData = ["Select State", "Texas", "New York", "California"]
        countryData = ["Select Country", "USA", "England", "Nigeria", "Ghana"]
        //eventTypeData = ["Select Event Type", "Birthday", "Wedding", "Anniversary", "Baby Shower", "Wedding Shower", "Family Reunion", "Engagement Party", "House Party", "Part"]
          
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        eventNameTextField.delegate = self
        eventDateTextField.delegate = self
        eventTypeTextField.delegate = self
        eventAddress1TextField.delegate = self
        eventAddress2TextField.delegate = self
        eventCityTextField.delegate = self
        eventStateTextField.delegate  = self
        eventZipCodeTextField.delegate = self
        eventCountryTextField.delegate = self
        
        eventNameTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventDateTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventTypeTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventAddress1TextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventAddress2TextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventCityTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventStateTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventZipCodeTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventCountryTextField.addTarget(self, action: #selector(CreateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
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
        addEventTypeData()
       // profileLable.text = String(profileId!)
        customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventAddress2TextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: false)
        
        
        
        eventNameErrorLabel.isHidden = true
        eventDateTimeErrorLabel.isHidden = true
        eventTypeErrorLabel.isHidden = true
        address1ErrorLabel.isHidden = true
        address2ErrorLabel.isHidden = true
        cityErrorLabel.isHidden = true
        stateErrorLabel.isHidden = true
        zipcodeErrorLabel.isHidden = true
        countryErrorLabel.isHidden = true
        createEventLabel.isHidden = true
       // createEventLabel.text = createEventTitle
        // Do any additional setup after loading the view.
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock
            // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    func scroll2Top() {
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
//    private func borderForTextField(textField: UITextField, validationFlag: Bool) {
//
//        if validationFlag == false {
//            textField.layer.cornerRadius = 6.0
//            textField.layer.masksToBounds = true
//            textField.layer.borderColor = UIColor(red: 211/256, green: 211/256, blue: 211/256, alpha: 1.0 ).cgColor
//            textField.layer.borderWidth = 1.0
//        } else {
//            textField.layer.cornerRadius = 6.0
//            textField.layer.masksToBounds = true
//            textField.layer.borderColor = UIColor(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0 ).cgColor
//            textField.layer.borderWidth = 1.0
//        }
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==0{
                switch textField{
                case eventNameTextField :
                    customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: true)
                    eventNameErrorLabel.isHidden = false
                    eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventNameTextField.text!).errorMsg//"Missing Event Name."
                    eventNameTextField.becomeFirstResponder()
                case eventDateTextField:
                    customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: true)
                    eventDateTimeErrorLabel.isHidden = false
                    eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTextField.text!).errorMsg
                    eventDateTextField.becomeFirstResponder()
                case eventTypeTextField:
                    customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: true)
                    eventTypeErrorLabel.isHidden = false
                    eventTypeErrorLabel.text = self.formValidation.validateName2(name2: eventTypeTextField.text!).errorMsg
                    eventTypeTextField.becomeFirstResponder()
                case eventAddress1TextField:
                    customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: true)
                    address1ErrorLabel.isHidden = false
                    address1ErrorLabel.text = self.formValidation.validateName2(name2: eventAddress1TextField.text!).errorMsg
                    eventAddress1TextField.becomeFirstResponder()
//                case address2TextField:
//                    self.borderForTextField(textField: address2TextField, validationFlag: true)
//                    address2ErrorLabel.isHidden = false
//                    address2ErrorLabel.text = "Missing Address 2"
//                    address2TextField.becomeFirstResponder()
                case eventCityTextField:
                    customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: true)
                    cityErrorLabel.isHidden = false
                    cityErrorLabel.text = self.formValidation.validateName2(name2: eventCityTextField.text!).errorMsg
                    eventCityTextField.becomeFirstResponder()
                case eventStateTextField:
                    customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: true)
                    stateErrorLabel.isHidden = false
                    stateErrorLabel.text = self.formValidation.validateName2(name2:  eventStateTextField.text!).errorMsg
                    eventStateTextField.becomeFirstResponder()
                case eventZipCodeTextField:
                    customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: true)
                    zipcodeErrorLabel.isHidden = false
                    zipcodeErrorLabel.text = self.formValidation.validateName2(name2: eventZipCodeTextField.text!).errorMsg
                    eventZipCodeTextField.becomeFirstResponder()
                case eventCountryTextField:
                    customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: true)
                    countryErrorLabel.isHidden = false
                    countryErrorLabel.text = self.formValidation.validateName2(name2: eventCountryTextField.text!).errorMsg
                    eventCountryTextField.becomeFirstResponder()
                default:
                    break
                }
            }else{
                switch textField{
                case eventNameTextField :
                    eventNameErrorLabel.isHidden = true
                    eventNameErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: false)
                case eventDateTextField:
                    eventDateTimeErrorLabel.isHidden = true
                    eventDateTimeErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
                case eventTypeTextField:
                    eventTypeErrorLabel.isHidden = true
                    eventTypeErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: false)
                case eventAddress1TextField:
                    address1ErrorLabel.isHidden = true
                    address1ErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: false)
//                case address2TextField:
//                    address2ErrorLabel.isHidden = true
//                    address2ErrorLabel.text = ""
//                    self.borderForTextField(textField: address2TextField, validationFlag: false)
                case eventCityTextField:
                    cityErrorLabel.isHidden = true
                    cityErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: false)
                case eventStateTextField:
                    stateErrorLabel.isHidden = true
                    stateErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: false)
                case eventZipCodeTextField:
                    zipcodeErrorLabel.isHidden = true
                    zipcodeErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: false)
                case eventCountryTextField:
                    countryErrorLabel.isHidden = true
                    countryErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: false)
                default:
                    break
                    
                }
            }
    }
    func addEventTypeData(){
          //var array: [EventTypeData] = []
        eventtypeData.append(EventTypeData(id: 0, eventTypeName: "Select Event Type"))
        eventtypeData.append(EventTypeData(id: 1, eventTypeName: "Birthday"))
        eventtypeData.append(EventTypeData(id: 2, eventTypeName: "Anniversary"))
        eventtypeData.append(EventTypeData(id: 7, eventTypeName: "Wedding Anniversary"))
        eventtypeData.append(EventTypeData(id: 3, eventTypeName: "Wedding"))
        eventtypeData.append(EventTypeData(id: 4, eventTypeName: "Baby Shower"))
        eventtypeData.append(EventTypeData(id: 5, eventTypeName: "Graduation"))
        eventtypeData.append(EventTypeData(id: 6, eventTypeName: "Naming Ceremony"))
        eventtypeData.append(EventTypeData(id: 8, eventTypeName: "Family Reunion"))
        eventtypeData.append(EventTypeData(id: 9, eventTypeName: "Concert"))
        eventtypeData.append(EventTypeData(id: 10, eventTypeName: "General Party"))
        eventtypeData.append(EventTypeData(id: 11, eventTypeName: "Coffee House"))
        eventtypeData.append(EventTypeData(id: 12, eventTypeName: "Cover Band"))
        eventtypeData.append(EventTypeData(id: 13, eventTypeName: "Thanksgiving"))
         // print(eventtypeData )
      }
    
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
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a" //yyyy-MM-dd'T'HH:mm"
        eventDateTextField.text   = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
        eventDateTimeErrorLabel.isHidden = true
        eventDateTimeErrorLabel.text = ""
    }
    private func addBottomLineToTextField(textField: UITextField) {
         
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 2/3, green: 2/3, blue: 2/3, alpha: 1.0).cgColor
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

    func getEventTypeId(eventTypeName: String) -> Int {
          for e in eventtypeData {
              if e.eventTypeName == eventTypeName {
                  let id = e.id
                  return id
            
              } else {
                
              }
          }
          return 0
      }
      
    
    @IBAction func eventSaveButtonPressed(_ sender: Any) {
        
        guard let eventName = eventNameTextField.text,
              //print("This is the second event name \(eventName!)")
            //let eventName = eventNameTextField.text
            let eventDateTime = eventDateTextField.text,
            let eventAddress1 = eventAddress1TextField.text,
            let eventAddress2 = eventAddress2TextField.text,
            let eventCity = eventCityTextField.text,
            let eventState = eventStateTextField.text,
            let eventCountry = eventCountryTextField.text,
            let eventZipCode = eventZipCodeTextField.text,
            let eventType = eventTypeTextField.text
        
        else {
            return
        }
       
        print("eventDateTextField.text = \(eventDateTextField.text!)")
        
        
        let isValidateEventName = self.formValidation.validateName2(name2: eventName).isValidate
       
        
        let isValidateEventDateTime = self.formValidation.validateName2(name2: eventDateTime).isValidate
        let isValidateEventType = self.formValidation.validateName2(name2: eventType).isValidate
        let isValidateAddress1 = self.formValidation.validateName2(name2: eventAddress1).isValidate
        let isValidateAddress2 = self.formValidation.validateName2(name2: eventAddress2).isValidate
        let isValidateCity = self.formValidation.validateName2(name2: eventCity).isValidate
        let isValidateZipCode = self.formValidation.validateName2(name2: eventZipCode).isValidate
        let isValidateState = self.formValidation.validateName2(name2: eventState).isValidate
        let isValidateCountry = self.formValidation.validateName2(name2: eventCountry).isValidate
        print("isValidateEventName = \(isValidateEventName)")
        if (isValidateEventName == false) {
            eventNameTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: true)
            print("I am still here")
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            eventNameErrorLabel.isHidden = false
            eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventName).errorMsg
            return
        } else {
            customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: false)
            eventNameErrorLabel.isHidden = true
            eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventName).errorMsg
        }
        
        if (isValidateEventDateTime == false) {
            eventDateTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: true)
            print("isValidateEventDateTime = false")
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTime).errorMsg
            return
        } else {
            print("isValidateEventDateTime = true")
            customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
            eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTime).errorMsg
        }
        
        if (isValidateEventType == false) {
            eventTypeTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            eventTypeErrorLabel.text = self.formValidation.validateName2(name2: eventType).errorMsg
            return
        } else {
            customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: false)
            eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventType).errorMsg
        }
        
        if (isValidateAddress1 == false) {
            eventAddress1TextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            address1ErrorLabel.text = self.formValidation.validateName2(name2: eventAddress1).errorMsg
            return
        } else {
            customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: false)
            address1ErrorLabel.text = self.formValidation.validateName2(name2: eventAddress1).errorMsg
        }
        
//        if (isValidateAddress2 == false) {
//            address2TextField.becomeFirstResponder()
//            self.borderForTextField(textField: address2TextField, validationFlag: true)
//            //print("Incorrect First Name")
//            //loadingLabel.text = "Incorrect First Name"
//            address2ErrorLabel.text = self.formValidation.validateName2(name2: eventName).errorMsg
//            return
//        } else {
//            self.borderForTextField(textField: address2TextField, validationFlag: false)
//            address2ErrorLabel.text = self.formValidation.validateName2(name2: eventName).errorMsg
//        }
//
        if (isValidateCity == false) {
            eventCityTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            cityErrorLabel.text = self.formValidation.validateName2(name2: eventCity).errorMsg
            return
        } else {
            customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: false)
            cityErrorLabel.text = self.formValidation.validateName2(name2: eventCity).errorMsg
        }
        
        if (isValidateState == false) {
            eventStateTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            stateErrorLabel.text = self.formValidation.validateName2(name2: eventState).errorMsg
            return
        } else {
            customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: false)
            stateErrorLabel.text = self.formValidation.validateName2(name2: eventState).errorMsg
        }
        
        if (isValidateZipCode == false) {
            eventZipCodeTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            zipcodeErrorLabel.text = self.formValidation.validateName2(name2: eventZipCode).errorMsg
            return
        } else {
            customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: false)
            zipcodeErrorLabel.text = self.formValidation.validateName2(name2: eventZipCode).errorMsg
        }
        
        if (isValidateCountry == false) {
            eventCountryTextField.becomeFirstResponder()
            customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            countryErrorLabel.text = self.formValidation.validateName2(name2: eventCountry).errorMsg
            return
        } else {
            customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: false)
            countryErrorLabel.text = self.formValidation.validateName2(name2: eventCountry).errorMsg
        }
        //var eventDateTime: String = "Wed, 19 Aug 2020 08:02 AM"
        //remove the AM/PM before you pass string on to be formatted to yyyy-MM-dd HH:mm
//        let incomingDate = eventDateTime
//        let index = incomingDate!.lastIndex(of: " ") ?? incomingDate!.endIndex
//        let finalDate = incomingDate![..<index]
//        print("finalDate= \(finalDate)")
        
        if (isValidateEventName == true || isValidateEventDateTime == true || isValidateEventType == true || isValidateAddress1 == true ||  isValidateCity == true || isValidateState == true || isValidateZipCode == true || isValidateCountry == true ) {
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a"
            let date = dateFormatter.date(from:String(eventDateTime))!


            let formatedEventDateTime  = getFormattedDate(date: date, format: "yyyy-MM-dd'T'HH:mm:ss")

            
            //let formatedEventDateTime  = getFormattedDate(date: Date(), format: "yyyy-MM-dd HH:mm")
            print("format event date\(formatedEventDateTime)")
            var eventTypeId: Int
            eventTypeId = getEventTypeId(eventTypeName: eventType)
            
            let AddEvent = EventModel(ownerId: profileId!, name: eventName, dateTime: formatedEventDateTime, address1: eventAddress1, address2: eventAddress2, city: eventCity, zipCode: eventZipCode, country: eventCountry, state: eventState, eventType: eventTypeId, eventId: 0, isActive: true, eventState: 0)
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
                    self.createEventLabel.isHidden = false
                    self.createEventLabel.textColor = UIColor(red: 82/256, green: 156/256, blue: 32/256, alpha: 1.0) // UIColor(red: 204/256, green: 0/256, blue: 0/256, alpha: 1.0)
                    
                    self.createEventLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
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
                    self.eventTypeTextField.text?.removeAll()
                    
                    self.scroll2Top()
                 case .failure(let error):
                    self.createEventLabel.text = error.localizedDescription
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
        } else if activePickerViewTextField == eventTypeTextField {
            return eventtypeData.count
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
                } else if activePickerViewTextField == eventTypeTextField {
            return eventtypeData[row].eventTypeName
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
        } else if activePickerViewTextField == eventTypeTextField {
            eventTypeTextField.text = eventtypeData[row].eventTypeName
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
        } else if activePickerViewTextField == eventTypeTextField {
            activePickerViewTextField.inputView = pickerView
        }
        
    }
}

