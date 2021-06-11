//
//  EventSettingTableViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/23/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
//import BraintreeDropIn
//import Braintree


class EventSettingTableViewController: UITableViewController {

    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    
   
    @IBOutlet weak var eventCodeLabel: UILabel!
    
    @IBOutlet weak var eventTypeIconImageView: UIImageView!
    
  
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var paymentActionMessageLabel: UILabel!
    @IBOutlet weak var paymentSelectedLabel: UILabel!
    
    @IBOutlet weak var paymentIconImageView: UIImageView!
   // @IBOutlet weak var addEditPaymentButton: UIButton!
    
    @IBOutlet weak var addEditPaymentButton: UIButton!
    
    @IBOutlet weak var paymentNickNameTextField: UITextField!
    
    @IBOutlet weak var rsvpSwitch: UISwitch!
    
    @IBOutlet weak var withdrawAmountTextField: UITextField!
    @IBOutlet weak var autoReplenishSwitch: UISwitch!
    @IBOutlet weak var autoReplenishAmountTextField: UITextField!
    @IBOutlet weak var notificationAmountTextField: UITextField!
    
    @IBOutlet weak var paymentErrorLabel: UILabel!
    @IBOutlet weak var paymentNickNameErrorLabel: UILabel!
    
    @IBOutlet weak var generalMessage: UILabel!
    @IBOutlet weak var withdrawAmountErrorLabel: UILabel!
    
    @IBOutlet weak var replenishAmountErrorLabel: UILabel!
    
    @IBOutlet weak var alertAmountErrorLabel: UILabel!
    
   
    @IBOutlet weak var replenishAmtPlusBtn: UIButton!
    @IBOutlet weak var replenishAmtMinusBtn: UIButton!
    @IBOutlet weak var alertAmtPlusBtn: UIButton!
    @IBOutlet weak var alertAmtMinusBtn: UIButton!
    //currency converter
    var amt = 0
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    let customtextfield = CustomTextField()
 
    var withdrawAmount: Int = 0
    var withdrawAmount2: Int = 0
    var isAutoReplenish: Bool?
    var autoReplenishAmount: Int = 0
    var notificationAmount: Int = 0
    var paymentTypeFromPaymentType: Int64?
    var paymentMethodIdFromPreference: Int64?
    var paymentMethodIdFromGetPaymentType: Int64?
    var paymentMethodId: Int64 = 0
    var newPaymentMethodId: Int = 0
    var orignalPaymentMethodId: Int = 0
    
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var token: String?
    var eventId: Int64?
    var profileId: Int64?
    var ownerId: Int64?
    var paymentClientToken: String?
    var paymentNickName: String?
    var paymentNickNamePrimary: String?
    
    var isAttendingEventId: Int64?
    var eventTypeIcon: String = ""
    var screenIdentifier: String?
    var paymentTypeData: Data?
    var gifterTotalTransAmount: Int = 0
    
    
//    var paymentOptionType: BTUIKPaymentOptionType?
//    var paymentMethodNonce: BTPaymentMethodNonce?
    var paymentDescription: String?
    var isReadyToSavePayment: Bool = false
    var isAddNewPayment: Bool = false
    var currencyCode: String = "usd"
    var isRefreshScreen: Bool = false
    //weak var myDelegate: HomeViewController!
    
    var formValidation =   Validation()
    
    var getIsRefreshDataDelegate: RefreshScreenDelegate?
    var encryptedAPIKey: String = ""
    
    //var sprayDelegate: SprayTransactionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.allowsSelection = false
        
        print("isAttendingEventId =\(String(isAttendingEventId!))")
//        withdrawAmountTextField.leftViewMode = UITextField.ViewMode.always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 40, width: 20, height: 20))
//        let image = UIImage(named: "dollarIcon")
//
//        imageView.image = image
//        withdrawAmountTextField.leftView = imageView
//
//
        
        print(eventName)
        eventNameLabel.text = eventName
        eventDateTimeLabel.text = eventDateTime
        eventCodeLabel.text = eventCode
        eventTypeIconImageView.image = UIImage(named: eventTypeIcon)
        
        paymentNickNameErrorLabel.text = ""
        withdrawAmountErrorLabel.text = ""
        replenishAmountErrorLabel.text = ""
        alertAmountErrorLabel.text = ""
        generalMessage.text = ""
        paymentErrorLabel.text = ""
        
//        self.borderForTextField(textField: paymentNickNameTextField, validationFlag: false)
//        self.borderForTextField(textField: withdrawAmountTextField, validationFlag: false)
//        self.borderForTextField(textField: notificationAmountTextField, validationFlag: false)
//        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
//
        
        //if coming from the SprayViewController the
        //give the spray amount the focus - change text to red
        if screenIdentifier == "Spray" {
            withdrawAmountTextField.textColor = UIColor(red: 145/256, green: 28/256, blue: 17/256, alpha: 1.0)
            self.borderForTextField(textField: withdrawAmountTextField, validationFlag: true)
            withdrawAmountErrorLabel.text = "Please increase your withdrawal"
            withdrawAmountTextField.becomeFirstResponder()
        }
        //getPaymenttype2()
        //getPaymenttype()
       
        
        getEventPref3()
        
        //getPaymenttype()
        //getEventPreference() //use to populate event preference screen
        
        //turn off switch when coming from myInvitation screen
        if screenIdentifier == "RSVP" {
            rsvpSwitch.isOn = false
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /*
        // MARK: isAttedingEventId is use to indicate that an attendee is currently RSVP.
        if the value of isAttendingEventId = 0, it means the attendee has removed their
        RSVP flag so we should set swift to off
        print("isAttendingEventId = \(isAttendingEventId!)")
        print("screenIdentifier = \(screenIdentifier!)") */
        
        if isAttendingEventId != 0 {
            rsvpSwitch.isOn = true
        } else {
             rsvpSwitch.isOn = false
        }
        
        customtextfield.borderForTextField(textField: paymentNickNameTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: notificationAmountTextField, validationFlag: false)
        customtextfield.borderForTextField(textField: withdrawAmountTextField, validationFlag: false)

        paymentNickNameTextField.delegate = self
        withdrawAmountTextField.delegate = self
        autoReplenishAmountTextField.delegate = self
        notificationAmountTextField.delegate = self
        
        withdrawAmountTextField.addTarget(self, action: #selector(EventSettingTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        autoReplenishAmountTextField.addTarget(self, action: #selector(EventSettingTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        notificationAmountTextField.addTarget(self, action: #selector(EventSettingTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        paymentNickNameTextField.addTarget(self, action: #selector(EventSettingTableViewController.textFieldDidChange(_:)), for: .editingChanged)
//        withdrawAmountTextField.delegate = self
//        withdrawAmountTextField.placeholder = updateTextField()
//        
//        autoReplenishAmountTextField.delegate = self
//        autoReplenishAmountTextField.placeholder = updateTextField()
//        
//        notificationAmountTextField.delegate = self
//        notificationAmountTextField.placeholder = updateTextField()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
        }
    }
    
    func scrollToHeader() {
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        debugPrint("Back Button pressed from Table View Controller.")
        
        print("isRefreshScreen from table view = \(isRefreshScreen)")
        getIsRefreshDataDelegate?.refreshScreen(isRefreshScreen: isRefreshScreen)
    }
    
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//        if parent == nil {
//            debugPrint("Back Button pressed from Table View Controller.")
//
//            print("isRefreshScreen from table view = \(isRefreshScreen)")
//            //selectionDelegate.didTapChoice(name: "Dominic")
//            //refreshscreendelegate?.refreshScreen(isRefreshScreen: true)
//            getIsRefreshDataDelegate?.refreshScreen(isRefreshScreen: isRefreshScreen)
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        getGifterTotalTransBalance()
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    @IBAction func increaseFundButtonPressed(_ sender: Any) {
        withdrawAmountErrorLabel.text = ""
        if (withdrawAmountTextField.text) == "" {
            let withdrawAmount = 0
            // var replenishAmount2: Int = 0
            let withdrawAmount2 = withdrawAmount + 1
             
            withdrawAmountTextField.text = String(withdrawAmount2)
        }else {
            let withdrawAmount: String = withdrawAmountTextField.text!
            
            var withdrawAmount2: Int = 0
            withdrawAmount2 = Int(withdrawAmount)! + 1
             
            withdrawAmountTextField.text! = String(withdrawAmount2)
        }
    }
    
    @IBAction func decreaseFundButtonPressed(_ sender: Any) {
        
        
        if withdrawAmountTextField.text! == "" {
            let withdrawAmount2 = 0
            withdrawAmountTextField.text = String(withdrawAmount2)
        } else {
            let withdrawAmount: String = withdrawAmountTextField.text!
            
            if Int(withdrawAmount)! > 0 {
                var withdrawAmount2: Int = 0
                withdrawAmount2 = Int(withdrawAmount)! - 1
                
                withdrawAmountTextField.text = String(withdrawAmount2)
            } else {
                let withdrawAmount2 = 0
                withdrawAmountTextField.text! = String(withdrawAmount2)
                
                withdrawAmountErrorLabel.text = "Amount cannot be below 0."
            }
        }
       
       
    }
    
    @IBAction func increaseReplenishAmtBtn(_ sender: Any) {
        replenishAmountErrorLabel.text = ""
        if (autoReplenishAmountTextField.text!) == "" {
            let replenishAmount = 0
            // var replenishAmount2: Int = 0
            let replenishAmount2 = replenishAmount + 1
             
             autoReplenishAmountTextField.text! = String(replenishAmount2)
            
        } else {
            let replenishAmount: String = autoReplenishAmountTextField.text!
            
            var replenishAmount2: Int = 0
            replenishAmount2 = Int(replenishAmount)! + 1
             
            autoReplenishAmountTextField.text! = String(replenishAmount2)
        }
        
    }
    
    @IBAction func decreaseReplenishAmtBtn(_ sender: Any) {
        //let replenishAmount: String = autoReplenishAmountTextField.text!
        if autoReplenishAmountTextField.text! == "" {
            let replenishAmount2 = 0
            autoReplenishAmountTextField.text! = String(replenishAmount2)
        } else {
            let replenishAmount: String = autoReplenishAmountTextField.text!
            if Int(replenishAmount)! > 0 {
                replenishAmountErrorLabel.text = ""
                var replenishAmount2: Int = 0
                
                replenishAmount2 = Int(replenishAmount)! - 1
                
                autoReplenishAmountTextField.text! = String(replenishAmount2)
            } else {
                let replenishAmount2 = 0
                autoReplenishAmountTextField.text! = String(replenishAmount2)
                replenishAmountErrorLabel.text = "Amount cannot be below 0."
            }
        }
       
       
    }
    
    
    @IBAction func increaseAlertAmtBtn(_ sender: Any) {
        
        alertAmountErrorLabel.text = ""
        if (notificationAmountTextField.text!) == "" {
            let alertAmount = 0
            // var replenishAmount2: Int = 0
            let alertAmount2 = alertAmount + 1
             
            notificationAmountTextField.text! = String(alertAmount2)
            
        } else {
            let alertAmount: String = notificationAmountTextField.text!
            
            var alertAmount2: Int = 0
            alertAmount2 = Int(alertAmount)! + 1
             
            notificationAmountTextField.text! = String(alertAmount2)
        }
    }
    
    @IBAction func decreaseAlertAmtBtn(_ sender: Any) {
        //don't go below 0
        if notificationAmountTextField.text! == "" {
            let alertAmount2 = 0
            notificationAmountTextField.text! = String(alertAmount2)
        } else {
            let alertAmount: String =
                notificationAmountTextField.text!
                
            if Int(alertAmount)! > 0 {
                alertAmountErrorLabel.text = ""
                var alertAmount2: Int = 0
                
                alertAmount2 = Int(alertAmount)! - 1
                
                notificationAmountTextField.text! = String(alertAmount2)
            } else {
                let alertAmount2 = 0
                
                notificationAmountTextField.text! = String(alertAmount2)
                alertAmountErrorLabel.text = "Amount cannot be below 0."
            }
            
        }
        
    }
    
    func updateTextField() -> String? {
        let number = Double(amt/100) + Double(amt%100)/100
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    func getGifterTotalTransBalance()   {
        
        var availablebalance: Int = 0
        //var theGifterTotalTransBalance: Int = 0
        let request = Request(path: "/api/Event/transactiontotal/\(profileId!)/\(eventId!)", token: token!, apiKey: encryptedAPIKey)
               
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let gifterBalance):
                
                    //return paymentmethod1
                //self.gifterData = gifterBalance
                let decoder = JSONDecoder()
                do {
                   let gifterBalanceJson: GifterTransactionTotal = try decoder.decode(GifterTransactionTotal.self, from: gifterBalance)
                   
                    //for gifter in gifterBalanceJson {
                    if  gifterBalanceJson.eventId == eventId &&  gifterBalanceJson.profileId == profileId {
                           //theGifterTotalTransBalance = gifter.totalAmountAllTransactions
                        self.gifterTotalTransAmount =  gifterBalanceJson.totalAmountAllTransactions
                        print("self.gifterTotalTransAmount = \(gifterBalanceJson.totalAmountAllTransactions)")
                    }
                   //}
                      
               } catch {
                   print(error)
               }
                //self.getEventPref2(paymenttypeData: paymentmethod1)
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }

    }
    
   
    
    @IBAction func isAutoReplenishSwitchButton(_ sender: UISwitch) {
       
        if sender.isOn == false {
            
            replenishAmtPlusBtn.isEnabled = false
            replenishAmtMinusBtn.isEnabled = false
            alertAmtPlusBtn.isEnabled = false
            alertAmtMinusBtn.isEnabled = false
            
            autoReplenishAmountTextField.isEnabled = false
            notificationAmountTextField.isEnabled = false
            
            autoReplenishAmountTextField.text = ""
            notificationAmountTextField.text = ""
            autoReplenishAmountTextField.placeholder = ""
            notificationAmountTextField.placeholder = ""
            
        } else {
            replenishAmtPlusBtn.isEnabled = true
            replenishAmtMinusBtn.isEnabled = true
            alertAmtPlusBtn.isEnabled = true
            alertAmtMinusBtn.isEnabled = true
            autoReplenishAmountTextField.isEnabled = true
            notificationAmountTextField.isEnabled = true
            autoReplenishAmountTextField.placeholder = "Enter Replenish Amount"
            notificationAmountTextField.placeholder = "Enter Alert Amount"
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        if isReadyToSavePayment == true {
            if text?.utf16.count==0{
                switch textField{
                case withdrawAmountTextField :
                    self.borderForTextField(textField: withdrawAmountTextField, validationFlag: true)
                   
                    withdrawAmountErrorLabel.text = self.formValidation.validateNumTextField(incomingValue: withdrawAmountTextField.text!).errorMsg//"Missing Event Name."
                    withdrawAmountTextField.becomeFirstResponder()
                case autoReplenishAmountTextField :
                  
                    self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: true)
                    
                    replenishAmountErrorLabel.text = self.formValidation.validateNumTextField(incomingValue: autoReplenishAmountTextField.text!).errorMsg//"Missing Event Name."
                    autoReplenishAmountTextField.becomeFirstResponder()
                   
//                case notificationAmountTextField :
//                    self.borderForTextField(textField: notificationAmountTextField, validationFlag: true)
//                    alertAmountErrorLabel.isHidden = false
//                    alertAmountErrorLabel.text = self.formValidation.validateName2(name2: notificationAmountTextField.text!).errorMsg//"Missing Event Name."
//                    notificationAmountTextField.becomeFirstResponder()
                case paymentNickNameTextField :
                    self.borderForTextField(textField: paymentNickNameTextField , validationFlag: true)
                  
                    paymentNickNameErrorLabel.text = self.formValidation.validateName2(name2: paymentNickNameTextField.text!).errorMsg//"Missing Event Name."
                    paymentNickNameTextField.becomeFirstResponder()
                default:
                    break
                }
            }else{
                switch textField{
                case  withdrawAmountTextField :
                
                    withdrawAmountErrorLabel.text = ""
                    self.borderForTextField(textField:  withdrawAmountTextField, validationFlag: false)
                case autoReplenishAmountTextField :

                    replenishAmountErrorLabel.text = ""
                    self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
//                case notificationAmountTextField :
//                    
//                    alertAmountErrorLabel.isHidden = true
//                    alertAmountErrorLabel.text = ""
//                    self.borderForTextField(textField: notificationAmountTextField, validationFlag: false)
                case paymentNickNameTextField :
                    paymentNickNameErrorLabel.text = ""
                    self.borderForTextField(textField: paymentNickNameTextField, validationFlag: false)
                default:
                    break
                    
                }
            }
        }
       
    }
    
    //use to go back after after update
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        (viewController as? EventSettingContainerViewController)?.isRefreshData = true // Here you pass the to your original view controller
//    }
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
    
    @IBAction func saveEventSettingButtonPressed(_ sender: Any) {
        //call addPayment when a new card is added
        guard let withdrawamount = withdrawAmountTextField.text,
              //print("This is the second event name \(eventName!)")
            //let eventName = eventNameTextField.text
            let replenishAmount = autoReplenishAmountTextField.text,
            let alertAmount = notificationAmountTextField.text,
            let nickName = paymentNickNameTextField.text
        else {
            return
        }
        
        let isValidateWithdrawAmount = self.formValidation.validateNumTextField(incomingValue: withdrawamount).isValidate
        let isValidateReplenishAmount = self.formValidation.validateNumTextField(incomingValue: replenishAmount).isValidate
        let isValidateNickName = self.formValidation.validateName2(name2: nickName).isValidate
        
        //proceed if all field have been validated
        //if isValidateWithdrawAmount == true {
        if isReadyToSavePayment == true {
            print("sReadyToSavePayment = true")
            //proceed if all field have been validated
            if (isValidateNickName  == false) {
                paymentNickNameTextField.becomeFirstResponder()
                self.borderForTextField(textField: paymentNickNameTextField, validationFlag: true)
                print("I am still here")
                //print("Incorrect First Name")
                //loadingLabel.text = "Incorrect First Name"
           
                paymentNickNameErrorLabel.text = self.formValidation.validateName2(name2: nickName).errorMsg
                return
            } else {
                self.borderForTextField(textField: paymentNickNameTextField, validationFlag: false)
              
                paymentNickNameErrorLabel.text = self.formValidation.validateName2(name2: nickName).errorMsg
                
         
            }
            
            if (isValidateWithdrawAmount  == false) {
                withdrawAmountTextField.becomeFirstResponder()
                self.borderForTextField(textField: withdrawAmountTextField, validationFlag: true)
                print("I am still here")
                //print("Incorrect First Name")
                //loadingLabel.text = "Incorrect First Name"
             
                withdrawAmountErrorLabel.text = self.formValidation.validateNumTextField(incomingValue: withdrawamount).errorMsg
                return
            } else {
                self.borderForTextField(textField: withdrawAmountTextField, validationFlag: false)
               
                withdrawAmountErrorLabel.text = self.formValidation.validateNumTextField(incomingValue: withdrawamount).errorMsg
            }
            
            if (isValidateNickName == true && isValidateWithdrawAmount == true) {
                if autoReplenishSwitch.isOn == true {
                    if (isValidateReplenishAmount == false) {
                        autoReplenishAmountTextField.becomeFirstResponder()
                        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: true)
                        print("I am still here")
                        //print("Incorrect First Name")
                        //loadingLabel.text = "Incorrect First Name"
                      
                        replenishAmountErrorLabel.text = self.formValidation.validateNumTextField(incomingValue: replenishAmount).errorMsg
                        return
                    } else {
                        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
                        
                        replenishAmountErrorLabel.text = self.formValidation.validateNumTextField(incomingValue: replenishAmount).errorMsg
                        
//                        //add payment
//                        addPayment(paymentNonce: paymentMethodNonce!.nonce, paymentOptionType: Int64(paymentOptionType!.rawValue), paymentDescription: paymentDescription!, paymentExpiration: "12/31/2099")
//
//                        print("paymentOptionType 1 = \(Int64(paymentOptionType!.rawValue))")
//                        print("paymentDescription 1 = \(paymentDescription!)")
//                        //save preference
//                        saveEventPreference(paymentMethod: Int(Int64(paymentOptionType!.rawValue)))
//                        isRefreshScreen = true
//
//                        self.generalMessage.text = "Update was successful."
//                        self.generalMessage.textColor = UIColor(red: 32/256, green: 106/256, blue: 93/256, alpha: 1.0)
//                        scrollToHeader()
                        
                        if isAddNewPayment == true {
                            
//                            print("1. isAddNewPayment = true")
//                            //add payment
//                            addPayment(paymentNonce: paymentMethodNonce!.nonce, paymentOptionType: Int64(paymentOptionType!.rawValue), paymentDescription: paymentDescription!, paymentExpiration: "12/31/2099")
//
//                            //get the latest payment data
//                            getPaymentTypeData(paymentTypeId: self.paymentOptionType!.rawValue)
//
                            //get the paymenttheodId of the new paymentmethod
                            //self.newPaymentMethodId = getPaymentMethodId(paymentTypeData: paymentTypeData!, paymentType: self.paymentOptionType!.rawValue)!
                            
                            //saveEventPreference(paymentMethodId: newPaymentMethodId)
                            
                            isRefreshScreen = true
                        } else if orignalPaymentMethodId > 0 {
                            saveEventPreference(paymentMethodId: orignalPaymentMethodId )
                            isRefreshScreen = true
                        } else if paymentTypeFromPaymentType! > 0 && isAddNewPayment == true  {
//                            addPayment(paymentNonce: paymentMethodNonce!.nonce, paymentOptionType: Int64(paymentOptionType!.rawValue), paymentDescription: paymentDescription!, paymentExpiration: "12/31/2099")
//
//                            //get the latest payment data
//                            getPaymentTypeData(paymentTypeId: Int(paymentOptionType!.rawValue))
                            
                            //get the paymenttheodId of the new paymentmethod
                            //self.newPaymentMethodId = getPaymentMethodId(paymentTypeData: paymentTypeData!, paymentType: self.paymentOptionType!.rawValue)!
                            
                            //saveEventPreference(paymentMethodId: newPaymentMethodId)
                            isRefreshScreen = true
                        }
                        
                        if isRefreshScreen == true {
                            self.generalMessage.text = "Update was successful."
                            self.generalMessage.textColor = UIColor(red: 32/256, green: 106/256, blue: 93/256, alpha: 1.0)
                        }
                 
                        scrollToHeader()
                    }
                } else {
                    if isAddNewPayment == true {
    
//                        //add payment
//                        addPayment(paymentNonce: paymentMethodNonce!.nonce, paymentOptionType: Int64(paymentOptionType!.rawValue), paymentDescription: paymentDescription!, paymentExpiration: "12/31/2099")
//
//                        //get the latest payment data
//                        getPaymentTypeData(paymentTypeId: paymentOptionType!.rawValue)
//
                        //get the paymenttheodId of the new paymentmethod
                        //self.newPaymentMethodId = getPaymentMethodId(paymentTypeData: paymentTypeData!, paymentType: self.paymentOptionType!.rawValue)!
                        
                        //saveEventPreference(paymentMethodId: newPaymentMethodId)
                        isRefreshScreen = true
                    } else if orignalPaymentMethodId > 0 {
                        saveEventPreference(paymentMethodId: orignalPaymentMethodId)
                        isRefreshScreen = true
                    } else if paymentTypeFromPaymentType! > 0 && isAddNewPayment == true  {
//                        addPayment(paymentNonce: paymentMethodNonce!.nonce, paymentOptionType: Int64(paymentOptionType!.rawValue), paymentDescription: paymentDescription!, paymentExpiration: "12/31/2099")
//
//                        //get the latest payment data
//                        getPaymentTypeData(paymentTypeId: paymentOptionType!.rawValue)
                        
                        //get the paymenttheodId of the new paymentmethod
                        //self.newPaymentMethodId = getPaymentMethodId(paymentTypeData: paymentTypeData!, paymentType: self.paymentOptionType!.rawValue)!
                        
                        //saveEventPreference(paymentMethodId: newPaymentMethodId)
                        isRefreshScreen = true
                    }
                    
                    if isRefreshScreen == true {
                        self.generalMessage.text = "Update was successful."
                        self.generalMessage.textColor = UIColor(red: 32/256, green: 106/256, blue: 93/256, alpha: 1.0)
                    }
             
                    scrollToHeader()
                }
            }
        } else {
            //print("not ready to save payment")
            //paymentErrorLabel.text = "Please Add Payment Information"
            self.generalMessage.text = "Please Add Payment Information And Set Withdral Amount"
            self.generalMessage.textColor = UIColor(red: 27/256, green: 60/256, blue: 128/256, alpha: 1.0)
            scrollToHeader()
        }
            
        //print("paymentMethodIdFromGetPaymentType!  = \(paymentMethodIdFromGetPaymentType!)")
            //save preference if there is a payment method and the withdraw amount is not 0
          
//            print("Int(withdrawAmountTextField.text!) =\(withdrawAmountTextField.text!)")
//            withdrawAmount2 = Int(withdrawAmountTextField.text!)!
////
//        var isReadyToSavePref: Bool = false
//        if withdrawAmount > 0 {
//            if paymentTypeFromPaymentType != 0 {
//                paymentMethodId = paymentTypeFromPaymentType!
//                paymentErrorLabel.text = ""
//                isReadyToSavePref = true
//            } else if paymentMethodIdFromPreference != 0 {
//                paymentMethodId = paymentMethodIdFromPreference!
//                paymentErrorLabel.text = ""
//                isReadyToSavePref = true
//            } else {
//                isReadyToSavePref = false
//            }
//            if isReadyToSavePref == true {
//                if autoReplenishSwitch.isOn == true {
//                    if (isValidateReplenishAmount == false) {
//                        autoReplenishAmountTextField.becomeFirstResponder()
//                        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: true)
//                        print("I am still here")
//                        //print("Incorrect First Name")
//                        //loadingLabel.text = "Incorrect First Name"
//                        replenishAmountErrorLabel.isHidden = false
//                        replenishAmountErrorLabel.text = self.formValidation.validateName2(name2: replenishAmount).errorMsg
//                        return
//                    } else {
//                        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
//                        replenishAmountErrorLabel.isHidden = true
//                        replenishAmountErrorLabel.text = self.formValidation.validateName2(name2: replenishAmount).errorMsg
//
//
//                    }
//                } else  {
//                    saveEventPreference(paymentMethod: Int(Int64(paymentMethodId)))
//                    isRefreshScreen = true
//                }
//
//            } else {
//                paymentErrorLabel.text = "Please Add Payment Method to Continue"
//            }
//
//        } else {
//            if paymentMethodIdFromPreference! != 0 || paymentMethodIdFromPreference != 0 {
//                withdrawAmountErrorLabel.text = "Field Cannot Be Empty"
//                self.borderForTextField(textField: withdrawAmountTextField, validationFlag: true)
//                withdrawAmountTextField.becomeFirstResponder()
//            }
//        }
//            if paymentTypeFromPaymentType != 0 && withdrawAmount > 0 {
//                saveEventPreference(paymentMethod: Int(Int64(paymentMethodIdFromGetPaymentType!)))
//            } else {
//
//                withdrawAmountErrorLabel.text = "Field Cannot Be Empty"
//                if autoReplenishSwitch.isOn == true {
//                    if autoReplenishAmountTextField.text == "" {
//                        replenishAmountErrorLabel.text = "Field Cannot Be Empty"
//                        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: true)
//                    }
//                }
//                let isValidateWithdrawAmount = self.formValidation.validateName2(name2: withdrawamount).isValidate
//                let isValidateAutoRepAmount = self.formValidation.validateName2(name2: replenishAmount).isValidate
//
//                let isValidateAlertAmount = self.formValidation.validateName2(name2: alertAmount).isValidate
//
//                if isValidateWithdrawAmount == false {
//                    withdrawAmountTextField.becomeFirstResponder()
//                    self.borderForTextField(textField: withdrawAmountTextField, validationFlag: true)
//                    print("I am still here")
//                    //print("Incorrect First Name")
//                    //loadingLabel.text = "Incorrect First Name"
//                    withdrawAmountErrorLabel.isHidden = false
//                    withdrawAmountErrorLabel.text = self.formValidation.validateName2(name2: withdrawamount).errorMsg
//                    return
//                } else {
//                    self.borderForTextField(textField: withdrawAmountTextField, validationFlag: false)
//                    withdrawAmountErrorLabel.isHidden = true
//                    withdrawAmountErrorLabel.text = self.formValidation.validateName2(name2: withdrawamount).errorMsg
//                }
//
//
//                //only validate if autoreplenish is on
//                if autoReplenishSwitch.isOn == true {
//                    if isValidateAutoRepAmount == false {
//                        autoReplenishAmountTextField.becomeFirstResponder()
//                        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: true)
//                        print("I am still here")
//                        //print("Incorrect First Name")
//                        //loadingLabel.text = "Incorrect First Name"
//                        replenishAmountErrorLabel.isHidden = false
//                        replenishAmountErrorLabel.text = self.formValidation.validateName2(name2: replenishAmount).errorMsg
//                        return
//                    } else {
//                        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
//                        replenishAmountErrorLabel.isHidden = true
//                        replenishAmountErrorLabel.text = self.formValidation.validateName2(name2: replenishAmount).errorMsg
//                    }
//
//                    if isValidateAlertAmount == false {
//                        notificationAmountTextField.becomeFirstResponder()
//                        self.borderForTextField(textField: notificationAmountTextField, validationFlag: true)
//                        print("I am still here")
//                        //print("Incorrect First Name")
//                        //loadingLabel.text = "Incorrect First Name"
//                        alertAmountErrorLabel.isHidden = false
//                        alertAmountErrorLabel.text = self.formValidation.validateName2(name2: alertAmount).errorMsg
//                        return
//                    } else {
//                        self.borderForTextField(textField: notificationAmountTextField, validationFlag: false)
//                        alertAmountErrorLabel.isHidden = true
//                        alertAmountErrorLabel.text = self.formValidation.validateName2(name2: alertAmount).errorMsg
//                    }
//                }
//
//                if isValidateWithdrawAmount == true {
//                    if autoReplenishSwitch.isOn == true {
//                        //if isValidateAutoRepAmount
//                    }
//                }
//                let alert = UIAlertController(title: "Message", message: "Withdraw amount and paymethod is required to Save your preference.", preferredStyle: .actionSheet)
//                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                //alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  { action in self.performSegue(withIdentifier: "backToHome", sender: self) }))

//                self.present(alert, animated: true)
            //}
            
            //do this when a user is coming from the Invitation section of the home screen
            //this mean that an attendee is tryig to RSVP. If they set RSVP to false, don't let them
            //move forward
            if rsvpSwitch.isOn == false && screenIdentifier == "RSVP" {
                let alert = UIAlertController(title: "RSVP", message: "You have not RSVP for this event? Select Cancel so that you can RSVP or select Exit to leave this screen.", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler:  { action in self.performSegue(withIdentifier: "goToHomeScreen", sender: self) }))

                self.present(alert, animated: true)
                       //print("Balance is Zero")
            } else if rsvpSwitch.isOn == true && screenIdentifier == "RSVP"{  //this is first time RSVP
                
                let addAttendee = AddAttendees(profileId: ownerId!, eventId: eventId!, eventAttendees: [Attendees(profileId: profileId!, firstName: "Test", lastName: "test", email: "email", phone: "123",eventId: eventId!, isAttending: true)])
                
                //let updateAttendee = Attendees(profileId: profileId, eventId: eventId, isAttending: true)
                
                //print(updateAttendee)
                isRefreshScreen = true
                let request = PostRequest(path: "/api/Event/addattendees", model: addAttendee, token: token!, apiKey: encryptedAPIKey, deviceId: "")
                    Network.shared.send(request) { (result: Result<Empty, Error>)  in
                            switch result {
                            case .success( _):
                                self.generalMessage.text = "Update was successful."
                                self.generalMessage.textColor = UIColor(red: 32/256, green: 106/256, blue: 93/256, alpha: 1.0)
                                break
                            //case .failure(let error):
                            case .failure(let error):
                                self.generalMessage.text = "The Application is Temporary Unavailable. Please try again shortly. \(error.localizedDescription)"
                                self.generalMessage.textColor = UIColor(red: 193/256, green: 37/256, blue: 22/256, alpha: 1.0)
                                //self.messageLabel.text = error.localizedDescription
                                //print(error.localizedDescription)
                        }
                    }
                
            }
           
            //do this when an attendee set the switch to false indicating that they
            //no longer want to RSVP. The next time they return, the switch will be set
            //to false
            if screenIdentifier == "EventSettings" && rsvpSwitch.isOn == false && isAttendingEventId! != 0 {
                print("EventSettings IS TURNED OFF SETTING ISATTENDING = FALSE = \(rsvpSwitch.isOn)")
                let updateAttendee = Attendees(profileId: profileId!, firstName: "Test", lastName: "test", email: "email", phone: "123", eventId: eventId!, isAttending: false)
        
                let request = PostRequest(path: "/api/Event/updateattendee", model: updateAttendee, token: token!, apiKey: encryptedAPIKey, deviceId: "")
        
                Network.shared.send(request) { (result: Result<Empty, Error>)  in
                    switch result {
                    case .success( _):
                        self.generalMessage.text = "Update was successful."
                        self.generalMessage.textColor = UIColor(red: 32/256, green: 106/256, blue: 93/256, alpha: 1.0)
                        break
                    case .failure(let error):
                        self.generalMessage.text = "The Application is Temporary Unavailable. Please try again shortly. \(error.localizedDescription)"
                                                        self.generalMessage.textColor = UIColor(red: 193/256, green: 37/256, blue: 22/256, alpha: 1.0)
                        //self.messageLabel.text = error.localizedDescription
                    }
                }
                self.isRefreshScreen = true
            } else if screenIdentifier == "EventSettings" && rsvpSwitch.isOn == true && isAttendingEventId! == 0 {
                print("EventSettings is attending event id = 0 = \(rsvpSwitch.isOn)")
                let updateAttendee = Attendees(profileId: profileId!, firstName: "Test", lastName: "test", email: "email", phone: "123", eventId: eventId!, isAttending: true)
        
                let request = PostRequest(path: "/api/Event/updateattendee", model: updateAttendee, token: token!, apiKey: encryptedAPIKey, deviceId: "")
        
                Network.shared.send(request) { (result: Result<Empty, Error>)  in
                    switch result {
                    case .success( _):
                        self.generalMessage.text = "Update was successful."
                        self.generalMessage.textColor = UIColor(red: 32/256, green: 106/256, blue: 93/256, alpha: 1.0)
                        break
                       
                    case .failure(let error):
                        self.generalMessage.text = "The Application is Temporary Unavailable. Please try again shortly. \(error.localizedDescription)"
                                                        self.generalMessage.textColor = UIColor(red: 193/256, green: 37/256, blue: 22/256, alpha: 1.0)
                        //self.messageLabel.text = error.localizedDescription
                    }
                }
                self.isRefreshScreen = true
            } else {
                print("There is nothing to chang")
            }
            
    //
    //        if (self.paymentOptionType!.rawValue > 0 && self.paymentMethodNonce!.nonce != nil) {
    //            addPayment(paymentNonce: self.paymentMethodNonce!.nonce, paymentOptionType: Int64(self.paymentOptionType!.rawValue), paymentDescription: self.paymentDescription!, paymentExpiration: "12/1/2030")
    //
    //            print("paymentOption 2 = \(Int64(self.paymentOptionType!.rawValue))")
    //                                print("paymentMethod! 2 = \(self.paymentMethodNonce!.nonce)")
    //                                //print("paymentIcon = \(paymentIcon)")
    //                                print("paymentDescription 2 = \(self.paymentDescription!)")
    //        } else {
    //            print("no event preference payment ")
    //        }
    //
            
        //}
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return numberOfRowsAtSection.count
        return 3
        
    }

    
    


    @IBAction func addPaymentButtonPressed(_ sender: Any) {
         showDropIn(clientTokenOrTokenizationKey: paymentClientToken!)
        // self.performSegue(withIdentifier: "addPaymentVC", sender: nil)
       // performSegue(withIdentifier: "addPaymentVC", sender: self)
                   // self.dismiss(animated: true, completion: nil)
        
        
//        let addPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "addPaymentVC") as! AddPaymentViewController
//                                 self.navigationController?.pushViewController(addPaymentVC , animated: true)
//
                                  //selectRSVPVC.eventName = theEventName
    }
    
//    func getEventPreference2(profileId: Int64, eventId: Int64, token: String) {
//           var balance: Int = 0
//        print("I am in getPayment")
//        let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token)
//
//                               Network.shared.send(request) { (result: Result<Data, Error>)  in
//
//                                   switch result {
//
//                                   case .success(let eventPreferenceData):
//
//                                       //self.parse(json: event)
//
//
//
//                                     let decoder = JSONDecoder()
//
//                                            do {
//
//                                                let eventPreferenceJson: [EventPreferenceData] = try decoder.decode([EventPreferenceData].self, from: eventPreferenceData)
//
//                                                  for eventPrefData in eventPreferenceJson {
//          //                                            print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
//          //                                            print("customName = \(paymenttypedata.customName!)")
//          //                                            print("paymenttype = \(paymenttypedata.paymentType!)")
//
//                                                      balance = eventPrefData.maxSprayAmount
//
//
//
//                                                      print("BALANCE = \(balance)")
//
//
//                                                      //self.withdrawAmountTextField.text! = String(eventPrefData.maxSprayAmount)
//          //                                            self.autoReplenishAmountTextField.text  = String(eventPrefData.replenishAmount)
//          //                                            self.notificationAmountTextField.text = String(eventPrefData.notificationAmount)
//          //                                            self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
//
//          //                                            self.paymentNickNameTextField.text = (paymenttypedata.customName!)
//          //                                          self.paymentSelectedLabel.text = paymenttypedata.paymentDescription
//          //                                          self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
//          //                                          self.paymentActionMessageLabel.text = "edit payment Information for this event..."
//          //
//                    //                                print("error message = \(paymentJson[x].errorMessage!)")
//                    //                                print("error code = \(paymentJson[x].errorCode!)")
//                                                  }
//
//                                            } catch {
//
//                                                print(error)
//
//                                            }
//
//
//                                   case .failure(let error):
//
//                                       print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
//
//                                   }
//
//                              }
//
//              }
//
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
//        let request =  BTDropInRequest()
//        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
//        { [self] (controller, result, error) in
//            if (error != nil) {
//                print("ERROR")
//            } else if (result?.isCancelled == true) {
//                print("CANCELLED")
//            } else if let result = result {
//                // Use the BTDropInResult properties to update your UI
//                self.paymentOptionType = result.paymentOptionType
//                self.paymentMethodNonce = result.paymentMethod
//                let paymentIcon = result.paymentIcon
//                self.paymentDescription = result.paymentDescription
//
//
//
//                self.paymentSelectedLabel.text = self.paymentDescription
//                let size = CGSize(width: 20, height: 20)
//                let view = result.paymentIcon as? BTUIKVectorArtView
//                self.paymentIconImageView.image = view?.image(of: size)
//
//                //self.addEditPaymentButton.setBackgroundImage(UIImage(named: "editIcon"), for: UIControl.State.normal)
//                self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
//                self.paymentActionMessageLabel.text = "edit payment Information for this event..."
//                self.paymentNickNameTextField.text = ""
//                self.paymentErrorLabel.text = ""
//                print("paymentOption= \(self.paymentOptionType!.rawValue)")
//                print("paymentMethod Nonce! = \(self.paymentMethodNonce!.nonce)")
//                print("paymentIcon = \(paymentIcon)")
//                print("paymentDescription = \(self.paymentDescription!)")
//                self.isReadyToSavePayment = true
//                self.isAddNewPayment = true
//                self.isRefreshScreen = true
//
//                print("self.paymentOptionType!.rawValue = \(self.paymentOptionType!.rawValue)")
//                print("The new paymentMethodId = \(self.newPaymentMethodId )")
//
//                print("orignalPaymentMethodId = \(orignalPaymentMethodId)")
//
//                //only request newpaymentmethodIf if paymentmethod exist for the event
//                if orignalPaymentMethodId > 0 {
//                    self.newPaymentMethodId = getPaymentMethodId(paymentTypeData: paymentTypeData!, paymentType: self.paymentOptionType!.rawValue)!
//                    //call get paymentTypeData when the selected
//                    //payment already exist and populate paymentnicknamefield
//                    if newPaymentMethodId > 0 {
//                        getPaymentTypeData(paymentTypeId: self.paymentOptionType!.rawValue)
//                        print("I am in newPaymentMethodId > 0 \(self.paymentOptionType!.rawValue)")
//                        //getEventPref3()
//                    }
//                }
//
//            }
//            controller.dismiss(animated: true, completion: nil)
//        }
//        self.present(dropIn!, animated: true, completion: nil)
    }
    
    

    func saveEventPreference(paymentMethodId: Int) {
        print("SaveEventPreference was called #1")
        withdrawAmount = Int(withdrawAmountTextField.text!)!
//        guard let autoReplenishAmount = Int(autoReplenishAmountTextField.text!) else  {
//            return
//        }
        autoReplenishAmount = Int(autoReplenishAmountTextField.text!) ?? 0
        notificationAmount = Int(notificationAmountTextField.text!) ?? 0
        
        if autoReplenishSwitch.isOn == true {
            isAutoReplenish = true
        } else {
            isAutoReplenish = false
        }
        //print("paymentType= \(paymentType)")
        
        let addEventPreference = EventPreference(eventId: eventId!, profileId: profileId!, paymentMethod: paymentMethodId, maxSprayAmount: withdrawAmount, replenishAmount: autoReplenishAmount, notificationAmount:  notificationAmount, isAutoReplenish: isAutoReplenish!,currency: currencyCode)

        print("ADD EVENT PREFERENCE \(addEventPreference)")
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token!, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref); break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
    func addPayment(paymentNonce: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        
        
        
        paymentNickName = paymentNickNameTextField.text!
        
        print("my payment Nicke Name =\(paymentNickName!)")
        let addPayment = AddPaymentType(nonce: paymentNonce, customName: paymentNickName, paymentType: paymentOptionType, paymentDescription: paymentDescription, paymentExpiration: paymentExpiration, profileId: profileId)
        
        print("ADD PAYMENT = \(addPayment)")
        let request = PostRequest(path: "/api/PaymentMethod/add", model: addPayment , token: token!, apiKey: encryptedAPIKey, deviceId: "")

        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _):
                //after adding new card get the new PaymentmethodId
                //get the paymenttheodId of the new paymentmethod
               // self.newPaymentMethodId = self.getPaymentMethodId(paymentTypeData: self.paymentTypeData!, paymentType: self.paymentOptionType!.rawValue)!
                
                print("inside ADD PAYMENT = self.newPaymentMethodId \(self.newPaymentMethodId )")
                self.saveEventPreference(paymentMethodId: self.newPaymentMethodId)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
  
    func getPaymentMethodId(paymentTypeData: Data, paymentType: Int) -> Int?  {
//        let request = Request(path: "/api/PaymentMethod/all/\(profileId!)", token: token!)
//
//        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
//            switch result {
//            case .success(let paymentmethod1):
//                    //return paymentmethod1
//                self.getEventPref2(paymenttypeData: paymentmethod1)
//            case .failure(let error):
//                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
//            }
//        }
        
//        let request = Request(path: "/api/PaymentMethod/all/\(profileId!)", token: token!)
//        Network.shared.send(request) { (result: Result<Data, Error>)  in
//            switch result {
//                case .success(let paymentmethod1):
//                       //self.parse(json: event)
//                    //this decoder code works - temporary commenting out
        var paymentMethodIdout: Int = 0
        
         let decoder = JSONDecoder()
         do {
            let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentTypeData)
            for paymenttypedata in paymentJson {
              
                if paymenttypedata.paymentType! == paymentType {
                    paymentMethodIdout = Int(paymenttypedata.paymentMethodId!)
                    //set primary payment nickname - we want to use this if it exist
                    //paymentNickNamePrimary = paymenttypedata.customName
                }
            }
               
        } catch {
            print(error)
        }
//               case .failure(let error):
//                    print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
//               }
//
        return paymentMethodIdout
    }
    
    func getPaymentTypeData(paymentTypeId: Int)  {
        let request = Request(path: "/api/PaymentMethod/all/\(profileId!)", token: token!, apiKey: encryptedAPIKey)
               
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let paymentmethod1):
                
                    //return paymentmethod1
                self.paymentTypeData = paymentmethod1
                let decoder = JSONDecoder()
                do {
                   let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                   for paymenttypedata in paymentJson {
                     
                    if paymenttypedata.paymentType! == paymentTypeId {
                        //paymentType
                        print("AWELE IGHEDOSA paymenttypedata.customName \(paymenttypedata.customName)")
                          // paymentMethodIdout = Int(paymenttypedata.paymentMethodId!)
                           //set primary payment nickname - we want to use this if it exist
                        self.paymentNickNamePrimary = paymenttypedata.customName
                        self.paymentNickNameTextField.text = self.paymentNickNamePrimary
                       }
                   }
                      
               } catch {
                   print(error)
               }
                print("Dominic Ighedos - paymentmethod1 \(paymentmethod1)")
                //self.getEventPref2(paymenttypeData: paymentmethod1)
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }
        
    }
    
    //I am using this getEventPref3 function
    func getEventPref3() {
        
        //get the total amount that the gifter has given
        //for this event
        getGifterTotalTransBalance()
        
        
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId!)", token: token!, apiKey: encryptedAPIKey)
        
        Network.shared.send(request) { (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                        for eventPrefData in eventPreferenceJson {
                            print("Event Id = \(eventPrefData.eventId)")
                            print("Incoming Event Id = \(String(describing: self.eventId))")
                            
                            
                            if eventPrefData.eventId == self.eventId {
                                self.paymentMethodIdFromPreference = Int64(eventPrefData.paymentMethodDetails.paymentMethodId)
                                if eventPrefData.paymentMethodDetails.paymentMethodId == eventPrefData.paymentMethod {
                                    self.isReadyToSavePayment = true
                                    print("eventPreferenceData.paymentMethod == paymenttypedata.paymentType! ")
//                                    if eventPrefData.paymentMethodDetails.paymentType == 5 {
//                                        self.paymentIconImageView.image = UIImage(named: "visaicon")
//                                    } else if eventPrefData.paymentMethodDetails.paymentType == 4 {
//                                        self.paymentIconImageView.image = UIImage(named: "mastercardicon")
//                                    }
                                    
                                    self.paymentSelectedLabel.text = eventPrefData.paymentMethodDetails.paymentDescription!
                                    self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
                                    self.paymentActionMessageLabel.text = "edit payment Information for this event..."
                                    self.paymentTypeFromPaymentType = Int64(eventPrefData.paymentMethodDetails.paymentType)
                                    print("paymentTypeFromPaymentType =\(eventPrefData.paymentMethodDetails.paymentType)")
                                    self.paymentMethodIdFromGetPaymentType = Int64(eventPrefData.paymentMethodDetails.paymentMethodId)
                                    self.orignalPaymentMethodId = Int(eventPrefData.paymentMethodDetails.paymentMethodId)
                 //                                print("error message = \(paymentJson[x].errorMessage!)")
                 //                                print("error code = \(paymentJson[x].errorCode!)")
                                    print("original payment method Id =\(self.orignalPaymentMethodId)")
                                    print("paymentmethodId = \(eventPrefData.paymentMethodDetails.paymentMethodId)")
                                    print("customName = \(eventPrefData.paymentMethodDetails.customName!)")
                                    print("paymenttype = \(eventPrefData.paymentMethodDetails.paymentType)")
                                    
                                    print("paymenttypedata.paymentType! = \(eventPrefData.paymentMethodDetails.paymentType)")
                                    print("paymenttypedata.paymentMethodId = \(eventPrefData.paymentMethodDetails.paymentMethodId)")
                                    
                                    self.withdrawAmountTextField.text! = String(eventPrefData.maxSprayAmount)
                                    self.autoReplenishAmountTextField.text  = String(eventPrefData.replenishAmount)
                                    self.notificationAmountTextField.text = String(eventPrefData.notificationAmount)
                                    self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
                                    
                                    //display paymentmethod icon
                                    switch eventPrefData.paymentMethodDetails.paymentType {
                                    case 5:
                                        self.paymentIconImageView.image = UIImage(named: "visaicon")
                                    case 4:
                                        self.paymentIconImageView.image = UIImage(named: "mastercardicon")
                                    case 3:
                                        self.paymentIconImageView.image = UIImage(named: "discovericon")
                                    case 1:
                                        self.paymentIconImageView.image = UIImage(named: "amexicon")
                                    default:
                                        break
                                    }
                                    
                                    //get and store PaymenttypeData on file
                                    self.getPaymentTypeData(paymentTypeId: eventPrefData.paymentMethodDetails.paymentType)
                                    
//                                    self.orignalPaymentMethodId = eventPrefData.paymentMethodDetails.paymentMethodId
//                                    //if primary payment nick name is availabl, use that...
//                                    if self.paymentNickNamePrimary != "" {
//                                        self.paymentNickNameTextField.text = self.paymentNickNamePrimary
//                                    } else {
//                                        self.paymentNickNameTextField.text = eventPrefData.paymentMethodDetails.customName!
//                                    }
                                    
                                    
                                    
                                    if self.autoReplenishSwitch.isOn == false {
                                        
                                        self.replenishAmtPlusBtn.isEnabled = false
                                        self.replenishAmtMinusBtn.isEnabled = false
                                        self.alertAmtPlusBtn.isEnabled = false
                                        self.alertAmtMinusBtn.isEnabled = false
                                        
                                        self.autoReplenishAmountTextField.isEnabled = false
                                        self.notificationAmountTextField.isEnabled = false
                                        
                                        self.autoReplenishAmountTextField.text = ""
                                        self.notificationAmountTextField.text = ""
                                    } else {
                                        self.replenishAmtPlusBtn.isEnabled = true
                                        self.replenishAmtMinusBtn.isEnabled = true
                                        self.alertAmtPlusBtn.isEnabled = true
                                        self.alertAmtMinusBtn.isEnabled = true
                                        
                                        self.autoReplenishAmountTextField.isEnabled = true
                                        self.notificationAmountTextField.isEnabled = true
                                        self.autoReplenishAmountTextField.placeholder = "Enter Replenish Amount"
                                        self.notificationAmountTextField.placeholder = "Enter Alert Amount"
                                    }
                                    break
                                }
                                
//                                let decoder = JSONDecoder()
//                                do {
//                                    let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymenttypeData)
//                                    for paymenttypedata in paymentJson {
//                                        if eventPrefData.paymentMethod == paymenttypedata.paymentType! {
//                                            //this shows that i have a payment
//                                            //on file
//                                            self.isReadyToSavePayment = true
//                                            print("eventPreferenceData.paymentMethod == paymenttypedata.paymentType! ")
//                                            if paymenttypedata.paymentType! == 5 {
//                                                self.paymentIconImageView.image = UIImage(named: "visaicon")
//                                            } else if paymenttypedata.paymentType! == 4 {
//                                                self.paymentIconImageView.image = UIImage(named: "mastercardicon")
//                                            }
//
//                                            self.paymentNickNameTextField.text = (paymenttypedata.customName!)
//                                            self.paymentSelectedLabel.text = paymenttypedata.paymentDescription
//                                            self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
//                                            self.paymentActionMessageLabel.text = "edit payment Information for this event..."
//                                            self.paymentTypeFromPaymentType = paymenttypedata.paymentType!
//                                            print("paymentTypeFromPaymentType =\(paymenttypedata.paymentType!)")
//                                            self.paymentMethodIdFromGetPaymentType = paymenttypedata.paymentMethodId!
//                         //                                print("error message = \(paymentJson[x].errorMessage!)")
//                         //                                print("error code = \(paymentJson[x].errorCode!)")
//
//                                            print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
//                                            print("customName = \(paymenttypedata.customName!)")
//                                            print("paymenttype = \(paymenttypedata.paymentType!)")
//
//                                            print("paymenttypedata.paymentType! = \(paymenttypedata.paymentType!)")
//                                            print("paymenttypedata.paymentMethodId = \(paymenttypedata.paymentMethodId!)")
//
//                                            self.withdrawAmountTextField.text! = String(eventPrefData.maxSprayAmount)
//                                            self.autoReplenishAmountTextField.text  = String(eventPrefData.replenishAmount)
//                                            self.notificationAmountTextField.text = String(eventPrefData.notificationAmount)
//                                            self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
//
//                                            if self.autoReplenishSwitch.isOn == false {
//                                                self.autoReplenishAmountTextField.isEnabled = false
//                                                self.notificationAmountTextField.isEnabled = false
//
//                                                self.autoReplenishAmountTextField.text = ""
//                                                self.notificationAmountTextField.text = ""
//                                            } else {
//                                                self.autoReplenishAmountTextField.isEnabled = true
//                                                self.notificationAmountTextField.isEnabled = true
//                                                self.autoReplenishAmountTextField.placeholder = "Enter Replenish Amount"
//                                                self.notificationAmountTextField.placeholder = "Enter Alert Amount"
//                                            }
//
//                                        }
//                                   }
//
//                               } catch {
//                                   print(error)
//                               }
//
                                //exit if eventId = eventId
                                break
                                
                            //else if eventId <> eventId
                            } else {
                                self.withdrawAmountTextField.text! = ""
                                self.autoReplenishAmountTextField.text = ""
                                self.notificationAmountTextField.text = ""
                                self.autoReplenishSwitch.isOn = false
                                self.autoReplenishAmountTextField.isEnabled = false
                                self.notificationAmountTextField.isEnabled = false
                                    
                                self.autoReplenishAmountTextField.text = ""
                                self.notificationAmountTextField.text = ""
                                self.autoReplenishAmountTextField.text = ""
                                self.notificationAmountTextField.text = ""
                                
                                self.paymentMethodIdFromPreference = 0
                                self.addEditPaymentButton.setImage(UIImage(named: "plusicon"), for: .normal)
                                self.paymentActionMessageLabel.text = "Add payment Information for this event..."
                                self.paymentSelectedLabel.text = ""
                                self.paymentIconImageView.image = UIImage(named: "paymentInfoIcon")
                                self.paymentNickNameTextField.text = ""
                                
                            }
                        }
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
    
    //hold on this function - using getVentPref3 to test
    func getEventPref2(paymenttypeData: Data) {
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId!)", token: token!, apiKey: encryptedAPIKey)
        
        Network.shared.send(request) { (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData] = try decoder.decode([EventPreferenceData].self, from: eventPreferenceData)
                        for eventPrefData in eventPreferenceJson {
                            print("Event Id = \(eventPrefData.eventId)")
                            print("Incoming Event Id = \(String(describing: self.eventId))")
                            
                            if eventPrefData.eventId == self.eventId {
                                let decoder = JSONDecoder()
                                do {
                                    let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymenttypeData)
                                    for paymenttypedata in paymentJson {
                                        if eventPrefData.paymentMethod == paymenttypedata.paymentType! {
                                            //this shows that i have a payment
                                            //on file
                                            self.isReadyToSavePayment = true
                                            print("eventPreferenceData.paymentMethod == paymenttypedata.paymentType! ")
                                            
                                            switch paymenttypedata.paymentType! {
                                            case 5:
                                                self.paymentIconImageView.image = UIImage(named: "visaicon")
                                            case 4:
                                                self.paymentIconImageView.image = UIImage(named: "mastercardicon")
                                            case 1:
                                                self.paymentIconImageView.image = UIImage(named: "amexicon")
                                            default:
                                                break
                                            }
                                            //no longer needed for now
//                                            if paymenttypedata.paymentType! == 5 {
//                                                self.paymentIconImageView.image = UIImage(named: "visaicon")
//                                            } else if paymenttypedata.paymentType! == 4 {
//                                                self.paymentIconImageView.image = UIImage(named: "mastercardicon")
//                                            }
                                        
                                            self.paymentNickNameTextField.text = (paymenttypedata.customName!)
                                            self.paymentSelectedLabel.text = paymenttypedata.paymentDescription
                                            self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
                                            self.paymentActionMessageLabel.text = "edit payment Information for this event..."
                                            self.paymentTypeFromPaymentType = paymenttypedata.paymentType!
                                            print("paymentTypeFromPaymentType =\(paymenttypedata.paymentType!)")
                                            self.paymentMethodIdFromGetPaymentType = paymenttypedata.paymentMethodId!
                         //                                print("error message = \(paymentJson[x].errorMessage!)")
                         //                                print("error code = \(paymentJson[x].errorCode!)")
                                            
                                            print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
                                            print("customName = \(paymenttypedata.customName!)")
                                            print("paymenttype = \(paymenttypedata.paymentType!)")
                                            
                                            print("paymenttypedata.paymentType! = \(paymenttypedata.paymentType!)")
                                            print("paymenttypedata.paymentMethodId = \(paymenttypedata.paymentMethodId!)")
                                            
                                            self.withdrawAmountTextField.text! = String(eventPrefData.maxSprayAmount)
                                            self.autoReplenishAmountTextField.text  = String(eventPrefData.replenishAmount)
                                            self.notificationAmountTextField.text = String(eventPrefData.notificationAmount)
                                            self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
                                            
                                            if self.autoReplenishSwitch.isOn == false {
                                                self.autoReplenishAmountTextField.isEnabled = false
                                                self.notificationAmountTextField.isEnabled = false
                                                
                                                self.autoReplenishAmountTextField.text = ""
                                                self.notificationAmountTextField.text = ""
                                            } else {
                                                self.autoReplenishAmountTextField.isEnabled = true
                                                self.notificationAmountTextField.isEnabled = true
                                                self.autoReplenishAmountTextField.placeholder = "Enter Replenish Amount"
                                                self.notificationAmountTextField.placeholder = "Enter Alert Amount"
                                            }

                                        }
                                   }

                               } catch {
                                   print(error)
                               }
                                
                                //exit if eventId = eventId
                                break
                            }
                        }
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
    
    func getPaymenttype() {
        let request = Request(path: "/api/PaymentMethod/all/\(profileId!)", token: token!, apiKey: encryptedAPIKey)
               
               Network.shared.send(request) { (result: Result<Data, Error>)  in
                   
                   switch result {
                       
                   case .success(let paymentmethod1):
                       //self.parse(json: event)
                    //this decoder code works - temporary commenting out
                     let decoder = JSONDecoder()
                     do {
                        let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                        for paymenttypedata in paymentJson {
                            print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
                            print("customName = \(paymenttypedata.customName!)")
                            print("paymenttype = \(paymenttypedata.paymentType!)")
                            
                            print("paymenttypedata.paymentType! = \(paymenttypedata.paymentType!)")
                            print("paymenttypedata.paymentMethodId = \(paymenttypedata.paymentMethodId!)")
                            if paymenttypedata.paymentType! == 5 {
                                self.paymentIconImageView.image = UIImage(named: "visaicon")
                            } else if paymenttypedata.paymentType! == 4 {
                                self.paymentIconImageView.image = UIImage(named: "mastercardicon")
                            }
                            self.paymentNickNameTextField.text = (paymenttypedata.customName!)
                            self.paymentSelectedLabel.text = paymenttypedata.paymentDescription
                            self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
                            self.paymentActionMessageLabel.text = "edit payment Information for this event..."
                            self.paymentTypeFromPaymentType = paymenttypedata.paymentType!
                            print("paymentTypeFromPaymentType =\(paymenttypedata.paymentType!)")
                            self.paymentMethodIdFromGetPaymentType = paymenttypedata.paymentMethodId!
//                                print("error message = \(paymentJson[x].errorMessage!)")
//                                print("error code = \(paymentJson[x].errorCode!)")
                        }

                    } catch {
                        
                        print(error)
                        
                    }
                    
                       
                   case .failure(let error):
                       
                       print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
                       
                   }
                   
               }
               
    }
    
    func getEventPreference() {
        let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId!)", token: token!, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
        switch result {
        case .success(let eventPreferenceData):
        let decoder = JSONDecoder()
            do {
                let eventPreferenceJson: [EventPreferenceData] = try decoder.decode([EventPreferenceData].self, from: eventPreferenceData)
                for eventPrefData in eventPreferenceJson {
                    print("Event Id = \(eventPrefData.eventId)")
                    print("Incoming Event Id = \(String(describing: self.eventId))")
                    
                    //check if preference record for event
                    //already exist
                    if eventPrefData.eventId == self.eventId {
                        self.withdrawAmountTextField.text! = String(eventPrefData.maxSprayAmount)
                        self.autoReplenishAmountTextField.text  = String(eventPrefData.replenishAmount)
                        self.notificationAmountTextField.text = String(eventPrefData.notificationAmount)
                        self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
                        
                        self.paymentActionMessageLabel.text = ""
                        if self.autoReplenishSwitch.isOn == false {
                            self.autoReplenishAmountTextField.isEnabled = false
                            self.notificationAmountTextField.isEnabled = false
                            
                            self.autoReplenishAmountTextField.text = ""
                            self.notificationAmountTextField.text = ""
                        } else {
                            self.autoReplenishAmountTextField.isEnabled = true
                            self.notificationAmountTextField.isEnabled = true
                            self.autoReplenishAmountTextField.placeholder = "Enter Replenish Amount"
                            self.notificationAmountTextField.placeholder = "Enter Alert Amount"
                        }
                        self.paymentMethodIdFromPreference = Int64(eventPrefData.paymentMethod)
                        
                        break
                    //when payment pref doesn't exist for this event
                    } else if (eventPrefData.eventId == 0 || eventPrefData.eventId != self.eventId)  {
                        self.withdrawAmountTextField.text! = ""
                        self.autoReplenishAmountTextField.text = ""
                        self.notificationAmountTextField.text = ""
                        self.autoReplenishSwitch.isOn = false
                        self.autoReplenishAmountTextField.isEnabled = false
                        self.notificationAmountTextField.isEnabled = false
                            
                        self.autoReplenishAmountTextField.text = ""
                        self.notificationAmountTextField.text = ""
                        self.autoReplenishAmountTextField.text = ""
                        self.notificationAmountTextField.text = ""
                        
                        self.paymentMethodIdFromPreference = 0
                        self.addEditPaymentButton.setImage(UIImage(named: "plusicon"), for: .normal)
                        self.paymentActionMessageLabel.text = "Add payment Information for this event..."
                        self.paymentSelectedLabel.text = ""
                        self.paymentIconImageView.image = UIImage(named: "paymentInfoIcon")
                        self.paymentNickNameTextField.text = ""
                    }
                    
                    
                    
                }
            } catch {
                print(error)
            }
        case .failure(let error):
            print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if(segue.identifier == "addPaymentVC"){
            let NextVC = segue.destination as! AddPaymentViewController
            NextVC.token = token!
            NextVC.paymentClientToken = paymentClientToken!
            NextVC.eventName = eventName
            
        //                            NextVC.token = token2pass
        //                          displayVC.token = token2pass
        //                          displayVC.userdata = userdata
         } else if(segue.identifier == "backToHome") {
            let NextVC = segue.destination as! EventSettingContainerViewController
            NextVC.token = token!
            NextVC.encryptedAPIKey = encryptedAPIKey
            NextVC.paymentClientToken = paymentClientToken!
            NextVC.profileId = profileId
            NextVC.isRefreshData = isRefreshScreen
         } else if(segue.identifier == "goToHomeScreen") {
            let NextVC = segue.destination as! HomeViewController
            NextVC.token = token!
            NextVC.encryptedAPIKey = encryptedAPIKey
            NextVC.paymentClientToken = paymentClientToken!
            NextVC.profileId = profileId!
            NextVC.isRefreshData = isRefreshScreen
         }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //set this current view controller to the other UIViewController which will be pushed (vc2)
//        //You will need it later when pass back data
//        let secondViewController = segue.destinationViewController as! vc2
//        secondViewController.previousVC = self
//    }
   

}


extension EventSettingTableViewController: UITextFieldDelegate {
    //func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //MARK - UITextField Delegates
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            //For mobile numer validation
            
            
            if (textField == withdrawAmountTextField || textField == autoReplenishAmountTextField || textField == notificationAmountTextField) {
                print("textField \(textField)")
                //setFormattedAmount(string)
                let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")//Here change this characters based on your requirement
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
            }
            
            
//            switch string {
//            case "0","1","2","3","4","5","6","7","8","9":
//                currentString += string
//                print(currentString)
//                formatCurrency(string: currentString)
//            default:
//                var array = Array(string)
//                var currentStringArray = Array(currentString)
//                if array.count == 0 && currentStringArray.count != 0 {
//                    currentStringArray.removeLast()
//                    currentString = ""
//                    for character in currentStringArray {
//                        currentString += String(character)
//                    }
//                    formatCurrency(string: currentString)
//                }
//            }
//            return false
            return true
        }
//
//    func formatCurrency(string: String) {
//        print("format \(string)")
//        let formatter = NumberFormatter()
//        formatter.numberStyle = NumberFormatter.Style.currency // Style.CurrencyStyle
//        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
//        var numberFromField =  String(currentString)
//        textField.text = formatter.stringFromNumber(numberFromField)
//        //print(textField.text )
//    }
//
}


//    private func setFormattedAmount(_ string: String) {
//        switch string {
//        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
//            let amountString = amountString + string
//        default:
//            if amountString.count > 0 {
//                amountString.removeLast()
//            }
//        }
//
//        let amount = (NSString(string: amountString).doubleValue) / 100
//        textField.text = formatAmount(amount)
//    }
//
//    private func formatAmount(_ amount: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = .current
//
//        if let amount = formatter.string(from: NSNumber(value: amount)) {
//            return amount
//        }
//
//        return ""
//    }
//
    
    


    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        
//        return 7
//    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
//
//        // Configure the cell...
//        switch (indexPath.section) {
//        case 0: do {
//                cell.textLabel!.text = "Dominic Birthday"
//            }
//
//            default:
//                break;
//        }
//
//        return cell;
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



