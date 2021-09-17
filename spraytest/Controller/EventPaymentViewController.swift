//
//  EventPaymentViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/23/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import Stripe

class CellClass: UITableViewCell {
    
}
class EventPaymentViewController: UIViewController, STPAddCardViewControllerDelegate, STPAuthenticationContext {
    
    lazy var cardTextField: STPPaymentCardTextField = {
            let cardTextField = STPPaymentCardTextField()
            return cardTextField
        }()
    @IBOutlet weak var fullScreenPaymentUIView: UIView!
    @IBOutlet weak var btnSelectPayment: UIButton!
    @IBOutlet weak var initialSprayAmountTextField: UITextField!
    @IBOutlet weak var autoReplenishAmountTextField: UITextField!
    @IBOutlet weak var alertAmountTextField: UITextField!
    @IBOutlet weak var autoReplenishSwitch: UISwitch!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var paymentMethodIcon: UIImageView!
    //    @IBOutlet weak var paymentMethodIcon: UIButton!
    
    @IBOutlet weak var autoReplenishLbl: UILabel!
 
    @IBOutlet weak var giftAmountSegConrol: UISegmentedControl!
    
    @IBOutlet weak var autoReplenishAmountSegControl: UISegmentedControl!
    @IBOutlet weak var currentBalance: UILabel!
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateTimeLbl: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    var customtextfield = CustomTextField()
    var availablePaymentData = [PaymentTypeData2]()
    

    var addSprayAmountOptions = [AddSprayAmountOptions]()
    var addSprayAmountOptionsAutoReplenish = [AddSprayAmountOptions]()
    
    var profileId: Int64 = 0
    var eventId: Int64 = 0
    var token: String = ""
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventTypeIcon: String = ""
    var paymentClientToken: String = ""
    var availableBalance: Int = 0
    var updatedBalance: Int = 0
    var completionAction: String = ""
    var currencycode: String = ""
    var alert: UIAlertController!
    var isPaymentMethodAvailable: Bool = false
    
    var isSingleReceiverEvent: Bool = false //2/13 this flag will be used to check if event is for band/street performer/waiter if sothe flag will == true
    var hasPaymentMethodEvent: Bool = false //hold for now 3/18
    var isRsvprequired: Bool = false
    //var isSingleReceiver: Bool = false
    var defaultEventPaymentMethod: Int = 0
    var defaultEventPaymentCustomName: String = ""
    var refreshscreendelegate: RefreshScreenDelegate?
    var isRefreshScreen: Bool = false
    var isRefreshScreen2: Bool = false
    var paymentMethodIconName: String = ""
    var autoReplenishFlg: Bool = false
    var autoReplenishAmt: Int = 0
    var encryptedAPIKey: String = ""
    var currencySymbol: String = ""
    var currencyCode: String = ""
    var countryData = CountryData()
    var eventDefaultCurrencyCode: String = ""
    var country: String = ""
    var isPaymentMethodAvailable2: Bool = false /*used to set the the payment method button default value Select Payment or Add Payment*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
               let lock = DispatchSemaphore(value: 0)
               // Load any saved meals, otherwise load sample data.
//               self.loadDbMeals(completion: {
//                   lock.signal()
//               })
               lock.wait()
               // finished fetching data
           }
        /*initialize*/
        paymentMethodIcon.image = UIImage(named: "paymentInfoIcon")
        
        /*use event country to identify the default currency*/
        print("COUNTRY IN VIEWDID LOAD \(country)")
        eventDefaultCurrencyCode = countryData.getCurrencyCodeWithCountryName(country: country)
        
        print("EVENT DEAFULT CURRENCY CODE VIEWDID LOAD \(eventDefaultCurrencyCode)")
        
        print("paymentClientToken = \(paymentClientToken)")
        //btnSelectPayment.semanticContentAttribute = .forceLeftToRight
//        self.btnSelectPayment.setImage(UIImage(named: "visaicon"), for: UIControl.State.normal)
//        //self.btnSelectPayment.setImage(UIImage(named: "visaicon"), for: UIControl.State.normal)
//        self.btnSelectPayment.semanticContentAttribute = .forceRightToLeft
//        self.btnSelectPayment.contentHorizontalAlignment = .left // UIControlContentHorizontalAlignmentLeft
//
//        self.btnSelectPayment.imageEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 10)
//
   
        
        
        
        print("Event Payment my completion \(completionAction)")
        //use to keep keyboard down
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        self.navigationItem.title = "Update Payment Method..."
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        //

        DispatchQueue.global(qos: .background).async {
            self.getAvailablePaymentData() // self.getEventPref() is called withing getAvailablePaymentData
        }
        self.updateEventInfo()
        print("view did load isRefreshScreen = \(isRefreshScreen)")
    }
    
    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)

           // When you want to send data back to the caller
           // call the method on the delegate
            print("View will disappear")
//           if let refreshscreendelegate = refreshscreendelegate {
//            refreshscreendelegate.refreshScreen(isRefreshScreen: true)
//            print("ViewWill Disappear")
//           }
        
        if self.isMovingFromParent {
               //self.delegate.updateData( data)
            print(" I am moving back")
            refreshscreendelegate?.refreshScreen(isRefreshScreen: isRefreshScreen)
           }
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        
        //remove setupPayment VC from the stack when going back to home VC
       // navigationController!.removeViewController(EventPaymentViewController.self)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    func updateEventInfo(){
        eventNameLbl.text = eventName
        eventDateTimeLbl.text = eventDateTime
        eventImage.image = UIImage(named: eventTypeIcon)
    }
    func callGoSpray() {
        if self.completionAction == "gotospray" {
            print("ADD EVENT PREFERENCE - 1 ")
            if self.eventTypeIcon == "entertainer" || self.eventTypeIcon  == "waiter" || eventTypeIcon  == "bandicon" || eventTypeIcon  == "concerticon" {
                print("ADD EVENT PREFERENCE 2 ")
                self.completionAction = "singlereceiver"
            } else {
                self.completionAction = "allreceiver"
            }
            var receiverName: String = ""
            if isSingleReceiverEvent == true {
                receiverName = eventName
            } else {
                receiverName = ""
            }
            print("isPaymentMethodAvailable DOMINIC = \(self.isPaymentMethodAvailable)")
            //return user to the spray screen
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "GoSprayViewController") as! GoSprayViewController
            nextVC.eventId = self.eventId
            nextVC.profileId = self.profileId
            nextVC.token = token
            nextVC.encryptedAPIKey = encryptedAPIKey
            nextVC.completionAction = completionAction //"callspraycandidate"
            //nextVC.isPaymentMethodAvailable = paymentMethodAvailable
            nextVC.receiverName = receiverName
            nextVC.isPaymentMethodAvailable = true //isPaymentMethodAvailable hold for now 3/24
            nextVC.isSingleReceiverEvent = isSingleReceiverEvent
            nextVC.hasPaymentMethodEvent = hasPaymentMethodEvent
            nextVC.isRsvprequired = isRsvprequired
            nextVC.defaultEventPaymentMethod = defaultEventPaymentMethod
            nextVC.defaultEventPaymentCustomName = defaultEventPaymentCustomName
            nextVC.paymentClientToken = paymentClientToken
        
            self.navigationController?.pushViewController(nextVC , animated: true)
        }
    }
    @IBAction func savePaymentBtnPressed(_ sender: Any) {
        
     
            print(getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addgiftamount"))
            
            print(getSprayAmountInt(amountId: autoReplenishAmountSegControl.selectedSegmentIndex, category: "addreplenishamount"))
            print(autoReplenishSwitch.isOn)
            print(btnSelectPayment.currentTitle!)
            
            print("paymentmethodId = \(getPaymenthMethodId(customName: btnSelectPayment.currentTitle!))")
            print("seg val \(autoReplenishAmountSegControl.selectedSegmentIndex)")
        if btnSelectPayment.currentTitle! == "Select Payment" || btnSelectPayment.currentTitle! == "" {
            let alert = UIAlertController(title: "Missing Information", message: "Please select a Payment Method from the list or Add A New Payment Method", preferredStyle: UIAlertController.Style.alert)

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
                
                let updatedPaymentMethodId = getPaymenthMethodId(customName: btnSelectPayment.currentTitle!)
                
                print("SEG CONTROL AMOUNT = \(getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addgiftamount"))")
                //do this if ser saves w/ out add additional amount
                //this will preserve the available balance
                if updatedBalance == 0 {
                    updatedBalance = availableBalance +  getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addgiftamount")
                }
                
                print("UPDATED BALANCE \(updatedBalance)")
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
                
                //general payment
                let addEventPreference = EventPreference(eventId: 0, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencycode)

               
                print("addEventPreference \(addEventPreference)")
//                updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
//                closeScreen()
                let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
                Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
                    switch result {
                    case .success(let eventpref):
                        
                        self.isPaymentMethodAvailable = true
                        //self.hasPaymentMethodEvent = true
                        self.isRefreshScreen = true //use to refresh the HomeViewController
                        self.refreshscreendelegate?.refreshScreen(isRefreshScreen: true)
                        self.hasPaymentMethodEvent = false
                      
                        //completionaction = gotospray when a user select go to spray but no payment
                        //else completionaction = "" - user stays on the payment screen until the get back
                        self.completionAlert(message: "Update Was Successful", timer: 2, completionAction: completionAction)
                        
                        print(" I AM HERE A")
                        
                        //hold off on this 3;27
//                        addEventPrefs(eventId: eventId, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmout:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencycode)
                        //what is this for? 2/20
                        
                        
                        print(eventpref); break
                       
                    case .failure(let error):
                    print(error.localizedDescription)
                    }
                }
               
            }
    
        
    }
    
    func addEventPrefs(eventId: Int64, profileId: Int64, paymentMethod: Int, maxSprayAmount: Int, replenishAmount: Int, notificationAmout: Int, isAutoReplenish: Bool, currency: String) {
        let addEventPreference = EventPreference(eventId: eventId, profileId: profileId, paymentMethod: paymentMethod, maxSprayAmount: maxSprayAmount, replenishAmount: replenishAmount, notificationAmount:  0, isAutoReplenish: isAutoReplenish, currency: currency)

       print("addEventPreference  \(addEventPreference )")
//                updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
//                closeScreen()
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref):
               
                //self.isPaymentMethodAvailable = true
                self.hasPaymentMethodEvent = true
                self.isRefreshScreen = true //use to refresh the HomeViewController
                print("IT WAS UPDATED")
                self.refreshscreendelegate?.refreshScreen(isRefreshScreen: true)
                self.completionAlert(message: "Update Was Successful", timer: 1, completionAction: completionAction)
                //callGoSpray()
                //what is this for? 2/20
                print(" I AM HERE B")
                
                print(eventpref); break
               
            case .failure(let error):
            print(error.localizedDescription)
            }
        }

    }

    func completionAlert(message: String, timer: Int, completionAction:String) -> Void {
        let delay = Double(timer) //* Double(NSEC_PER_SEC)
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            alert.dismiss(animated: true)
            if completionAction == "gospray" {
                self.callGoSpray()
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
    
    @IBAction func addPaymentBtnPressed(_ sender: Any) {
        //launch stripe payment screen
        launchSetUpPaymentMethod()
        
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//
//        let navigationController = UINavigationController(rootViewController: addCardViewController)
//          present(navigationController, animated: true)
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
        nextVC.autoReplenishFlg = autoReplenishFlg
        nextVC.autoReplenishAmt = autoReplenishAmt
        

        nextVC.refreshscreendelegate = self
        nextVC.setuppaymentmethoddelegate = self
        nextVC.paymentClientToken = paymentClientToken
        nextVC.currentAvailableCredit =  availableBalance
        self.present(nextVC, animated: true, completion: nil)
        
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetupPaymentMethodViewController") as! SetupPaymentMethodViewController
      
            
       // self.navigationController?.pushViewController(nextVC , animated: true)
        //}
    }
    func loadSprayAmountOptions(currencyCode: String) {
        print("NAYLA NOAH IGHEDOA - \(currencyCode)")
        addSprayAmountOptionsAutoReplenish.removeAll()
        addSprayAmountOptions.removeAll()
        
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
    func loadSegmentsTitle() {
        //poplulate spray amount segment control
        print("giftAmountSegConrol.numberOfSegments = \(giftAmountSegConrol.numberOfSegments)")
        
        print("selected index \(giftAmountSegConrol.selectedSegmentIndex)")
        
        
        if self.isRefreshScreen2 == true {
            print("giftAmountSegConrol.numberOfSegments after adding payment = \(giftAmountSegConrol.numberOfSegments)")
            /*remove default segments before adding*/
            giftAmountSegConrol.removeSegment(at:0 , animated: true)
            giftAmountSegConrol.removeSegment(at:1, animated: true)
            
            /*only delete and refresh auto replenish segment if the whole thing currenctly populate*/
            if autoReplenishAmountSegControl.numberOfSegments > 2 {
                if addSprayAmountOptionsAutoReplenish.count > 0 {
                    autoReplenishAmountSegControl.removeSegment(at:0 , animated: true)
                    autoReplenishAmountSegControl.removeSegment(at:1, animated: true)
                    
                    /*remove all segmented controls and replenish later*/
                    for i in addSprayAmountOptionsAutoReplenish {
                        print("MY ID = \(i.id)")
                        autoReplenishAmountSegControl.removeSegment(at: i.id , animated: true)
                    }
                }
            }
            for i in addSprayAmountOptions {
                print("MY ID = \(i.id)")
                giftAmountSegConrol.removeSegment(at: i.id , animated: true)
            }
        }
        /*if giftAmountSegConrol.numberOfSegments > 0 {
            giftAmountSegConrol.numberOfSegments  = 0
            
            print("I removed giftAmountSegConrol.removeAllSegments ")
        }*/
        
        //giftAmountSegConrol.removeAllSegments()
        
        for i in addSprayAmountOptions {
       
            print("MY ID = \(i.id) MY DISPLAY NAME = \(i.displayAmount)")
            if i.id == 0 {
                giftAmountSegConrol.setTitle(i.displayAmount, forSegmentAt: i.id )
                print("MY ID = 0 = \(i.id) MY DISPLAY NAME 0= \(i.displayAmount)")
            } else if i.id == 1 {
                giftAmountSegConrol.setTitle(i.displayAmount, forSegmentAt: i.id )
                print("MY ID = 1 = \(i.id) MY DISPLAY NAME 1 = \(i.displayAmount)")
            } else {
                giftAmountSegConrol.insertSegment(withTitle: i.displayAmount, at: i.id, animated: true)
            }
        }
        print("addSprayAmountOptions =\(addSprayAmountOptions)")
        if self.isRefreshScreen2 == true {
            print("New segmented # = \(giftAmountSegConrol.numberOfSegments)")
            
        }
       
        //populate auto replenish seg control
        //autoReplenishAmountSegControl.removeAllSegments()
        print("autoReplenishAmountSegControl.numberOfSegments = \(autoReplenishAmountSegControl.numberOfSegments)")
        
        /*if autoReplenishAmountSegControl.numberOfSegments > 0 {
            autoReplenishAmountSegControl.removeAllSegments()
            print("I removed autoReplenishAmountSegControl.removeAllSegments ")
        }*/
        
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
    func getAvailablePaymentData() {
        let request = Request(path: "/api/PaymentMethod/all/\(profileId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
           case .success(let paymentmethod1):
               //self.parse(json: event)
            print("I am here inside getAvailablePaymentData")
            DispatchQueue.main.async {
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
                       
                   }  else {
                       print("RECORD COUNT = \(paymentJson.count)")
                       isPaymentMethodAvailable2 = true
                       for paymenttypedata in paymentJson {
                           if paymenttypedata.customName != "" {
                               /*check if currency is nill if so use the default country name to identify the currency*/
                               if let currency = paymenttypedata.currency {
                                   currencyCode = currency
                               } else {
                                   let locale = Locale.current /*get default country code*/
                                   currencyCode = countryData.getCurrencyCode(regionCode: locale.regionCode!)
                               }
                               
                               if paymenttypedata.defaultPaymentMethod == true {
                                   
                                   
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
                                   
                                   //currencyCode = paymenttypedata.currency!
                                   
                                   /*currencySymbol = Currency.shared.findSymbol(currencyCode: currencyCode)
                                   print("DEFAULT PAYMENT IS TRUE AWELE - \(currencyCode)")
                                  
                                   //getCurrencyData2(currencyCode: currencyCode)
                                   loadSprayAmountOptions(currencyCode: currencyCode)*/
                                  
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
                              
                               
                               //display the default payment on the dropdown list
       //                        if paymenttypedata.defaultPaymentMethod == true {
       //                            self.btnSelectPayment.setTitle(paymenttypedata.customName, for: .normal)
       //                        }
                                  
                               
                               print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
                               print("customName = \(paymenttypedata.customName!)")
                               print("paymenttype = \(paymenttypedata.paymentType!)")
                               
                               print("paymenttypedata.paymentType! = \(paymenttypedata.paymentType!)")
                               print("paymenttypedata.paymentMethodId = \(paymenttypedata.paymentMethodId!)")
                               print("paymenttypedata.defaultPaymentMethod = \(paymenttypedata.defaultPaymentMethod!)")
                               
           //                    if paymenttypedata.paymentType! == 5 {
           //                        self.paymentIconImageView.image = UIImage(named: "visaicon")
           //                    } else if paymenttypedata.paymentType! == 4 {
           //                        self.paymentIconImageView.image = UIImage(named: "mastercardicon")
           //                    }
           //                    self.paymentNickNameTextField.text = (paymenttypedata.customName!)
           //                    self.paymentSelectedLabel.text = paymenttypedata.paymentDescription
           //                    self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
           //                    self.paymentActionMessageLabel.text = "edit payment Information for this event..."
           //                    self.paymentTypeFromPaymentType = paymenttypedata.paymentType!
           //                    self.paymentMethodIdFromGetPaymentType = paymenttypedata.paymentMethodId!
           ////                                print("error message = \(paymentJson[x].errorMessage!)")
           //                                print("error code = \(paymentJson[x].errorCode!)")
                           }
                           
                       }
                   }
               
               
                   
                   
                } catch {
                   print(error)
                }
                
                self.tableView.reloadData()
                getEventPref()
            }
             
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
                        //self.gifterTotalTransAmount =  gifterBalanceJson.totalAmountAllTransactions
                        print("self.gifterTotalTransAmount = \(gifterBalanceJson.totalAmountAllTransactions)")
                    }
                   //}
                      
               } catch {
                   print(error)
               }
                //self.getEventPref2(paymenttypeData: paymentmethod1)
                //self.gifterTotalTransAmountLbl.text = "$" + String(self.gifterTotalTransAmount)
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }

    }
    
    func getEventPref() {
        
        print("getEventPref was called")
        //get the total amount that the gifter has given
        //for this event
        //getGifterTotalTransBalance()
        
        
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        //let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token)
        
        let request = Request(path: "/api/Event/prefs/\(profileId)/0", token: token, apiKey: encryptedAPIKey)
        
        Network.shared.send(request) { [self] (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    
                    DispatchQueue.main.async {
                        let decoder = JSONDecoder()
                        do {
                            let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                            if  eventPreferenceJson.count == 0 {
                                print("no event")
                                self.autoReplenishLbl.isHidden = true
                                
                                self.autoReplenishAmountSegControl.isHidden = true
                                self.autoReplenishSwitch.isOn = false
                                
                                print("I didn't land 1 \( isPaymentMethodAvailable2)")
                                if isPaymentMethodAvailable2 == false  {
                                    self.btnSelectPayment.setTitle("Add Payment Method", for: .normal)
                                } else {
                                    self.btnSelectPayment.setTitle("Select Payment", for: .normal)
                                }
                            } else {
                                for eventPrefData in eventPreferenceJson {
                                    print("Event Id = \(eventPrefData.eventId)")
                                    print("Incoming Event Id = \(String(describing: self.eventId))")
                                    
                                    
                                    /*check for the current eventId.. if found then exit loop*/
                                    //if eventPrefData.eventId == eventId {
                                        print("event Id = eventId")
                                        //if eventPrefData.eventId == self.eventId {
                                        //self.paymentMethodIdFromPreference = Int64(eventPrefData.paymentMethodDetails.paymentMethodId)
                                        
                                        
                                        print("BAT MAN PAYMENT METHOD ID = \(eventPrefData.paymentMethodDetails.paymentMethodId)")
                                    
                                       // if eventPrefData.paymentMethodDetails.paymentMethodId == eventPrefData.paymentMethod {
                                            
                                            //only use the payment for the event that you are on...
                                            currencycode = getPaymentMethodCurrency(paymentMethodId: Int64(eventPrefData.paymentMethod))
                                            
                                            print("BAT MAN CURRENCY CODE \(currencycode)")
                                           
                                            //\(eventPrefData.paymentMethodDetails.paymentMethodId)")
                                            
                                            //eventDefaultCurrencyCode == currencycode
                                           // self.isReadyToSavePayment = true
                                            print("eventPreferenceData.paymentMethod == paymenttypedata.paymentType! ")

                                            print("paymentTypeFromPaymentType =\(eventPrefData.paymentMethodDetails.paymentType)")

                                            print("paymentmethodId = \(eventPrefData.paymentMethodDetails.paymentMethodId)")
                                            print("customName = \(eventPrefData.paymentMethodDetails.customName!)")
                                            print("paymenttype = \(eventPrefData.paymentMethodDetails.paymentType)")
                                            
                                            print("paymenttypedata.paymentType! = \(eventPrefData.paymentMethodDetails.paymentType)")
                                            print("paymenttypedata.paymentMethodId = \(eventPrefData.paymentMethodDetails.paymentMethodId)")
                                        
                                            if eventDefaultCurrencyCode == currencycode {
                                                print("I landed 1 \(eventPrefData.paymentMethodDetails.paymentMethodId)")
                                                self.btnSelectPayment.setTitle(self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethodDetails.paymentMethodId), for: .normal)
                                                
                                                //\(eventPrefData.paymentMethodDetails.paymentMethodId)")
                                                
                                                self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish

                                                self.availableBalance = eventPrefData.maxSprayAmount
                                                self.currentBalance.text = currencySymbol  + String(self.availableBalance)
                                                //set the value of updated balance
                                                //self.updatedBalance = self.availableBalance
                                                print("autoreplish = \(eventPrefData.isAutoReplenish)")
                                                if eventPrefData.isAutoReplenish == true {
                                                    self.autoReplenishAmountSegControl.selectedSegmentIndex = self.getSegControlIndex(amount: eventPrefData.replenishAmount, category: "replenishamount" )
                                                    
                                                    autoReplenishFlg = true
                                                    autoReplenishAmt = eventPrefData.replenishAmount
                                                    
                                                }
                                                
                                                if self.autoReplenishSwitch.isOn == false {
                                                    self.autoReplenishLbl.isHidden = true
                                                    self.autoReplenishAmountSegControl.isHidden = true
                                                } else {
                                                    self.autoReplenishLbl.isHidden = false
                                                    self.autoReplenishAmountSegControl.isHidden = false
                                                }
                                            } else {
                                                print(" SUPER BIG CURRENCY CODE = \(currencycode)")
                                                print(" SUPER BIG EVENT CURRENCY CODE  =\(eventDefaultCurrencyCode)")
                                                print(" SUPER BIG PAYMENT METHOD ID \(eventPrefData.paymentMethodDetails.paymentMethodId)")
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
                                            
                                            
                                            print("PAYMENT METHOD NAME = \(self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethodDetails.paymentMethodId))")
                                            
                                            paymentMethodIconName = getPaymentMethodIcon(name: getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethodDetails.paymentMethodId))
                                            
                                            
                                            //paymentMethodIcon.image = UIImage(named: paymentMethodIconName)
                                            //paymentMethodIcon.image = UIImage(named: "paymentInfoIcon")
                                            
                                                //.setImage(UIImage(systemName: paymentMethodIconName), for: .normal)
                                            
                                            
                                           
                                           // break
                                        //}
                                       // break
                                        
                                    //else if eventId <> eventId
    //                                } else {
    //                                    self.autoReplenishSwitch.isOn = false
    //                                    self.autoReplenishLbl.isHidden = true
    //                                    self.autoReplenishAmountSegControl.isHidden = true
    //
    //
                                    //    break
                                    //} else {
                                        
                                    //}
                                    
                                   
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                case .failure(let error):
                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
//    func customeFieldStyling() {
//        customtextfield.noBorderForTextField(textField: initialSprayAmountTextField, validationFlag: false)
//        customtextfield.noBorderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
//        customtextfield.noBorderForTextField(textField: alertAmountTextField, validationFlag: false)
//
//    }
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        transparentView.frame = window?.frame ?? self.fullScreenPaymentUIView.frame
        self.fullScreenPaymentUIView.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height:0)
        self.fullScreenPaymentUIView.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        print("frames.origin.x = \(frames.origin.x) frames.origin.y = \(frames.origin.y) frames.height = \(frames.height) frames.width = \(frames.width)")
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
    
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { [self] in self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(dataSource.count * 50))
            
        }, completion: nil)
    }
    
    @objc func removeTransparentView () {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y, width: frames.height + 5, height: 0)
            
        }, completion: nil)
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

    @IBAction func selectPaymentBtnPressed(_ sender: Any) {
        dataSource = ["Visa ..1234", "Mastcard...1234", "Amex...9987"]
        selectedButton = btnSelectPayment
        addTransparentView(frames: btnSelectPayment.frame)
       // self.paymentMethodIcon.setImage(UIImage(systemName: getPaymentMethodIcon(name: "master 4444")), for: UIControl.State.normal)
        
      
        
        //paymentMethodIcon
        
    }
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    func addMyPayment(paymentMethodToken
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        //if i want to add default payment method, use the paymentmethod Id from this call to setup AddPref...
        //paymentmethodtoken is from the stripe UI
        let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: "08/17/2030", currency: "usd", profileId: profileId)

        let request = PostRequest(path: "/api/PaymentMethod/add", model: addPayment , token: token, apiKey: encryptedAPIKey, deviceId: "")

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let newpaymentdata):
                let decoder = JSONDecoder()
                do {
                    let newPaymentJson: PaymentTypeData = try decoder.decode(PaymentTypeData.self, from: newpaymentdata)
                    
                    getAvailablePaymentData() //refresh availablePaymentData object
                    addGeneralPaymentPref(paymentMethodId: newPaymentJson.paymentMethodId!, paymentDescription: customName)
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
        
        let addEventPreference = EventPreference(eventId: eventId, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencyCode)
            
        //set.btnSelectPayment.setTitle(paymentDescription)
       
        
        print("ADD EVENT PREFERENCE \(addEventPreference)")
//        updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
        //closeScreen()
        
        //hold 2/13 - for now...
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref);
                
                //updatedBalance = availableBalance + getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addreplenishamount")
                //giftAmountSegConrol.removeAllSegments()
                giftAmountSegConrol.selectedSegmentIndex = 2
                //segmentedControl.selectedSegmentIndex = index
                availableBalance = updatedGiftAmount
                currentBalance.text = currencySymbol  + String(self.availableBalance)
                
                //currentBalance.text = "$" + String(updatedBalance)
                btnSelectPayment.setTitle(paymentDescription, for: .normal)
                //paymentMethodIcon.image = UIImage(named: paymentDescription)
                paymentMethodIcon.image = UIImage(named: "paymentInfoIcon")
                

                
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
        //comment this out for now...
//        if paymentmethodCustNameExist(customName: paymentMethod.label) == false {
//            addMyPayment(paymentMethodToken: paymentClientToken, customName: paymentMethod.label, paymentOptionType: 0, paymentDescription: paymentMethod.image.description, paymentExpiration: "08/17/2030")
//        } else {
//            print("DUPLICATE PAYMENT METHOD")
//            giftAmountSegConrol.selectedSegmentIndex = 2
//            //segmentedControl.selectedSegmentIndex = index
//            availableBalance = 15
//            currentBalance.text = "$" + String(self.availableBalance)
//
//            //currentBalance.text = "$" + String(updatedBalance)
//            btnSelectPayment.setTitle(paymentMethod.label, for: .normal)
//
//            self.paymentMethodIcon.image = UIImage(named: paymentMethod.label)
//
//
//            self.completionAlert(message: "Payment Method \(paymentMethod.label) Already Exist. Please Update Your Available Credit and Continue.", timer: 5, completionAction: completionAction)
//        }
        
        
        
        print("label \(paymentMethod.label)")
        print("stripe Id \(paymentMethod.stripeId)")
        print("image \(paymentMethod.image)")
        print("card = \(paymentMethod.card)")
        print("allResponseFields = \(paymentMethod.allResponseFields)")
        
        // Collect card details
        let cardParams = cardTextField.cardParams //paymentMethod.card?.allResponseFields //cardTextField.cardParams// allResponseFields
        print("cardParams = \(cardParams)")
        let paymentMethodParams =  STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentMethod.stripeId)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

        paymentIntentParams.paymentMethodParams = paymentMethodParams

        paymentIntentParams.setupFutureUsage = STPPaymentIntentSetupFutureUsage(rawValue: Int(NSNumber(value: STPPaymentIntentSetupFutureUsage.offSession.rawValue)))
        
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { [self] (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                //self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                generalAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                break
            case .canceled:
                //self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                generalAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                break
            case .succeeded:
                //self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
                generalAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "")
                break
            @unknown default:
                fatalError()
                break
            }
        }
        
    
    }
    //general alert
    func generalAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //payment authentication if requiree
    func authenticationPresentingViewController() -> UIViewController {
        return self
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

extension EventPaymentViewController: UITableViewDelegate, UITableViewDataSource {
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
        //paymentMethodIcon.image = UIImage(named: paymentMethodIconName)
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

//not user right now
//extension UITextField {
//
//enum Direction {
//    case Left
//    case Right
//}
//
//// add image to textfield
//func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
//    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
//    mainView.layer.cornerRadius = 5
//
//    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
//    view.backgroundColor = .white
//    view.clipsToBounds = true
//    view.layer.cornerRadius = 5
//    view.layer.borderWidth = CGFloat(0.5)
//    view.layer.borderColor = colorBorder.cgColor
//    mainView.addSubview(view)
//
//    let imageView = UIImageView(image: image)
//    imageView.contentMode = .scaleAspectFit
//    imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
//    view.addSubview(imageView)
//
//    let seperatorView = UIView()
//    seperatorView.backgroundColor = colorSeparator
//    mainView.addSubview(seperatorView)
//
//    if(Direction.Left == direction){ // image left
//        seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
//        self.leftViewMode = .always
//        self.leftView = mainView
//    } else { // image right
//        seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
//        self.rightViewMode = .always
//        self.rightView = mainView
//    }
//
//    self.layer.borderColor = colorBorder.cgColor
//    self.layer.borderWidth = CGFloat(0.5)
//    self.layer.cornerRadius = 5
//}
//
//}
extension EventPaymentViewController:  RefreshScreenDelegate {
    func refreshScreen(isRefreshScreen: Bool) {
       
        self.isRefreshScreen2 = isRefreshScreen
        print("refreshData Blabablabalba  function was called = \(self.isRefreshScreen2)")
        print(self.isRefreshScreen2)
        //print("refreshHomeScreenDate = \(isShowScreen)")
    }


}

extension EventPaymentViewController:  SetupPaymentMethodDelegate {
    func passData(eventId: Int64, profileId: Int64, token: String, ApiKey: String, eventName: String, eventDateTime: String, eventTypeIcon: String, paymentClientToken: String, isSingleReceiverEvent: Bool, eventOwnerName: String, eventOwnerId: Int64) {
        self.eventId = eventId
        self.profileId = profileId
        self.eventName = eventName
        self.eventDateTime = eventDateTime
        self.eventTypeIcon = eventTypeIcon
        self.paymentClientToken = paymentClientToken
        self.isSingleReceiverEvent = isSingleReceiverEvent
    
        print("I am inside SetupPaymentMethodDelegate")
        
        print("view did appear isRefreshScreen = \(isRefreshScreen2)")
        //I called viewDidAppear
        if self.isRefreshScreen2 == true {
            
            print("I REFERESHED THE SCREEN")
            //customeFieldStyling()
            getAvailablePaymentData()
            //eventNameLabel.text = eventName + "\n \(eventDateTime)"
            //loadSprayAmountOptions()
            // Do any additional setup after loading the view.
            getEventPref()
            updateEventInfo()
        }
    }
    

}
