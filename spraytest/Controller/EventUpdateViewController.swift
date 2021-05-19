//
//  EventUpdateViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 6/6/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class EventUpdateViewController: UIViewController  {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDateTimeTextField: UITextField!
    @IBOutlet weak var eventTypeTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var eventCodeTextField: UITextField!
    
    @IBOutlet weak var eventStatusSwitch: UISwitch!
    
    @IBOutlet weak var closeEventLabel: UILabel!
    
    @IBOutlet weak var saveButton: MyCustomButton!
    
    
    @IBOutlet weak var messageLabel: UILabel!
    var activePickerViewTextField = UITextField()
    
    @IBOutlet weak var isSingleReceiverSwitch: UISwitch!
    
    @IBOutlet weak var isRSVPRequiredSwitch: UISwitch!
    
    @IBOutlet weak var eventNameErrorLabel: UILabel!
    @IBOutlet weak var eventDateTimeErrorLabel: UILabel!
    @IBOutlet weak var eventTypeErrorLabel: UILabel!
    @IBOutlet weak var address1ErrorLabel: UILabel!
    @IBOutlet weak var address2ErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var stateErrorLabel: UILabel!
    @IBOutlet weak var zipcodeErrorLabel: UILabel!
    @IBOutlet weak var countryErrorLabel: UILabel!
    
    var stateData: [String] = []
    var countryData: [String] = []
    //var eventtypeData: [String] = []
    var eventtypeData: [EventTypeData] = []
    
    var formValidation =   Validation()
    let customtextfield = CustomTextField()
    
    //instantiate picker view objects
    var datePicker = UIDatePicker()
    var pickerView = UIPickerView()
    var evenTypePicker = UIDatePicker()
    
   
    
    var eventName: String?
    var eventDateTime: String?
    var eventZipCode: String?
    var eventAddress1: String?
    var eventAddress2: String?
    var eventCity: String?
    var eventType: String?
    var eventState: String?
    var eventCountry: String?
    var eventCode: String?
    var eventStatus: Bool?
    var eventId: Int64?
    var profileId: Int64?
    var token: String?
    var isEventEdited: Bool = false
    var refreshscreendelegate: RefreshScreenDelegate?
    var isRSPRequired: Bool = false
    var isSingleReceiverEvent: Bool = false
    var encryptedAPIKey: String = ""
    //testing back button nav
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //use to keep keyboard down
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        messageLabel.text = ""
        closeEventLabel.text = ""
        //code for passing data back to the previous screen
       // navigationController?.delegate = self
        
        isSingleReceiverSwitch.isOn = isSingleReceiverEvent
        isRSVPRequiredSwitch.isOn = isRSPRequired
        
        if eventStatus == true {
            eventStatusSwitch.isOn = true
            enableDisableTextFields(enable: true)
            closeEventLabel.text = "Cancel Event"
        } else {
            eventStatusSwitch.isOn = false
            enableDisableTextFields(enable: false)
            closeEventLabel.text = "Activate Event"
        }
        
        eventNameTextField.text = eventName
        eventDateTimeTextField.text = eventDateTime //dateFormatTime2(date: date)
        address1TextField.text = eventAddress1
        address2TextField.text = eventAddress2
        cityTextField.text = eventCity
        stateTextField.text = eventState
        zipCodeTextField.text = eventZipCode
        countryTextField.text = eventCountry
        eventCodeTextField.text = eventCode
        eventTypeTextField.text = eventType
        
        print(" view did load\(eventDateTime!)")
        //data for the date picker
        stateData = ["Select State", "Texas", "New York", "California"]
        countryData = ["Select Country", "USA", "England", "Nigeria", "Ghana"]
        //eventtypeData = ["Birthday","Anniversary", "Wedding", "Graduation", "Concert", "Baby Shower", "Naming Ceremony"]

        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        addEventTypeData()
        createDatePicker()
        createEventTypePicker()
        
        
        eventNameTextField.delegate = self
        eventDateTimeTextField.delegate = self
        eventTypeTextField.delegate = self
        address1TextField.delegate = self
        address2TextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate  = self
        zipCodeTextField.delegate = self
        countryTextField.delegate = self
        
        eventNameTextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventDateTimeTextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventTypeTextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        address1TextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        address2TextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        stateTextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        zipCodeTextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(EventUpdateViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        // Do any additional setup after loading the view.
        customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventDateTimeTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: address1TextField, validationFlag: false)
        customtextfield.borderForTextField(textField: address2TextField, validationFlag: false)
        customtextfield.borderForTextField(textField: cityTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: stateTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: zipCodeTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: countryTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventCodeTextField, validationFlag: false)
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
        
//
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock
            // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
 
    
    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)

           // When you want to send data back to the caller
           // call the method on the delegate
        
           if let refreshscreendelegate = self.refreshscreendelegate {
            refreshscreendelegate.refreshScreen(isRefreshScreen: true)
            print("ViewWill Disappear")
           }
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            debugPrint("Back Button pressed Home.")
//            
//            self.refreshscreendelegate?.refreshScreen(isRefreshScreen: true)
            
        }
    }

    
//    override func viewWillDisappear(_ animated : Bool) {
//        super.viewWillDisappear(animated)
//
//        print("beginig of Viewwill disapper")
//        // When you want to send data back to the caller
//        // call the method on the delegate
//        if let refreshscreendelegate2 = self.refreshscreendelegate {
//            refreshscreendelegate2.refreshScreen(isRefreshScreen: true)
//         print("ViewWill Disappear")
//        }
//    }
    
   // override func didMove(toParent parent: UIViewController?) {
     //     super.didMove(toParent: parent)
          
          
          
        //if parent == nil {
            //refreshscreendelegate?.refreshScreen(isRefreshScreen:true)
           // self.refreshscreendelegate!.refreshScreen(isRefreshScreen: true)
            
//              sprayDelegate?.sprayGifterBalance(balance: gifterBalance )
//              sprayDelegate?.sprayReceiverBalance(balance: sprayAmount)
//              sprayDelegate?.processSprayTransaction(eventId: Int(eventId), senderId: Int(profileId), senderAmountRemaining: gifterBalance, receiverAmountReceived: sprayAmount, paymentMethod: 5)
//              debugPrint("Back Button pressed.")
          //}
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    func enableDisableTextFields(enable: Bool) {
        switch enable {
        case true:
            eventNameTextField.isEnabled = true
            eventDateTimeTextField.isEnabled = true
            eventTypeTextField.isEnabled = true
            address1TextField.isEnabled = true
            address2TextField.isEnabled = true
            cityTextField.isEnabled = true
            stateTextField.isEnabled = true
            zipCodeTextField.isEnabled = true
            countryTextField.isEnabled = true
            saveButton.isEnabled = true
        case false:
            eventNameTextField.isEnabled = false
            eventDateTimeTextField.isEnabled = false
            eventTypeTextField.isEnabled = false
            address1TextField.isEnabled = false
            address2TextField.isEnabled = false
            cityTextField.isEnabled = false
            stateTextField.isEnabled = false
            zipCodeTextField.isEnabled = false
            countryTextField.isEnabled = false
            saveButton.isEnabled = false
        default:
            break
        }
    }
    @IBAction func cancelCloseEventSwitch(_ sender: UISwitch) {
        //disable all fields
        if sender.isOn == true {
            enableDisableTextFields(enable: true)
            closeEventLabel.text = "Cancel Event"
        } else {
            enableDisableTextFields(enable: false)
            closeEventLabel.text = "Activate Event"
        }

    }
    func scroll2Top() {
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    //use to go back after after update
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
           (viewController as? HomeViewController)?.isRefreshData = true // Here you pass the to your original view controller
    }
    
    func addEventTypeData(){
        //var array: [EventTypeData] = []
        eventtypeData.append(EventTypeData(id: 0, eventTypeName: "Select Event Type"))
        eventtypeData.append(EventTypeData(id: 1, eventTypeName: "Birthday"))
        eventtypeData.append(EventTypeData(id: 2, eventTypeName: "Anniversary"))
        eventtypeData.append(EventTypeData(id: 7, eventTypeName: "Street Entertainer"))
        eventtypeData.append(EventTypeData(id: 3, eventTypeName: "Wedding"))
        eventtypeData.append(EventTypeData(id: 4, eventTypeName: "Baby Shower"))
        eventtypeData.append(EventTypeData(id: 5, eventTypeName: "Graduation"))
        eventtypeData.append(EventTypeData(id: 6, eventTypeName: "Naming Ceremony"))
        eventtypeData.append(EventTypeData(id: 8, eventTypeName: "Family Reunion"))
        eventtypeData.append(EventTypeData(id: 9, eventTypeName: "Concert"))
        eventtypeData.append(EventTypeData(id: 10, eventTypeName: "General Party"))
        eventtypeData.append(EventTypeData(id: 11, eventTypeName: "Waiter"))
        eventtypeData.append(EventTypeData(id: 12, eventTypeName: "Cover Band"))
        eventtypeData.append(EventTypeData(id: 13, eventTypeName: "Thanksgiving"))
       // print(eventtypeData )
    }
    
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
    
    func createEventTypePicker(){
          eventTypeTextField.textAlignment = .left
          let toolbar = UIToolbar()
          toolbar.sizeToFit()
          let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(eventTypeDonePressed))
          
          toolbar.setItems([doneBtn], animated: true)
          //assign toolbar
          eventTypeTextField.inputAccessoryView = toolbar
          eventTypeTextField.inputView = evenTypePicker
            self.borderForTextField(textField: eventTypeTextField, validationFlag: false)
            eventTypeErrorLabel.isHidden = true
            eventTypeErrorLabel.text = ""
        
          //datePicker.datePickerMode = .dateAndTime
       }
    @objc func eventTypeDonePressed() {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
          eventTypeTextField.text  = dateFormatter.string(from: datePicker.date)
          self.view.endEditing(true)
         
      }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a" //yyyy-MM-dd'T'HH:mm"
        eventDateTimeTextField.text   = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        self.borderForTextField(textField: eventDateTimeTextField, validationFlag: false)
        eventDateTimeErrorLabel.isHidden = true
        eventDateTimeErrorLabel.text = ""
    }
    
    func dateFormatTime2(date : Date) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a"
          return dateFormatter.string(from: date)
      }
    func dateFormatTime(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    
    //data format
    func getFormattedDate(date: Date, format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: date)
     }
    
//    func getFormattedDate(date: String, format: String) -> String {
//        let dateformat = DateFormatter()
//        dateformat.dateFormat = format
//               
//           
//        let mydate = dateformat.date(from: date)!
//        let date1 = mydate
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        //var dateString = dateFormatter.string(from: date1)
//        return dateFormatter.string(from: date1)
//        //println(dateString)
//                 
//        //return dateformat.string(from: date)
//    }
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
    
    
    
    @IBAction func saveEventButtonPressed(_ sender: Any) {
        
//        if eventStatusSwitch.isOn == true {
//            let closeEvent = CloseEvent(profileId: profileId!, eventId: eventId!)
//            print("closeEvent = \(closeEvent)")
//            let request = PostRequest(path: "/api/Event/close", model: closeEvent, token: "")
//
//             Network.shared.send(request) { (result: Result<Empty, Error>)  in
//                switch result {
//                case .success(let user):
//                  break
//
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        } else  {
        if eventStatusSwitch.isOn == true  {
            eventStatus = true
        } else {
            eventStatus = false
        }
        
        guard let eventName = eventNameTextField.text,
              //print("This is the second event name \(eventName!)")
            let  eventDateTime = eventDateTimeTextField.text,
            let  eventAddress1 = address1TextField.text,
            let  eventAddress2 = address2TextField.text,
            let  eventCity = cityTextField.text,
            let  eventState = stateTextField.text,
            let  eventCountry = countryTextField.text,
            let  eventZipCode = zipCodeTextField.text,
            let  eventType = eventTypeTextField.text
            
            
            else {
                return
            }
        
       
        
           
            print("eventName = \(eventName)")
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
                self.borderForTextField(textField: eventNameTextField, validationFlag: true)
                print("I am still here")
                //print("Incorrect First Name")
                //loadingLabel.text = "Incorrect First Name"
                eventNameErrorLabel.isHidden = false
                eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventName).errorMsg
                return
            } else {
                self.borderForTextField(textField: eventNameTextField, validationFlag: false)
                eventNameErrorLabel.isHidden = true
                eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventName).errorMsg
            }
            
            if (isValidateEventDateTime == false) {
                eventDateTimeTextField.becomeFirstResponder()
                self.borderForTextField(textField: eventDateTimeTextField, validationFlag: true)
                print("isValidateEventDateTime = false")
                //print("Incorrect First Name")
                //loadingLabel.text = "Incorrect First Name"
                eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTime).errorMsg
                return
            } else {
                print("isValidateEventDateTime = true")
                self.borderForTextField(textField: eventDateTimeTextField, validationFlag: false)
                eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTime).errorMsg
            }
            
            if (isValidateEventType == false) {
                eventTypeTextField.becomeFirstResponder()
                self.borderForTextField(textField: eventTypeTextField, validationFlag: true)
                //print("Incorrect First Name")
                //loadingLabel.text = "Incorrect First Name"
                eventTypeErrorLabel.text = self.formValidation.validateName2(name2: eventType).errorMsg
                return
            } else {
                self.borderForTextField(textField: eventTypeTextField, validationFlag: false)
                eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventType).errorMsg
            }
            
            if (isValidateAddress1 == false) {
                address1TextField.becomeFirstResponder()
                self.borderForTextField(textField: address1TextField, validationFlag: true)
                //print("Incorrect First Name")
                //loadingLabel.text = "Incorrect First Name"
                address1ErrorLabel.text = self.formValidation.validateName2(name2: eventAddress1).errorMsg
                return
            } else {
                self.borderForTextField(textField: address1TextField, validationFlag: false)
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
            cityTextField.becomeFirstResponder()
            self.borderForTextField(textField: cityTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            cityErrorLabel.text = self.formValidation.validateName2(name2: eventCity).errorMsg
            return
        } else {
            self.borderForTextField(textField: cityTextField, validationFlag: false)
            cityErrorLabel.text = self.formValidation.validateName2(name2: eventCity).errorMsg
        }
        
        if (isValidateState == false) {
            stateTextField.becomeFirstResponder()
            self.borderForTextField(textField: stateTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            stateErrorLabel.text = self.formValidation.validateName2(name2: eventState).errorMsg
            return
        } else {
            self.borderForTextField(textField: stateTextField, validationFlag: false)
            stateErrorLabel.text = self.formValidation.validateName2(name2: eventState).errorMsg
        }
        
        if (isValidateZipCode == false) {
            zipCodeTextField.becomeFirstResponder()
            self.borderForTextField(textField: zipCodeTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            zipcodeErrorLabel.text = self.formValidation.validateName2(name2: eventZipCode).errorMsg
            return
        } else {
            self.borderForTextField(textField: zipCodeTextField, validationFlag: false)
            zipcodeErrorLabel.text = self.formValidation.validateName2(name2: eventZipCode).errorMsg
        }
        
        if (isValidateCountry == false) {
            countryTextField.becomeFirstResponder()
            self.borderForTextField(textField: countryTextField, validationFlag: true)
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            countryErrorLabel.text = self.formValidation.validateName2(name2: eventCountry).errorMsg
            return
        } else {
            self.borderForTextField(textField: countryTextField, validationFlag: false)
            countryErrorLabel.text = self.formValidation.validateName2(name2: eventCountry).errorMsg
        }
        
        
        if (isValidateEventName == true || isValidateEventDateTime == true || isValidateEventType == true || isValidateAddress1 == true ||  isValidateCity == true || isValidateState == true || isValidateZipCode == true || isValidateCountry == true ) {

            
            //print("address2TextField.text =\(address2TextField.text)")
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a"
            let date = dateFormatter.date(from:String(eventDateTime))!

            print("data = \(date)")
            let formatedEventDateTime  = getFormattedDate(date: date, format: "yyyy-MM-dd'T'HH:mm:ss")
            
            print("formatedEventDateTime \(formatedEventDateTime)")
            var eventTypeId: Int
           
            eventTypeId = getEventTypeId(eventTypeName: eventType)
            
            print("eventTypeId =\(eventTypeId)")
            print("eventType Name =\(eventType)")
            
           
                
            print("event date time =\(eventDateTime)")
            print("this is the 3rd event name \(eventName)")
            //let newUser = UserModel(id: 2, name: "Peter", username: "Livesey", email: "941ecfff8dc3@medium.com")
            let eventData = EventModelEdit(ownerId: profileId!, name: eventName, dateTime: formatedEventDateTime, address1: eventAddress1, address2: eventAddress2, city: eventCity, zipCode: eventZipCode, country: eventCountry, state: eventState, eventType: eventTypeId, isRsvprequired: isRSVPRequiredSwitch.isOn, isSingleReceiver: isSingleReceiverSwitch.isOn, eventId: eventId!, isActive: eventStatus!, eventState: 1)
                    
            print(eventData)
            let request = PostRequest(path: "/api/Event/update", model: eventData, token: token!, apiKey: encryptedAPIKey, deviceId: "")
            Network.shared.send(request) { (result: Result<Data, Error>) in
                switch result {
                case .success(let eventdata1):
                    print("eventdate =\(eventdata1.description)")
                    let decoder = JSONDecoder()
                    do {
                       let eventDataJson: EventDataReturned = try decoder.decode(EventDataReturned.self, from: eventdata1)
                      // for dataoutput in eventDataJson {
          
                           
                        if eventDataJson.success == false {
                                
                            self.messageLabel.textColor = UIColor(red: 204/256, green: 0/256, blue: 0/256, alpha: 1.0)
                            self.messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                            self.messageLabel.text = eventDataJson.errorCode! + ": " + eventDataJson.errorMessage!
                        }else {
                                
                            self.messageLabel.textColor = UIColor(red: 82/256, green: 156/256, blue: 32/256, alpha: 1.0)
                            self.messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                            self.messageLabel.text = "Event was updated successfully."
                        }
                        //}

                    } catch {
                        self.messageLabel.textColor = UIColor(red: 204/256, green: 0/256, blue: 0/256, alpha: 1.0)
                        self.messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                        self.messageLabel.text = "Network error from catch: \(error.localizedDescription)"
                        //print(error.localizedDescription)
                   }
      
                   self.isEventEdited = true
                    
                    //call authentication func
                    //self.authenticateUser(userName: self.username!, password: self.password!)
                    //self.loadingLabel.text = "Registration was successful..."
                case .failure(let error):
                    self.messageLabel.textColor = UIColor(red: 204/256, green: 0/256, blue: 0/256, alpha: 1.0)
                    self.messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                    self.messageLabel.text = "Network error from case: \(error.localizedDescription)"
                }
            }
    
            }
       // }
        scroll2Top()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    private func borderForTextField(textField: UITextField, validationFlag: Bool) {

        if validationFlag == false {
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 211/256, green: 211/256, blue: 211/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
        } else {
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==0{
                switch textField{
                case eventNameTextField :
                    self.borderForTextField(textField: eventNameTextField, validationFlag: true)
                    eventNameErrorLabel.isHidden = false
                    eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventNameTextField.text!).errorMsg//"Missing Event Name."
                    eventNameTextField.becomeFirstResponder()
                case eventDateTimeTextField:
                    self.borderForTextField(textField: eventDateTimeTextField, validationFlag: true)
                    eventDateTimeErrorLabel.isHidden = false
                    eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTimeTextField.text!).errorMsg
                    eventDateTimeTextField.becomeFirstResponder()
                case eventTypeTextField:
                    self.borderForTextField(textField: eventTypeTextField, validationFlag: true)
                    eventTypeErrorLabel.isHidden = false
                    eventTypeErrorLabel.text = self.formValidation.validateName2(name2: eventTypeTextField.text!).errorMsg
                    eventTypeTextField.becomeFirstResponder()
                case address1TextField:
                    self.borderForTextField(textField: address1TextField, validationFlag: true)
                    address1ErrorLabel.isHidden = false
                    address1ErrorLabel.text = self.formValidation.validateName2(name2: address1TextField.text!).errorMsg
                    address1TextField.becomeFirstResponder()
//                case address2TextField:
//                    self.borderForTextField(textField: address2TextField, validationFlag: true)
//                    address2ErrorLabel.isHidden = false
//                    address2ErrorLabel.text = "Missing Address 2"
//                    address2TextField.becomeFirstResponder()
                case cityTextField:
                    self.borderForTextField(textField: cityTextField, validationFlag: true)
                    cityErrorLabel.isHidden = false
                    cityErrorLabel.text = self.formValidation.validateName2(name2: cityTextField.text!).errorMsg
                    cityTextField.becomeFirstResponder()
                case stateTextField:
                    self.borderForTextField(textField: stateTextField, validationFlag: true)
                    stateErrorLabel.isHidden = false
                    stateErrorLabel.text = self.formValidation.validateName2(name2:  stateTextField.text!).errorMsg
                    stateTextField.becomeFirstResponder()
                case zipCodeTextField:
                    self.borderForTextField(textField: zipCodeTextField, validationFlag: true)
                    zipcodeErrorLabel.isHidden = false
                    zipcodeErrorLabel.text = self.formValidation.validateName2(name2: zipCodeTextField.text!).errorMsg
                    zipCodeTextField.becomeFirstResponder()
                case countryTextField:
                    self.borderForTextField(textField: countryTextField, validationFlag: true)
                    countryErrorLabel.isHidden = false
                    countryErrorLabel.text = self.formValidation.validateName2(name2: countryTextField.text!).errorMsg
                    countryTextField.becomeFirstResponder()
                default:
                    break
                }
            }else{
                switch textField{
                case eventNameTextField :
                    eventNameErrorLabel.isHidden = true
                    eventNameErrorLabel.text = ""
                    self.borderForTextField(textField: eventNameTextField, validationFlag: false)
                case eventDateTimeTextField:
                    eventDateTimeErrorLabel.isHidden = true
                    eventDateTimeErrorLabel.text = ""
                    self.borderForTextField(textField: eventDateTimeTextField, validationFlag: false)
                case eventTypeTextField:
                    eventTypeErrorLabel.isHidden = true
                    eventTypeErrorLabel.text = ""
                    self.borderForTextField(textField: eventTypeTextField, validationFlag: false)
                case address1TextField:
                    address1ErrorLabel.isHidden = true
                    address1ErrorLabel.text = ""
                    self.borderForTextField(textField: address1TextField, validationFlag: false)
//                case address2TextField:
//                    address2ErrorLabel.isHidden = true
//                    address2ErrorLabel.text = ""
//                    self.borderForTextField(textField: address2TextField, validationFlag: false)
                case cityTextField:
                    cityErrorLabel.isHidden = true
                    cityErrorLabel.text = ""
                    self.borderForTextField(textField: cityTextField, validationFlag: false)
                case stateTextField:
                    stateErrorLabel.isHidden = true
                    stateErrorLabel.text = ""
                    self.borderForTextField(textField: stateTextField, validationFlag: false)
                case zipCodeTextField:
                    zipcodeErrorLabel.isHidden = true
                    zipcodeErrorLabel.text = ""
                    self.borderForTextField(textField: zipCodeTextField, validationFlag: false)
                case countryTextField:
                    countryErrorLabel.isHidden = true
                    countryErrorLabel.text = ""
                    self.borderForTextField(textField: countryTextField, validationFlag: false)
                default:
                    break
                    
                }
            }
    }

//    private func addBottomLineToTextField(textField: UITextField) {
//            
//           let bottomLine = CALayer()
//           bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
//           bottomLine.backgroundColor = UIColor.init(red: 2/3, green: 2/3, blue: 2/3, alpha: 1.0).cgColor
//           //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
//           textField.borderStyle = .none
//            
//            textField.layer.addSublayer(bottomLine)
//            
//        }
       
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
        } else if activePickerViewTextField == eventTypeTextField {
            return eventtypeData.count
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
        } else if activePickerViewTextField == eventTypeTextField {
            return eventtypeData[row].eventTypeName
        } else {
            return ""
        }
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activePickerViewTextField == stateTextField {
            stateTextField.text = stateData[row]
            self.borderForTextField(textField: stateTextField, validationFlag: false)
            stateErrorLabel.isHidden = true
            stateErrorLabel.text = ""
            self.view.endEditing(true)
        } else if activePickerViewTextField == countryTextField {
            countryTextField.text = countryData[row]
            self.borderForTextField(textField: countryTextField, validationFlag: false)
            countryErrorLabel.isHidden = true
            countryErrorLabel.text = ""
            self.view.endEditing(true)
        } else if activePickerViewTextField == eventTypeTextField {
            eventTypeTextField.text = eventtypeData[row].eventTypeName
            self.borderForTextField(textField: eventTypeTextField, validationFlag: false)
            eventTypeErrorLabel.isHidden = true
            eventTypeErrorLabel.text = ""
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
        } else if activePickerViewTextField == eventTypeTextField {
            activePickerViewTextField.inputView = pickerView
        }
        
    }
}


//extension EventUpdateViewController: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        (viewController as? HomeViewController)?.isEventEdited = isEventEdited // Here you pass the to your original view controller
//    }
//}

//extension Date {
//   func getFormattedDate(format: String) -> String {
//        let dateformat = DateFormatter()
//        dateformat.dateFormat = format
//        return dateformat.string(from: self)
//    }
//}
extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}
