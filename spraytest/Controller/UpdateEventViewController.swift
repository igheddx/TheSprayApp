//
//  UpdateEventViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 3/4/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class UpdateEventViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileLable: UILabel!
    @IBOutlet weak var createEventLabel: UILabel!
    var createEventTitle: String?
    
  
    
    @IBOutlet weak var eventCurrentStateSegCont: UISegmentedControl!
    //    var profileId: Int64 = 0
//    var token: String?
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
    
    @IBOutlet weak var isSingleReceiverSwitch: UISwitch!
    
    @IBOutlet weak var isRSVPRequiredSwitch: UISwitch!
    @IBOutlet weak var eventCodeLbl: UILabel! //UITextField!
    
    @IBOutlet weak var eventStatusSwitch: UISwitch!
    
    //@IBOutlet weak var closeEventLabel: UILabel!
    
    @IBOutlet weak var saveButton: MyCustomButton!
    @IBOutlet weak var isForBusinessSwitch: Switch1!
   
    
    @IBOutlet weak var eventStatusTextField: CustomTextField2!
    //@IBOutlet weak var eventDateTimeErrorLabel: UILabel!
//    @IBOutlet weak var eventTypeErrorLabel: UILabel!
//    @IBOutlet weak var address1ErrorLabel: UILabel!
//    @IBOutlet weak var address2ErrorLabel: UILabel!
//    @IBOutlet weak var cityErrorLabel: UILabel!
//    @IBOutlet weak var stateErrorLabel: UILabel!
//    @IBOutlet weak var zipcodeErrorLabel: UILabel!
//    @IBOutlet weak var countryErrorLabel: UILabel!
    
    var customtextfield = CustomTextField()
    var countrylist: [CountryList] = []
    var countrystatelist: [CountryStateList] = []
    var eventStatusList: [EventStatus] = []
    var statelist: [StateList] = []
    var stateData: [String] = []
    var countryData: [String] = []
    var eventtypeData: [EventTypeData] = []
    var countryList: [String] = []
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
    var eventType: String?
    var eventState: String?
    var eventCountry: String?
    var eventCode: String?
    var eventStatus: Bool?
    var eventId: Int64?
    var profileId: Int64 = 0
    var token: String?
    var encryptedAPIKey: String =  ""
    var isEventEdited: Bool = false
    var refreshscreendelegate: RefreshScreenDelegate?
    var isRSVPRequired: Bool = false
    var isSingleReceiverEvent: Bool = false
    var eventCurrentState: Int? // 2 //99 is default
    var isRefreshScreen: Bool = false
    var isForBusiness: Bool?
    var isForBusinessCheck: Bool = false
    var isEventClosureCancel: Bool = false
    var isProceed: Bool = false
    var eventStage: Int = 1
//    var eventName: String?
//    var eventDateTime: String?
//    var eventZipCode: String?
//    var eventAddress1: String?
//    var eventAddress2: String?
//    var eventCity: String?
//    var eventState: String?
//    var eventType: String?
//    var eventCountry: String?
//    var eventCode: String?
//    var eventId: Int64?
    var selectedCountry: String?
    var eventStageId: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        print("eventCurrentState = \(eventCurrentState)")
        //always disable eventcode
        eventCodeLbl.isEnabled = false
        
        if eventStatus == true {
            //eventStatusSwitch.isOn = false
            enableDisableTextFields(enable: true)
            //closeEventLabel.text = "Event Is Active"
        } else {
            //eventStatusSwitch.isOn = true
            enableDisableTextFields(enable: false)
           // closeEventLabel.text = "Inactive Event"
        }
        
        
        if let i = isForBusiness {
            isForBusinessCheck = i
        } else {
            isForBusinessCheck = false
        }
        
        isSingleReceiverSwitch.isOn = isSingleReceiverEvent
        isRSVPRequiredSwitch.isOn = isRSVPRequired
        isForBusinessSwitch.isOn = isForBusinessCheck
    
        self.navigationItem.title = "Update Event"
          
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        pickerView.setValue(UIColor.black, forKey:"textColor")
        
        
        countrystatelist.removeAll()
        statelist.removeAll()
        eventtypeData.removeAll()
        countrylist.removeAll()
        eventStatusList.removeAll()
        
        loadCountryList()
        loadCountryStateListData()
        EventStatusList()
        
        eventNameTextField.text = eventName
        eventDateTextField.text = eventDateTime //dateFormatTime2(date: date)
        eventAddress1TextField.text = eventAddress1
        eventAddress2TextField.text = eventAddress2
        eventCityTextField.text = eventCity
        eventStateTextField.text = eventState
        eventZipCodeTextField.text = eventZipCode
        eventCountryTextField.text = eventCountry
        eventCodeLbl.text = eventCode
        eventTypeTextField.text = eventType
        eventStatusTextField.text = eventStageConversionId(statusId: eventCurrentState!)
        
        eventNameTextField.delegate = self
        eventDateTextField.delegate = self
        eventTypeTextField.delegate = self
        eventAddress1TextField.delegate = self
        eventAddress2TextField.delegate = self
        eventCityTextField.delegate = self
        eventStateTextField.delegate  = self
        eventZipCodeTextField.delegate = self
        eventCountryTextField.delegate = self
        eventStatusTextField.delegate = self
        //textFiled.delegate = self
        
        eventNameTextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventDateTextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventTypeTextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventAddress1TextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventAddress2TextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventCityTextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventStateTextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventZipCodeTextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventCountryTextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        eventStatusTextField.addTarget(self, action: #selector(UpdateEventViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        
        
        //createPickerView()
        dismissPickerView()
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
        customtextfield.borderForTextField(textField: eventStatusTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventStatusTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: false)
        //customtextfield.borderForTextField(textField: eventCodeTextField, validationFlag: false)
                
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock
            // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        scroll2Top()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
               //self.delegate.updateData( data)
            print(" I am moving back")
            refreshscreendelegate?.refreshScreen(isRefreshScreen: isRefreshScreen)
        }
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }


    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }


    func scroll2Top() {
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    func enableDisableTextFields(enable: Bool) {
        switch enable {
        case true:
            eventNameTextField.isEnabled = true
            eventDateTextField.isEnabled = true
            eventTypeTextField.isEnabled = true
            eventAddress1TextField.isEnabled = true
            eventAddress2TextField.isEnabled = true
            eventCityTextField.isEnabled = true
            eventStateTextField.isEnabled = true
            eventZipCodeTextField.isEnabled = true
            eventCountryTextField.isEnabled = true
            eventStatusTextField.isEnabled = true
            saveButton.isEnabled = true
        case false:
            eventNameTextField.isEnabled = false
            eventDateTextField.isEnabled = false
            eventTypeTextField.isEnabled = false
            eventAddress1TextField.isEnabled = false
            eventAddress2TextField.isEnabled = false
            eventCityTextField.isEnabled = false
            eventStateTextField.isEnabled = false
            eventZipCodeTextField.isEnabled = false
            eventCountryTextField.isEnabled = false
            eventStatusTextField.isEnabled = false
            saveButton.isEnabled = false
        default:
            break
        }
    }
    
    /*no longer in use 7/19/2021*/
    func loadEventCurrentStateSegCont() {
        eventCurrentStateSegCont.setTitle("Created", forSegmentAt: 0)
        eventCurrentStateSegCont.setTitle("Open", forSegmentAt: 1)
        eventCurrentStateSegCont.setTitle("Close", forSegmentAt: 2)
        eventCurrentStateSegCont.setTitle("Cancel", forSegmentAt: 3)
    }
    
    @IBAction func sprayCelebrantSwitchSelect(_ sender: Any) {
        if isSingleReceiverSwitch.isOn == true {
            isForBusinessSwitch.isOn = false
           // isForBusinessSwitch.isEnabled = false
        } else {
            isForBusinessSwitch.isOn = false
            //isForBusinessSwitch.isEnabled = true
        }
        
    }
    
    @IBAction func rsvpSwitchSelect(_ sender: Any) {
        if isRSVPRequiredSwitch.isOn == true {
            isForBusinessSwitch.isOn = false
            //isForBusinessSwitch.isEnabled = false
        } else {
            isForBusinessSwitch.isOn = false
            //isForBusinessSwitch.isEnabled = true
        }
     
    }
    
    
    @IBAction func forBusinessSwitchSelect(_ sender: Any) {
        if isForBusinessSwitch.isOn == true {
            isSingleReceiverSwitch.isOn = false
            //isSingleReceiverSwitch.isEnabled = false
            isRSVPRequiredSwitch.isOn = false
            //isRSVPRequiredSwitch.isEnabled = false
        } else {
            isSingleReceiverSwitch.isOn = false
            //isSingleReceiverSwitch.isEnabled = true
            isRSVPRequiredSwitch.isOn = false
            //isRSVPRequiredSwitch.isEnabled = true
        }
      
        
    }
    
    @IBAction func eventCurrentStateSegContPressed(_ sender: Any) {
        eventCurrentState = eventCurrentStateSegCont.selectedSegmentIndex
        
    }
    /*@IBAction func cancelCloseEventSwitch(_ sender: UISwitch) {
        //disable all fields
        if eventStatus == true {
            if sender.isOn == true {
                enableDisableTextFields(enable: false)
                //closeEventLabel.text = "Inactivate Event"
            } else {
                enableDisableTextFields(enable: true)
                //closeEventLabel.text = "Event Is Active"
            }
        } else {
            if sender.isOn == true {
                enableDisableTextFields(enable: true)
                //closeEventLabel.text = "Event Is Active"
            } else {
                enableDisableTextFields(enable: false)
                //closeEventLabel.text = "Inactivate Event"
            }
        }
        
//        if sender.isOn == true {
//            enableDisableTextFields(enable: true)
//            closeEventLabel.text = "Cancel Event"
//        } else {
//            enableDisableTextFields(enable: false)
//            closeEventLabel.text = "Activate Event"
//        }

    }*/
    
    
//    func scroll2Top() {
//        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
//    }
    func loadCountryList() {
        let data0 = CountryList(countryCode: "OO", countryName: "Select Country")
        countrylist.append(data0)
        let data1 = CountryList(countryCode: "US", countryName: "United States")
        countrylist.append(data1)
        let data2 = CountryList(countryCode: "NG", countryName: "Nigeria")
        countrylist.append(data2)
        let data3 = CountryList(countryCode: "UK", countryName: "United Kingdom")
        countrylist.append(data3)
        let data4 = CountryList(countryCode: "IN", countryName: "India")
        countrylist.append(data4)
    }
    
    func EventStatusList() {
        let data1 = EventStatus(statusId: 1, status: "Created")
            eventStatusList.append(data1)
        
        let data2 = EventStatus(statusId: 2, status: "Open")
        eventStatusList.append(data2)
        
        let data3 = EventStatus(statusId: 3, status: "Close")
        eventStatusList.append(data3)
        
        let data4 = EventStatus(statusId: 4, status: "Cancel")
        eventStatusList.append(data4)
    }
    
    /*get event stage Id*/
    func eventStageConversion(status: String) -> Int {
        var statusId: Int = 0
        //myStatus = status
        for theEventStage in eventStatusList {
            if status == theEventStage.status {
                statusId = theEventStage.statusId
                break
            }
        }
        return statusId
    }
    
    /*get event Stage name*/
    func eventStageConversionId(statusId: Int) -> String {
        var status: String = ""
        //myStatus = status
        for theEventStage in eventStatusList {
             
            if statusId == theEventStage.statusId {
                status = theEventStage.status
                break
            }
        }
        return status
    }
    
    func loadCountryStateListData() {
        let data01 = CountryStateList(countryCode: "US", countryName: "United States", stateCode: "OO", stateName: "Select State")
        countrystatelist.append(data01)
        let data1 = CountryStateList(countryCode: "US", countryName: "United States", stateCode: "TX", stateName: "Texas")
        countrystatelist.append(data1)
        
        let data2 = CountryStateList(countryCode: "US", countryName: "United States", stateCode: "NY", stateName: "New York")
        countrystatelist.append(data2)
        let data3 = CountryStateList(countryCode: "US", countryName: "United States", stateCode: "CA", stateName: "California")
        countrystatelist.append(data3)
        let data02 = CountryStateList(countryCode: "NG", countryName: "Nigeria", stateCode: "OO", stateName: "Select State")
        countrystatelist.append(data02)
        let data4 = CountryStateList(countryCode: "NG", countryName: "Nigeria", stateCode: "LG", stateName: "Lagos")
        countrystatelist.append(data4)
        let data5 = CountryStateList(countryCode: "NG", countryName: "Nigeria", stateCode: "AB", stateName: "Abuja")
        countrystatelist.append(data5)
        let data6 = CountryStateList(countryCode: "NG", countryName: "Nigeria", stateCode: "DL", stateName: "Delta")
        countrystatelist.append(data6)
        let data03 = CountryStateList(countryCode: "UK", countryName: "United Kingdom", stateCode: "OO", stateName: "Select State")
        countrystatelist.append(data03)
        let data7 = CountryStateList(countryCode: "UK", countryName: "United Kingdom", stateCode: "LD", stateName: "London")
        countrystatelist.append(data7)
        let data8 = CountryStateList(countryCode: "UK", countryName: "United Kingdom", stateCode: "CB", stateName: "Cambridge")
        countrystatelist.append(data8)
        let data9 = CountryStateList(countryCode: "UK", countryName: "United Kingdom", stateCode: "CT", stateName: "Chester")
        countrystatelist.append(data9)
        let data04 = CountryStateList(countryCode: "IN", countryName: "India", stateCode: "OO", stateName: "Select State")
        countrystatelist.append(data04)
        let data10 = CountryStateList(countryCode: "IN", countryName: "India", stateCode: "MH", stateName: "Maharashtra")
        countrystatelist.append(data10)
        let data11 = CountryStateList(countryCode: "IN", countryName: "India", stateCode: "PB", stateName: "Punjab")
        countrystatelist.append(data11)
        
        //load statelist
        statelist.removeAll()
        print("event country name from HomeVC = \(eventCountry)")
        loadStateList(countryCode: getCountryCode(countryName: eventCountry!))
    }
    
    func getCountryCode(countryName: String) -> String {
        var myCountryCode: String = ""
        for country in countrylist {
            print("my country name is \(country.countryName)")
            if countryName == country.countryName {
                myCountryCode = country.countryCode
                print(" i got a country code =\(country.countryCode) ")
                break
            }
        }
        print("myCountryCode = \(myCountryCode)")
       return myCountryCode
    }
    //load state based on country selected
    func loadStateList(countryCode: String) {
        statelist.removeAll()
        print("countrystatelist = \(countrystatelist)")
        for country in countrystatelist {
    
            if country.countryCode == countryCode {
                print("my state list are \(country.stateName)")
                let stateData = StateList(stateCode: country.stateCode, stateName: country.stateName)
                statelist.append(stateData)
            }
        }
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
        self.tabBarController?.tabBar.isHidden = true
            if text?.utf16.count==0{
                switch textField{
                case eventNameTextField :
                    customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: true)
                    //eventNameErrorLabel.isHidden = false
                   // eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventNameTextField.text!).errorMsg//"Missing Event Name."
                    eventNameTextField.becomeFirstResponder()
                case eventDateTextField:
                    customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: true)
                    //eventDateTimeErrorLabel.isHidden = false
                    //eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTextField.text!).errorMsg
                    eventDateTextField.becomeFirstResponder()
                case eventTypeTextField:
                    customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: true)
                    //eventTypeErrorLabel.isHidden = false
                    //eventTypeErrorLabel.text = self.formValidation.validateName2(name2: eventTypeTextField.text!).errorMsg
                    eventTypeTextField.becomeFirstResponder()
                case eventAddress1TextField:
                    customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: true)
                    //address1ErrorLabel.isHidden = false
                    //address1ErrorLabel.text = self.formValidation.validateName2(name2: eventAddress1TextField.text!).errorMsg
                    eventAddress1TextField.becomeFirstResponder()
//                case address2TextField:
//                    self.borderForTextField(textField: address2TextField, validationFlag: true)
//                    address2ErrorLabel.isHidden = false
//                    address2ErrorLabel.text = "Missing Address 2"
//                    address2TextField.becomeFirstResponder()
                case eventCityTextField:
                    customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: true)
                    ///cityErrorLabel.isHidden = false
                    //cityErrorLabel.text = self.formValidation.validateName2(name2: eventCityTextField.text!).errorMsg
                    eventCityTextField.becomeFirstResponder()
                case eventStateTextField:
                    customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: true)
                    //stateErrorLabel.isHidden = false
                    //stateErrorLabel.text = self.formValidation.validateName2(name2:  eventStateTextField.text!).errorMsg
                    eventStateTextField.becomeFirstResponder()
                case eventZipCodeTextField:
                    customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: true)
                    //zipcodeErrorLabel.isHidden = false
                    //zipcodeErrorLabel.text = self.formValidation.validateName2(name2: eventZipCodeTextField.text!).errorMsg
                    eventZipCodeTextField.becomeFirstResponder()
                case eventCountryTextField:
                    customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: true)
                case eventStatusTextField:
                    customtextfield.borderForTextField(textField: eventStatusTextField, validationFlag: true)
                    //countryErrorLabel.isHidden = false
                    //self.formValidation.validateName2(name2: eventCountryTextField.text!).errorMsg
                    eventStatusTextField.becomeFirstResponder()
                default:
                    break
                }
            }else{
                switch textField{
                case eventNameTextField :
                    //eventNameErrorLabel.isHidden = true
                    //eventNameErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: false)
                case eventDateTextField:
                    //eventDateTimeErrorLabel.isHidden = true
                    //eventDateTimeErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
                case eventTypeTextField:
                   // eventTypeErrorLabel.isHidden = true
                   // eventTypeErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: false)
                case eventAddress1TextField:
                    //address1ErrorLabel.isHidden = true
                    //address1ErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: false)
//                case address2TextField:
//                    address2ErrorLabel.isHidden = true
//                    address2ErrorLabel.text = ""
//                    self.borderForTextField(textField: address2TextField, validationFlag: false)
                case eventCityTextField:
                    //cityErrorLabel.isHidden = true
                    //cityErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: false)
                case eventStateTextField:
                    //stateErrorLabel.isHidden = true
                    //stateErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: false)
                case eventZipCodeTextField:
                   // zipcodeErrorLabel.isHidden = true
                    //zipcodeErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: false)
                case eventCountryTextField:
                    //countryErrorLabel.isHidden = true
                    //countryErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: false)
                case eventStatusTextField:
                    //countryErrorLabel.isHidden = true
                    //countryErrorLabel.text = ""
                    customtextfield.borderForTextField(textField: eventStatusTextField, validationFlag: false)
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
//        eventtypeData.append(EventTypeData(id: 14, eventTypeName: "Waiter"))
//        eventtypeData.append(EventTypeData(id: 15, eventTypeName: "Street Entertainer"))
         // print(eventtypeData )
      }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case eventNameTextField :
                eventNameTextField.resignFirstResponder()
            case eventDateTextField:
                eventDateTextField.resignFirstResponder()
            case eventTypeTextField:
                eventTypeTextField.resignFirstResponder()
            case eventAddress1TextField:
                eventAddress1TextField.resignFirstResponder()
            case eventAddress2TextField:
                eventAddress2TextField.resignFirstResponder()
            case eventCityTextField:
                eventCityTextField.resignFirstResponder()
            case eventStateTextField:
                eventStateTextField.resignFirstResponder()
            case eventZipCodeTextField:
                eventZipCodeTextField.resignFirstResponder()
            case eventCountryTextField:
                eventCountryTextField.resignFirstResponder()
            case eventStatusTextField:
                eventStatusTextField.resignFirstResponder()
            default:
                break
        }
        return true
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
        self.tabBarController?.tabBar.isHidden = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy h:mm a" //yyyy-MM-dd'T'HH:mm"
        eventDateTextField.text   = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
        //eventDateTimeErrorLabel.isHidden = true
        //eventDateTimeErrorLabel.text = ""
    }
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           //textFiled.inputView = pickerView
    }
    func dismissPickerView() {
//       let toolBar = UIToolbar()
//       toolBar.sizeToFit()
//       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
//       toolBar.setItems([button], animated: true)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.action))
        toolBar.isUserInteractionEnabled = true
        toolBar.setItems([doneBtn], animated: true)
        //textFiled.inputAccessoryView = toolBar
        eventTypeTextField.inputAccessoryView = toolBar
        eventStateTextField.inputAccessoryView = toolBar
        eventCountryTextField.inputAccessoryView = toolBar
        eventStatusTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    private func addBottomLineToTextField(textField: UITextField) {
//         
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
//        bottomLine.backgroundColor = UIColor.init(red: 2/3, green: 2/3, blue: 2/3, alpha: 1.0).cgColor
//        //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
//        textField.borderStyle = .none
//         
//         textField.layer.addSublayer(bottomLine)
//         
//     }
    
    
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
    
    //set textfield focus and highlight border set
    func textFieldFocus(textField: UITextField) {
        textField.becomeFirstResponder()
        customtextfield.borderForTextField(textField: textField, validationFlag: true)
        
        print("There is focus")
        switch textField{
       
        case eventDateTextField:
            print("NOah ighedosa")
            self.tabBarController?.tabBar.isHidden = true
        default:
            break
        }
    }
    func displayAlertMessage(displayMessage: String, textField: UITextField) {
        let alert2 = UIAlertController(title: "Missing Information", message: displayMessage, preferredStyle: .alert)
        //alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] (action) in self.textFieldFocus(textField: textField)}))
        
        self.present(alert2, animated: true)
        
    }
    
    func displayAlertMessage2(displayMessage: String, completionAction:String) {
        
        if completionAction == "success" {
            let alert2 = UIAlertController(title: "Information", message: displayMessage, preferredStyle: .alert)

            //alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: nil))
            alert2.addAction(UIAlertAction(title: "Done. Return Home ", style: .default, handler: { (action) in self.launchVC(vcName: "home")}))
            alert2.addAction(UIAlertAction(title: "Make More Changes", style: .cancel, handler: nil))
         
            self.present(alert2, animated: true)
        } else if completionAction == "error" {
            let alert2 = UIAlertController(title: "Error", message: displayMessage, preferredStyle: .alert)
            //alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            alert2.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            
            self.present(alert2, animated: true)
        }
    }
    func launchVC(vcName:String) {
        if vcName == "home" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
      
            nextVC.profileId = profileId
            nextVC.token = token
            nextVC.encryptedAPIKey = encryptedAPIKey
           self.navigationController?.pushViewController(nextVC , animated: true)
        }
        
    }
    
    /*call this function to set a flag for alerting user that event
     will be closed or cancel*/
    func okwithEventClosureCancel() {
        isEventClosureCancel = true
        isProceed = true
        updateEvent()
    }
    /* set flag to false if user does not want to proceed w/ closing event but the event
     stage is close or cancel*/
    func proceedFlag() {
        isProceed = false
    }
    
    func getFormattedDateToDate(dateinput: String) -> Date {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from:dateinput)!
        return date
    }
    

    
    @IBAction func eventSaveButtonPressed(_ sender: Any) {
        
        updateEvent()
    }
    
    func updateEvent() {
        //self.LoadingStart(message: "Updating Event...")
        print("this is the 3rd event name \(eventNameTextField.text)")
        guard let eventName = eventNameTextField.text,
              //print("This is the second event name \(eventName!)")
            //let eventName = eventNameTextField.text
            let eventDateTime = eventDateTextField.text,
            let eventAddress1 = eventAddress1TextField.text,
            let eventCity = eventCityTextField.text,
            let eventState = eventStateTextField.text,
            let eventCountry = eventCountryTextField.text,
            let eventZipCode = eventZipCodeTextField.text,
            let eventType = eventTypeTextField.text,
            let eventStatusList = eventStatusTextField.text
        else {
            return
        }
       
        let eventAddress2 = eventAddress2TextField.text
        
        print("eventDateTextField.text = \(eventDateTextField.text!)")
        
        
        let isValidateEventName = self.formValidation.validateName2(name2: eventName).isValidate
        let isValidateEventDateTime = self.formValidation.validateName2(name2: eventDateTime).isValidate
        let isValidateEventType = self.formValidation.validateName2(name2: eventType).isValidate
        let isValidateAddress1 = self.formValidation.validateName2(name2: eventAddress1).isValidate
        //let isValidateAddress2 = self.formValidation.validateName2(name2: eventAddress2).isValidate
        let isValidateCity = self.formValidation.validateName2(name2: eventCity).isValidate
        let isValidateZipCode = self.formValidation.validateName2(name2: eventZipCode).isValidate
        let isValidateState = self.formValidation.validateName2(name2: eventState).isValidate
        let isValidateCountry = self.formValidation.validateName2(name2: eventCountry).isValidate
        
        let isValidateEventStatus = self.formValidation.validateName2(name2: eventStatusList).isValidate
        
        
        
        if (isValidateCountry == false || eventCountryTextField.text == "Select Country") {
            self.LoadingStop()
            let message = "Country is Required"
            displayAlertMessage(displayMessage: message, textField: eventCountryTextField)
            
            return
        } else {
            customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: false)
        }
        
        /* event status */
        if (isValidateEventStatus == false || eventStatusTextField.text == "Select Event Status") {
            self.LoadingStop()
            let message = "Event Status is Required"
            displayAlertMessage(displayMessage: message, textField: eventStatusTextField)
            
            return
        } else {
            customtextfield.borderForTextField(textField: eventStatusTextField, validationFlag: false)
        }
        
        print("isValidateEventStatus = \(isValidateEventStatus)")
        
        if (isValidateEventName == false) {
            self.LoadingStop()
            //customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: true)
            let message = "Event Name is Required"
            displayAlertMessage(displayMessage: message, textField: eventNameTextField)
            //eventNameTextField.becomeFirstResponder()
            
            print("I am still here")
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            //eventNameErrorLabel.isHidden = false
            //eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventName).errorMsg
            
            return
        } else {
            customtextfield.borderForTextField(textField: eventNameTextField, validationFlag: false)
            //eventNameErrorLabel.isHidden = true
            //eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventName).errorMsg
        }
        if (isValidateEventType == false || eventTypeTextField.text == "Select Event Type") {
            self.LoadingStop()
            //customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: true)
            let message = "Event Type is Required"
            displayAlertMessage(displayMessage: message, textField: eventTypeTextField)
            //eventTypeTextField.becomeFirstResponder()
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            //eventTypeErrorLabel.text = self.formValidation.validateName2(name2: eventType).errorMsg
            
            return
        } else {
            customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: false)
            //eventNameErrorLabel.text = self.formValidation.validateName2(name2: eventType).errorMsg
        }
        
        if (isValidateEventDateTime == false) {
            //self.LoadingStop()
            //customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: true)
            let message = "Event Date & Time is Required"
            displayAlertMessage(displayMessage: message, textField: eventDateTextField)
            //eventDateTextField.becomeFirstResponder()
            print("isValidateEventDateTime = false")
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            //eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTime).errorMsg
           
            return
        } else {
            
            //let isValidateEventDateTime = false
            let currentDate = getFormattedDateToDate(dateinput: Date.getCurrentDate())
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "E, d MMM yyyy h:mm a" //E, d MMM yyyy HH:mm a"
            let date = dateFormatter.date(from:String(eventDateTime))!

            let formatedEventDateTime  = getFormattedDate(date: date, format: "yyyy-MM-dd'T'HH:mm:ss")
            let newEventDateTime = getFormattedDateToDate(dateinput: formatedEventDateTime)
            
            print("newEventDateTime \(newEventDateTime) and currentDate = \(currentDate)")
            if newEventDateTime <= currentDate {
                print("DATE ISSUE")
                LoadingStop()
                let message = "Event date & time must be greater than the current date & time"
                displayAlertMessage(displayMessage: message, textField: eventDateTextField)
            }
            print("isValidateEventDateTime = true")
            customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
            //eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTime).errorMsg
        }
        
     
        
        if (isValidateAddress1 == false) {
            self.LoadingStop()
            //customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: true)
            let message = "Event Address is Required"
            displayAlertMessage(displayMessage: message, textField: eventAddress1TextField)
            //eventAddress1TextField.becomeFirstResponder()
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            //address1ErrorLabel.text = self.formValidation.validateName2(name2: eventAddress1).errorMsg
            
            return
        } else {
            customtextfield.borderForTextField(textField: eventAddress1TextField, validationFlag: false)
            //address1ErrorLabel.text = self.formValidation.validateName2(name2: eventAddress1).errorMsg
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
            self.LoadingStop()
           // customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: true)
            let message = "City is Required"
            displayAlertMessage(displayMessage: message, textField: eventCityTextField)
            //eventCityTextField.becomeFirstResponder()
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            //cityErrorLabel.text = self.formValidation.validateName2(name2: eventCity).errorMsg
            
            return
        } else {
            customtextfield.borderForTextField(textField: eventCityTextField, validationFlag: false)
            //cityErrorLabel.text = self.formValidation.validateName2(name2: eventCity).errorMsg
        }
        
        if (isValidateState == false || eventStateTextField.text == "Select State") {
            self.LoadingStop()
           // customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: true)
            let message = "Event State is Required"
            displayAlertMessage(displayMessage: message, textField: eventStateTextField)
            //eventStateTextField.becomeFirstResponder()
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            //stateErrorLabel.text = self.formValidation.validateName2(name2: eventState).errorMsg
           
            return
        } else {
            customtextfield.borderForTextField(textField: eventStateTextField, validationFlag: false)
            //stateErrorLabel.text = self.formValidation.validateName2(name2: eventState).errorMsg
        }
        
        if (isValidateZipCode == false) {
            self.LoadingStop()
            //customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: true)
            let message = "Event Zip Code is Required"
            displayAlertMessage(displayMessage: message, textField: eventZipCodeTextField)
           //eventZipCodeTextField.becomeFirstResponder()
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            //zipcodeErrorLabel.text = self.formValidation.validateName2(name2: eventZipCode).errorMsg
            
            return
        } else {
            customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: false)
            //zipcodeErrorLabel.text = self.formValidation.validateName2(name2: eventZipCode).errorMsg
        }
        
     
        //var eventStageId: Int?
        var message: String = ""
        eventStageId = eventStageConversion(status: eventStatusTextField.text!)
        
        print("eventStageId = \(eventStageId)")
        print("isEventClosureCancel =\(isEventClosureCancel)")
        if isEventClosureCancel == false {
            print("Dominic 1 ")
            if eventStageId == 3 || eventStageId == 4 {
                print("Dominic 2 ")
                self.LoadingStop()
                
                if eventStageId == 3 {
                    message = "You are about to close this event. Closing this event will trigger the payout process. Would you like to process?"
                } else if eventStageId == 4 {
                    message = "You are about to Cancel this event. Note: this event will no longer be accisible. Would you like to process?"
                }
                //customtextfield.borderForTextField(textField: eventZipCodeTextField, validationFlag: true)
                
                //displayAlertMessage(displayMessage: message, textField: eventZipCodeTextField)
                let alert = UIAlertController(title: "Event Closure/Cancel", message: message, preferredStyle: .actionSheet)

                //alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [self] (action) in }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [self] (action) in proceedFlag()}))
                alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { [self] (action) in okwithEventClosureCancel()}))

                self.present(alert, animated: true)
                
            } else {
                print("Dominic 5 ")
                isProceed = true
            }
        } else {
            print("Dominic 4 ")
            isProceed = true
        }
       
        
        
        //var eventDateTime: String = "Wed, 19 Aug 2020 08:02 AM"
        //remove the AM/PM before you pass string on to be formatted to yyyy-MM-dd HH:mm
//        let incomingDate = eventDateTime
//        let index = incomingDate!.lastIndex(of: " ") ?? incomingDate!.endIndex
//        let finalDate = incomingDate![..<index]
//        print("finalDate= \(finalDate)")
        
        print("isProceed = \(isProceed)")
        if (isValidateEventName == true && isValidateEventDateTime == true && isValidateEventType == true && isValidateAddress1 == true &&  isValidateCity == true && isValidateState == true && isValidateZipCode == true && isValidateCountry == true && isValidateEventStatus == true && isProceed == true) {
            
           
            
//            print("eventTypeId =\(eventTypeId)")
//            print("eventType Name =\(eventType)")
//
//
//
//            print("event date time =\(eventDateTime)")
           
            //let newUser = UserModel(id: 2, name: "Peter", username: "Livesey", email: "941ecfff8dc3@medium.com")
            var eventCurrentStateUpdated: Int?
            switch eventCurrentState {
            case 0 :
                eventCurrentStateUpdated = 1 //created
            case 1 :
                eventCurrentStateUpdated = 2 //opened
            case 2 :
                eventCurrentStateUpdated = 3 //closed
            case 3 :
                eventCurrentStateUpdated = 4 //cancel
            default:
                eventCurrentStateUpdated = 1
                break
            }
            
            //check if event close is selected - then close event before updating the remaining event record
            if Int64(eventStageId!) == 3 {
                print("Most current Event StageId) \(Int64(eventStageId!))")
                
                //self.LoadingStart(message: "Closing Event. Please wait...")
                
                
                //self.completionAlert(message: "Closing Event. Please wait...", timer: 4, completionAction: "")
                
                closeEvent()
                print("Close event was called")
            } else {
                updateEventRecord()
            }
            
            
           
    
        }

    }
    
    func updateEventRecord() {
        guard let eventName = eventNameTextField.text,
              //print("This is the second event name \(eventName!)")
            //let eventName = eventNameTextField.text
            let eventDateTime = eventDateTextField.text,
            let eventAddress1 = eventAddress1TextField.text,
            let eventCity = eventCityTextField.text,
            let eventState = eventStateTextField.text,
            let eventCountry = eventCountryTextField.text,
            let eventZipCode = eventZipCodeTextField.text,
            let eventType = eventTypeTextField.text,
            let eventStatusList = eventStatusTextField.text
        else {
            return
        }
       
        let eventAddress2 = eventAddress2TextField.text
        print("new event name \(eventName)")
        
        
        isRefreshScreen = true
        //print("address2TextField.text =\(address2TextField.text)")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "E, d MMM yyyy h:mm a"
        let date = dateFormatter.date(from:String(eventDateTime))!

        print("data = \(date)")
        let formatedEventDateTime  = getFormattedDate(date: date, format: "yyyy-MM-dd'T'HH:mm")
        
        print("formatedEventDateTime \(formatedEventDateTime)")
        var eventTypeId: Int
       
        eventTypeId = getEventTypeId(eventTypeName: eventType)
        eventStageId = eventStageConversion(status: eventStatusTextField.text!)
        
        let eventData = EventModelEdit(ownerId: profileId, name: eventName, dateTime: formatedEventDateTime, address1: eventAddress1, address2: eventAddress2, city: eventCity, zipCode: eventZipCode, country: eventCountry, state: eventState, eventType: eventTypeId,  isRsvprequired: isRSVPRequiredSwitch.isOn, isSingleReceiver: isSingleReceiverSwitch.isOn, isForBusiness: isForBusinessSwitch.isOn, eventId: eventId!, isActive: eventStatus!, eventState: Int64(eventStageId!))
        
        /*
         isSingleReceiverSwitch.isOn = isSingleReceiverEvent
         isRSVPRequiredSwitch.isOn = isRSPRequired
         */
        print(eventData)

        let request = PostRequest(path: "/api/Event/update", model: eventData, token: token!, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>) in
            switch result {
            case .success(let eventdata1):
                print("eventdate =\(eventdata1.description)")
                let decoder = JSONDecoder()
                do {
                   let eventDataJson: EventDataReturned = try decoder.decode(EventDataReturned.self, from: eventdata1)

                    if eventDataJson.success == false {
                        self.LoadingStop()
                        let message = "Something went wrong. Please try again."
                        self.displayAlertMessage2(displayMessage: message, completionAction: "error")

                    }else {
                        self.scroll2Top()
                        
                        print("UPDATED")
                        self.LoadingStop()
                        let message = "Event was updated successfully."
                        self.displayAlertMessage2(displayMessage: message, completionAction: "success")
                       
                    }
                } catch {
                    self.LoadingStop()
                    self.scroll2Top()
                    let message = "Something went wrong. Please try again \n. \(error.localizedDescription)"
                    self.displayAlertMessage2(displayMessage: message, completionAction: "error")
               }
  
               self.isEventEdited = true
            case .failure(let error):
                self.LoadingStop()
                self.scroll2Top()
                let message = "Something went wrong. Please try again \n. \(error.localizedDescription)"
                self.displayAlertMessage2(displayMessage: message, completionAction: "error")
            }
        }
    }
    func closeEvent() {
        print("I called closed")
        let close = EventCloseModel(profileId: profileId, eventId: eventId!)
        
        /*
         isSingleReceiverSwitch.isOn = isSingleReceiverEvent
         isRSVPRequiredSwitch.isOn = isRSPRequired
         */
        //print(eventData)
        let request = PostRequest(path: "/api/Event/close", model: close, token: token!, apiKey: encryptedAPIKey, deviceId: "")
        print("Event Close Request = \(request)")
        Network.shared.send(request) { (result: Result<EventCloseResult, Error>) in
            switch result {
            case .success(let eventclose):
                self.updateEventRecord()
                self.LoadingStop()
                
                let message = "Event Closure is Complete."
                self.displayAlertMessage2(displayMessage: message, completionAction: "success")
                
                break
            case .failure(let error):
                //self.scroll2Top()
                let message = "Something went wrong. Please try again \n. \(error.localizedDescription)"
                self.displayAlertMessage2(displayMessage: message, completionAction: "error")
            }
        }
    }
    
    
    func completionAlert(message: String, timer: Int, completionAction:String) -> Void {
        let delay = Double(timer) //* Double(NSEC_PER_SEC)
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            alert.dismiss(animated: true)
            //self.LoadingStop()
            if completionAction == "goback" {
                //self.redirect() commented out 10/9
                self.dismiss(animated: true, completion: nil)
                //self.launchEventPaymentScreen()
//                if((self.presentingViewController) != nil){
//                    self.dismiss(animated: false, completion: nil)
//                }
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




extension  UpdateEventViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activePickerViewTextField == eventStateTextField {
            return statelist.count
        } else if activePickerViewTextField == eventCountryTextField {
            return countrylist.count
        } else if activePickerViewTextField == eventTypeTextField {
            return eventtypeData.count
        } else if activePickerViewTextField == eventStatusTextField {
            return eventStatusList.count
        
//        } else if activePickerViewTextField == textFiled {
//            return countryList.count // number of dropdown items
//
        } else {
            return 0
        }
    }
}

extension  UpdateEventViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if activePickerViewTextField == eventStateTextField {
            return statelist[row].stateName
        } else if activePickerViewTextField == eventCountryTextField {
            return countrylist[row].countryName
        } else if activePickerViewTextField == eventTypeTextField {
            return eventtypeData[row].eventTypeName
        } else if activePickerViewTextField == eventStatusTextField {
            return eventStatusList[row].status
//        } else if activePickerViewTextField == textFiled {
//            return countryList[row] // dropdown item
//
        } else {
            return ""
        }
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activePickerViewTextField == eventStateTextField {
            eventStateTextField.text = statelist[row].stateName
            //self.view.endEditing(true)
        } else if activePickerViewTextField == eventCountryTextField {
            eventCountryTextField.text = countrylist[row].countryName//countryData[row]
            loadStateList(countryCode: countrylist[row].countryCode)
            eventStateTextField.text = "" //clear state textfield when country is selected
            //self.view.endEditing(true)
        } else if activePickerViewTextField == eventTypeTextField {
            eventTypeTextField.text = eventtypeData[row].eventTypeName
            //self.view.endEditing(true)
        } else if activePickerViewTextField == eventStatusTextField  {
            eventStatusTextField.text = eventStatusList[row].status
            //self.view.endEditing(true)
        }
//        else if activePickerViewTextField == textFiled {
//            selectedCountry = countryList[row] // selected item
//            textFiled.text = selectedCountry
//        }
    }
}

extension  UpdateEventViewController: UITextFieldDelegate {
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
        } else if activePickerViewTextField == eventStatusTextField {
            activePickerViewTextField.inputView = pickerView
        }
        
    }
}

extension UpdateEventViewController{
    func LoadingStart(message: String){
        ProgressDialog.alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating();

    ProgressDialog.alert.view.addSubview(loadingIndicator)
    present(ProgressDialog.alert, animated: true, completion: nil)
  }

  func LoadingStop(){
    ProgressDialog.alert.dismiss(animated: true, completion: nil)
  }
}
