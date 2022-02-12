//
//  CreateEventViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    var window: UIWindow?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileLable: UILabel!
    @IBOutlet weak var createEventLabel: UILabel!
    var createEventTitle: String?
    
   
    var profileId: Int64 = 0
    var token: String = ""
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
    
    @IBOutlet weak var isForBusinessSwitch: Switch1!
    
    //    @IBOutlet weak var eventNameErrorLabel: UILabel!
//    @IBOutlet weak var eventDateTimeErrorLabel: UILabel!
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
    var eventState: String?
    var eventType: String?
    var eventCountry: String?
    var eventCode: String?
    var eventId: Int64?
    var selectedCountry: String?
    var refreshscreendelegate: RefreshScreenDelegate?
    var isRefreshScreen: Bool = false
    var encryptedAPIKey: String = ""
    var myProfileData: [MyProfile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        // Let it size itself to its preferred size
        datePicker.sizeToFit()
        // Set the frame without changing the size
        datePicker.frame = .init(x: 20, y: 100, width: datePicker.bounds.size.width, height: datePicker.bounds.size.height)

        //view.addSubview(datePicker)
        //default swith settings
        
        print("My PROFILE DATA \(myProfileData)")
        print("my toke = \(token)")
        //use to keep keyboard down
       /* NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil); */
        
        isSingleReceiverSwitch.isOn = false
        isRSVPRequiredSwitch.isOn = true
        isForBusinessSwitch.isOn = false
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        //countryList = ["Algeria", "Andorra", "Angola", "India", "Thailand"]
        
        self.navigationItem.title = "Create Event"
   
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
       
        //data for the date picker
        //stateData = ["Select State", "Texas", "New York", "California"]
       // countryData = ["Select Country", "USA", "England", "Nigeria", "Ghana"]
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
        //textFiled.delegate = self
        
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
        countrystatelist.removeAll()
        statelist.removeAll()
        eventtypeData.removeAll()
        countrylist.removeAll()
        
        loadCountryList()
        loadCountryStateListData()
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
        customtextfield.borderForTextField(textField: eventTypeTextField, validationFlag: false)
        
        
        
//        eventNameErrorLabel.isHidden = true
//        eventDateTimeErrorLabel.isHidden = true
//        eventTypeErrorLabel.isHidden = true
//        address1ErrorLabel.isHidden = true
//        address2ErrorLabel.isHidden = true
//        cityErrorLabel.isHidden = true
//        stateErrorLabel.isHidden = true
//        zipcodeErrorLabel.isHidden = true
//        countryErrorLabel.isHidden = true
       // createEventLabel.isHidden = true
       // createEventLabel.text = createEventTitle
        // Do any additional setup after loading the view.
        
        
    }
    
    var child =  SpinnerViewController()
    func createSpinnerView() {
        //let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        
    }
    
    func stopSpinnerView() {
        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
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
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock
            // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        // scroll2Top()  - comment out for now 7/13
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//        if parent == nil {
//            print("Back Button pressed Home.")
//            
//            //print("isRefreshData from container screen \(isRefreshData)")
//            //selectionDelegate.didTapChoice(name: "Dominic")
//           // refreshscreendelegate?.refreshScreen(isRefreshScreen: isRefreshScreen)
//            //refreshscreendelegate?.refreshScreen(isRefreshScreen: isRefreshData)
//            //sprayDelegate?.sprayEventSettingRefresh(isEventSettingRefresh: true)
//
//        }
//    }
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    func scroll2Top() {
        scrollView.contentOffset = CGPoint(x: 5.0, y: 5.0)
    }
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
    }
    
    //load state based on country selected
    func loadStateList(countryCode: String) {
        
      
        for country in countrystatelist {
    
            if country.countryCode == countryCode {
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
                    print("I was sELECTED - DOMINIC 1")
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
                    //countryErrorLabel.isHidden = false
                    //self.formValidation.validateName2(name2: eventCountryTextField.text!).errorMsg
                    eventCountryTextField.becomeFirstResponder()
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
                    print("I was sELECTED - DOMINIC 2")
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
        
        //datePicker.transform = CGAffineTransformMake(0.5, 0, 0, 0.5, -80, 0);
        
 
        
        //assign toolbar
        eventDateTextField.inputAccessoryView = toolbar
        
        eventDateTextField.inputView = datePicker
       
        datePicker.datePickerMode = .dateAndTime
    }
    
    @objc func donePressed() {
        self.tabBarController?.tabBar.isHidden = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy h:mm a" //E, d MMM yyyy hh:mm a" //yyyy-MM-dd'T'HH:mm"
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
        
        print("textFieldFocu")
        let text = textField.text
        //self.tabBarController?.tabBar.isHidden = true
            //if text?.utf16.count==0{
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
            alert2.addAction(UIAlertAction(title: "I Am Done", style: .default, handler: { (action) in self.launchVC(vcName: "home")}))
            alert2.addAction(UIAlertAction(title: "Add Another Event", style: .cancel, handler: nil))
         
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
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//            nextVC.profileId = profileId
//            nextVC.token = token
//           self.navigationController?.pushViewController(nextVC , animated: true)
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name:
                "Main", bundle: nil)
            let nextVC: HomeViewController =  mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController" ) as! HomeViewController
            //innerPage.lbldesc = "We made its"
            nextVC.profileId = profileId
            //nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.encryptedAPIKey = encryptedAPIKey
            self.window?.rootViewController = nextVC
            self.window?.makeKeyAndVisible()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
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
    
    func addinvitees(myProfileId: Int64, firstName: String, lastName: String, email: String, phone: String, eventId: Int64, ownerProfileId: Int64) {
        
    
        let addInvitees = AddInvitee(profileId: ownerProfileId, eventId: eventId, eventInvitees: [AddInvitee2(firstName: firstName, lastName: lastName, email: email, phone: phone, profileId: myProfileId)])
            // JoinEvent(joinList: [JoinEventFields(profileId: profileId, email: email, phone: phone, eventCode: eventCode)])
        
        print("token = \(token)")
        print("addInvitees= \(addInvitees)")
        
        let request = PostRequest(path: "/api/Event/addinvitees", model: addInvitees, token: token, apiKey: encryptedAPIKey, deviceId: "")
        
        
        print("addinvitees request = \(request)")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success( _):
                //RSVP
                print("CALLED RSVP")
               
                /*call rsvp so that owner can attend*/
                self.rsvp(myProfileId: myProfileId, firstName: firstName, lastName: lastName, email: email, phone: phone, eventId: eventId, ownerProfileId: ownerProfileId)
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                //localizedDescriptionif error.localizedDescription
                //self.rsvp(eventIdvar: eventId, ownerId: ownerProfileId)
                stopSpinnerView()
                
            }
        }
    }
    func rsvp(myProfileId: Int64, firstName: String, lastName: String, email: String, phone: String, eventId: Int64, ownerProfileId: Int64) {
        
        /*var firstname: String = ""
        var lastname: String = ""
        var email: String = ""
        var phone: String = ""
        for profile in myProfileData {
            firstname = profile.firstName
            lastname = profile.lastName
            email = profile.email
            phone = profile.phone
        }*/
       
        let addAttendee = AddAttendees(profileId: ownerProfileId, eventId: eventId, eventAttendees: [Attendees(profileId: myProfileId, firstName: firstName, lastName: lastName, email: email, phone: phone, eventId: eventId, isAttending: true)])
        //let updateAttendee = Attendees(profileId: profileId, eventId: eventId, isAttending: true)
        
        print("RSVP addAttendee = \(addAttendee)")
        //print(updateAttendee)
        //isRefreshScreen = true
        let request = PostRequest(path: "/api/Event/addattendees", model: addAttendee, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Empty, Error>)  in
            switch result {
            case .success( _):
                defaults.set(true, forKey: "isRefreshHomeVC")
                stopSpinnerView()
                let message = "Congratulations! Your event has been successfully created."
                self.displayAlertMessage2(displayMessage: message, completionAction: "success")
                break
            //case .failure(let error):
            case .failure(let error):
                print(error.localizedDescription)
                stopSpinnerView()
            }
        }
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
        
        if (isValidateCountry == false || eventCountryTextField.text == "Select Country") {
            
            //customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: true)
       
            let message = "Country is Required"
            //eventCountryTextField.becomeFirstResponder()
            displayAlertMessage(displayMessage: message, textField: eventCountryTextField)
            
            //print("Incorrect First Name")
            //loadingLabel.text = "Incorrect First Name"
            //countryErrorLabel.text = self.formValidation.validateName2(name2: eventCountry).errorMsg
            return
        } else {
            customtextfield.borderForTextField(textField: eventCountryTextField, validationFlag: false)
            //countryErrorLabel.text = self.formValidation.validateName2(name2: eventCountry).errorMsg
        }
       
        
      
     
        
        if (isValidateAddress1 == false) {
            
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
        
        
        var isEventDateTimeInThePast: Bool = false
        if (isValidateEventDateTime == false) {
            
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
            
            print("isValidateEventDateTime = true")
            //customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
            
            let currentDate = getFormattedDateToDate(dateinput: Date.getCurrentDate())
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "E, d MMM yyyy h:mm a" //E, d MMM yyyy HH:mm a"
            let date = dateFormatter.date(from:String(eventDateTime))!

            let formatedEventDateTime  = getFormattedDate(date: date, format: "yyyy-MM-dd'T'HH:mm:ss")
            let newEventDateTime = getFormattedDateToDate(dateinput: formatedEventDateTime)
            
            if newEventDateTime <= currentDate {
                let isValidateEventDateTime = false
                isEventDateTimeInThePast = true
                let message = "Event date & time must be greater than the current date & time"
                displayAlertMessage(displayMessage: message, textField: eventDateTextField)
            } else {
                customtextfield.borderForTextField(textField: eventDateTextField, validationFlag: false)
            }
            
            //eventDateTimeErrorLabel.text = self.formValidation.validateName2(name2: eventDateTime).errorMsg
        }
        
     
        //var eventDateTime: String = "Wed, 19 Aug 2020 08:02 AM"
        //remove the AM/PM before you pass string on to be formatted to yyyy-MM-dd HH:mm
//        let incomingDate = eventDateTime
//        let index = incomingDate!.lastIndex(of: " ") ?? incomingDate!.endIndex
//        let finalDate = incomingDate![..<index]
//        print("finalDate= \(finalDate)")
        
        if (isValidateEventName == true && isValidateEventDateTime == true && isValidateEventType == true && isValidateAddress1 == true &&  isValidateCity == true && isValidateState == true && isValidateZipCode == true && isValidateCountry == true &&  isEventDateTimeInThePast == false ) {
            
            createSpinnerView()
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "E, d MMM yyyy h:mm a" //E, d MMM yyyy HH:mm a"
            let date = dateFormatter.date(from:String(eventDateTime))!


            let formatedEventDateTime  = getFormattedDate(date: date, format: "yyyy-MM-dd'T'HH:mm")

            
            //let formatedEventDateTime  = getFormattedDate(date: Date(), format: "yyyy-MM-dd HH:mm")
            print("event date = \(eventDateTextField.text)")
            print("format event date = \(formatedEventDateTime)")
            var eventTypeId: Int
            eventTypeId = getEventTypeId(eventTypeName: eventType)
            
            let AddEvent = EventModel(ownerId: profileId, name: eventName, dateTime: formatedEventDateTime, address1: eventAddress1, address2: eventAddress2, city: eventCity, zipCode: eventZipCode, country: eventCountry, state: eventState, eventType: eventTypeId, isRsvprequired: isRSVPRequiredSwitch.isOn, isSingleReceiver: isSingleReceiverSwitch.isOn, isForBusiness: isForBusinessSwitch.isOn,  eventId: 0, isActive: true, eventState: 2 )
            print(AddEvent)
            let request = PostRequest(path: "/api/Event/add", model: AddEvent, token: token, apiKey: encryptedAPIKey, deviceId: "")
             
            
            print("create event request = \(request)")
            Network.shared.send(request) { [self] (result: Result<EventData, Error>)  in
                 switch result {
                 case .success(let event):
    //                 self.token2pass = user.token!
    //                 self.userdata = user
    //                 self.profileId = String(user.profileId!)
    //
    //                 print(" this is dominic \(user)")
    //
                    self.isRefreshScreen = true
                    self.eventCode = event.eventCode
                    self.eventId = event.eventId
                    
                    var firstname: String = ""
                    var lastname: String = ""
                    var email: String = ""
                    var phone: String = ""
                    for profile in self.myProfileData {
                        firstname = profile.firstName
                        lastname = profile.lastName
                        email = profile.email
                        phone = profile.phone
                    }
                    
                    /*add owner as an invitee */
                    addinvitees(myProfileId: profileId, firstName: firstname, lastName: lastname, email: email, phone: phone, eventId: event.eventId, ownerProfileId: profileId)
                    
                   
                    
                 
                    //self.createEventLabel.isHidden = false
                    //self.createEventLabel.textColor = UIColor(red: 82/256, green: 156/256, blue: 32/256, alpha: 1.0) // UIColor(red: 204/256, green: 0/256, blue: 0/256, alpha: 1.0)
                    
                    //self.createEventLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
                    //self.createEventLabel.text = "Congratulations. Your event has been creeated. Your Event Code is:   \(self.eventCode!)"
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
                    //self.createEventLabel.text = error.localizedDescription
                    //print( error.localizedDescription)
                     stopSpinnerView()
                    let message = "This Feature is Temporarily Unavaiable. Please contact our support at 1-800-000-0001 \n \(error.localizedDescription)"
                    self.displayAlertMessage2(displayMessage: message, completionAction: "error")
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
            return statelist.count
        } else if activePickerViewTextField == eventCountryTextField {
            return countrylist.count
        } else if activePickerViewTextField == eventTypeTextField {
            return eventtypeData.count
//        } else if activePickerViewTextField == textFiled {
//            return countryList.count // number of dropdown items
//
        } else {
            return 0
        }
    }
}

extension CreateEventViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if activePickerViewTextField == eventStateTextField {
            return statelist[row].stateName
        } else if activePickerViewTextField == eventCountryTextField {
            return countrylist[row].countryName
        } else if activePickerViewTextField == eventTypeTextField {
            return eventtypeData[row].eventTypeName
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
        }
//        else if activePickerViewTextField == textFiled {
//            selectedCountry = countryList[row] // selected item
//            textFiled.text = selectedCountry
//        }
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

