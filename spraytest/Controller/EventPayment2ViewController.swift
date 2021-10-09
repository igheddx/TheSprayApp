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
    var countryData = CountryData()
    
    var profileId: Int64 = 0
    var eventId: Int64 = 0
    var token: String = ""
    var paymentClientToken: String = ""
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventOwnerName: String = ""
    var eventOwnerId: Int64 = 0
    var eventTypeIcon: String = ""
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
    
    var refreshscreendelegate: RefreshScreenDelegate?
    var setuppaymentmethoddelegate: SetupPaymentMethodDelegate?
    //var haspaymentdelegate: HasPaymentMethodDelegate?
    
    //var currencycode: String = "usd" /*this is no longer used.. delete later*/
    var newPaymentMethodAdded: Bool = false
    var paymentMethodIconName: String = ""
    var encryptedAPIKey: String = ""
    var receiverName: String = ""
    var isPaymentMethodAvailable: Bool = false
    var isPaymentMethodAvailable2: Bool = false /*used to set the the payment method button default value Select Payment or Add Payment*/
    var isSingleReceiverEvent: Bool = false
    var setRefreshScreen: Bool = false
    var paymentMethod: Int = 0
    var isRefreshScreen: Bool = false
    var currencyCode: String = ""
    var currencycode: String = ""
    var currencySymbol: String = ""
    var eventDefaultCurrencyCode: String = ""
    var country: String = ""
    var isCurrencyMisalignedWithEvent: Bool = false
    var source: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*initialize*/
        paymentMethodIcon.image = UIImage(named: "paymentInfoIcon")
        
        /*use event country to identify the default currency*/
        print("COUNTRY IN VIEWDID LOAD \(country)")
        eventDefaultCurrencyCode = countryData.getCurrencyCodeWithCountryName(country: country)
        
        print("EVENT DEAFULT CURRENCY CODE VIEWDID LOAD \(eventDefaultCurrencyCode)")
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
        
        print("ViewDidLoad EventPayment2VC = isRefreshScreen = \(isRefreshScreen )")
        if isRefreshScreen == false {
            print("VIEWDID LOAD REFRESH - called")
            initiliazationTasks()
            customeFieldStyling()
            
            DispatchQueue.global(qos: .background).async {
                self.getAvailablePaymentData() // self.getEventPref() is called withing getAvailablePaymentData
                self.getGifterTotalTransBalance()
            }

        } else  {
            print("no VIEWDID LOAD REFRESH - SECOND TIME WAS REFRESHED FROM SETUPAYMENT")
        }
       
        
       
        //eventNameLabel.text = eventName + "\n \(eventDateTime)"
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidApp EventPayment2VC = isRefreshScreen = \(isRefreshScreen )")
        if isRefreshScreen == true {
            print("I WAS REFRESHED FROM SETUPAYMENT")
            initiliazationTasks()
            
    
            DispatchQueue.global(qos: .background).async {
                self.getAvailablePaymentData() // self.getEventPref() is called withing getAvailablePaymentData
                self.getGifterTotalTransBalance()
            }

        } else {
            print("viewDidAppear I WAS nOT REFRESHED FROM SETUPAYMENT")
        }
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
        refreshscreendelegate?.refreshScreen(isRefreshScreen:isRefreshScreen)
        setuppaymentmethoddelegate?.passData(eventId: eventId, profileId: profileId, token: token, ApiKey: encryptedAPIKey,  eventName: eventName, eventDateTime: eventName, eventTypeIcon: eventTypeIcon, paymentClientToken: paymentClientToken, isSingleReceiverEvent: isSingleReceiverEvent, eventOwnerName: eventOwnerName, eventOwnerId: eventOwnerId, source: source)
        haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(newPaymentMethodId))
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
        //launchStripePaymentScreen()
        launchSetUpPaymentMethod()
    }
    @IBAction func saveEventPayment(_ sender: Any) {
        print(getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addgiftamount"))
        
        print(getSprayAmountInt(amountId: autoReplenishAmountSegControl.selectedSegmentIndex, category: "addreplenishamount"))
        print(autoReplenishSwitch.isOn)
        print("Selected button title \(btnSelectPayment.currentTitle!)")
        
        print("paymentmethodId = \(getPaymenthMethodId(customName: btnSelectPayment.currentTitle!))")
        print("seg val \(autoReplenishAmountSegControl.selectedSegmentIndex)")
        if btnSelectPayment.currentTitle! == "Select Payment" {
            // create the alert
            let alert = UIAlertController(title: "Select Payment Method", message: "Please select a Payment Method from the list to continue.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else if autoReplenishSwitch.isOn == true && autoReplenishAmountSegControl.selectedSegmentIndex < 0 {
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
            } else {
                
                print("newPaymentMethodAdded == false ")
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
            
            let addEventPreference = EventPreference(eventId: 0, profileId: profileId, paymentMethod: Int(paymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencyCode)

            print("ADD EVENT PREFERENCE \(addEventPreference)")
        
            updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
            
            let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
            Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
                switch result {
                case .success(let eventpref): print(eventpref);
                    isRefreshScreen = true
                    haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(paymentMethodId))
                    self.completionAlert(message: "Update Was Successful", timer: 1)
                    //close payment window
                    
                    break
                case .failure(let error):
                print(error.localizedDescription)
                }
            }
            
            
            //need to update 
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
    
    //get paymentmethodCurrency
    func getPaymentMethodCurrency(paymentMethodId: Int64) -> String {
        var thePaymentMethodCurrency: String = ""
        if paymentMethodId > 0 {
            for i in availablePaymentData {
                if i.paymentMethodId == paymentMethodId {
                    if let currency = i.currency {
                        thePaymentMethodCurrency = currency
                    } else  {
                        //let locale = Locale.current /*get default country code*/
                        //currencyCode = eventDefaultCurrencyCode //countryData.getCurrencyCode(regionCode: locale.regionCode!)
                        thePaymentMethodCurrency = "none" //eventDefaultCurrencyCode //currencyCode
                    }
                    
                    break
                }
            }
            return thePaymentMethodCurrency
        } else {
           // let locale = Locale.current /*get default country code*/
            currencyCode = eventDefaultCurrencyCode //countryData.getCurrencyCode(regionCode: locale.regionCode!)
            
            thePaymentMethodCurrency = "none" //currencyCode
            return thePaymentMethodCurrency
        }
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
    
    func launchSetUpPaymentMethod() {
      
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "SetupPaymentMethodViewController") as! SetupPaymentMethodViewController

       

        nextVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        nextVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext
    

        nextVC.eventId = self.eventId
        nextVC.profileId = self.profileId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventTypeIcon = eventTypeIcon
        nextVC.eventOwnerName = eventOwnerName
        nextVC.eventOwnerId =  eventOwnerId
//        nextVC.autoReplenishFlg = autoReplenishFlg
//        nextVC.autoReplenishAmt = autoReplenishAmt
        
        nextVC.refreshscreendelegate = self
        nextVC.haspaymentdelegate = self
        //nextVC.refreshscreendelegate = self
        nextVC.setuppaymentmethoddelegate = self
//        
        nextVC.paymentClientToken = paymentClientToken
        nextVC.currentAvailableCredit =  availableBalance
        nextVC.country = country
        self.present(nextVC, animated: true, completion: nil)
        
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetupPaymentMethodViewController") as! SetupPaymentMethodViewController
      
            
       // self.navigationController?.pushViewController(nextVC , animated: true)
        //}
    }
    
    func getAvailablePaymentData() {
        print("I am inside getavailablePaument222")
        let request = Request(path: "/api/PaymentMethod/all/\(profileId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
           case .success(let paymentmethod1):
            print("I am inside getavailablePaument = \(paymentmethod1.count)")
               //self.parse(json: event)
             let decoder = JSONDecoder()
             do {
                let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                
                if paymentJson.count == 0 {
                    if eventDefaultCurrencyCode == currencyCode {
                        //isCurrencyMisalignedWithEvent = false
                        currencySymbol = Currency.shared.findSymbol(currencyCode: currencyCode)
                        print("DEFAULT PAYMENT IS TRUE AWELE I - \(currencyCode)")
                       
                        print("currencySymbol 1 = \(currencySymbol)")
                        //getCurrencyData2(currencyCode: currencyCode)
                        loadSprayAmountOptions(currencyCode: currencyCode)
                        
                        self.btnSelectPayment.setTitle("Add Payment Method", for: .normal)
                    } else {
                        print("EVENT CURRENCY CODE 1 = \(eventDefaultCurrencyCode)")
                        currencySymbol = Currency.shared.findSymbol(currencyCode: eventDefaultCurrencyCode)
                        print("DEFAULT PAYMENT IS TRUE AWELE U - \(eventDefaultCurrencyCode)")
                       
                        print("currencySymbol 2 = \(currencySymbol)")
                        //getCurrencyData2(currencyCode: currencyCode)
                        loadSprayAmountOptions(currencyCode: eventDefaultCurrencyCode)
                    }
                } else {
                    print("RECORD COUNT = \(paymentJson.count)")
                    isPaymentMethodAvailable2 = true
                    for paymenttypedata in paymentJson {
                        if paymenttypedata.customName != "" {
                            /*assign currency, */
                            if let currency = paymenttypedata.currency {
                                currencyCode = currency
                                print("my currencode 1 = \(currencyCode)")
                            } else {
                                let locale = Locale.current /*get default country code*/
                                currencyCode = countryData.getCurrencyCode(regionCode: locale.regionCode!)
                                
                                print("my currencode 2 = \(currencyCode)")
                            }
                            if paymenttypedata.defaultPaymentMethod == true {
                                /*check if currency is nill if so use the default country name to identify the currency*/
                                print("DEFAULT PAYMENT NAME = \(paymenttypedata.customName)")
                                print("DEFAULT PAYMENT NAME = \(paymenttypedata.currency)")
                                print("DEFAULT PAYMENT NAME = \(paymenttypedata.paymentMethodId)")
                                
                               
                                //currencyCode = paymenttypedata.currency!
                                print("EVENT CURRENCY CODE 0 = \(eventDefaultCurrencyCode)")
                                if eventDefaultCurrencyCode == currencyCode {
                                    //isCurrencyMisalignedWithEvent = false
                                    currencySymbol = Currency.shared.findSymbol(currencyCode: currencyCode)
                                    print("DEFAULT PAYMENT IS TRUE AWELE I - \(currencyCode)")
                                   
                                    print("currencySymbol 1 = \(currencySymbol)")
                                    //getCurrencyData2(currencyCode: currencyCode)
                                    loadSprayAmountOptions(currencyCode: currencyCode)
                                    
                                    
    //                                currencySymbol = Currency.shared.findSymbol(currencyCode: currencyCode)
    //                                print("DEFAULT PAYMENT IS TRUE AWELE - \(currencyCode)")
    //                                country = countryData.getCurrencyCode(regionCode: currencyCode)
    //                                getCurrencyData2(currencyCode: currencyCode)
                                } else {
                                    
                                    print("EVENT CURRENCY CODE 1 = \(eventDefaultCurrencyCode)")
                                    currencySymbol = Currency.shared.findSymbol(currencyCode: eventDefaultCurrencyCode)
                                    print("DEFAULT PAYMENT IS TRUE AWELE U - \(eventDefaultCurrencyCode)")
                                   
                                    print("currencySymbol 2 = \(currencySymbol)")
                                    //getCurrencyData2(currencyCode: currencyCode)
                                    loadSprayAmountOptions(currencyCode: eventDefaultCurrencyCode)
                                    
                                    
    //                                getCurrencyData2(currencyCode: eventDefaultCurrencyCode)
    //                                currencySymbol = Currency.shared.findSymbol(currencyCode: eventDefaultCurrencyCode)
    //                                country = countryData.getCountryNameWithCurrencyCode(currencyCode: eventDefaultCurrencyCode)
    //                                print("MY COUNTRY FROM GOTOSPRAY = \(country)")
    //                                displayPaymentMethodMismatchAlert()
                                   // isCurrencyMisalignedWithEvent = true
                                    /*send alert that payment could not be used and redirect users to would you like to add new payment method*/
                                }
                                
                                
                               
                            }
                            /*only add payment menthod that matches event  currency*/
                            if eventDefaultCurrencyCode == currencyCode {
                                let adddata = PaymentTypeData2(paymentMethodId: paymenttypedata.paymentMethodId!,
                                   profileId: paymenttypedata.profileId,
                                   paymentType: paymenttypedata.paymentType,
                                   customName: paymenttypedata.customName,
                                   paymentDescription: paymenttypedata.paymentDescription,
                                   paymentExpiration: paymenttypedata.paymentExpiration,
                                   defaultPaymentMethod: paymenttypedata.defaultPaymentMethod, currency: paymenttypedata.currency,
                                   paymentImage: paymenttypedata.paymentDescription)
                                self.availablePaymentData.append(adddata)
                            }
                           
                            
    //                        let adddata = PaymentTypeData2(paymentMethodId: paymenttypedata.paymentMethodId!,
    //                                                       profileId: paymenttypedata.profileId,
    //                                                       paymentType: paymenttypedata.paymentType,
    //                                                       customName: paymenttypedata.customName,
    //                                                       paymentDescription: paymenttypedata.paymentDescription,
    //                                                       paymentExpiration: paymenttypedata.paymentExpiration,
    //                                                       defaultPaymentMethod: paymenttypedata.defaultPaymentMethod,
    //                                                       currency: paymenttypedata.currency,
    //                                                       paymentImage: paymenttypedata.paymentDescription)
    //                        self.availablePaymentData.append(adddata)
                            
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
                        if isCurrencyMisalignedWithEvent == false {
                            self.gifterTotalTransAmount =  gifterBalanceJson.totalAmountAllTransactions
                        } else {
                            self.gifterTotalTransAmount =  0 //default value when payment method currency and event country does not match
                        }
                        
                        print("self.gifterTotalTransAmount = \(gifterBalanceJson.totalAmountAllTransactions)")
                    }
                   //}
                      
               } catch {
                   print(error)
               }
                //self.getEventPref2(paymenttypeData: paymentmethod1)
                self.gifterTotalTransAmountLbl.text = currencySymbol + String(self.gifterTotalTransAmount)
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }

    }
    
    func getEventPref() {
        
        //get the total amount that the gifter has given
        //for this event
        getGifterTotalTransBalance()
        
        print("getEventPref was called")
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        //let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token)
        let request = Request(path: "/api/Event/prefs/\(profileId)/0", token: token, apiKey: encryptedAPIKey)
        print("getEventPref \(request)")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    print("getEventPref success 1")
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                        if eventPreferenceJson.count == 0 {
                            print("getEventPref record count = 0")
                            self.availableBalance = 0
                            self.currentBalance.text = currencySymbol + String(self.availableBalance)
                            self.autoReplenishLbl.isHidden = true
                            self.autoReplenishAmountSegControl.isHidden = true
                            
                            print("I didn't land 1 \( isPaymentMethodAvailable2)")
                            if isPaymentMethodAvailable2 == false  {
                                self.btnSelectPayment.setTitle("Add Payment Method", for: .normal)
                            } else {
                                self.btnSelectPayment.setTitle("Select Payment", for: .normal)
                            }
                            
                            print("1 count = 0 availableBalance = \(self.availableBalance)")
                            break
                        } else {
                            print("getEventPref record count > 0")
                            /*payment method does not align with event currencycode - reset everything*/
                            if  isCurrencyMisalignedWithEvent == true {
                                self.availableBalance = 0
                                self.currentBalance.text = currencySymbol + String(self.availableBalance)
                                self.autoReplenishSwitch.isOn = false
                                self.autoReplenishLbl.isHidden = true
                                self.autoReplenishAmountSegControl.isHidden = true
                                
                                print("I didn't land 1 \( isPaymentMethodAvailable2)")
                                if isPaymentMethodAvailable2 == false  {
                                    self.btnSelectPayment.setTitle("Add Payment Method", for: .normal)
                                } else {
                                    self.btnSelectPayment.setTitle("Select Payment", for: .normal)
                                }
                                
                                print("2 count = 0 availableBalance = \(self.availableBalance)")
                                break
                            } else {
                                print("getEventPref record count = 0")
                                for eventPrefData in eventPreferenceJson {
                                    print("Event Id = \(eventPrefData.eventId)")
                                    print("Incoming Event Id = \(String(describing: self.eventId))")
                                    
                                    currencycode = getPaymentMethodCurrency(paymentMethodId: Int64(eventPrefData.paymentMethod))
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
             
                                    if eventDefaultCurrencyCode == currencycode {
                                        self.btnSelectPayment.setTitle(self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethod), for: .normal)
                                        
                                        self.btnSelectPayment.tag = eventPrefData.paymentMethod
                                        print("self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethodDetails.paymentMethodId) \(self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethod))")
                                        paymentMethodIconName = getPaymentMethodIcon(name: getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethod))
                                        
                                        
                                        //paymentMethodIcon.image = UIImage(named: paymentMethodIconName)
                                        //paymentMethodIcon.image = UIImage(named: "paymentInfoIcon")
                                        self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
                                    
                                        //self.availableBalance = eventPrefData.maxSprayAmount - self.gifterTotalTransAmount
                                        self.availableBalance = eventPrefData.maxSprayAmount
                                        
                                                                                print("availableBalance = \(self.availableBalance)")
                                        self.currentBalance.text = currencySymbol + String(self.availableBalance)
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
                                    } else {
                                        print("I didn't land 1")
                                        //self.btnSelectPayment.setTitle("Select Payment", for: .normal)
                                        print("I didn't land 1 \( isPaymentMethodAvailable2)")
                                        if isPaymentMethodAvailable2 == false  {
                                            self.btnSelectPayment.setTitle("Add Payment Method", for: .normal)
                                        } else {
                                            self.btnSelectPayment.setTitle("Select Payment", for: .normal)
                                        }
                                        
                                        self.autoReplenishSwitch.isOn = false

                                        self.availableBalance = 0
                                        self.currentBalance.text = currencySymbol  + String(self.availableBalance)
                                        
                                        self.autoReplenishLbl.isHidden = true
                                        self.autoReplenishAmountSegControl.isHidden = true
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
                                }
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
        Network.shared.send(request) { [self] (result: Result<Data, Error>)   in
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
                                    self.currentBalance.text = currencySymbol + String(self.availableBalance)
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
    
    func loadSprayAmountOptions(currencyCode: String) {
        print("NAYLA NOAH IGHEDOA - \(currencyCode)")
        addSprayAmountOptionsAutoReplenish.removeAll()
        addSprayAmountOptions.removeAll() /*cleanup*/
        switch currencyCode {
        case "usd":
            //load data for spray amount segment control
            let data0 = AddSprayAmountOptions(id: 0, amount: 0, displayAmount: currencySymbol + "0")
            addSprayAmountOptions.append(data0)
            let data1 = AddSprayAmountOptions(id: 1, amount: 10, displayAmount: currencySymbol + "10")
            addSprayAmountOptions.append(data1)
            let data2 = AddSprayAmountOptions(id: 2, amount: 15, displayAmount: currencySymbol + "15")
            addSprayAmountOptions.append(data2)
            let data3 = AddSprayAmountOptions(id: 3, amount: 25, displayAmount: currencySymbol + "25")
            addSprayAmountOptions.append(data3)
            let data4 = AddSprayAmountOptions(id: 4, amount: 50, displayAmount: currencySymbol + "50")
            addSprayAmountOptions.append(data4)
            let data5 = AddSprayAmountOptions(id: 5, amount: 100, displayAmount: currencySymbol + "100")
            addSprayAmountOptions.append(data5)
            
            //load data for replenish amount segment control
           
            let data00 = AddSprayAmountOptions(id: 0, amount: 0, displayAmount: currencySymbol +  "0")
            addSprayAmountOptionsAutoReplenish.append(data00)
            let data11 = AddSprayAmountOptions(id: 1, amount: 10, displayAmount: currencySymbol + "10")
            addSprayAmountOptionsAutoReplenish.append(data11)
            let data22 = AddSprayAmountOptions(id: 2, amount: 15, displayAmount: currencySymbol + "15")
            addSprayAmountOptionsAutoReplenish.append(data22)
            let data33 = AddSprayAmountOptions(id: 3, amount: 25, displayAmount: currencySymbol + "25")
            addSprayAmountOptionsAutoReplenish.append(data33)
            let data44 = AddSprayAmountOptions(id: 4, amount: 50, displayAmount: currencySymbol + "50")
            addSprayAmountOptionsAutoReplenish.append(data44)
            let data55 = AddSprayAmountOptions(id: 5, amount: 100, displayAmount: currencySymbol + "100")
            addSprayAmountOptionsAutoReplenish.append(data55)
            loadSegmentsTitle()
        case "ngn":
            print("NAYLA IGHEDOA - \(currencyCode)")
            //load data for spray amount segment control
            let data0 = AddSprayAmountOptions(id: 0, amount: 0, displayAmount: currencySymbol +  "0")
            addSprayAmountOptions.append(data0)
            let data1 = AddSprayAmountOptions(id: 1, amount: 500, displayAmount: currencySymbol + "500")
            addSprayAmountOptions.append(data1)
            let data2 = AddSprayAmountOptions(id: 2, amount: 1000, displayAmount: currencySymbol + "1000")
            addSprayAmountOptions.append(data2)
            let data3 = AddSprayAmountOptions(id: 3, amount: 1500, displayAmount: currencySymbol +  "1500")
            addSprayAmountOptions.append(data3)
            let data4 = AddSprayAmountOptions(id: 4, amount: 2000, displayAmount: currencySymbol +  "2000")
            addSprayAmountOptions.append(data4)
            //let data5 = AddSprayAmountOptions(id: 5, amount: 100, displayAmount: "100")
            //addSprayAmountOptions.append(data5)
            
            //load data for replenish amount segment control
           
            let data00 = AddSprayAmountOptions(id: 0, amount: 0, displayAmount: currencySymbol + "0")
            addSprayAmountOptionsAutoReplenish.append(data00)
            let data11 = AddSprayAmountOptions(id: 1, amount: 500, displayAmount: currencySymbol + "500")
            addSprayAmountOptionsAutoReplenish.append(data11)
            let data22 = AddSprayAmountOptions(id: 2, amount: 1000, displayAmount: currencySymbol + "1000")
            addSprayAmountOptionsAutoReplenish.append(data22)
            let data33 = AddSprayAmountOptions(id: 3, amount: 1500, displayAmount: currencySymbol + "1500")
            addSprayAmountOptionsAutoReplenish.append(data33)
            let data44 = AddSprayAmountOptions(id: 4, amount: 2000, displayAmount: currencySymbol + "2000")
            addSprayAmountOptionsAutoReplenish.append(data44)
            //let data55 = AddSprayAmountOptions(id: 5, amount: 100, displayAmount: "100")
            //addSprayAmountOptionsAutoReplenish.append(data55)
            loadSegmentsTitle()
        default:
            break
        }
        
       
    }
    
    /* remove later
     func loadSprayAmountOptions(currencyCode: String) {
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
    } */
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
        currentBalance.text = currencySymbol + String(updatedBalance)
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
       
        /*add code to update prefe with new payment method selected  -
         currency doesn't match then show alert.call refresh getAvailablePayment*/
       
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
    /*func addMyPaymentOld(paymentMethodToken
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
    }*/
    
    
    func addMyPayment(paymentMethodToken
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String, currencyCode: String) {
        //if i want to add default payment method, use the paymentmethod Id from this call to setup AddPref...
        //paymentmethodtoken is from the stripe UI
        let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: "08/17/2030", currency: currencyCode, profileId: profileId)
        
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
                    addGeneralPaymentPref(paymentMethodId: newPaymentJson.paymentMethodId!, paymentDescription: customName, currencyCode: newPaymentJson.currency!)
                    
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
    
    
    
    func addGeneralPaymentPref(paymentMethodId: Int64, paymentDescription: String, currencyCode: String) {
        
        //self.launchSprayCandidate()
        
        let updatedPaymentMethodId = paymentMethodId
        let updatedGiftAmount = 15 //7/28 this will be based on currency code
        let updatedAutoReplenishFlag = false
        let updatedAutoReplenishAmount: Int = 0
        let currencyCode = currencyCode //"usd"
        
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
                currentBalance.text = currencySymbol + String(self.availableBalance)
                
                //currentBalance.text = "$" + String(updatedBalance)
                btnSelectPayment.setTitle(paymentDescription, for: .normal)
               // btnSelectPayment.tag =  eventpref.paym
                paymentMethodIconName = getPaymentMethodIcon(name: paymentDescription)
                
                //paymentMethodIcon.image = UIImage(named: "paymentInfoIcon")
                
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
        
        
        
        /*if paymentmethodCustNameExist(customName: paymentMethod.label) == false {
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
           
        } */
        
        
        
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
        paymentMethodIcon.image = UIImage(named: "paymentInfoIcon")
        
        print("BTN Payment Pressed - Dominic \(availablePaymentData[indexPath.row].paymentMethodId!)")
        let paymentMethodCurrency = getPaymentMethodCurrency(paymentMethodId: availablePaymentData[indexPath.row].paymentMethodId!)
        if paymentMethodCurrency  == "none" {
            print("no currenc ")
            let alert = UIAlertController(title: "Currency Mismatch", message: "The currency of the Payment Method you selected does not match the currency of Country where this event is being held. Please add or select a new Payment Method.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else  {
            if paymentMethodCurrency  == eventDefaultCurrencyCode {
                print("currency code matche")
            } else {
                print("currency does not match")
            }
            
        }
        print("paymentMethodCurrency =  \(paymentMethodCurrency)")
        
        removeTransparentView()
    }
}

extension EventPayment2ViewController:  RefreshScreenDelegate {
    func refreshScreen(isRefreshScreen: Bool) {
       
        print("DID SOMEONE CALLED 2")
        print("DID SOMEONE CALLED 2 =\(isRefreshScreen)")
        self.setRefreshScreen = isRefreshScreen
        self.isRefreshScreen = isRefreshScreen
        print("refreshData Blabablabalba  function was called = \(self.setRefreshScreen)")
        print(self.setRefreshScreen)
        //print("refreshHomeScreenDate = \(isShowScreen)")
        if self.setRefreshScreen == true {
            
            completionAction = "" //this is to avoid the need payment method prompt 7/6 may not need this, but hold on for now
            
            //getGifterTotalTransBalance()
            //initializationTask()
            
            initiliazationTasks()
            
            getAvailablePaymentData()
            getGifterTotalTransBalance()
            
            print("I REFERESHED THE SCREEN")
            //customeFieldStyling()
//            getAvailablePaymentData()
//            //eventNameLabel.text = eventName + "\n \(eventDateTime)"
//            //loadSprayAmountOptions()
//            // Do any additional setup after loading the view.
//            getEventPref()
//            updateEventInfo()
        }
    }


}

extension EventPayment2ViewController:  SetupPaymentMethodDelegate {
    func passData(eventId: Int64, profileId: Int64, token: String, ApiKey: String, eventName: String, eventDateTime: String, eventTypeIcon: String, paymentClientToken: String, isSingleReceiverEvent: Bool, eventOwnerName: String, eventOwnerId: Int64, source: String) {
        self.eventId = eventId
        self.profileId = profileId
        self.eventName = eventName
        //self.eventDateTime = eventDateTime
        //self.eventTypeIcon = eventTypeIcon
        self.paymentClientToken = paymentClientToken
        self.isSingleReceiverEvent = isSingleReceiverEvent
    
        print("DID SOMEONE CALLED 1")
        //7/7 comment this out for now - may revisit
//        if self.isSingleReceiverEvent == false {
//            launchSprayCandidate()
//            circleMenu()
//        } else {
//            giftReceiverNameLbl.text = eventOwnerName
//
//            giftAmountReceived = 0
//            giftReceiverId = eventOwnerId
//            //self.displayNamelbl?.text = "Now Spraying, " + receivername
//            //self.sprayTotalLblAmt?.text = " -- $0.00"
//            receiverName =  eventOwnerName
//            giftAmountReceivedLbl.text = "$" + String(giftAmountReceived)
//
//        }
//        print("I am inside SetupPaymentMethodDelegate")
//
//        print("view did appear isRefreshScreen = \(setRefreshScreen)")
//        //I called viewDidAppear
        
    }
    

}


extension EventPayment2ViewController:  HasPaymentMethodDelegate {
    func hasPaymentMethod(hasPaymentMethod: Bool, paymentMethodId: Int) {
        
        print("DID SOMEONE CALLED 3")
        print("DID SOMEONE CALLED 3 =\(paymentMethodId)")
        
        isPaymentMethodAvailable = hasPaymentMethod
        print("HasPaymentMethodDelegate was called isPaymentMethodAvailable = \(isPaymentMethodAvailable)")
        if paymentMethodId > 0 {
            paymentMethod = paymentMethodId
        }
    }
}
