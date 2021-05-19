//
//  EventPayment2ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/2/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import Stripe

//class CellClass: UITableViewCell {
//
//}
struct AddSprayAmountOptions {
    let id: Int
    let amount: Int
    let displayAmount: String
}
class EventPayment2ViewController: UIViewController, STPAddCardViewControllerDelegate {

    //@IBOutlet weak var btnSelectPayment: UIButton!
    
    @IBOutlet weak var btnSelectPayment: UIButton!
    //@IBOutlet weak var btnSelectPayment: UIButton!
//    @IBOutlet weak var initialSprayAmountTextField: UITextField!
//    @IBOutlet weak var autoReplenishAmountTextField: UITextField!
//    @IBOutlet weak var alertAmountTextField: UITextField!
//    @IBOutlet weak var autoReplenishSwitch: UISwitch!
//    @IBOutlet weak var eventNameLabel: UILabel!
//
    
    @IBOutlet weak var secondUIView: UIView!
    @IBOutlet weak var halfScreenPayment: UIView!
    @IBOutlet weak var gifterTotalTransAmountLbl: UILabel!
    @IBOutlet weak var autoReplenishLbl: UILabel!
    @IBOutlet weak var autoReplenishSwitch: UISwitch!
    @IBOutlet weak var giftAmountSegConrol: UISegmentedControl!
    
    @IBOutlet weak var paymentMethodIcon: UIImageView!
    @IBOutlet weak var autoReplenishAmountSegControl: UISegmentedControl!
    @IBOutlet weak var currentBalance: UILabel!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    //var customtextfield = CustomTextField()
    var availablePaymentData = [PaymentTypeData2]()
    var addSprayAmountOptions = [AddSprayAmountOptions]()
    var addSprayAmountOptionsAutoReplenish = [AddSprayAmountOptions]()
    
    var profileId: Int64 = 0
    var eventId: Int64 = 0
    var token: String = ""
    var paymentClientToken: String = ""
    var eventName: String = ""
    var eventDateTime: String = ""
    var gifterTotalTransAmount: Int = 0
    var isReadyToSavePayment: Bool = false
    var completionAction: String = ""
    
    //var paymentClientToken: String = ""
    
    //need to confirm if i need these variables 2/2
    var paymentTypeFromPaymentType: Int64?
    var paymentMethodIdFromPreference: Int64?
    var paymentMethodIdFromGetPaymentType: Int64?
    var paymentMethodId: Int64 = 0
    var newPaymentMethodId: Int = 0
    var orignalPaymentMethodId: Int = 0
    var availableBalance: Int = 0
    var updatedBalance: Int = 0
    
    var updategfitamountdelegate:  UpdatedGiftAmountDelegate?
    var haspaymentdelegate: HasPaymentMethodDelegate?
    
    var currencycode: String = "usd"
    var newPaymentMethodAdded: Bool = false
    var paymentMethodIconName: String = ""
    var encryptedAPIKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //use to keep keyboard down
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
      

      
        
        //self.navigationItem.title = "Select Event Payment"
        //secondUIView.backgroundColor = .clear
        view.backgroundColor = .clear
        createTheView()
        // Do any additional setup after loading the view.
        
//        halfScreenPayment.layer.borderColor  = UIColor.lightGray.cgColor
//        halfScreenPayment.layer.shadowOffset = CGSize(width: 1, height: 1.0)
//        halfScreenPayment.layer.shadowOpacity  = 0.0
//        halfScreenPayment.layer.masksToBounds = false
//        halfScreenPayment.layer.cornerRadius = 10.0
//
        secondUIView.layer.borderColor  = UIColor.lightGray.cgColor
        secondUIView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        secondUIView.layer.shadowOpacity  = 1.0
        secondUIView.layer.masksToBounds = false
        secondUIView.layer.cornerRadius = 10.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        initiliazationTasks()
        customeFieldStyling()
        
        getAvailablePaymentData()
        getGifterTotalTransBalance()
        loadSprayAmountOptions()
        
       
        //eventNameLabel.text = eventName + "\n \(eventDateTime)"
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        let somespace: CGFloat = 40

        self.btnSelectPayment.setImage(UIImage(systemName: "chevron.down"), for: UIControl.State.normal)

        self.btnSelectPayment.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.btnSelectPayment.frame.size.width - somespace , bottom: 0, right: 0)

        //print(self.btnSelectPayment.imageView?.frame)

        self.btnSelectPayment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1 )
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    private func createTheView() {

        let xCoord = self.view.bounds.width /// 2 - 50
        let yCoord = self.view.bounds.height /// 2 - 50

        let centeredView = UIView(frame: CGRect(x: xCoord, y: yCoord, width: self.view.bounds.width, height: self.view.bounds.height))
        centeredView.backgroundColor = .blue
        self.view.addSubview(centeredView)
    }
    
    func closeScreen() {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
            
          }
    }
    @IBAction func closeHalfScreen(_ sender: Any) {
        closeScreen()
    }
    @IBAction func savePaymentBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func launchPaymentScreenBtnPressed(_ sender: Any) {
        launchStripePaymentScreen()
    }
    @IBAction func saveEventPayment(_ sender: Any) {
        print(getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addgiftamount"))
        
        print(getSprayAmountInt(amountId: autoReplenishAmountSegControl.selectedSegmentIndex, category: "addreplenishamount"))
        print(autoReplenishSwitch.isOn)
        print(btnSelectPayment.currentTitle!)
        
        print("paymentmethodId = \(getPaymenthMethodId(customName: btnSelectPayment.currentTitle!))")
        print("seg val \(autoReplenishAmountSegControl.selectedSegmentIndex)")
        if autoReplenishSwitch.isOn == true && autoReplenishAmountSegControl.selectedSegmentIndex < 0 {
            // create the alert
            let alert = UIAlertController(title: "Missing Information", message: "Since Auto Replenish is On, you must select Auto Replenish Amount.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else if availableBalance <= 0 &&  giftAmountSegConrol.selectedSegmentIndex < 0 {
            // create the alert
            let alert = UIAlertController(title: "Missing Information", message: "Your current balance is $\(availableBalance). To continue, please add more funds by selecting an amount from the options below.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            //do this if user saves w/ out add additional amount
            //this will preserve the available balance
            if updatedBalance == 0 {
                updatedBalance = availableBalance
            }
            if newPaymentMethodAdded == false {
                paymentMethodId = getPaymenthMethodId(customName: btnSelectPayment.currentTitle!)
            }
            
            print("the new PaymentMethodid = \(paymentMethodId)")
            let updatedGiftAmount = updatedBalance
            let updatedAutoReplenishFlag = autoReplenishSwitch.isOn
            var updatedAutoReplenishAmount: Int = 0
            
            if autoReplenishSwitch.isOn == true {
                if autoReplenishAmountSegControl.selectedSegmentIndex >= 0 {
                    updatedAutoReplenishAmount = getSprayAmountInt(amountId: autoReplenishAmountSegControl.selectedSegmentIndex, category: "addreplenishamount")
                } else  {
                    updatedAutoReplenishAmount = 0
                }
               
            } else {
                updatedAutoReplenishAmount = 0
            }
            
            let addEventPreference = EventPreference(eventId: 0, profileId: profileId, paymentMethod: Int(paymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencycode)

            print("ADD EVENT PREFERENCE \(addEventPreference)")
        
            updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
            
            let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
            Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
                switch result {
                case .success(let eventpref): print(eventpref);
                    haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(paymentMethodId))
                    self.completionAlert(message: "Update Was Successful", timer: 1)
                    //close payment window
                    
                    break
                case .failure(let error):
                print(error.localizedDescription)
                }
            }
        }
    }
    
    
    //get paymentMethodId for payment description selected
    func getPaymenthMethodId(customName: String) -> Int64 {
        var thePaymentMethodId: Int64 = 0
        for i in availablePaymentData {
            if i.customName == customName {
                thePaymentMethodId = i.paymentMethodId!
                break
            }
        }
        return thePaymentMethodId
    }
    
    //use this to get payment description/name
    func getPaymenthMethodName(paymentmethodid: Int) -> String {
        var thePaymentMethodName: String = ""
        for i in availablePaymentData {
            if i.paymentMethodId! == paymentmethodid {
                thePaymentMethodName = i.customName!
                break
            }
        }
        return thePaymentMethodName
    }
    
    func getPaymentMethodIcon(name: String) -> String {
        let paymentMethodDesc = name
        let index = paymentMethodDesc.firstIndex(of: " ") ?? paymentMethodDesc.endIndex
        let paymentMethodIcon = paymentMethodDesc[..<index]
        var paymentIcon: String = ""
        switch paymentMethodIcon {
        case "Visa":
            paymentIcon = "visaicon"
        case "Mastercard":
            paymentIcon = "mastercardicon"
        case "Discovercard":
            paymentIcon = "discovercardicon"
        default:
            paymentIcon = "discovercardicon"
        }
        print("payment method Icod = \(paymentIcon)")
        return paymentIcon
    }

    func completionAlert(message: String, timer: Int) -> Void {
        let delay = Double(timer) //* Double(NSEC_PER_SEC)
      let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
      present(alert, animated: true, completion: nil)
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
       alert.dismiss(animated: true)
        
        self.closeScreen()
      }
    }
    
  
    
    func getSegControlIndex(amount: Int, category: String) -> Int {
        var segControlIndex: Int = 0
        if category == "replenishamount" {
            for replenish in addSprayAmountOptionsAutoReplenish {
                if replenish.amount == amount {
                    segControlIndex = replenish.id
                    break
                }
            }
        } else if category == "initialamount" {
            for initialAmount in addSprayAmountOptionsAutoReplenish {
                if initialAmount.amount == amount {
                    segControlIndex = initialAmount.id
                    break
                }
            }
        }
        
        return segControlIndex
    }
    
    //not using this right now... but hold it 2/13
    @IBAction func addPaymentBtnPressed(_ sender: Any) {
        //launch stripe payment screen
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: addCardViewController)
          present(navigationController, animated: true)
    }
    
    func launchStripePaymentScreen(){
        //launch stripe payment screen
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: addCardViewController)
          present(navigationController, animated: true)
    }
    func getAvailablePaymentData() {
        let request = Request(path: "/api/PaymentMethod/all/\(profileId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
           case .success(let paymentmethod1):
               //self.parse(json: event)
             let decoder = JSONDecoder()
             do {
                let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                for paymenttypedata in paymentJson {
                    if paymenttypedata.customName != "" {
                        let adddata = PaymentTypeData2(paymentMethodId: paymenttypedata.paymentMethodId!,
                                                       profileId: paymenttypedata.profileId,
                                                       paymentType: paymenttypedata.paymentType,
                                                       customName: paymenttypedata.customName,
                                                       paymentDescription: paymenttypedata.paymentDescription,
                                                       paymentExpiration: paymenttypedata.paymentExpiration,
                                                       defaultPaymentMethod: paymenttypedata.defaultPaymentMethod,
                                                       paymentImage: paymenttypedata.paymentDescription)
                        self.availablePaymentData.append(adddata)
                        
                        //display the default payment on the dropdown list
                        /* comment this out for now 4/5 i don't need it*/
//                        if paymenttypedata.defaultPaymentMethod == true {
//                            self.btnSelectPayment.setTitle(paymenttypedata.customName, for: .normal)
//                            paymentMethodIconName = getPaymentMethodIcon(name: paymenttypedata.customName!)
//
//                            paymentMethodIcon.image = UIImage(named: paymentMethodIconName)
//
//                        }
                           
                        
                        print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
                        print("customName = \(paymenttypedata.customName!)")
                        print("paymenttype = \(paymenttypedata.paymentType!)")
                        
                        print("paymenttypedata.paymentType! = \(paymenttypedata.paymentType!)")
                        print("paymenttypedata.paymentMethodId = \(paymenttypedata.paymentMethodId!)")
                        print("paymenttypedata.defaultPaymentMethod = \(paymenttypedata.defaultPaymentMethod!)")
                    }
                    
                }
             } catch {
                print(error)
             }
            self.tableView.reloadData()
            getEventPref()
            case .failure(let error):
               print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
           }
       }
    }
    
    func getGifterTotalTransBalance()   {
        
        var availablebalance: Int = 0
        //var theGifterTotalTransBalance: Int = 0
        let request = Request(path: "/api/Event/transactiontotal/\(profileId)/\(eventId)", token: token, apiKey: encryptedAPIKey)
               
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
                self.gifterTotalTransAmountLbl.text = "$" + String(self.gifterTotalTransAmount)
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }

    }
    
    func getEventPref() {
        
        //get the total amount that the gifter has given
        //for this event
        getGifterTotalTransBalance()
        
        
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        //let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token)
        let request = Request(path: "/api/Event/prefs/\(profileId)/0", token: token, apiKey: encryptedAPIKey)
        
        Network.shared.send(request) { [self] (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                        if eventPreferenceJson.count == 0 {
                            self.availableBalance = 0
                            self.currentBalance.text = "$" + String(self.availableBalance)
                            break
                        } else {
                            for eventPrefData in eventPreferenceJson {
                                print("Event Id = \(eventPrefData.eventId)")
                                print("Incoming Event Id = \(String(describing: self.eventId))")
                                
                                
                                //if eventPrefData.eventId == self.eventId {
                                self.paymentMethodIdFromPreference = Int64(eventPrefData.paymentMethod)
                                //only use the payment for the event that you are on...
                                //if eventPrefData.paymentMethodDetails.paymentMethodId == eventPrefData.paymentMethod {
                                    self.isReadyToSavePayment = true
                                    print("eventPreferenceData.paymentMethod == paymenttypedata.paymentType! ")


                                    self.paymentTypeFromPaymentType = Int64(eventPrefData.paymentMethodDetails.paymentType)
                                    print("paymentTypeFromPaymentType =\(eventPrefData.paymentMethodDetails.paymentType)")
                                    self.paymentMethodIdFromGetPaymentType = Int64(eventPrefData.paymentMethodDetails.paymentMethodId)
                                    self.orignalPaymentMethodId = Int(eventPrefData.paymentMethodDetails.paymentMethodId)
         
                                    
                                    self.btnSelectPayment.setTitle(self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethod), for: .normal)
                                    
                                    print("self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethodDetails.paymentMethodId) \(self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethod))")
                                    paymentMethodIconName = getPaymentMethodIcon(name: getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethod))
                                    
                                    
                                    paymentMethodIcon.image = UIImage(named: paymentMethodIconName)
                                    
                                    self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
                                    //self.availableBalance = eventPrefData.maxSprayAmount - self.gifterTotalTransAmount
                                    self.availableBalance = eventPrefData.maxSprayAmount
                                    self.currentBalance.text = "$" + String(self.availableBalance)
                                    print("autoreplish = \(eventPrefData.isAutoReplenish)")
                                    if eventPrefData.isAutoReplenish == true {
                                        self.autoReplenishAmountSegControl.selectedSegmentIndex = self.getSegControlIndex(amount: eventPrefData.replenishAmount, category: "replenishamount" )
                                    }

                                    if self.autoReplenishSwitch.isOn == false {
                                        
                                        self.autoReplenishLbl.isHidden = true
                                        self.autoReplenishAmountSegControl.isHidden = true

                                    } else {
                                        self.autoReplenishLbl.isHidden = false
                                        self.autoReplenishAmountSegControl.isHidden = false
                                    }
                                    break
//                                }
//                                break
                                
                                //else if eventId <> eventId
//                                } else {
//                                    self.autoReplenishSwitch.isOn = false
//                                    self.autoReplenishLbl.isHidden = true
//                                    self.autoReplenishAmountSegControl.isHidden = true
//
//                                }
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
    
    func getLatestSprayAmount() {
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        //let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token)
        let request = Request(path: "/api/Event/prefs/\(profileId)/0", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                        for eventPrefData in eventPreferenceJson {
                            print("Event Id = \(eventPrefData.eventId)")
                            print("Incoming Event Id = \(String(describing: self.eventId))")
                            
                            
                            //if eventPrefData.eventId == self.eventId {
                            self.paymentMethodIdFromPreference = Int64(eventPrefData.paymentMethod)
                                //only use the payment for the event that you are on...
                                //if eventPrefData.paymentMethodDetails.paymentMethodId == eventPrefData.paymentMethod {
                                    self.isReadyToSavePayment = true
                                    print("eventPreferenceData.paymentMethod == paymenttypedata.paymentType! ")

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
                                    
                                    self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
                                    self.availableBalance = eventPrefData.maxSprayAmount - self.gifterTotalTransAmount
                                    self.currentBalance.text = "$" + String(self.availableBalance)
                                    print("autoreplish = \(eventPrefData.isAutoReplenish)")

                                    
                                    
                                    if self.autoReplenishSwitch.isOn == false {
                                        
                                        self.autoReplenishLbl.isHidden = true
                                        self.autoReplenishAmountSegControl.isHidden = true
                                    } else {
                                        self.autoReplenishLbl.isHidden = false
                                        self.autoReplenishAmountSegControl.isHidden = false

//                                        self.notificationAmountTextField.placeholder = "Enter Alert Amount"
                                    }
                                    break
//                                    break
//                                }
//
//
//                                break
                                
                            //else if eventId <> eventId
//                            } else {
//
//                            }
                        }
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
    
  
    func loadSprayAmountOptions() {
        //load data for spray amount segment control
        let data0 = AddSprayAmountOptions(id: 0, amount: 0, displayAmount: "Open")
        addSprayAmountOptions.append(data0)
        let data1 = AddSprayAmountOptions(id: 1, amount: 5, displayAmount: "$5")
        addSprayAmountOptions.append(data1)
        let data2 = AddSprayAmountOptions(id: 2, amount: 15, displayAmount: "$15")
        addSprayAmountOptions.append(data2)
        let data3 = AddSprayAmountOptions(id: 3, amount: 25, displayAmount: "$25")
        addSprayAmountOptions.append(data3)
        let data4 = AddSprayAmountOptions(id: 4, amount: 50, displayAmount: "$50")
        addSprayAmountOptions.append(data4)
        let data5 = AddSprayAmountOptions(id: 5, amount: 100, displayAmount: "$100")
        addSprayAmountOptions.append(data5)
        
        //load data for replenish amount segment control
       
        let data00 = AddSprayAmountOptions(id: 0, amount: 0, displayAmount: "$0")
        addSprayAmountOptionsAutoReplenish.append(data00)
        let data11 = AddSprayAmountOptions(id: 1, amount: 5, displayAmount: "$5")
        addSprayAmountOptionsAutoReplenish.append(data11)
        let data22 = AddSprayAmountOptions(id: 2, amount: 15, displayAmount: "$15")
        addSprayAmountOptionsAutoReplenish.append(data22)
        let data33 = AddSprayAmountOptions(id: 3, amount: 25, displayAmount: "$25")
        addSprayAmountOptionsAutoReplenish.append(data33)
        let data44 = AddSprayAmountOptions(id: 4, amount: 50, displayAmount: "$50")
        addSprayAmountOptionsAutoReplenish.append(data44)
        let data55 = AddSprayAmountOptions(id: 5, amount: 100, displayAmount: "$100")
        addSprayAmountOptionsAutoReplenish.append(data55)
        loadSegmentsTitle()
    }
    func loadSegmentsTitle() {
        //poplulate spray amount segment control
        for i in addSprayAmountOptions {
            if i.id == 0 {
                giftAmountSegConrol.setTitle(i.displayAmount, forSegmentAt: i.id )
            } else if i.id == 1 {
                giftAmountSegConrol.setTitle(i.displayAmount, forSegmentAt: i.id )
            } else {
                giftAmountSegConrol.insertSegment(withTitle: i.displayAmount, at: i.id, animated: true)
            }
        }
        
        //populate auto replenish seg control
        for i in addSprayAmountOptionsAutoReplenish {
            if i.id == 0 {
                autoReplenishAmountSegControl.setTitle(i.displayAmount, forSegmentAt: i.id )
            } else if i.id == 1 {
                autoReplenishAmountSegControl.setTitle(i.displayAmount, forSegmentAt: i.id )
            } else {
                autoReplenishAmountSegControl.insertSegment(withTitle: i.displayAmount, at: i.id, animated: true)
            }
        }
        
    }
    func getSprayAmountInt(amountId: Int, category: String) -> Int {
        var amountInt: Int = 0
        if category == "addgiftamount" {
            for i in addSprayAmountOptions {
                if i.id == amountId {
                    amountInt = i.amount
                    //return amountInt
                    break
                }
            }
        } else if category == "addreplenishamount" {
            for j in addSprayAmountOptionsAutoReplenish {
                if j.id == amountId {
                    amountInt = j.amount
                    //return amountInt
                    break
                }
            }
        }
        
        return amountInt

        
        
//        segcontrol.setTitle("$5", forSegmentAt: 1)
//        //segcontrol.setTitle("$10", forSegmentAt: 2)
//        segcontrol.insertSegment(withTitle: "$10", at: 2, animated: true)
//        segcontrol.insertSegment(withTitle: "$15", at: 3, animated: true)
//        segcontrol.insertSegment(withTitle: "$25", at: 4, animated: true)
//        segcontrol.insertSegment(withTitle: "$50", at: 5, animated: true)
//        segcontrol.insertSegment(withTitle: "$100", at: 6, animated: true)
    }
    
    //hold for now - may delete later 2/4
    @IBAction func amountSegControlPressed(_ sender: Any) {
        print(getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addgiftamount"))
        updatedBalance = availableBalance + getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addreplenishamount")
        currentBalance.text = "$" + String(updatedBalance)
    }
    
    @IBAction func replenishAmountSegControlPressed(_ sender: Any) {
        print(getSprayAmountInt(amountId: autoReplenishAmountSegControl.selectedSegmentIndex, category: "addreplenishamount"))
    }
    
    
    @IBAction func isAutoReplenishSwitchButton(_ sender: UISwitch) {
       
        if sender.isOn == false {
            autoReplenishLbl.isHidden = true
            autoReplenishAmountSegControl.isHidden = true
        } else  {
            autoReplenishLbl.isHidden = false
            autoReplenishAmountSegControl.isHidden = false
        }
    }
    
    func initiliazationTasks() {
        if autoReplenishSwitch.isOn == false {
            autoReplenishLbl.isHidden = true
            autoReplenishAmountSegControl.isHidden = true
        } else  {
            autoReplenishLbl.isHidden = false
            autoReplenishAmountSegControl.isHidden = false
        }
    }
    func customeFieldStyling() {
//        customtextfield.noBorderForTextField(textField: initialSprayAmountTextField, validationFlag: false)
//        customtextfield.noBorderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
//        customtextfield.noBorderForTextField(textField: alertAmountTextField, validationFlag: false)
    
    }
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        transparentView.frame = window?.frame ?? self.halfScreenPayment.frame
        self.halfScreenPayment.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height:0)
        self.halfScreenPayment.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        print("frames.origin.x = \(frames.origin.x) frames.origin.y = \(frames.origin.y) frames.height = \(frames.height) frames.width = \(frames.width)")
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
    
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { [self] in self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(availablePaymentData.count * 50))
            
        }, completion: nil)
    }
    
    @objc func removeTransparentView () {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y, width: frames.height + 5, height: 0)
            
        }, completion: nil)
    }
    
    @IBAction func selectPaymentBtnPressed(_ sender: Any) {
        //dataSource = ["Visa ..1234", "Mastcard...1234", "Amex...9987"]
        selectedButton = btnSelectPayment
        addTransparentView(frames: btnSelectPayment.frame)
    }
    
    @IBAction func selectPaymentBtnPressed2(_ sender: Any) {
        //dataSource = ["Visa ..1234", "Mastcard...1234", "Amex...9987"]
        selectedButton = self.btnSelectPayment
        addTransparentView(frames: self.btnSelectPayment.frame)
        
        
    }
    //check if name of paymentmethod exist
    func paymentmethodCustNameExist(customName: String) -> Bool {

        var hasCustomMethodName: Bool = false
        for i in availablePaymentData {
            if i.customName == customName {
                hasCustomMethodName = true
                break
            }
        }
        return  hasCustomMethodName
    }
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    //this is an old function remove later 3/31/2021
    func addMyPaymentOld(paymentMethodToken
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        
        let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: "08/17/2030", profileId: profileId)

        let request = PostRequest(path: "/api/PaymentMethod/add", model: addPayment , token: token, apiKey: encryptedAPIKey, deviceId: "")

        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func addMyPayment(paymentMethodToken
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        //if i want to add default payment method, use the paymentmethod Id from this call to setup AddPref...
        //paymentmethodtoken is from the stripe UI
        let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: "08/17/2030", profileId: profileId)
        
        print("paymentmethodToke = \(paymentMethodToken)")
        print("addPayment \(addPayment)")
        let request = PostRequest(path: "/api/PaymentMethod/add", model: addPayment , token: token, apiKey: encryptedAPIKey, deviceId: "")

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let newpaymentdata):
                let decoder = JSONDecoder()
                do {
                    let newPaymentJson: PaymentTypeData = try decoder.decode(PaymentTypeData.self, from: newpaymentdata)
                    newPaymentMethodAdded = true
                    print(" AIM INSIDE api/PaymentMethod/add closure")
                    print("new paymentId = \(newPaymentJson.paymentMethodId)")
                    paymentMethodId = newPaymentJson.paymentMethodId!
                    availablePaymentData.removeAll() //clear object
                    getAvailablePaymentData() //refresh paymentData
                    addGeneralPaymentPref(paymentMethodId: newPaymentJson.paymentMethodId!, paymentDescription: customName)
                    
                    haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(newPaymentJson.paymentMethodId!))
                    //for data in newPaymentJson {

                       
                    //}

               } catch {
                   print(error)
               }
                //newpayment.
                //break
                //this will return payment methodId...
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func addGeneralPaymentPref(paymentMethodId: Int64, paymentDescription: String) {
        
        //self.launchSprayCandidate()
        
        let updatedPaymentMethodId = paymentMethodId
        let updatedGiftAmount = 15
        let updatedAutoReplenishFlag = false
        let updatedAutoReplenishAmount: Int = 0
        let currencyCode = "usd"
        
        let addEventPreference = EventPreference(eventId: 0, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencyCode)
            
        //set.btnSelectPayment.setTitle(paymentDescription)
       
        
        print("ADD EVENT PREFERENCE \(addEventPreference)")
//        updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
        //closeScreen()
        
        //hold 2/13 - for now...
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref);
                
                print(" i am INSIDE GENERAL ADD PREFS")
                //updatedBalance = availableBalance + getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addreplenishamount")
                haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(updatedPaymentMethodId))
                giftAmountSegConrol.selectedSegmentIndex = 2
                //segmentedControl.selectedSegmentIndex = index
                availableBalance = updatedGiftAmount
                currentBalance.text = "$" + String(self.availableBalance)
                
                //currentBalance.text = "$" + String(updatedBalance)
                btnSelectPayment.setTitle(paymentDescription, for: .normal)
                
                paymentMethodIconName = getPaymentMethodIcon(name: paymentDescription)
                
                paymentMethodIcon.image = UIImage(named: paymentMethodIconName)
                
                //self.btnSelectPayment.setTitle(self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethodDetails.paymentMethodId), for: .normal)
                
                
                //self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish

               
                
                //call launch spray candidate - in the future i will add logic here to
                //only launch if not street performer, waiter, or band
//                if self.completionAction == "allreceiver" {
//
//                    self.giftBalanceLbl.text = String(updatedGiftAmount)
//                    self.sprayAmount = updatedGiftAmount
//                    self.receiverName = ""
//                    self.launchSprayCandidate()
//                } else {
//                    //change the name to the real person when you get it 2/27
//                    self.giftReceiverNameLbl.text = self.eventOwnerName
//                    print("updatedGiftAmount \(updatedGiftAmount)")
//                    self.giftBalanceLbl.text = String(updatedGiftAmount)
//                    self.sprayAmount = updatedGiftAmount
//                    self.receiverName = self.eventOwnerName
//                    //self.launchSprayCandidate()
//                }
                //hold for no2 3/27
                //self.callGoSpray()
                
                break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
//        addMyPayment(paymentMethodToken: paymentMethod.stripeId, customName: paymentMethod.label, paymentOptionType: 0, paymentDescription: paymentMethod.image.description, paymentExpiration: "08/17/2030")
//
        print("label \(paymentMethod.label)")
        print("stripe Id \(paymentMethod.stripeId)")
        print("image \(paymentMethod.image)")
        
        
        
        if paymentmethodCustNameExist(customName: paymentMethod.label) == false {
            addMyPayment(paymentMethodToken: paymentClientToken, customName: paymentMethod.label, paymentOptionType: 0, paymentDescription: paymentMethod.image.description, paymentExpiration: "08/17/2030")
            
            print("customName Payment name does not exist... going to add it")
            //haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true)
            
        } else {
            //self.completionAlert(message: "Payment Method \(paymentMethod.label) Already Exist.  Available Credit and Continue.", timer: 3, completionAction: "completionAction")
            let paymentMethodId =  getPaymenthMethodId(customName: paymentMethod.label)
            let paymentDescription = paymentMethod.label
            
            self.addGeneralPaymentPref(paymentMethodId:paymentMethodId, paymentDescription: paymentDescription)
            
            print("DUPLICATE PAYMENT METHOD")
            //giftAmountSegConrol.selectedSegmentIndex = 2
            //segmentedControl.selectedSegmentIndex = index
            availableBalance = 15
            currentBalance.text = "$" + String(self.availableBalance)
            
            closeScreen()
            //currentBalance.text = "$" + String(updatedBalance)
            //btnSelectPayment.setTitle(paymentMethod.label, for: .normal)
           
        }
        
        
        
//        print("label \(paymentMethod.label)")
//        print("stripe Id \(paymentMethod.stripeId)")
//        print("image \(paymentMethod.image)")
    }
    
    
    func completionAlert(message: String, timer: Int, completionAction:String) -> Void {
        let delay = Double(timer) //* Double(NSEC_PER_SEC)
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            alert.dismiss(animated: true)
//            if completionAction == "gospray" {
//                self.callGoSpray()
//            }
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

extension EventPayment2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePaymentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
       
        cell.textLabel?.text = availablePaymentData[indexPath.row].customName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedButton.setTitle(availablePaymentData[indexPath.row].customName, for: .normal)
        
        let paymentId = availablePaymentData[indexPath.row].paymentMethodId
        selectedButton.setTitle(getPaymenthMethodName(paymentmethodid: Int(paymentId!)), for: .normal)
        
        
        //paymentMethodIconName =
        paymentMethodIconName = getPaymentMethodIcon(name: getPaymenthMethodName(paymentmethodid: Int(paymentId!)))
        
        print("paymentMethodIconName \(paymentMethodIconName)")
        paymentMethodIcon.image = UIImage(named: paymentMethodIconName)
        
        removeTransparentView()
    }
}
