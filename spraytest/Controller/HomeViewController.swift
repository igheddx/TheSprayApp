//

//  HomeViewController.swift

//  spraytest

//

//  Created by Ighedosa, Dominic on 5/28/20.

//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.

//


import Foundation
import UIKit
import AppCenter
import AppCenterCrashes
//import SVProgressHUD


class HomeViewController: UIViewController, UITextFieldDelegate {

 
    
    let defaults = UserDefaults.standard
    var noActivityLabel: UILabel = UILabel()
    var addEventCodeTextField: UITextField = UITextField()
    
    var lable1: String?
    //test
    var isEventEdited: Bool = false
    var isRefreshData: Bool = false
    //protocol example still good
    //var clickedPath: IndexPath? = nil
      
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var eventId: Int64 = 0
    var eventOwnerId: Int64 = 0
    var eventOwnerName: String = ""
    var eventType: String = ""
    var eventTypeIcon2: String = "" //this is the eventTypeIcon pass when you scan a QRCode
    var updateAttendee: Attendees?
    var attendeeFlagWasSet: Bool = false
    var eventtypeData: [EventTypeData] = []
    var myProfileData: [MyProfile] = []
    var stripeOnboardingMessage: String = ""
    //variable that goes w/ goSpray viewcontroller
    var sprayAmount: Int = 0
    var isReplenish: Bool = false
    var replenishAmount: Int = 0
    
    var stripeBalanceAvailable = [AmountCurrency]() //new data
    var stripeBalancePending = [AmountCurrency]() //new data
    var infoBoardMetric =  [BalanceAmountCurrency]()
    
    var setstatusbarbgcolor = StatusBarBackgroundColor()
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var lablemessage: UILabel!

    @IBOutlet weak var lablemessage: UILabel!
    var videos: [Video] = []
    //var events = [EventList]()
    
    //var eventsOwned = [EventsOwned]()
    
    
    var token: String?
    var paymentClientToken: String = ""
    var profileId: Int64 = 0
    var eventResult = [EventResult]()
    var homescreeneventdata_2 = [HomeScreenEventDataModel]() //old data
    var homescreeneventdata = [EventProperty]() //new data
    var eventproperty: [EventProperty] = []
    var eventsownedmodel = [EventProperty]()
    var eventsattendingmodel = [EventProperty]()
    var eventIdsattendingmodel = [Int]()
    var eventsinvitedmodel = [EventProperty]()
    var eventpaymentmethod = [eventPaymentMethod]()
    var isAttending = [isAttendingModel]()
    var isattendingdata = [isAttendingData]()
    let eventTypeIcon = EventTypeIcon()
    var availablePaymentData = [PaymentTypeData2]()
    
    var isPaymentMethodAvailable2: Bool = false
    //let isPaymentMethodOnFile: Bool = UserDefaults.standard.bool(forKey: "isPaymentMethodAvailable")
    var generalPaymentMethodId: Int = 0
    var generalDefaultPaymentCustomName: String = ""
    var completionAction: String = ""
    var avatar: String = ""
    var isPaymentMethodGeneralAvailable: Bool = false
    var isSingleReceiverEventStr: String = "" //use this from when QR code is scanned and you are trying to determine if event is single receiver
    var isSingleReceiver: Bool = false
    var displayName: String = ""
    var outstandingTransferAmt: String = ""
    //var pendingPayoutAmt: String = ""
    var pendingPayoutAmt2: String = ""
    var totalGiftedAmt: String = ""
    var totalGiftReceivedAmt: String = ""
    var currency: String = ""
    var paymentCustomerId: String = ""
    var paymentConnectedActId: String = ""
    var encryptedAPIKey: String = ""
    var encryptedDeviceId: String = ""
    var currencyCode: String = ""
    var currencySymbol: String = ""
    var countryData = CountryData ()
    
    
    var QRCodeScan: String = ""
   // var myProfileData: [MyProfile] = []
    //var refreshscreendelegate: RefreshScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("BRIAN TAB ID VIEW DID LOAD = \(tabBarController!.selectedIndex )")
        print("paymentClientToken \(paymentClientToken)")
        print("HOME encryptedAPIKey \(encryptedAPIKey)")
        
//        AppCenter.start(withAppSecret: "ec81818c-6d8c-452d-9011-85b7ecbf8a5e", services:[
//          Crashes.self
//        ])
        
        
        self.tabBarController?.delegate = self
        setstatusbarbgcolor.setBackground()
        //tabBarController!.selectedIndex = 0
       // UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
       /* if #available(iOS 13.0, *) {
                   let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                    statusBar.backgroundColor = UIColor.init(red: 244/255, green: 209/255, blue: 96/255, alpha: 1.0)
                    UIApplication.shared.keyWindow?.addSubview(statusBar)
            print("NOAH")
            //rgb(244, 209, 96)
        } else {
                
            print("NAYLA")
//            var statusBarManager: UIView? {
//                  return  value(forKey: "statusBarManager") as? UIView
//            }
                UIApplication.shared.statusBarManager?.backgroundColor = UIColor.init(red: 237/255, green: 85/255, blue: 61/255, alpha: 1.0)
        } */
        /*comment out for now 7/11
         
         if #available(iOS 13.2, *) {
            print("i am here statusBarManager")
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.init(red: 255/250, green: 255/250, blue: 255/250, alpha: 1)
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            print("i am here - nope didn't work statusBarManager")
            //   var statusBarManager: UIView? {
            //      return value(forKey: "statusBarManager") as? UIView
            //    }
             UIApplication.shared.statusBarManager?.backgroundColor = UIColor.init(red: 255/250, green: 255/250, blue: 255/250, alpha: 1)
            
        } */

        
        
        if stripeOnboardingMessage == "success" {
            self.completionAlert(message: "Congratulations!!! Your Onetime Payout Setup is Complete. Once Verification is Complete and Approved, Your Payout Will Begin.", timer: 6, completionAction: "gospray")
        } else if stripeOnboardingMessage == "failed" {
            self.completionAlert(message: "Oh no... Something Went Wrong With the Onetime Payout Setup. Please Try Again Latter.", timer: 6, completionAction: "gospray")
        }
        clearData()
        // get profile data for eventOwner - this is the event coming from the scaned QR cod
        if eventOwnerId > 0 {
            print("Joined event after authentication 1")
            getOtherProfileData(profileId: eventOwnerId)
        }
        
        
//        for data in myProfileData {
//            displayName = data.firstName
//        }
        //get user profile info... set haspyament flag and other varialbe
        getProfileData(profileId: profileId)
        getProfileNamePicture()
        print("MY PROFILE ID = \(profileId)")
        print("isEventEdited \(isEventEdited) isRefreshData=\(isRefreshData)")
        
        //call getMyevent func when the screen loads
        // print("paymentClientToken - Home = \(paymentClientToken!)")
        if isEventEdited == false && isRefreshData == false {
            print("View Did Load Inside false isEventEdited = \(isEventEdited)")
            //LoadingStart(message: "Loading...")
            availablePaymentData.removeAll()
            getAvailablePaymentData()
            
            
            //getPrefData()
        } else {
            print("QRCodeScan ViewDidLoad = \(QRCodeScan)")
        }

        
       
        // UIBarButtonItem(systemItem: .action), UIBarButtonItem(customView: customView)
       // title: "Dominic", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleClick)
        
        //let btnRefresh = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pers, target: self, action: #selector(handleClick))
//        let customImageBarBtn1 = UIBarButtonItem(image: newAvatarImage!.withRenderingMode(.alwaysOriginal),
//            style: .plain, target: self, action: #selector(handleClick))
       //let customImageBarBtn2 = UIBarButtonItem(title: displayName, style: .plain, target: self, action: nil)
//
//        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//        moreButton.setBackgroundImage(UIImage(named: "ic_more_vert_3"), for: .normal)
//        moreButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)
        
           //If you want icon in left side
           // navigationItem.leftBarButtonItem = btnRefresh

           //If you want icon in right side
            //navigationItem.rightBarButtonItem = btnRefresh
       
       // navigationItem.rightBarButtonItems = [customImageBarBtn2]
        
       
        
        
        //self.rightBarButton.titleLabel.text = @"Test";
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dominic", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleClick))
        
        //setStatusBarColor()  commented out for now
        
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow:")), name:UIResponder.keyboardWillShowNotification, object: nil);
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide:")), name:UIResponder.keyboardWillHideNotification, object: nil);

        
        //hhid backbutton when coming back from scanner
        self.navigationItem.setHidesBackButton(true, animated: true)
        print("my profile home \(myProfileData)")
        print("the eventId = \(eventId)")
        //variable to determine if user has a paymenthod on file
        print("eventType= \(eventType)")
        
        //if any of these single receiver event, then....
        //if eventType == "entertainer" || eventType == "waiter" || eventType == "bandicon" || eventType == "concerticon" {
        if isSingleReceiverEventStr == "true" {
            //checkIfPaymentMethodExist()
            
            completionAction = "singlereceiver"
            print("I called  checkIfPaymentMethodExist")
           // if eventTypeIcon.getEventTypeIcon(eventTypeId: eventType) == "waiter" {
                //let value = eventTypeIcon.getEventTypeIcon(eventTypeId: eventType)
        } else {
            completionAction = "allreceiver"
        }
        
       
        
        //check if payment method exist all regardless of event
        //checkIfGeneralEventPaymentMethod(profileId: profileId)
        
        print("isPaymentMethodAvailable2 = \(isPaymentMethodAvailable2)")
        self.navigationItem.title = "My Activities"
       
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
       
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //self.tableView.layer.borderWidth = 0
        //self.tableView.backgroundColor =  UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0)
        
          print("isRefreshData  viewdidLoad \(isRefreshData)")
        print("BACK BUTTON TRIGGERED VIEWDID DID LOAD")
       // print(convertDateFormatter(date: "2020-07-20T19:45:20.435"))

//        readyToSprayButtonPressed.layer.borderColor = UIColor.clear.cgColor
        tableView.register(MySprayEventTableViewCell.nib(), forCellReuseIdentifier: MySprayEventTableViewCell.identifier)
        tableView.register(MyInvitationsTableViewCell.nib(), forCellReuseIdentifier: MyInvitationsTableViewCell.identifier)
        tableView.register(MyEventsTableViewCell.nib(), forCellReuseIdentifier: MyEventsTableViewCell.identifier)
        tableView.register(InfoBoardTableViewCell.nib(), forCellReuseIdentifier: InfoBoardTableViewCell.identifier)
        
        
        //SVProgressHUD.setDefaultMaskType(.black)
        //SVProgressHUD.show(withStatus: "Authenticating...")
        
//        homescreeneventdata_2.removeAll()
//        homescreeneventdata.removeAll()
        
        print("MY proifle ID = \(profileId)")
        addEventTypeData()
        
        //restore tabBar if missing
        if self.tabBarController?.tabBar.isHidden == true {
            print("Link - tabbar should be back 1")
            self.tabBarController?.tabBar.isHidden = false
        } else  {
            print("Link - bad  1")
        }
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        print("eventType= \(eventType)")
//        homescreeneventdata_2.removeAll()
//        homescreeneventdata.removeAll()
        //restore tabBar if missing
        if self.tabBarController?.tabBar.isHidden == true {
            print("Link - tabbar should be back 2")
            self.tabBarController?.tabBar.isHidden = false
        } else {
            print("Link - bad  2")
        }
        print("isRefreshData = \(isRefreshData)")
        setstatusbarbgcolor.setBackground()
        // print("View Did Appear isEventEdited = \(isEventEdited)")
//        if isEventEdited == true {
//            clearData()
//        }
        
//        if #available(iOS 13.2, *) {
//            print("i am here statusBarManager")
//            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
//             statusBar.backgroundColor = UIColor.init(red: 255/250, green: 255/250, blue: 255/250, alpha: 1)
//             UIApplication.shared.keyWindow?.addSubview(statusBar)
//        } else {
//            print("i am here - nope didn't work statusBarManager")
//            //   var statusBarManager: UIView? {
//            //      return value(forKey: "statusBarManager") as? UIView
//            //    }
//             UIApplication.shared.statusBarManager?.backgroundColor = UIColor.init(red: 255/250, green: 255/250, blue: 255/250, alpha: 1)
//            
//        }
//        
        //uncommented this so that getMyEvents is not called on initial load of screen
        if isRefreshData == true {
            print("isRefreshData Did Appear 1 = \(isRefreshData)")
            clearData()
            
            print("QRCodeScan ViewDAppear = \(QRCodeScan)")
            
            //get user profile info... set haspyament flag and other varialbe
            getProfileData(profileId: profileId)
            //getMyEvents()
            availablePaymentData.removeAll()
            getAvailablePaymentData() /*no longer calling  getDataForInfoUIView() will call inside getAvailablePaymentData*/
           
            //getPrefData()
             print("BACK BUTTON TRIGGERED VIEWDID APPEAR isRefreshData  = \(isRefreshData )")
            
            // get profile data for eventOwner - this is the event coming from the scaned QR cod
            if eventOwnerId > 0 {
                print("Joined event after authentication 2")
                getOtherProfileData(profileId: eventOwnerId)
            }
            
            getProfileNamePicture()
        }
       
        AppUtility.lockOrientation(.portrait)
       
         // print("isRefreshData  Did Appear 2 \(isRefreshData)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           navigationController?.isHiddenHairline = true
        print("View will appear was called")
        
        //only preselect home after logging into scan
        if eventOwnerId > 0 {
            tabBarController!.selectedIndex = 0
        }
        
        //print("BRIAN TAB ID = \(tabBarController!.selectedIndex )")
        
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           navigationController?.isHiddenHairline = false
        AppUtility.lockOrientation(.all)
       }
    
   
 
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func handleClick() {
        print("do notheing")
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

            thePaymentMethodCurrency = "none" //currencyCode
            return thePaymentMethodCurrency
        }
    }
    
    func getAvailablePaymentData() {
        let request = Request(path: "/api/PaymentMethod/all/\(profileId)", token: token!, apiKey: encryptedAPIKey)
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
        case .success(let paymentmethod1):
               //self.parse(json: event)
            print("it's successful")
            let decoder = JSONDecoder()
                do {
                    let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                    /*if no payment record on file then use default country region code to get
                    currencyCode */
                    if paymentJson.count == 0 {
                        let locale = Locale.current /*get default country code*/
                        currencyCode =   countryData.getCurrencyCode(regionCode: locale.regionCode!)
                        currencySymbol = Currency.shared.findSymbol(currencyCode: currencyCode)
                        getDataForInfoUIView(currencyCode: currencyCode)
                        
                        print("DEFAULT PAYMENT IS TRUE AWELE - \(currencyCode)")
                      
                    } else {
                        for paymenttypedata in paymentJson {
                            print("first time in the loop")
                            if paymenttypedata.customName != "" {
                                /*assign currency, */
                                if paymenttypedata.defaultPaymentMethod == true {
                                    
                                    /*check if currency is nill if so use the default country name to identify the currency*/
                                    if let currency = paymenttypedata.currency {
                                        currencyCode = currency
                                    } else {
                                        let locale = Locale.current /*get default country code*/
                                        currencyCode = countryData.getCurrencyCode(regionCode: locale.regionCode!)
                                    }
                                    //currencyCode = paymenttypedata.currency! /*get currency from payment method and country selected*/
                                    
                                    currencySymbol = Currency.shared.findSymbol(currencyCode: currencyCode)
                                    
                                    getDataForInfoUIView(currencyCode: currencyCode)
                                    print("DEFAULT PAYMENT IS TRUE AWELE - \(currencyCode)")
                                }
                
                                
                                let adddata = PaymentTypeData2(paymentMethodId: paymenttypedata.paymentMethodId!,
                                   profileId: paymenttypedata.profileId,
                                   paymentType: paymenttypedata.paymentType,
                                   customName: paymenttypedata.customName,
                                   paymentDescription: paymenttypedata.paymentDescription,
                                   paymentExpiration: paymenttypedata.paymentExpiration,
                                   defaultPaymentMethod: paymenttypedata.defaultPaymentMethod,
                                   currency: paymenttypedata.currency,
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
                                
                                print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
                                print("customName = \(paymenttypedata.customName!)")
                                print("paymenttype = \(paymenttypedata.paymentType!)")
                                
                                print("paymenttypedata.paymentType! = \(paymenttypedata.paymentType!)")
                                print("paymenttypedata.paymentMethodId = \(paymenttypedata.paymentMethodId!)")
                                print("paymenttypedata.defaultPaymentMethod = \(paymenttypedata.defaultPaymentMethod!)")
                            }
                        }
                    }
                    print("success but no data")
                 } catch {
                    print(error)
                 }
            /*self.tableView.reloadData()
            getEventPref()*/
            
                case .failure(let error):
                    let locale = Locale.current /*get default country code*/
                    currencyCode =   countryData.getCurrencyCode(regionCode: locale.regionCode!)
                    currencySymbol = Currency.shared.findSymbol(currencyCode: currencyCode)
                    getDataForInfoUIView(currencyCode: currencyCode)
                    
                    
                    print("DEFAULT PAYMENT IS TRUE AWELE - \(currencyCode)")
                   print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }
    //this is used to get profile name and picture from the myprofile object..
    //this is displayed at the top of the nagvigation bar in the homeviewcontroller
    func getProfileNamePicture() {
        
        //get profileName
        var avatarStr: String = ""
        var newAvatarImage: UIImage?
        var userDisplayName: String = ""
        if myProfileData.isEmpty {
            UserDefaults.standard.set("userprofile", forKey: "userProfileImage")
            UserDefaults.standard.set("", forKey: "userDisplayName")
            avatarStr = "noimage" //UserDefaults.standard.string(forKey: "userProfileImage")! //"noimage"
            displayName = UserDefaults.standard.string(forKey: "userDisplayName")!
            print("no avatar")
            paymentCustomerId = ""
            paymentConnectedActId = ""
            
        } else {
            for name in myProfileData {
                UserDefaults.standard.set(name.firstName, forKey: "userDisplayName")
                userDisplayName = UserDefaults.standard.string(forKey: "userDisplayName")!
                displayName = userDisplayName //name.firstName
                
                print("I am inside myProfile loop")
                if let avatarStr1 = name.avatar {
                    avatarStr = avatarStr1
                    UserDefaults.standard.set(avatarStr, forKey: "userProfileImage")
                   
                } else {
                    avatarStr = "noimage"
                    UserDefaults.standard.set("userprofile", forKey: "userProfileImage")
                    print("no image here")
                    break
                }
               
                if let  paymentCustId = name.paymentCustomerId {
                    paymentCustomerId = paymentCustId
                } else  {
                    paymentCustomerId = ""
                }
                
                if let  paymentConnectedId = name.paymentConnectedActId {
                   paymentConnectedActId = paymentConnectedId
                } else  {
                    paymentConnectedActId = ""
                }
                
                    
            }
        }
       
        
        if avatarStr == "noimage" {
            let userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            newAvatarImage = UIImage(named: userProfileImage!)
            print("noimage")
            
        } else {
            let userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            //newAvatarImage = UIImage(named: userProfileImage!)
            
            newAvatarImage = convertBase64StringToImage(imageBase64String: userProfileImage!)
            print("there is an image???")
        }
       
        
//        if let myAvatar2 = myAvatar2 {
//
//            myAvatar.image = convertBase64StringToImage(imageBase64String: myAvatar2)
//        } else {
//            myAvatar.image = UIImage(named: "userprofile")
        //}
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
           let customView = UIView(frame: frame)
           let imageView = UIImageView(image: newAvatarImage)
           imageView.frame = frame
           imageView.layer.cornerRadius = imageView.frame.height * 0.5
           imageView.layer.masksToBounds = true
           customView.addSubview(imageView)
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(customView: customView), UIBarButtonItem(title: displayName, style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleClick))
            ]
        } else {
            // Fallback on earlier versions
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
    
    //Decoding Base64 Image
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
//    func getDataForInfoUIView2(json: Data){
//        let decoder = JSONDecoder()
//        do {
//            print("i am doing")
//            let stripeBalanceJson: [StripeBalance2] = try decoder.decode([StripeBalance2].self, from: json)
//            print("stripeBalanceJson =\(stripeBalanceJson)")
//            for available in stripeBalanceJson {
//               print("available amound =\(available.available.amount)")
//            }
//
//
//        //let decoder = JSONDecoder()
//        //do {
//          //  let stripeBalanceJson: StripeBalance = try decoder.decode(StripeBalance.self, from: mybalance)
//
//            print("we are inside O")
////                    for available in stripeBalanceJson.available {
////
////                            print("available= \(available.amount)")
////                    let data = BalanceAmountCurrency(metricType: "outstandingTransferAmt", amount: available.amount, currency: available.currency)
////                    }
//
//
//
////                        print("available amount = \(available.amount)")
////                        let data = BalanceAmountCurrency(metricType: "outstandingTransferAmt", amount: available.amount, currency: available.currency)
////                         infoDataforInfoUIView.append(data)
////                        print("UI View Metric data = available \( infoDataforInfoUIView)")
//
//
//
////                    for pending in stripeBalanceJson.pending {
////                    print("pending amount = \(pending.amount)")
//////                        let data2 = StripeBalanceAmountCurrency(amount: pending.amount, currency: pending.currency)
//////                        stripeBalancePending.append(data2)
////
////                    let data2 = BalanceAmountCurrency(metricType: "pendingPayoutAmt", amount: pending.amount, currency: pending.currency)
////                         infoDataforInfoUIView.append(data2)
////                        print("UI View Metric data = pending \( infoDataforInfoUIView)")
////                    }
//
//    } catch {
//
//    }
//    }
    func jsonToString(json: Data){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    func getDataForInfoUIView(currencyCode: String){
        getRecipientTotalAmt()
        getSenderTotalAmount()
       // clearData()
        
        let request = Request(path: "/api/Profile/balance/\(profileId)", token: token!, apiKey: encryptedAPIKey)
        print("profileId = \(profileId)")
        print(" i am getting InfoUIView data")
        
        Network.shared.send(request) { [self] (result: Result<InfoBoardMetrics, Error>)  in
            switch result {
            case .success(let mybalance):
                print(mybalance.pending)
                infoBoardMetric.removeAll() //clear object
                
                if let pending = mybalance.pending {
                    let pending = mybalance.pending
                    for pending in mybalance.pending! {
                        let data1 = BalanceAmountCurrency(metricType: "pendingPayoutAmt", amount: pending.amount!, currency: pending.currency!)
                        infoBoardMetric.append(data1)
                        
                        print("the currency code is = \(pending.currency!)")
                    }
                    
                    print("pending is good \(pending)")
                } else {
//                    let pending = "Nothing - bad"
//                    print("pending is bad \(pending)")
//                    for pending in mybalance.pending! {
                    let data1 = BalanceAmountCurrency(metricType: "pendingPayoutAmt", amount: 0, currency: currencyCode)
                    infoBoardMetric.append(data1)
                    //}
                }
                //print("is pending empty \(mybalance.pending!.isEmpty)")
               
                if let available = mybalance.available {
                    for available in mybalance.available! {
                        let data2 = BalanceAmountCurrency(metricType: "outstandingTransferAmt", amount: available.amount!, currency: available.currency!)
                        infoBoardMetric.append(data2)
                    }
                } else  {
                    //for available in mybalance.available! {
                        let data2 = BalanceAmountCurrency(metricType: "outstandingTransferAmt", amount: 0, currency: currencyCode)
                        infoBoardMetric.append(data2)
                    //}
                }
                    
                
                print("infoBoardMetric =\(infoBoardMetric)")
                for i in infoBoardMetric {
                    print("metrictype =\(i.metricType)")
                    print("amount = \(i.amount)")
                    print("currentcy = \(i.currency)")
                }
                print("I am inside Info again")
              
                
                for item in self.infoBoardMetric {
                    print("i am inside infoBoardMetric ")
                    if item.metricType == "outstandingTransferAmt" {
                        outstandingTransferAmt = String(item.amount)
                        currency = item.currency
                    }
                
                   
                    if item.metricType == "pendingPayoutAmt" {
                        pendingPayoutAmt2 = String(item.amount)
                        currency = item.currency
                    }
                }
                getMyEvents()
            case .failure(let error):
                
                /*4/22 this is a temporary solution - when a user doesn't
                have pending transfer, the object structure looks like this...
                 the null value is causing this to break... need to talk to Karl about changing this... in the meantime, I am going to hardcode the value
                 {
                     "available": null,
                     "pending": null,
                     "success": false,
                     "errorCode": null,
                     "errorMessage": null
                 }*/
                infoBoardMetric.removeAll() //clear object
                //for pending in mybalance.pending {
                    let data1 = BalanceAmountCurrency(metricType: "pendingPayoutAmt", amount: 0, currency: currencyCode)
                    infoBoardMetric.append(data1)
               // }
                
                //for available in mybalance.available {
                    let data2 = BalanceAmountCurrency(metricType: "outstandingTransferAmt", amount: 0, currency: currencyCode)
                    infoBoardMetric.append(data2)
                //}
                
                print("infoBoardMetric =\(infoBoardMetric)")
                for i in infoBoardMetric {
                    print("metrictype =\(i.metricType)")
                    print("amount = \(i.amount)")
                    print("currentcy = \(i.currency)")
                }
                print("I am inside Info again")
              
                
                for item in self.infoBoardMetric {
                    print("i am inside infoBoardMetric ")
                    if item.metricType == "outstandingTransferAmt" {
                        outstandingTransferAmt = String(item.amount)
                        currency = item.currency
                    }
                
                   
                    if item.metricType == "pendingPayoutAmt" {
                        pendingPayoutAmt2 = String(item.amount)
                        currency = item.currency
                    }
                }
                getMyEvents()
                print(" balance failed DOMINIC G IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }
    
    
    func getSenderTotalAmount() {
      
        //clear object data
        //eventmetricsspraydetails.removeAll()
        
        let request = Request(path: "/api/SprayTransaction/sendertotal/\(profileId)/0", token: token!, apiKey: encryptedAPIKey)

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
        case .success(let sprayData):
        let decoder = JSONDecoder()
            do {
                let sprayDetailJson: sEventMetricsSprayData  = try decoder.decode(sEventMetricsSprayData.self, from: sprayData)
                
              
                
                totalGiftedAmt = String(sprayDetailJson.totalAmountGifted)
//                for sprayData in  sprayDetailJson.recipientList {
//                    switch isForSearch {
//                    case true:
//                        let data1 = EventMetricsSprayDetails(lastName: sprayData.lastName, firstName: sprayData.firstName, totalAmount: sprayData.totalAmount, recordType: "Receiver")
//
//                        eventmetricsspraydetails2.append(data1)
//                    case false:
//                        let data1 = EventMetricsSprayDetails(lastName: sprayData.lastName, firstName: sprayData.firstName, totalAmount: sprayData.totalAmount, recordType: "Receiver")
//
//                        eventmetricsspraydetails.append(data1)
//                    default:
//                        break
//                    }
//
//
//                }
                
                
            } catch {
                totalGiftedAmt = "0"
                print(error)
            }
            
        case .failure(let error):
            print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
        }
    }
    }
    
    func getRecipientTotalAmt() {
      
        //eventmetricsspraydetails.removeAll()
        let request = Request(path: "/api/SprayTransaction/recipienttotal/\(profileId)/0", token: token!, apiKey: encryptedAPIKey)

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
        case .success(let sprayData):
        let decoder = JSONDecoder()
            do {
                let sprayDetailJson: rEventMetricsSprayData  = try decoder.decode(rEventMetricsSprayData.self, from: sprayData)
                
                totalGiftReceivedAmt = String(sprayDetailJson.totalAmountReceived)
//                for sprayData in  sprayDetailJson.senderList {
//
//                    switch isForSearch {
//                    case true:
//
//                        let data1 = EventMetricsSprayDetails(lastName: sprayData.lastName, firstName: sprayData.firstName, totalAmount: sprayData.totalAmount, recordType: "Sender")
//                        eventmetricsspraydetails2.append(data1)
//                    case false:
//                        let data1 = EventMetricsSprayDetails(lastName: sprayData.lastName, firstName: sprayData.firstName, totalAmount: sprayData.totalAmount, recordType: "Sender")
//                        eventmetricsspraydetails.append(data1)
//                    default:
//                        break
//                    }
//
//
//
//                }
            } catch {
                totalGiftReceivedAmt = "0"
                print(error)
            }
            
           // tableView.reloadData()
      
        case .failure(let error):
            print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
        }
    }
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
    
    func setStatusBarColor() {
        if #available(iOS 13.0, *) {


               let statusBar1 =  UIView()
               statusBar1.frame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager!.statusBarFrame as! CGRect
               statusBar1.backgroundColor = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0) //UIColor.white

               UIApplication.shared.keyWindow?.addSubview(statusBar1)
    
            } else {

               let statusBar1: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
               statusBar1.backgroundColor = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)
                //UIColor.white
               
            }

    }
    //calling this on viewdid load
    func getProfileData(profileId: Int64) {
        print("getProfileData")
        let request = Request(path: "/api/Profile/\(profileId)", token: token!, apiKey: encryptedAPIKey)
        
        print("request=\(request)")
        Network.shared.send(request) { [self] (result: Result<ProfileData2, Error>)  in
        switch result {
        case .success(let profileData):
            print("PROFILE SUCCESS")
            //self.eventOwnerName = profileData.firstName
            self.isPaymentMethodGeneralAvailable = profileData.hasValidPaymentMethod
            self.generalPaymentMethodId = profileData.defaultPaymentMethod
            self.avatar = profileData.firstName
            self.displayName = profileData.firstName
//            self.paymentCustomerId = profileData.paymentCustomerId!
//            self.paymentConnectedActId = profileData.paymentConnectedActId!
            
            print("profileData.paymentConnectedActId \(profileData.paymentConnectedActId)")
            print("profileData.paymentCustomerId! \(profileData.paymentCustomerId!)")
            
            print("getProfileData Was successful")
            
//            if self.paymentConnectedActId.isNil {
//                print("paymentConnectedActId is NILL")
//                self.paymentConnectedActId = ""
//
//            }
//
//
//            if self.paymentCustomerId.isNil {
//                self.paymentCustomerId = ""
//                print("paymentCustomerId = \(paymentCustomerId)")
//            }
           
            if let iAvatar = profileData.avatar  {
                let dataString = iAvatar
                
                let dataURL = URL(string: dataString)
                let contents: String?
                do {
                    contents = try String(contentsOf: dataURL!)
                    //contents = try Data(contentsOf: someURL)
                    print("image 1 = \(profileData.avatar!)")
                    //originalAvatar = profileData.avatar!
                } catch {
                    contents = "dominic"
                   // print("image 2 = \(profileData.avatar!)")
                    //originalAvatar = profileData.avatar!
                }
                
                //let image = UIImage(data: data)
                
                //myAvatar.image = UIImage(named: contents!)
                
                let results = dataString.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
                for imageString in results {
                    autoreleasepool {
                        
                        let image2 = imageString.base64ToImage()
                        //myAvatar.image = image2

                    }
                
                }
                
//            } else {
//                myAvatar.image = UIImage(named: "userprofile")
            }
            
            
//            let imageData = Data.init(base64Encoded: profileData.avatar!, options: .init(rawValue: 0))
////               let image = UIImage(data: imageData!)
////               return image!
//            myAvatar.image = UIImage(data: imageData!)
            
            break
        case .failure(let error):
            print("PROFILE FAILED")
           //self.textLabel.text = error.localizedDescription
        print(" DOMINIC C IGHEDOSA ERROR \(error.localizedDescription)")
            self.eventOwnerName = "Not Identified..."
                    
            }
                  
        }
         //print(profiledata)
    }
    
    //calling this on viewdid load
    func getOtherProfileData(profileId: Int64) {
        print("getOtherProfileData")
        let request = Request(path: "/api/Profile/\(profileId)", token: token!, apiKey: encryptedAPIKey)
        
        print("request=\(request)")
        Network.shared.send(request) { [self] (result: Result<ProfileData2, Error>)  in
        switch result {
        case .success(let profileData):
            self.eventOwnerName = profileData.firstName
            
            print("OWNER NAME WHEN JOINED EVENT AFTER AUTHENTICAION \(self.eventOwnerName)")

//            if let iAvatar = profileData.avatar  {
//                let dataString = iAvatar
//
//                let dataURL = URL(string: dataString)
//                let contents: String?
//                do {
//                    contents = try String(contentsOf: dataURL!)
//                    //contents = try Data(contentsOf: someURL)
//                    print("image 1 = \(profileData.avatar!)")
//                    //originalAvatar = profileData.avatar!
//                } catch {
//                    contents = "dominic"
//                   // print("image 2 = \(profileData.avatar!)")
//                    //originalAvatar = profileData.avatar!
//                }
//
//                //let image = UIImage(data: data)
//
//                //myAvatar.image = UIImage(named: contents!)
//
//                let results = dataString.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
//                for imageString in results {
//                    autoreleasepool {
//
//                        let image2 = imageString.base64ToImage()
//                        //myAvatar.image = image2
//
//                    }
//
//                }
//
////            } else {
////                myAvatar.image = UIImage(named: "userprofile")
//            }
//
            
//            let imageData = Data.init(base64Encoded: profileData.avatar!, options: .init(rawValue: 0))
////               let image = UIImage(data: imageData!)
////               return image!
//            myAvatar.image = UIImage(data: imageData!)
            
            break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
        print(" DOMINIC D IGHEDOSA ERROR \(error.localizedDescription)")
            self.eventOwnerName = "Not Identified..."
                    
            }
                  
        }
         //print(profiledata)
    }
    
    //check if payment method exist for event Id from scan that was scanned
    //this is temporary - 3/17 i will remove this in the future because this flag will be part of the QR code
    func getPrefData() {
        
        print("checkIfPaymentMethodExist-1")
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        let request = Request(path: "/api/Event/prefs/\(profileId)/0", token: token!, apiKey: encryptedAPIKey)
       // let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token!)
        print("request = \(request)")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    print("A")
                    
                    print("checkIfPaymentMethodExist-2")
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                       
                        for eventPrefData in eventPreferenceJson {
                            if eventPrefData.paymentMethod > 0 {
                                print("eventPrefData.paymentMethod > 0")
                                //if eventPrefData.defaultEventPaymentMethod > 0 {
                                    self.isPaymentMethodAvailable2 = true
                                //} else {
                                   // self.isPaymentMethodAvailable2 = false
                                //}
                                
                                self.generalPaymentMethodId = eventPrefData.paymentMethod
                               
                                self.sprayAmount = eventPrefData.maxSprayAmount
                                self.isReplenish =  eventPrefData.isAutoReplenish
                                self.replenishAmount = eventPrefData.replenishAmount
                                //self.self.isPaymentMethodAvailable2 = eventPrefData.h
                                print("checkIfPaymentMethodExist-3")
                                break
                            } else {
                                //self.generalPaymentMethodId = eventPrefData.paymentMethod
                                self.isPaymentMethodAvailable2 = self.isPaymentMethodGeneralAvailable
                                self.sprayAmount = 0
                                self.isReplenish = false
                                self.replenishAmount = 0
                                //self.self.isPaymentMethodAvailable2 = eventPrefData.h
                                print("checkIfPaymentMethodExist-3")
                            }

                        }
            
                    } catch {
                        print(error)
                    }
                    
                    if self.isPaymentMethodGeneralAvailable == true {
                        //call launch goSpray
                        if self.sprayAmount == 0 {
                            print("checkIfPaymentMethodExist-4")
                            //call method to insert default payment and spray amounnt
                            self.addGeneralEventPaymentPref(updatedGiftAmount: 10, updatedAutoReplenishAmount: 0, updatedAutoReplenishFlag: false, updatedPaymentMethodId: self.generalPaymentMethodId, currencycode: "usd", isPaymentMethodAvailable: self.isPaymentMethodAvailable2)
                            //call goSpray
                            self.launchGotoSprayVC(updatedGiftAmount: self.sprayAmount, updatedAutoReplenishAmount:  self.replenishAmount, updatedAutoReplenishFlag: self.isReplenish, updatedPaymentMethodId: self.generalPaymentMethodId, currencycode: currencyCode, isPaymentMethodAvailable: self.isPaymentMethodAvailable2, country: "")
                        } else {
                            //call goSpray
                            print("checkIfPaymentMethodExist-5")
                            self.launchGotoSprayVC(updatedGiftAmount: self.sprayAmount, updatedAutoReplenishAmount:  self.replenishAmount, updatedAutoReplenishFlag: self.isReplenish, updatedPaymentMethodId: self.generalPaymentMethodId, currencycode: currencyCode, isPaymentMethodAvailable: self.isPaymentMethodAvailable2, country: "")
                        }
                    } else  {
                        //if no payment method ask the use add
                        let alert2 = UIAlertController(title: "Need Payment Method", message: "You currently do not have a Payment Method selected for this Event. A Payment Metheod is required to participate in the fun of Spraying. Would you like to add a Payment Method?", preferredStyle: .alert)

                        //alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: nil))
                        var isSingleReceiverEvent: Bool?
                        if self.isSingleReceiverEventStr == "true" {
                            isSingleReceiverEvent = true
                        } else {
                            isSingleReceiverEvent = false
                        }
                        alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: { [self] (action) in self.launchEventPaymentScreen(eventId2: eventId, eventName2: eventName, eventDateTime2: eventDateTime, completionAction: "gotospray", eventTypeIcon: eventTypeIcon2, isPaymentMethodAvailable: false, hasPaymentMethod: false, isRsvprequired: false, isSingleReceiver: isSingleReceiverEvent!, defaultEventPaymentMethod: generalPaymentMethodId, defaultEventPaymentCustomName: generalDefaultPaymentCustomName, country: "")}))
                        alert2.addAction(UIAlertAction(title: "No, Not Yet", style: .cancel, handler: nil))
                     
                        self.present(alert2, animated: true)
                    }
                    
                case .failure(let error):
                print(" DOMINIC E IGHEDOSA 1 ERROR \(error.localizedDescription)")
                    print("checkIfPaymentMethodExist-error")
            }
        }
    }
    
    func addGeneralEventPaymentPref(updatedGiftAmount: Int, updatedAutoReplenishAmount: Int, updatedAutoReplenishFlag: Bool, updatedPaymentMethodId: Int, currencycode: String, isPaymentMethodAvailable: Bool) {
        print("checkIfPaymentMethodExist-6")
        let addEventPreference = EventPreference(eventId: eventId, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencycode)

        print("ADD EVENT DOMINC PREFERENCE \(addEventPreference)")
    
    
        
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token!, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print("AWELE -- \(eventpref)");
                
                //self.completionAlert(message: "Update Was Successful", timer: 1)
                //close payment window
                print("checkIfPaymentMethodExist-8")
                self.launchGotoSprayVC(updatedGiftAmount: updatedGiftAmount, updatedAutoReplenishAmount: updatedAutoReplenishAmount, updatedAutoReplenishFlag: updatedAutoReplenishFlag, updatedPaymentMethodId: updatedPaymentMethodId, currencycode: currencycode, isPaymentMethodAvailable: self.isPaymentMethodAvailable2, country: "")
                break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }

    }
    
    func launchGotoSprayVC(updatedGiftAmount: Int, updatedAutoReplenishAmount: Int, updatedAutoReplenishFlag: Bool, updatedPaymentMethodId: Int, currencycode: String, isPaymentMethodAvailable: Bool, country: String) {
        
        print("checkIfPaymentMethodExist-9")
        print("ThIS IS A SINGLE RECEIVER EVENT \(eventType)")
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "GoSprayViewController") as! GoSprayViewController
        //hold for now 1/29/2021
       //                let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectAttendeeToSprayViewController") as! SelectAttendeeToSprayViewController
       //
       //                    nextVC.eventName = eventName
       //                    nextVC.eventDateTime = eventDateTime
       //                    nextVC.eventCode = eventCode
       
        print("launch go to sprayVC was called isPaymentMethodAvailable = \(isPaymentMethodAvailable)")
        nextVC.eventId = eventId
        nextVC.eventOwnerName = eventOwnerName
        nextVC.eventOwnerProfileId = eventOwnerId
        nextVC.profileId = profileId
        nextVC.token = token!
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.completionAction = completionAction
        nextVC.receiverName = "" //eventOwnerName - hold for now 3/20
        nextVC.refreshscreendelegate = self
        nextVC.sprayAmount = updatedGiftAmount
        nextVC.autoReplenishAmount = updatedAutoReplenishAmount
        nextVC.isAutoReplenishFlag = updatedAutoReplenishFlag
        nextVC.isPaymentMethodAvailable = isPaymentMethodAvailable
        nextVC.processspraytrandelegate = self
        nextVC.haspaymentdelegate = self
        nextVC.currencyCode = currencycode
        nextVC.country = country
        print("launchGotoSprayV country = \(country)")
        
       //                    nextVC.eventTypeIcon = eventTypeIcon
       //                    nextVC.paymentClientToken = paymentClientToken
                   
        self.navigationController?.pushViewController(nextVC , animated: true)
        //}

    }
    

    
    //when user select back button after editing the EventSettingViewController
    func getEventTypeName(eventTypeId: Int) -> String {
           for e in eventtypeData {
            if e.id == eventTypeId {
                let eventTypeName = e.eventTypeName
                   return eventTypeName
                  
               } else {
                 
               }
           }
           return ""
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
    
    func clearData(){
        eventsownedmodel.removeAll()
        eventsinvitedmodel.removeAll()
        eventsattendingmodel.removeAll()
        homescreeneventdata.removeAll()
        eventIdsattendingmodel.removeAll()
        isAttending.removeAll()
        isattendingdata.removeAll()
        
        //getMyEvents()
    }
    
    
    @IBAction func inviteButtonPressed(_ sender: Any) {
        let vc = InviteFriendViewController(nibName: "InviteFriendViewController", bundle: nil)
        //vc.messageLabel?.text  = "Next level blog photo booth, tousled authentic tote bag kogi"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func testFunctionWithNoEscapingClosure(myClosure:() -> Void) {
        print("function called")
        myClosure()
        return
    }


    //function call
//    testFunctionWithNoEscapingClosure(eventId: Int64) {
//        print("closure called")
//        var isPaymentMethodForEvent: Bool = false
//        let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId)", token: token!)
//
//        Network.shared.send(request) { (result: Result<Data, Error>)   in
//            switch result {
//                case .success(let eventPreferenceData):
//                    let decoder = JSONDecoder()
//                    do {
//                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
//                        for eventPrefData in eventPreferenceJson {
//                            if eventPrefData.paymentMethodDetails.paymentMethodId > 0{
//                                print("paymentMethodId > 0 \(eventPrefData.paymentMethodDetails.paymentMethodId )  eventId = \(eventId)")
//                                isPaymentMethodForEvent = true
//                                break
//                            } else {
//                                isPaymentMethodForEvent = false
//                            }
//                        }
//
//                    } catch {
//                        print(error)
//                    }
//
//                case .failure(let error):
//                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
//            }
//        }
//
//    }
//
        //hold for now... 3/17 was using to get haspyment flag..now getting this from the profile objec
//    func checkIfGeneralEventPaymentMethod(profileId: Int64)  {
//        let request = Request(path: "/api/Event/prefs/\(profileId)/0", token: token!)
//
//        print("request \(request)")
//        Network.shared.send(request) { (result: Result<Data, Error>)   in
//            switch result {
//                case .success(let eventPreferenceData):
//                    print("I am here 1")
//                    let decoder = JSONDecoder()
//                    do {
//                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
//                        print("I am here 2")
//                        if eventPreferenceJson.count > 0 {
//                            self.isPaymentMethodGeneralAvailable = true
//                            //let a = true
//                            print("self.isPaymentMethodGeneralAvailable  = true \(self.isPaymentMethodGeneralAvailable)")
//                            break
//                        }
//
//                    } catch {
//                        print(error)
//                    }
//
//                case .failure(let error):
//                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
//            }
//        }
//    }

    
    //moving to loginViewController - will followup late 1/26/21
    func checkEventPayment(eventId: Int64) -> Bool {
        var isPaymentMethodForEvent: Bool = false
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        
        print("before isPaymentMethodForEvent = \(isPaymentMethodForEvent)")
        func getEventPaymentMethod() -> Bool {

            let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token!, apiKey: encryptedAPIKey)

            Network.shared.send(request) { (result: Result<Data, Error>)   in
                switch result {
                    case .success(let eventPreferenceData):
                        let decoder = JSONDecoder()
                        do {
                            let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                            for eventPrefData in eventPreferenceJson {
                                if eventPrefData.paymentMethodDetails.paymentMethodId == 9 {
                                    print("paymentMethodId > 0 \(eventPrefData.paymentMethodDetails.paymentMethodId )  eventId = \(eventId)")
                                    isPaymentMethodForEvent = true
                                    print("paymentmethod >=21 During  \(isPaymentMethodForEvent)")
                                    break
                                } else {
                                    //setting to true temporarily 3/2
                                    isPaymentMethodForEvent = true
                                    print("paymentmethod < 21 During  \(isPaymentMethodForEvent)")
                                }
                            }

                        } catch {
                            print(error)
                        }

                    case .failure(let error):
                    print(" DOMINIC F IGHEDOSA 1 ERROR \(error.localizedDescription)")
                }
            }
            print("paymentmethod AFTER \(isPaymentMethodForEvent)")
            return isPaymentMethodForEvent
        }


        return getEventPaymentMethod()
    }
    func getMyEvents(){
        
        clearData()
        
        let request = Request(path: "/api/Event/myevents?profileid=\(profileId)", token: token!, apiKey: encryptedAPIKey)
        print("encryptedAPIKey from homescreen \(encryptedAPIKey)")
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success(let event):
                //populate data for InfoView
                
                self.parse(json: event)
            case .failure(let error):
                print(" DOMINIC G IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }
    
    
    func checkIfEventIsRSVP(mydata: [Int], eventId: Int64) -> Bool {
        var foundIt: Bool = false
        for i in mydata {
            if i == Int(eventId) {
                foundIt = true
                break
                
            }
        }
        return foundIt
    }
    //***** hold this for later *****
    
    func parse(json: Data) {
        print("parse JSON was calle \(json.count)")
        //eventjson.result.eventsOwned
        
       
         //let dataCollection0 = EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, eventType: eventType, isAttending: nil, dataCategory: "Info", hasPaymentMethod: hasPaymentMethod)
        
        let dataCollection0 = EventProperty(eventId: 0, ownerId: 0, name: "", dateTime: "", address1: "", address2: "", city: "", zipCode: "", country: "", state: "", eventState: 1, eventCode: "", isActive: true, eventType: 1, isRsvprequired: true, isSingleReceiver: false, isForBusiness: false, defaultEventPaymentMethod: 0, defaultEventPaymentCustomName: "", isAttending: false, dataCategory: "info", hasPaymentMethod: false, outstandingTransferAmt1: outstandingTransferAmt, pendingPayoutAmt1: pendingPayoutAmt2, totalGiftedAmt1: self.totalGiftedAmt, totalReceivedAmt1: totalGiftReceivedAmt, currency1: currencyCode, paymentCustomerId1: paymentCustomerId, paymentConnectedActId1: paymentCustomerId)
        homescreeneventdata.append(dataCollection0)
        //print("MY COUNTER = \(j) = \(dataCollection0)")
        //eventsownedmodel.append(dataCollection)
        
//        var outstandingTransferAmt: String = ""
//        var pendingPayountAmt: String = ""
//        var totalGiftedAmt: String = ""
//        var totalGiftReceivedAmt: String = ""
        
        
        let currentDateTime = getFormattedDateToDate(dateinput: Date.getCurrentDate())
       
        let decoder = JSONDecoder()
        
        do {
            
            let eventjson = try decoder.decode(EventListModel.self, from: json)
//                let isActive = eventjson.result.eventsOwned[i].isActive
            var j: Int = 0
          
                for i in eventjson.result.eventsOwned {
                    j = j + 1
                    if i.isActive == true {
                        
                        print("I am in eventsOwned")
                        let eventDateTime =  getFormattedDateToDate(dateinput: i.dateTime)
                        print(" eventDateTime \( eventDateTime) and currentDate = \(currentDateTime)")
                        if eventDateTime >= currentDateTime  {
                            print("QRCodeScan eventsOwned = \(QRCodeScan) - \(i.country)")
                            
                            let eventId = i.eventId// eventjson[i].result.eventsOwned[i].eventId
                            let ownerId = i.ownerId //eventjson[i].result.eventsOwned[i].ownerId
                            let name = i.name //eventjson[i].result.eventsOwned[i].name
                            let dateTime = i.dateTime //eventjson[i].result.eventsOwned[i].dateTime
                            let address1 = i.address1 //eventjson[i].result.eventsOwned[i].address1
                            let address2 = i.address2 //eventjson[i].result.eventsOwned[i].address2
                            let city = i.city //eventjson[i].result.eventsOwned[i].city
                            let zipCode = i.zipCode //eventjson[i].result.eventsOwned[i].zipCode
                            let country = i.country //eventjson[i].result.eventsOwned[i].country
                            let state = i.state //eventjson[i].result.eventsOwned[i].state
                            let eventState = i.eventState //eventjson[i].result.eventsOwned[i].eventState
                            let eventCode = i.eventCode //eventjson[i].result.eventsOwned[i].eventCode
                            let isActive = i.isActive //eventjson[i].result.eventsOwned[i].isActive
                            let eventType = i.eventType
                            let isRsvprequired = i.isRsvprequired
                            let isSingleReceiver = i.isSingleReceiver
                            var forBusiness: Bool = false
                            if let isForBusiness = i.isForBusiness {
                                forBusiness = isForBusiness
                            } else {
                                forBusiness = false
                            }
                            let defaultEventPaymentMethod =  i.defaultEventPaymentMethod
                            let defaultEventPaymentCustomName = i.defaultEventPaymentCustomName
                            let hasPaymentMethod = false
                            let currencyCode = getPaymentMethodCurrency(paymentMethodId: Int64(i.defaultEventPaymentMethod!))
                            
                            let dataCollection = EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, eventType: eventType, isRsvprequired: isRsvprequired!, isSingleReceiver: isSingleReceiver!, isForBusiness: forBusiness, defaultEventPaymentMethod: defaultEventPaymentMethod, defaultEventPaymentCustomName: defaultEventPaymentCustomName, isAttending: nil, dataCategory: "owned", hasPaymentMethod: hasPaymentMethod, outstandingTransferAmt1: self.outstandingTransferAmt, pendingPayoutAmt1: pendingPayoutAmt2, totalGiftedAmt1: self.totalGiftedAmt, totalReceivedAmt1: totalGiftReceivedAmt, currency1: currencyCode, paymentCustomerId1: paymentCustomerId, paymentConnectedActId1: paymentCustomerId)
                         
                            homescreeneventdata.append(dataCollection)
                            print("MY COUNTER = \(j) = \(dataCollection)")
                            //eventsownedmodel.append(dataCollection)
                        }
                      

                    }
            }
            

           
            
            
            for item in eventjson.result.eventIdsAttending {
                eventIdsattendingmodel.append(item)
                
            }
            
//            print("eventIdsattendingmodel.count is GREAT THAN \(eventIdsattendingmodel.count )")
//            if eventIdsattendingmodel.count > 0 {
//                print("GALVESTON")
//                for eventid in eventIdsattendingmodel {
//                    print("HOUSTON")
//                    print("eventIds attending = \(eventid)")
//
////                    for x in eventjson.result.eventsInvited {
////                        print("KEMAH --- \(x.name)")
////                        if x.isActive == true  {
////
////                            //call the checkIfEventIsRSVP function to see eventId exist in the attending array of objects
////                            //if so, don't add the invited array of objects
////                            let wefoundIt = checkIfEventIsRSVP(mydata: eventIdsattendingmodel, eventId: x.eventId)
////                            if wefoundIt == false {
////                                print("WefoundIt = \(wefoundIt) --- eventId = \(x.eventId)")
////                                print("eventIds doe not equal each other = \(x.eventId)")
////                                let eventId = x.eventId// eventjson[i].result.eventsOwned[i].eventId
////                                let ownerId = x.ownerId //eventjson[i].result.eventsOwned[i].ownerId
////                                let name = x.name //eventjson[i].result.eventsOwned[i].name
////                                let dateTime = x.dateTime //eventjson[i].result.eventsOwned[i].dateTime
////                                let address1 = x.address1 //eventjson[i].result.eventsOwned[i].address1
////                                let address2 = x.address2 //eventjson[i].result.eventsOwned[i].address2
////                                let city = x.city //eventjson[i].result.eventsOwned[i].city
////                                let zipCode = x.zipCode //eventjson[i].result.eventsOwned[i].zipCode
////                                let country = x.country //eventjson[i].result.eventsOwned[i].country
////                                let state = x.state //eventjson[i].result.eventsOwned[i].state
////                                let eventState = x.eventState //eventjson[i].result.eventsOwned[i].eventState
////                                let eventCode = x.eventCode //eventjson[i].result.eventsOwned[i].eventCode
////                                let isActive = x.isActive //eventjson[i].result.eventsOwned[i].isActive
////                                let eventType = x.eventType
////                                let isRsvprequired = x.isRsvprequired
////                                let isSingleReceiver = x.isSingleReceiver
////                                let defaultEventPaymentMethod =  x.defaultEventPaymentMethod
////                                let defaultEventPaymentCustomName = x.defaultEventPaymentCustomName
////
////                                let hasPaymentMethod = false //checkEventPayment(eventId: x.eventId)
////                                let dataCollection2 = EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, eventType: eventType, isRsvprequired: isRsvprequired!, isSingleReceiver: isSingleReceiver!, defaultEventPaymentMethod: defaultEventPaymentMethod, defaultEventPaymentCustomName: defaultEventPaymentCustomName, isAttending: nil, dataCategory: "invited", hasPaymentMethod: hasPaymentMethod)
////                                homescreeneventdata.append(dataCollection2)
////                                //eventsinvitedmodel.append(dataCollection2)
////
////                            }
////                        }
//                    //}
//                }
//            } else {
                //do this is invite has not been RSVP
            for x in eventjson.result.eventsInvited {
                if x.isActive == true {
                    /* this contain method seem to work to remove events that a person has already RSVP for few more events are still show - iOS Destruction party and Brian Birthday - need to talk to Karl about why they are still showing 3/19/21*/
                    if eventIdsattendingmodel.contains(Int(x.eventId)) == false {
                        
                        let eventDateTime =  getFormattedDateToDate(dateinput: x.dateTime!)
                        print(" eventDateTime \( eventDateTime) and currentDate = \(currentDateTime)")
                        if eventDateTime >= currentDateTime  {
                            print("I am in eventsInvited")
                            print("Idsattending count = 0 ")
                            print("QRCodeScan eventsInvited = \(QRCodeScan) - \(x.country)")
                            let eventId = x.eventId// eventjson[i].result.eventsOwned[i].eventId
                            let ownerId = x.ownerId //eventjson[i].result.eventsOwned[i].ownerId
                            let name = x.name //eventjson[i].result.eventsOwned[i].name
                            let dateTime = x.dateTime //eventjson[i].result.eventsOwned[i].dateTime
                            let address1 = x.address1 //eventjson[i].result.eventsOwned[i].address1
                            let address2 = x.address2 //eventjson[i].result.eventsOwned[i].address2
                            let city = x.city //eventjson[i].result.eventsOwned[i].city
                            let zipCode = x.zipCode //eventjson[i].result.eventsOwned[i].zipCode
                            let country = x.country //eventjson[i].result.eventsOwned[i].country
                            let state = x.state //eventjson[i].result.eventsOwned[i].state
                            let eventState = x.eventState //eventjson[i].result.eventsOwned[i].eventState
                            let eventCode = x.eventCode //eventjson[i].result.eventsOwned[i].eventCode
                            let isActive = x.isActive //eventjson[i].result.eventsOwned[i].isActive
                            let eventType = x.eventType
                            let isRsvprequired = x.isRsvprequired
                            let isSingleReceiver = x.isSingleReceiver
                            //let isForBusiness = x.isForBusiness
                            var forBusiness: Bool = false
                            if let isForBusiness = x.isForBusiness {
                                forBusiness = isForBusiness
                            } else {
                                forBusiness = false
                            }
                            let defaultEventPaymentMethod =  x.defaultEventPaymentMethod
                            let defaultEventPaymentCustomName = x.defaultEventPaymentCustomName
                            let hasPaymentMethod = false //checkEventPayment(eventId: x.eventId)
                            let currencyCode = getPaymentMethodCurrency(paymentMethodId: Int64(x.defaultEventPaymentMethod!))
                            let dataCollection2 = EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, eventType: eventType, isRsvprequired: isRsvprequired!, isSingleReceiver: isSingleReceiver!, isForBusiness: forBusiness, defaultEventPaymentMethod: defaultEventPaymentMethod, defaultEventPaymentCustomName: defaultEventPaymentCustomName, isAttending: nil, dataCategory: "invited", hasPaymentMethod: hasPaymentMethod, outstandingTransferAmt1: self.outstandingTransferAmt, pendingPayoutAmt1: pendingPayoutAmt2, totalGiftedAmt1: self.totalGiftedAmt, totalReceivedAmt1: totalGiftReceivedAmt, currency1: currencyCode, paymentCustomerId1: paymentCustomerId, paymentConnectedActId1: paymentCustomerId)
                            homescreeneventdata.append(dataCollection2)
                            //eventsinvitedmodel.append(dataCollection2)
                        }
                        
                    }
                }
            }
        //}
       
            
            print("eventjson.result.eventsAttending.count 1 = \(eventjson.result.eventsAttending.count)")
            for y in eventjson.result.eventsAttending {
                
                print("eventjson.result.eventsAttending.count 2 = \(eventjson.result.eventsAttending.count)")
                //print("y = \(y)")
                if y.isActive == true {
                    //find event with paymentMethod already assigned
                   
                    let eventDateTime =  getFormattedDateToDate(dateinput: y.dateTime!)
                    print(" eventDateTime \( eventDateTime) and currentDate = \(currentDateTime)")
                    if eventDateTime >= currentDateTime  {
                        print("I am in eventsAttending")
                        print("QRCodeScan eventsAttending = \(QRCodeScan) - \(y.country)")
                        let eventId = y.eventId// eventjson[i].result.eventsOwned[i].eventId
                        let ownerId = y.ownerId //eventjson[i].result.eventsOwned[i].ownerId
                        let name = y.name //eventjson[i].result.eventsOwned[i].name
                        let dateTime = y.dateTime //eventjson[i].result.eventsOwned[i].dateTime
                        let address1 = y.address1 //eventjson[i].result.eventsOwned[i].address1
                        let address2 = y.address2 //eventjson[i].result.eventsOwned[i].address2
                        let city = y.city //eventjson[i].result.eventsOwned[i].city
                        let zipCode = y.zipCode //eventjson[i].result.eventsOwned[i].zipCode
                        let country = y.country //eventjson[i].result.eventsOwned[i].country
                        let state = y.state //eventjson[i].result.eventsOwned[i].state
                        let eventState = y.eventState //eventjson[i].result.eventsOwned[i].eventState
                        let eventCode = y.eventCode //eventjson[i].result.eventsOwned[i].eventCode
                        let isActive = y.isActive //eventjson[i].result.eventsOwned[i].isActive
                        let eventType = y.eventType
                        let isRsvprequired = y.isRsvprequired
                        let isSingleReceiver = y.isSingleReceiver
                        //let isForBusiness = y.isForBusiness
                        var forBusiness: Bool = false
                        if let isForBusiness = y.isForBusiness {
                            forBusiness = isForBusiness
                        } else {
                            forBusiness = false
                        }
                        let defaultEventPaymentMethod =  y.defaultEventPaymentMethod
                        let defaultEventPaymentCustomName = y.defaultEventPaymentCustomName
                        let hasPaymentMethod = false //checkEventPayment(eventId: y.eventId)
                        let currencyCode = getPaymentMethodCurrency(paymentMethodId: Int64(y.defaultEventPaymentMethod!))
                        
                        
                        let dataCollection3 =  EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, eventType: eventType, isRsvprequired: isRsvprequired!, isSingleReceiver: isSingleReceiver!, isForBusiness: forBusiness, defaultEventPaymentMethod: defaultEventPaymentMethod, defaultEventPaymentCustomName: defaultEventPaymentCustomName, isAttending: nil, dataCategory: "attending", hasPaymentMethod: hasPaymentMethod, outstandingTransferAmt1: self.outstandingTransferAmt, pendingPayoutAmt1: pendingPayoutAmt2, totalGiftedAmt1: self.totalGiftedAmt, totalReceivedAmt1: totalGiftReceivedAmt, currency1: currencyCode, paymentCustomerId1: paymentCustomerId, paymentConnectedActId1: paymentConnectedActId)
                    
                    
                        
                        homescreeneventdata.append(dataCollection3)
                    }
                    
                   
                //eventsattendingmodel.append(dataCollection3)
                
                //y = y + 1
                
               // print(" EVENTS ATTENDDING  \(dataCollection3)")
                
                let data = isAttendingModel(profileId: profileId, eventId: eventId, category: "eventsAttending")
                
                isAttending.append(data)
                
                attendeeFlagWasSet = false
                    
                    print("eventIdsattendingmodel .count = \(eventIdsattendingmodel.count)")
                for eventidattending in eventIdsattendingmodel {
                    
                    print("eventidattending = \(eventidattending )")
                }
                    
                    
                
                }
            }
            
        } catch {

        }
        
    //comment this out for now 12/18/2020
//    let homescreeneventdata1 = HomeScreenEventDataModel(eventCategory: "My Events", eventProperty: eventsownedmodel)
//    let homescreeneventdata2 = HomeScreenEventDataModel(eventCategory: "My Invitations", eventProperty: eventsinvitedmodel)
//    let homescreeneventdata3 = HomeScreenEventDataModel(eventCategory: "My RSVP", eventProperty: eventsattendingmodel)
    //let homescreeneventdata4 = HomeScreenEventDataModel(eventCategory: "My RSVP Ids", eventProperty:   eventsIdattendingmodel)
    
     //hold for now 12/19/2020
//      if eventsownedmodel.count > 0 {
//          homescreeneventdata.append(homescreeneventdata1!)
//      }
//      if eventsinvitedmodel.count > 0 {
//          homescreeneventdata.append(homescreeneventdata2!)
//      }
//      if eventsattendingmodel.count > 0 {
//          homescreeneventdata.append(homescreeneventdata3!)
//      }
      
        //if eventsownedmodel.count == 0 && eventsinvitedmodel.count == 0 && eventsattendingmodel.count == 0   {
        if homescreeneventdata.count == 0 {
            performSegue(withIdentifier: "goToEmptyScreen", sender: self)

            
        } else {
            noActivityLabel.isHidden = true
        }
        
        LoadingStop()
        print("Loading Stop")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        print("eventIdsattendingmodel.count = \(eventIdsattendingmodel.count)")
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "test" {
            _ = segue.destination as? InviteFriendViewController
        }
        

        if let indexPathA = tableView.indexPathForSelectedRow {
            guard let destinationVC = segue.destination as? UpdateEventViewController else {return}
            let selectedRow = indexPathA.row
            destinationVC.eventName = homescreeneventdata[selectedRow].name!
            //destinationVC.eventName =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].name!
            
//            let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a"
            let myDate: String = homescreeneventdata[selectedRow].dateTime!
            //let dateoutput = dateFormatter.String(from:homescreeneventdata[indexPathA.section].eventProperty[selectedRow].dateTime!)
            
            //this is a temporation solution. it will not work if the input date does not
            //match the yyyy-mm-ddTHH:mm:ss date format
            //convert string to date
            var myEventDateTime: String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if dateFormatter.date(from: myDate) != nil {
                let datei = dateFormatter.date(from: myDate)
                //convert date back to string
                let df = DateFormatter()
                df.dateFormat = "E, d MMM yyyy HH:mm a"
                 myEventDateTime = df.string(from: datei!)
                        
            } else {
                myEventDateTime = myDate
            }
           
            
            
            destinationVC.eventDateTime = myEventDateTime //homescreeneventdata[indexPathA.section].eventProperty[selectedRow].dateTime!
            
//            destinationVC.eventZipCode =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].zipCode!
//            destinationVC.eventAddress1 =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].address1!
//            destinationVC.eventAddress2 =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].address2!
//            destinationVC.eventCity =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].city!
//            destinationVC.eventState =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].state!
//            destinationVC.eventCountry =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].country!
//            destinationVC.eventType  =  getEventTypeName(eventTypeId: homescreeneventdata[indexPathA.section].eventProperty[selectedRow].eventType! )
//            destinationVC.eventCode =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].eventCode!
//            destinationVC.eventStatus = homescreeneventdata[indexPathA.section].eventProperty[selectedRow].isActive
//            destinationVC.eventId =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].eventId
//            destinationVC.profileId =  profileId
//            destinationVC.token =  token
            
            destinationVC.eventZipCode =  homescreeneventdata[selectedRow].zipCode!
            destinationVC.eventAddress1 =  homescreeneventdata[selectedRow].address1!
            destinationVC.eventAddress2 =  homescreeneventdata[selectedRow].address2!
            destinationVC.eventCity =  homescreeneventdata[selectedRow].city!
            destinationVC.eventState =  homescreeneventdata[selectedRow].state!
            destinationVC.eventCountry =  homescreeneventdata[selectedRow].country!
            destinationVC.eventType  =  getEventTypeName(eventTypeId: homescreeneventdata[selectedRow].eventType! )
            destinationVC.eventCode =  homescreeneventdata[selectedRow].eventCode!
            destinationVC.eventStatus = homescreeneventdata[selectedRow].isActive
            destinationVC.eventId =  homescreeneventdata[selectedRow].eventId
            destinationVC.profileId =  profileId
            destinationVC.token =  token
            
        }
    }
    

    
    @objc func checkButtonTapped(_ sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPathB = self.tableView.indexPathForRow(at: buttonPosition)
        if indexPathB != nil {
            
            //print("I am here")
            
            let theEventName = homescreeneventdata[indexPathB!.row].name!
            let theEventDateTime = homescreeneventdata[indexPathB!.row].dateTime!
            let theEventCode = homescreeneventdata[indexPathB!.row].eventCode!
            let theEventId = homescreeneventdata[indexPathB!.row].eventId
            let theProfileId = profileId
            
            let inviteFriendsVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
            
            self.navigationController?.pushViewController(inviteFriendsVC, animated: true)
            
            inviteFriendsVC.eventName = theEventName
            inviteFriendsVC.eventDateTime = theEventDateTime
            inviteFriendsVC.eventCode = theEventCode
            inviteFriendsVC.eventId = theEventId
            inviteFriendsVC.profileId = theProfileId
            inviteFriendsVC.token = token!
            inviteFriendsVC.encryptedDeviceId = encryptedDeviceId
        }
        
    }
    
    
    @objc func checkButtonTapped3(_ sender: UIButton) {
       // print("I am here")
           let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
           let indexPathC = self.tableView.indexPathForRow(at: buttonPosition)
           if indexPathC != nil {
               
               //print("I am here")
               
               let theEventName = homescreeneventdata[indexPathC!.row].name!
               let theEventDateTime = homescreeneventdata[indexPathC!.row].dateTime!
               let theEventCode = homescreeneventdata[indexPathC!.row].eventCode!
               let theEventId = homescreeneventdata[indexPathC!.row].eventId
               let theProfileId = profileId
               
  
               let selectAttendeeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectAttendeeToSprayViewController") as! SelectAttendeeToSprayViewController
               self.navigationController?.pushViewController(selectAttendeeVC , animated: true)
               
               selectAttendeeVC.eventName = theEventName
               selectAttendeeVC.eventDateTime = theEventDateTime
               selectAttendeeVC.eventCode = theEventCode
               selectAttendeeVC.eventId = theEventId
               selectAttendeeVC.profileId = theProfileId
               selectAttendeeVC.token = token!
            selectAttendeeVC.paymentClientToken = paymentClientToken
               //self.performSegue(withIdentifier: "test", sender: sender)
           }
       }
    
    @objc func buttonAction(sender: Any) {

    }
    
    @IBAction func readyToSprayButtonPressed(_ sender: AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
                 let indexPathC = self.tableView.indexPathForRow(at: buttonPosition)
                 if indexPathC != nil {
                     
                     //print("I am here")
                     
                     let theEventName = homescreeneventdata[indexPathC!.row].name!
                     let theEventDateTime = homescreeneventdata[indexPathC!.row].dateTime!
                     let theEventCode = homescreeneventdata[indexPathC!.row].eventCode!
                     let theEventId = homescreeneventdata[indexPathC!.row].eventId
                     let theProfileId = profileId
                     
        
                     let selectAttendeeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectAttendeeToSprayViewController") as! SelectAttendeeToSprayViewController
                     self.navigationController?.pushViewController(selectAttendeeVC , animated: true)
                     
                     selectAttendeeVC.eventName = theEventName
                     selectAttendeeVC.eventDateTime = theEventDateTime
                     selectAttendeeVC.eventCode = theEventCode
                     selectAttendeeVC.eventId = theEventId
                     selectAttendeeVC.profileId = theProfileId
                     selectAttendeeVC.token = token!
                     
                     //self.performSegue(withIdentifier: "test", sender: sender)
                 }
       }
    @IBAction func eventSettingButtonTapped(_ sender: AnyObject) {
        let buttonPosition2 = sender.convert(CGPoint.zero, to: self.tableView)
     let indexPathE = self.tableView.indexPathForRow(at: buttonPosition2)
     if indexPathE != nil {

        //hold for now 1/22/21
//        let theEventName = homescreeneventdata[indexPathE!.row].name!
//        let theEventId = homescreeneventdata[indexPathE!.row].eventId
//

        //print("The event name \(theEventName)")
//         let selectRSVPVC = self.storyboard?.instantiateViewController(withIdentifier: "EventSettingViewController") as! EventSettingViewController
//         self.navigationController?.pushViewController(selectRSVPVC , animated: true)
//
        let selectRSVPVC = self.storyboard?.instantiateViewController(withIdentifier: "RSVPViewController") as! RSVPViewController
        self.navigationController?.pushViewController(selectRSVPVC , animated: true)
       
        
        //hold for now 1/22/21
//        selectRSVPVC.eventId = theEventId
//        selectRSVPVC.eventName = theEventName
//        selectRSVPVC.token = token!
//        selectRSVPVC.paymentClientToken =  paymentClientToken
//        selectRSVPVC.profileId = profileId!

     }
    }
    
    @IBAction func shareBtnPressed(_ sender: AnyObject) {
        
        
    }
    
  
    func convertDateFormatter(date: String) -> String {
        var incomingDate: String?
            incomingDate = date
        let index = incomingDate!.firstIndex(of: ".") ?? incomingDate!.endIndex
        let finalDate = incomingDate![..<index]
        //print("finalDate= \(finalDate)")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: String(finalDate))

        guard dateFormatter.date(from: String(finalDate)) != nil else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "E, d MMM yyyy h:mm a "//yyyy MMM HH:mm EEEE"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }
    
    
    @IBAction func checkButtonTapped2(_ sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPathC = self.tableView.indexPathForRow(at: buttonPosition)
        if indexPathC != nil {
            
            //print("I am here")
            
            let theEventName = homescreeneventdata[indexPathC!.row].name!
            let theEventDateTime = homescreeneventdata[indexPathC!.row].dateTime!
            let theEventCode = homescreeneventdata[indexPathC!.row].eventCode!
            let theEventId = homescreeneventdata[indexPathC!.row].eventId
            let theProfileId = profileId
            

            let selectAttendeeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectAttendeeToSprayViewController") as! SelectAttendeeToSprayViewController
            self.navigationController?.pushViewController(selectAttendeeVC , animated: true)
            
            selectAttendeeVC.eventName = theEventName
            selectAttendeeVC.eventDateTime = theEventDateTime
            selectAttendeeVC.eventCode = theEventCode
            selectAttendeeVC.eventId = theEventId
            selectAttendeeVC.profileId = theProfileId
            selectAttendeeVC.token = token!
            
            //self.performSegue(withIdentifier: "test", sender: sender)
        }
    }
    
    
    
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {

        var attendeeEventName: String?
        var attendeeEventId: Int64
        var attendeeOwnerId: Int64
        
    
        let switchPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPathD = self.tableView.indexPathForRow(at: switchPosition)
        if indexPathD != nil {
            let selectedRow = indexPathD!.row
            attendeeEventName =  homescreeneventdata[selectedRow].name!
            attendeeEventId = homescreeneventdata[selectedRow].eventId
            attendeeOwnerId = homescreeneventdata[selectedRow].ownerId

        }
        
 
        if (sender.isOn == true){
            //print("on")
        }
        else{
            
            // print("off")
        }
    }
  
}





extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return homescreeneventdata.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homescreeneventdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
   
        
        if homescreeneventdata[indexPath.row].dataCategory == "info" {
            
            
            let cell0 = tableView.dequeueReusableCell(withIdentifier: InfoBoardTableViewCell.identifier, for: indexPath) as! InfoBoardTableViewCell
            //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
            
//            let eventNameCellData = homescreeneventdata[indexPath.row].name!
//            let eventAddressCellData = homescreeneventdata[indexPath.row].address1! + " " + homescreeneventdata[indexPath.row].address2!
//            //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
//            let eventDateTimeCellData = homescreeneventdata[indexPath.row].dateTime!
//
//           let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.row].city! + ", " + homescreeneventdata[indexPath.row].state! + " " + homescreeneventdata[indexPath.row].zipCode! + " " +
//               homescreeneventdata[indexPath.row].country!
//
//            let eventCodeCellData = homescreeneventdata[indexPath.row].eventCode!
//
//            let isActiveFlagCellData = homescreeneventdata[indexPath.row].isActive
//
//            let eventImageCellData = eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
//            let eventIdData = homescreeneventdata[indexPath.row].eventId
//            let profileIdData = profileId
//            let ownerIdData = homescreeneventdata[indexPath.row].ownerId
//            let tokenData = token
//            let paymentClientTokenData = paymentClientToken
//            let isRsvprequiredCellData = homescreeneventdata[indexPath.row].isRsvprequired
//            let isSingleReceiverCellData = homescreeneventdata[indexPath.row].isSingleReceiver
//            let defaultEventPaymentMethodCellData = homescreeneventdata[indexPath.row].defaultEventPaymentMethod
//            let defaultEventPaymentCustomNameCellData = homescreeneventdata[indexPath.row].defaultEventPaymentCustomName
//
            print("homescreeneventdata[indexPath.row].pendingPayoutAmt1 \(homescreeneventdata[indexPath.row].pendingPayoutAmt1)")
            cell0.configure(with: homescreeneventdata[indexPath.row].outstandingTransferAmt1, pendingPayoutAmt: homescreeneventdata[indexPath.row].pendingPayoutAmt1, totalGiftedAmt: homescreeneventdata[indexPath.row].totalGiftedAmt1, totalReceivedAmt: homescreeneventdata[indexPath.row].totalReceivedAmt1, currency: homescreeneventdata[indexPath.row].currency1, paymentCustomerId: homescreeneventdata[indexPath.row].paymentCustomerId1, paymentConnectedActId:
                homescreeneventdata[indexPath.row].paymentConnectedActId1)
            //cell0.configure(with: <#T##String#>, pendingPayoutAmt: <#T##String#>, totalGiftedAmt: <#T##String#>, totalReceivedAmt: <#T##String#>)
//
            cell0.customCellDelegate = self
            return cell0
        }
        
        
        if homescreeneventdata[indexPath.row].dataCategory == "owned" {
             let cell2 = tableView.dequeueReusableCell(withIdentifier: MyEventsTableViewCell.identifier, for: indexPath) as! MyEventsTableViewCell
            //if homescreeneventdata[indexPath.row].dataCategory! == "owned" {
                   print("my invitation")
                  //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
    
    
            let eventNameCellData = homescreeneventdata[indexPath.row].name!
            let eventAddressCellData = homescreeneventdata[indexPath.row].address1! + " " + homescreeneventdata[indexPath.row].address2!
                
                //+ "\n" + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + "\n" + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
            let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.row].dateTime!)
    
    
            //let eventCityStateZipCountryCellData = ""
            let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.row].city! + ", " + homescreeneventdata[indexPath.row].state! + " " + homescreeneventdata[indexPath.row].zipCode! + " " +
                 homescreeneventdata[indexPath.row].country!
                
            let eventCodeCellData = homescreeneventdata[indexPath.row].eventCode!
            let isActiveFlagCellData = homescreeneventdata[indexPath.row].isActive
            let eventImageCellData = eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
            let eventIdData = homescreeneventdata[indexPath.row].eventId
            let profileIdData = profileId
            let ownerIdData = homescreeneventdata[indexPath.row].ownerId
            let tokenData = token!
            let apiKeyData = encryptedAPIKey
            
            let address1Data = homescreeneventdata[indexPath.row].address1!
            let address2Data = homescreeneventdata[indexPath.row].address2!
            let cityData = homescreeneventdata[indexPath.row].city!
            let stateData = homescreeneventdata[indexPath.row].state
            let zipCodeData = homescreeneventdata[indexPath.row].zipCode
            let countryData = homescreeneventdata[indexPath.row].country
            let eventStateData = homescreeneventdata[indexPath.row].eventState
            let eventTypeData =  homescreeneventdata[indexPath.row].eventType
            let isRsvprequiredCellData = homescreeneventdata[indexPath.row].isRsvprequired
            let isSingleReceiverCellData = homescreeneventdata[indexPath.row].isSingleReceiver
            let isForBusinessCellData = homescreeneventdata[indexPath.row].isForBusiness
            let defaultEventPaymentMethodCellData = homescreeneventdata[indexPath.row].defaultEventPaymentMethod
            let defaultEventPaymentCustomNameCellData = homescreeneventdata[indexPath.row].defaultEventPaymentCustomName
            
            let paymentClientTokenData = paymentClientToken
            
            var defaultEventPaymentCustomName: String = ""
            if let custName = defaultEventPaymentCustomNameCellData  {
                defaultEventPaymentCustomName = custName
            } else {
                defaultEventPaymentCustomName = ""
            }
    
            print("countryCellData Owned  = \(countryData)")
//            cell2.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, isActiveFlag: isActiveFlagCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData, paymentClientToken: paymentClientTokenData, address1: address1Data, address2: address2Data, city: cityData, state: stateData, zipCode: zipCodeData, country: countryData, eventState: eventStateData, eventType: eventTypeData)
//
            cell2.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, isActiveFlag: isActiveFlagCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData, ApiKey: apiKeyData, paymentClientToken: paymentClientTokenData, address1: address1Data, address2: address2Data, city: cityData, state: stateData!, zipCode: zipCodeData!, country: countryData!, eventState: eventStateData, eventType: eventTypeData!, eventType2: "", isRsvprequired: isRsvprequiredCellData, isSingleReceiver: isSingleReceiverCellData, isForBusiness: isForBusinessCellData, defaultEventPaymentMethod: defaultEventPaymentMethodCellData!, defaultEventPaymentCustomName: defaultEventPaymentCustomName)


                print("eventDateTimeCellData = \(eventDateTimeCellData)")
                cell2.myEventsCustomCellDelegate = self
            
                return cell2
    
         //}
     }
        
    if  homescreeneventdata[indexPath.row].dataCategory == "invited" {
        let cell3 = tableView.dequeueReusableCell(withIdentifier: MyInvitationsTableViewCell.identifier, for: indexPath) as! MyInvitationsTableViewCell
        cell3.myInvitationCustomCellDelegate = self
        print("RICHARD my invitation")
        

        //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
        if eventIdsattendingmodel.count == 0 {
            print("eventIdsattendingmodel.count = \(eventIdsattendingmodel.count)")
            let eventNameCellData = homescreeneventdata[indexPath.row].name!
            let eventAddressCellData = homescreeneventdata[indexPath.row].address1! + " " + homescreeneventdata[indexPath.row].address2!
            //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
            let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.row].dateTime!)

           let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.row].city! + ", " + homescreeneventdata[indexPath.row].state! + " " + homescreeneventdata[indexPath.row].zipCode! + " " +
               homescreeneventdata[indexPath.row].country!

            let eventCodeCellData = homescreeneventdata[indexPath.row].eventCode!
            
            let isActiveFlagCellData = homescreeneventdata[indexPath.row].isActive
            
            let eventImageCellData = eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
            let eventIdData = homescreeneventdata[indexPath.row].eventId
            let profileIdData = profileId
            let ownerIdData = homescreeneventdata[indexPath.row].ownerId
            let tokenData = token
            let apiKeyData = encryptedAPIKey
            let paymentClientTokenData = paymentClientToken
            let eventTypeCellData = eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
            let isRsvprequiredCellData = homescreeneventdata[indexPath.row].isRsvprequired
            let isSingleReceiverCellData = homescreeneventdata[indexPath.row].isSingleReceiver
            let isForBusinessCellData = homescreeneventdata[indexPath.row].isForBusiness
            let defaultEventPaymentMethodCellData = homescreeneventdata[indexPath.row].defaultEventPaymentMethod
            let defaultEventPaymentCustomNameCellData = homescreeneventdata[indexPath.row].defaultEventPaymentCustomName
            let countryCellData = homescreeneventdata[indexPath.row].country
            
            print("countryCellData Invited 1 = \(countryCellData)")
            
            var defaultEventPaymentCustomName: String = ""
            if let custName = defaultEventPaymentCustomNameCellData  {
                defaultEventPaymentCustomName = custName
            } else {
                defaultEventPaymentCustomName = ""
            }
            cell3.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, isActiveFlag: isActiveFlagCellData, eventType: eventTypeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, ApiKey: apiKeyData, paymentClientToken: paymentClientTokenData, myProfileData: myProfileData, isRsvprequired: isRsvprequiredCellData, isSingleReceiver: isSingleReceiverCellData, isForBusiness: isForBusinessCellData, defaultEventPaymentMethod: defaultEventPaymentMethodCellData!, defaultEventPaymentCustomName: defaultEventPaymentCustomName, country: countryCellData! )
        } else {
            for eventidattending in eventIdsattendingmodel {
                print("RICHARD my invitation eventidattending = \(eventidattending)")
                //print("eventidattending = \(eventidattending)")
                //print("eventId = \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId)")
                //cell3.detailTextLabel?.text = String(homescreeneventdata[indexPath.row].eventId)
                if eventidattending != homescreeneventdata[indexPath.row].eventId {
                    //cell3.textLabel?.text = String(homescreeneventdata[indexPath.row].eventId)
                    //print("eventidattend = \(eventidattending) AND \(homescreeneventdata[indexPath.row].eventId)")
                    let eventNameCellData = homescreeneventdata[indexPath.row].name!
                    let eventAddressCellData = homescreeneventdata[indexPath.row].address1! + " " + homescreeneventdata[indexPath.row].address2!
                    //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
                    let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.row].dateTime!)

                   let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.row].city! + ", " + homescreeneventdata[indexPath.row].state! + " " + homescreeneventdata[indexPath.row].zipCode! + " " +
                       homescreeneventdata[indexPath.row].country!

                    let eventCodeCellData = homescreeneventdata[indexPath.row].eventCode!
                    
                    let isActiveFlagCellData = homescreeneventdata[indexPath.row].isActive
                    
                    let eventImageCellData = eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
                    let eventIdData = homescreeneventdata[indexPath.row].eventId
                    let profileIdData = profileId
                    let ownerIdData = homescreeneventdata[indexPath.row].ownerId
                    let tokenData = token
                    let apiKeyData = encryptedAPIKey
                    let paymentClientTokenData = paymentClientToken
                    let eventTypeCellData = eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
                    let isRsvprequiredCellData = homescreeneventdata[indexPath.row].isRsvprequired
                    let isSingleReceiverCellData = homescreeneventdata[indexPath.row].isSingleReceiver
                    let isForBusinessCellData = homescreeneventdata[indexPath.row].isForBusiness
                    let defaultEventPaymentMethodCellData = homescreeneventdata[indexPath.row].defaultEventPaymentMethod
                    let defaultEventPaymentCustomNameCellData = homescreeneventdata[indexPath.row].defaultEventPaymentCustomName
                    let countryCellData = homescreeneventdata[indexPath.row].country
                    
                    print("countryCellData Invited 2 = \(countryCellData)")
                    var defaultEventPaymentCustomName: String = ""
                    if let custName = defaultEventPaymentCustomNameCellData  {
                        defaultEventPaymentCustomName = custName
                    } else {
                        defaultEventPaymentCustomName = ""
                    }
                    
                    
                    cell3.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, isActiveFlag: isActiveFlagCellData, eventType:eventTypeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, ApiKey: apiKeyData, paymentClientToken: paymentClientTokenData, myProfileData: myProfileData, isRsvprequired: isRsvprequiredCellData, isSingleReceiver: isSingleReceiverCellData, isForBusiness: isForBusinessCellData, defaultEventPaymentMethod: defaultEventPaymentMethodCellData!, defaultEventPaymentCustomName: defaultEventPaymentCustomName, country: countryCellData!)

                }
            }
        }
        
    
        return cell3
        
    }
        
                   
        
    if homescreeneventdata[indexPath.row].dataCategory == "attending" {
        
        print("event has payment method! \(homescreeneventdata[indexPath.row].hasPaymentMethod)")
        
        var isAttendingEventIdCellData: Int = 0
        for eventidattending in eventIdsattendingmodel {
            if eventidattending == homescreeneventdata[indexPath.row].eventId {
                isAttendingEventIdCellData = eventidattending
            }
                
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MySprayEventTableViewCell.identifier, for: indexPath) as! MySprayEventTableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
    
        let eventNameCellData =  String(homescreeneventdata[indexPath.row].name!)
        let eventAddressCellData = homescreeneventdata[indexPath.row].address1! + " " + homescreeneventdata[indexPath.row].address2!
        //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
        let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.row].dateTime!)


        let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.row].city! + ", " + homescreeneventdata[indexPath.row].state! + " " + homescreeneventdata[indexPath.row].zipCode! + " " +
         homescreeneventdata[indexPath.row].country!

        let eventCodeCellData = homescreeneventdata[indexPath.row].eventCode!
        
        let isActiveFlagCellData = homescreeneventdata[indexPath.row].isActive
        

        let eventImageCellData =  eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
        let eventIdData = homescreeneventdata[indexPath.row].eventId
        let profileIdData = profileId
        let ownerIdData = homescreeneventdata[indexPath.row].ownerId
        let tokenData = token
        let apiKeyData = encryptedAPIKey
        let paymentClientTokenData = paymentClientToken
        let hasPaymentMethod = homescreeneventdata[indexPath.row].hasPaymentMethod
        let eventTypeCellData =  eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
        
        let isRsvprequiredCellData = homescreeneventdata[indexPath.row].isRsvprequired
        let isSingleReceiverCellData = homescreeneventdata[indexPath.row].isSingleReceiver
        let isForBusinessCellData = homescreeneventdata[indexPath.row].isForBusiness
        let defaultEventPaymentMethodCellData = homescreeneventdata[indexPath.row].defaultEventPaymentMethod
        let defaultEventPaymentCustomNameCellData = homescreeneventdata[indexPath.row].defaultEventPaymentCustomName
        let countryCellData = homescreeneventdata[indexPath.row].country
        print("John Baum Country - \(countryCellData)")
        var defaultEventPaymentCustomName: String = ""
        if let custName = defaultEventPaymentCustomNameCellData  {
            defaultEventPaymentCustomName = custName
        } else {
            defaultEventPaymentCustomName = ""
        }
        
        print("paymentmethodcelldata  = \(defaultEventPaymentMethodCellData)")
        
        print("countryCellData Attending - Dominic  = \(countryCellData)")
        
        let currencyCodeCellData = homescreeneventdata[indexPath.row].currency1
        
        cell.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData,isActiveFlag: isActiveFlagCellData, eventType: eventTypeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, ApiKey: apiKeyData, paymentClientToken: paymentClientTokenData, isAttendingEventId: Int64(isAttendingEventIdCellData),hasPaymentMethod: hasPaymentMethod,isRsvprequired: isRsvprequiredCellData, isSingleReceiver: isSingleReceiverCellData, isForBusiness: isForBusinessCellData, defaultEventPaymentMethod: defaultEventPaymentMethodCellData!, defaultEventPaymentCustomName: defaultEventPaymentCustomName, country: countryCellData!, currencyCode: currencyCodeCellData)

            cell.customCellDelegate = self

                return cell
             }
        return UITableViewCell()
        
    }
    
    
    
    
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return homescreeneventdata[section].eventCategory
//    }
    
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 15))
//
//        view.layer.borderWidth = 0
//
//        view.backgroundColor = UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0) //.lightGray
//
//        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width, height: 30))
//        lbl.textColor = .white
//
//        //lbl.text = "Events Owned"
//
//        lbl.text = homescreeneventdata[section].eventCategory
//
//        lbl.font = UIFont.boldSystemFont(ofSize: 25.0)
//
//        //view.addSubview(lbl)
//        view.addSubview(lbl)
//
//        return view
//
//    }
    
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if homescreeneventdata[indexPath.section].dataCategory == "owned" {
//            performSegue(withIdentifier: "goToEventEdit", sender: self)
//        }
//    }
    func launchEventPaymentScreen(eventId2: Int64, eventName2: String, eventDateTime2: String, completionAction: String, eventTypeIcon: String, isPaymentMethodAvailable: Bool, hasPaymentMethod: Bool, isRsvprequired: Bool, isSingleReceiver: Bool, defaultEventPaymentMethod: Int, defaultEventPaymentCustomName: String, country: String) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventPaymentViewController") as! EventPaymentViewController
        //hold for now 1/29/2021
        nextVC.eventId = eventId2
        nextVC.profileId = profileId
        nextVC.token = token!
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.eventName = eventName2
        nextVC.eventDateTime = eventDateTime2
        nextVC.completionAction = completionAction
        nextVC.eventTypeIcon = eventTypeIcon
        nextVC.isPaymentMethodAvailable = isPaymentMethodAvailable
        nextVC.refreshscreendelegate = self
        nextVC.paymentClientToken = paymentClientToken
        nextVC.country = country
        
        print("my completionAction = \(completionAction)")
                   
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    func onboardCustomer() {
        LoadingStart(message: "Loading...")
        var myName: String = ""
        var myLastName: String = ""
        var myusername: String = ""
        var myEmail: String = ""
        var myPhone: String = ""
        var myAvatar: String?
        var myPaymentCustomerId: String?
        var myPaymentConnectedActId: String?
        var myReturnUrl: String = ""
        var myRefreshUrl: String = ""
 
        for myprofile in myProfileData {
            myName = myprofile.firstName
            myLastName = myprofile.lastName
            myusername = myprofile.email
            myEmail = myprofile.email
            myPhone = myprofile.phone
            myAvatar = myprofile.avatar
            myPaymentCustomerId = myprofile.paymentCustomerId
            myPaymentConnectedActId = myprofile.paymentConnectedActId
            //failure something goes wrong
            
            print("myprofile.firstName \(myprofile.firstName)")
            
//            print("I am in scanner and my name is \(firstname )")
//            print("I am in scanner and my name is \(lastname )")
//            print("I am in scanner and my name is \(email)")
//            print("I am in scanner and my name is \(phone)")
        }
        
//       let profileData = ProfileAvatar(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: email, email: email, phone: phone, avatar: avatar, success: true)

        myReturnUrl = "https://projectxclientapp.azurewebsites.net/stripe/Index?profileid=\(profileId)&status=success&token=\(token!)"
        myRefreshUrl = "https://projectxclientapp.azurewebsites.net/stripe/Index?profileid=\(profileId)&status=failed&token=\(token!)"
        
        let onboardingProfile = ProfileOnboarding(token: token, profileId: profileId, firstName: myName, lastName: myLastName, userName: myusername, email: myEmail, phone: myPhone, avatar: myAvatar, paymentCustomerId: myPaymentCustomerId, paymentConnectedActId: myPaymentConnectedActId, success: true, returnUrl: myReturnUrl, refreshUrl: myRefreshUrl)
       
        print("onboardingProfile =\(onboardingProfile)")
        let request = PostRequest(path: "/api/profile/addaccount", model: onboardingProfile, token: token!, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>) in
            switch result {
            case .success(let urldata):
                print("avatar \(urldata)")
                print("SUCCESS")
                
                print(String(data: urldata, encoding: .utf8) ?? "*")
                
                let m = URL(string: String(data: urldata, encoding: .utf8) ?? "*")
                print("m \(m)")
                //print(URL(string: data: urldata, encoding: .utf8) ?? "*"))
                let redirectUrl = String(data: urldata, encoding: .utf8) ?? "*"
                
                print("redirectUrl before \(redirectUrl)")
                
                
//                let s = String(redirectUrl)
//                let delCharSet = NSCharacterSet(charactersIn: " ")

                let redirectURL2 = redirectUrl.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
                
                //s.replacingOccurrences(of: " ", with: "")
               // let fileUrl = URL.init(fileURLWithPath: redirectUrl)
              
                let jsonData = redirectURL2.data(using: .utf8)!
                let connectedaccount: ConnectedAccount = try! JSONDecoder().decode(ConnectedAccount.self, from: jsonData)
                
                //print("MY URL IS \(connectedaccount.url!)")
                print("IS ACCOUNT CONNECTED HOME \(connectedaccount.isAccountConnected)")
//                if let jsonData = try? JSONSerialization.data(withJSONObject: redirectURL2, options: JSONSerialization.WritingOptions.prettyPrinted)
//                {
//                    do {
//                        let foo = try JSONDecoder().decode(Foo.self, from: jsonData)
//                        print("MY BI URL IS ", foo.url)
//                    } catch {
//                        print("ERROR:", error)
//                    }
//                }
                
               
                print("redirectURL2 \(redirectURL2)")
                //let url = URL(string: redirectUrl)
                if connectedaccount.isAccountConnected == false {
                    launcWebView(urlstring: connectedaccount.url!)
                    LoadingStop()
                } else  {
                    LoadingStop()
                }
                
//                let url = redirectUrl
//                let urlStr : String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                let convertedURL : URL = URL(string: urlStr)!
//                //let convertedURL2 : URL = URL(string: redirectUrl)!
//                
//               // print("convertedUR2L \(convertedURL2)")
//                
//                print("this is the URL = \(convertedURL)")
                //launcWebView(urlstring: redirectUrl)
               
                //StripeAccountOnboardingViewController
                
//                let decoder = JSONDecoder()
//                do {
//                    let urlJson: OnboardingUrl = try decoder.decode(OnboardingUrl.self, from: urldata)
//                    //for url in urlJson {
//                        //           url.redirectUrl
//                        print("MY URL = \( urlJson.redirectUrl)")
//                    //}
//
//                } catch {
//                    print(error)
//                }
                break

            case .failure(let error):
            print(" DOMINIC H IGHEDOSA 1 ERROR \(error.localizedDescription)")
                LoadingStop()
            }
        }
    }
    
    func launcWebView(urlstring: String){
        //let url =  URL(string: urlstring)
//        let convertedURL : URL = URL(string: String(urlstring))!
//        print(convertedURL.absoluteURL)
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "StripeAccountOnboardingViewController") as! StripeAccountOnboardingViewController
        nextVC.urlRedirect = urlstring
        nextVC.token = token!
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.paymentClientToken = paymentClientToken
        nextVC.profileId = profileId
        nextVC.refreshscreendelegate = self
        nextVC.myProfileData = myProfileData
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
  
    
    func callSprayScreen(eventId: Int64, eventName: String, eventDateTime: String, eventOwnerId: Int64, completionAction: String, eventTypeIcon: String, paymentMethodAvailable: Bool, eventHasPaymentMethod: Bool, isRsvprequired: Bool, isSingleReceiver: Bool, paymentMethodId: Int, paymentCustomName: String, country: String, currencyCode: String) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "GoSprayViewController") as! GoSprayViewController

        print("callSprayScreen was called paymentMethodAvailable = \(paymentMethodAvailable)")
        
        print("eventOwnerid B from Call Spray Screen= \(eventOwnerId)")
        
        var receiverName: String = ""
        if isSingleReceiver == true {
            receiverName = eventName
        } else {
            receiverName = ""
        }
        
        print("callSprayScreen my country\(country)")
        
        print("callSprayScreen paymentmethod = \(paymentMethodId)")
        nextVC.eventId = eventId
        nextVC.profileId = profileId
        nextVC.token = token!
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.completionAction = completionAction //"callspraycandidate"
        nextVC.isPaymentMethodAvailable = isPaymentMethodGeneralAvailable
        nextVC.receiverName = receiverName
        nextVC.isSingleReceiverEvent = isSingleReceiver
        nextVC.hasPaymentMethodEvent = eventHasPaymentMethod
        nextVC.isRsvprequired = isRsvprequired
        nextVC.defaultEventPaymentMethod = paymentMethodId
        nextVC.defaultEventPaymentCustomName = paymentCustomName
        nextVC.refreshscreendelegate = self
        nextVC.paymentClientToken = paymentClientToken
        nextVC.processspraytrandelegate = self
        nextVC.haspaymentdelegate = self
        nextVC.eventOwnerProfileId = eventOwnerId
        nextVC.country = country
        nextVC.currencyCode = currencyCode
        //nextVC.currencyCode = currency
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    func addEventPrefPayment(eventId: Int64, eventName: String, eventDateTime: String, eventOwnerId: Int64, completionAction: String, eventTypeIcon: String, paymentMethodAvailable: Bool, eventHasPaymentMethod: Bool, isRsvprequired: Bool, isSingleReceiver: Bool, paymentMethodId: Int, paymentCustomName: String, generalPaymentMethodId: Int) {
        
        //self.launchSprayCandidate()
        
        let updatedPaymentMethodId = generalPaymentMethodId //getPaymenthMethodId(customName: paymentCustonName)
        let updatedGiftAmount = 10
        let updatedAutoReplenishFlag = false
        let updatedAutoReplenishAmount: Int = 0
        let currencyCode: String = "usd"
        
        let addEventPreference = EventPreference(eventId: eventId, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencyCode)

        print("ADD EVENT PREFERENCE \(addEventPreference)")
//        updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
        //closeScreen()
        
        //hold 2/13 - for now...
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token!, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref);
                print("i called callSprayScreen 6 - ? ")
                callSprayScreen(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, eventOwnerId: eventOwnerId, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: false, eventHasPaymentMethod: eventHasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, paymentMethodId: paymentMethodId, paymentCustomName: paymentCustomName, country: "", currencyCode: currencyCode)
                
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
                
                break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
   
}


extension HomeViewController:  MyCustomCellDelegator  {
    func infoBoard(completionAction: String) {
        if completionAction == "createevent" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateEventViewController") as! CreateEventViewController
            nextVC.profileId = profileId
            nextVC.token = token!
            nextVC.encryptedAPIKey = encryptedAPIKey
            nextVC.refreshscreendelegate = self
            nextVC.myProfileData = myProfileData
            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if completionAction == "joinevent" {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
            
            nextVC.completionAction = "postloginscan"
            nextVC.profileId = profileId
            nextVC.myProfileData = myProfileData
            nextVC.token = token!
            nextVC.encryptedAPIKey = encryptedAPIKey
            
            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if completionAction == "onboardcustomer" {
            onboardCustomer()
        }
    }
    
    func callSegueFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool, eventType: String, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, ApiKey: String, paymentClientToken: String, screenIdentifier: String, isAttendingEventId: Int64, eventTypeIcon: String, hasPaymentMethod: Bool, isRsvprequired: Bool, isSingleReceiver: Bool, isForBusiness: Bool, defaultEventPaymentMethod: Int, defaultEventPaymentCustomName: String, country: String, currencyCode: String) {
       
        print("callSegueFromCell country = \(country)")
        print("HAS PAYMENT METHOD = \(hasPaymentMethod)")
        //set hasPaymentMethod to True for now 2/13
        //let hasPaymentMethod = true
        
        print("eventOwnerid A = \(ownerId)")
        if screenIdentifier == "ReadyToSpray" {
             
            //if user have not RSVP, then alert them and redirect them to Event Settings
            if isAttendingEventId == 0 {
                
                print("isAttendingEventId = \(isAttendingEventId) ")
                let alert = UIAlertController(title: "RSVP", message: "Please RSVP so that you can participate in Spray. To RSVP, select Cancel and go to Event Settings", preferredStyle: .actionSheet)

                //alert.addAction(UIAlertAction(title: "RSVP", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                //{ action in self.performSegue(withIdentifier: "backToHome", sender: self) }))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("isPaymentMethodGeneralAvailable = \(isPaymentMethodGeneralAvailable)")
               // print("isPaymentMethodOnFile = \(isPaymentMethodOnFile)")
                print("hasPaymentMethod = \(hasPaymentMethod)")
                if  isPaymentMethodGeneralAvailable == false && defaultEventPaymentMethod == 0 {
                    print("i called callSprayScreen 7 - \(country)")
                    let alert2 = UIAlertController(title: "Need Payment Method", message: "You currently do not have a Payment Method selected for this Event. A Payment Metheod is required to participate in the fun of Spraying. Would you like to add a Payment Method?", preferredStyle: .alert)

                    //alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: nil))
                    //commented out temporarily 3/31/21 - will revisit
//                    alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: { [self] (action) in self.launchEventPaymentScreen(eventId2: eventId, eventName2: eventName, eventDateTime2: eventDateTime, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, isPaymentMethodAvailable: false, hasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, defaultEventPaymentMethod: defaultEventPaymentMethod, defaultEventPaymentCustomName: defaultEventPaymentCustomName)}))
                    
                    alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: { [self] (action) in self.callSprayScreen(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, eventOwnerId: ownerId, completionAction: "gotostripe", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: false, eventHasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, paymentMethodId: defaultEventPaymentMethod, paymentCustomName: defaultEventPaymentCustomName, country: country, currencyCode: currencyCode)}))
                    
                    
                    
                    alert2.addAction(UIAlertAction(title: "No, Not Yet", style: .cancel, handler: nil))
                 
                    self.present(alert2, animated: true)
                } else if isPaymentMethodGeneralAvailable == false && defaultEventPaymentMethod > 0 {
                    //set default
                    print("i called callSprayScreen 1 - \(country)")
                    callSprayScreen(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, eventOwnerId: ownerId, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: false, eventHasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, paymentMethodId: defaultEventPaymentMethod, paymentCustomName: defaultEventPaymentCustomName, country: country, currencyCode: currencyCode)
                    
                    //3/19 not using this right now
//                    let alert2 = UIAlertController(title: "Select Payment Method", message: "We found one or more Payment Methods on file. Please select the Payment Method to use for this Event.", preferredStyle: .alert)
//
//                    //alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: nil))
//                    alert2.addAction(UIAlertAction(title: "Select Payment Method", style: .default, handler: { [self] (action) in self.launchEventPaymentScreen(eventId2: eventId, eventName2: eventName, eventDateTime2: eventDateTime, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, isPaymentMethodAvailable: true, hasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, defaultEventPaymentMethod: defaultEventPaymentMethod, defaultEventPaymentCustomName: defaultEventPaymentCustomName)}))
//                    alert2.addAction(UIAlertAction(title: "Not Ready, Go Back Home", style: .cancel, handler: nil))
//
//                    self.present(alert2, animated: true)
                } else if isPaymentMethodGeneralAvailable == true || defaultEventPaymentMethod > 0 {
                   /*if no payment method for event, then use default payment method
                     add default spray amount$15 - then call go to spray
                     
                     the if generalPaymentMethodId == 0 should never happen because if paymentavailble = true, there
                     must be a payment method Id - for now, we're going to add this here to capture this unrealistic scenaria. remove after we have clean data 3/19/2021
                     */
                    if defaultEventPaymentMethod > 0 {
                        print("i called callSprayScreen 2 - \(country)")
                        callSprayScreen(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, eventOwnerId: ownerId, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: false, eventHasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, paymentMethodId: defaultEventPaymentMethod, paymentCustomName: defaultEventPaymentCustomName, country: country, currencyCode: currencyCode)
                    } else if generalPaymentMethodId == 0 {
                        
                        let alert2 = UIAlertController(title: "Need Payment Method", message: "You currently do not have a Payment Method selected for this Event. A Payment Metheod is required to participate in the fun of Spraying. Would you like to add a Payment Method?", preferredStyle: .alert)

                        //alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: nil))
                        //hold on to this piece of code 3/31/21 will revisit in the future
//                        alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: { [self] (action) in self.launchEventPaymentScreen(eventId2: eventId, eventName2: eventName, eventDateTime2: eventDateTime, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, isPaymentMethodAvailable: false, hasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, defaultEventPaymentMethod: defaultEventPaymentMethod, defaultEventPaymentCustomName: defaultEventPaymentCustomName)}))
                        print("i called callSprayScreen 3 - \(country)")
                        
                        alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: { [self] (action) in  self.callSprayScreen(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, eventOwnerId: ownerId, completionAction: "gotostripe", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: false, eventHasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, paymentMethodId: defaultEventPaymentMethod, paymentCustomName: defaultEventPaymentCustomName, country: country, currencyCode: currencyCode)}))
                      
                        alert2.addAction(UIAlertAction(title: "No, Not Yet", style: .cancel, handler: nil))
                     
                        self.present(alert2, animated: true)
                    } else if defaultEventPaymentMethod == 0 {
                        
                        self.callSprayScreen(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, eventOwnerId: ownerId, completionAction: "", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: false, eventHasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, paymentMethodId: defaultEventPaymentMethod, paymentCustomName: defaultEventPaymentCustomName, country: country, currencyCode: currencyCode)
                        
                        /*I don't think i need this 8/15 - hold for now...
                         addEventPrefPayment(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, eventOwnerId: ownerId, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: isPaymentMethodGeneralAvailable, eventHasPaymentMethod: false, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, paymentMethodId: generalPaymentMethodId, paymentCustomName: generalDefaultPaymentCustomName, generalPaymentMethodId: generalPaymentMethodId) */
                        
                    }
                
                } else {
                    //if any of these single receiver event, then....
//                    if eventTypeIcon == "entertainer" || eventTypeIcon  == "waiter" || eventTypeIcon  == "bandicon" || eventTypeIcon  == "concerticon" {
//
//                        completionAction = "singlereceiver"
//                    } else {
                    //completionAction = "allreceiver"
                    //}
                    
                    var paymentMethodAvailable: Bool = false
                    if hasPaymentMethod == true || isPaymentMethodGeneralAvailable == true {
                        paymentMethodAvailable = true
                    }
                    
                    //call spray screen
//                    callSprayScreen(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: paymentMethodAvailable, hasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, defaultEventPaymentMethod: defaultEventPaymentMethod, defaultEventPaymentCustomName: defaultEventPaymentCustomName)
                    print("i called callSprayScreen 4 - \(country)")
                    callSprayScreen(eventId: eventId, eventName: eventName, eventDateTime: eventDateTime, eventOwnerId: ownerId, completionAction: "gotospray", eventTypeIcon: eventTypeIcon, paymentMethodAvailable: false, eventHasPaymentMethod: hasPaymentMethod, isRsvprequired: isRsvprequired, isSingleReceiver: isSingleReceiver, paymentMethodId: defaultEventPaymentMethod, paymentCustomName: defaultEventPaymentCustomName, country: country, currencyCode: currencyCode)
                    //call go to spray
                }
              
            }
            
        } else if  screenIdentifier == "EventSettings" {
            
            //let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "EventSettingTableVC2") as! EventSettingTableViewController
            //let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
            //self.present(navController, animated:true, completion: nil)
            
            //hold for later 1/23/21
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventContainer") as! EventSettingContainerViewController
//            nextVC.selectionDelegate = self
//            nextVC.refreshscreendelegate = self
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventPaymentViewController") as! EventPaymentViewController
            
            nextVC.eventName = eventName
            nextVC.eventDateTime = eventDateTime
            //nextVC.eventCode = eventCode
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.completionAction = "editpayment"
            //nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.encryptedAPIKey = ApiKey
            nextVC.paymentClientToken  =  paymentClientToken
            //nextVC.ownerId = 31
//            nextVC.isAttendingEventId = isAttendingEventId
//            nextVC.screenIdentifier = screenIdentifier
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.refreshscreendelegate = self
            nextVC.country = country
            
//            nextVC.selectionDelegate = self
//            nextVC.refreshscreendelegate = self
            
            
//            let viewControllerB = EventSettingTableViewController()
//            viewControllerB.myDelegate = self
//            viewControllerB.eventName = "Dominc Ighedosa"
            
//            let appdelegate = UIApplication.shared.delegate as! AppDelegate
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            var tableViewController = mainStoryboard.instantiateViewController(withIdentifier: "EventSettingTableVC") as! EventSettingTableViewController
//            let navigationVC = UINavigationController(rootViewController: tableViewController)
            //appdelegate.window!.rootViewController = navigationVC
//            let theArticlesSB = UIStoryboard(name: "Main", bundle: nil)
//            let vc = theArticlesSB.instantiateViewController(withIdentifier: "EventSettingTableVC") as! EventSettingTableViewController
//            self.present(vc, animated: true, completion: nil)
//            self.performSegue(withIdentifier: "EventSettingTableVC", sender: self)
            
//            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//           let vc: MyTableVC = mainStoryboard.instantiateViewControllerWithIdentifier("showPlan") as! MyTableVC
//           self.presentViewController(vc, animated: true, completion: nil)
//
            
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                   let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "EventSettingTableVC") as! EventSettingTableViewController
//                   self.present(balanceViewController, animated: true, completion: nil)
//
            
            //hold for later 1/23/21
//            nextVC.eventName = eventName
//            nextVC.eventDateTime = eventDateTime
//            nextVC.eventCode = eventCode
//            nextVC.eventId = eventId
//            nextVC.profileId = profileId
//            nextVC.ownerId = ownerId
//            nextVC.token = token
//            nextVC.paymentClientToken  =  paymentClientToken
//            //nextVC.ownerId = 31
//            nextVC.isAttendingEventId = isAttendingEventId
//            nextVC.screenIdentifier = screenIdentifier
//            nextVC.eventTypeIcon = eventTypeIcon
            
           self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "EventMetrics" {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventMetricsViewController") as! EventMetricsViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDate = eventDateTime
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.encryptedAPIKey = ApiKey
            nextVC.paymentClientToken  =  paymentClientToken
            nextVC.country = country
   
            //nextVC.ownerId = 31
//            nextVC.isAttendingEventId = isAttendingEventId
//            nextVC.screenIdentifier = screenIdentifier
//            nextVC.eventTypeIcon = eventTypeIcon
//            
             self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "QRCode" {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayQRCodeViewController") as! DisplayQRCodeViewController
            
            print("DISPLAY QR CODE COUNTRY = \(country)")
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDate = eventDateTime
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventType = eventType
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.encryptedAPIKey = ApiKey
            nextVC.paymentClientToken  =  paymentClientToken
            nextVC.country = country
            //nextVC.ownerId = 31
//            nextVC.isAttendingEventId = isAttendingEventId
//            nextVC.screenIdentifier = screenIdentifier
//            nextVC.eventTypeIcon = eventTypeIcon
//
             self.navigationController?.pushViewController(nextVC , animated: true)
        }
        
        //navigationController!.removeViewController(HomeViewController.self)
    }

}



extension HomeViewController:  MyInvitationCustomCellDelegate  {
    func callEventSettingFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool, eventType: String, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, ApiKey: String, paymentClientToken: String, screenIdentifier: String, eventTypeIcon: String, profileData: [MyProfile], isRsvprequired: Bool, isSingleReceiver: Bool, isForBusiness: Bool, defaultEventPaymentMethod: Int, defaultEventPaymentCustomName: String, country: String) {
       // print("I am ready to seque ")
        
        if screenIdentifier == "RSVP" {
            
            //let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventSettingTableVC") as! EventSettingTableViewController
            //hold for now 1/22/21
            //let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventContainer") as! EventSettingContainerViewController
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "RSVPViewController") as! RSVPViewController
//            nextVC.eventName = eventName
//            nextVC.eventId = eventId
//            nextVC.profileId = profileId
//            nextVC.ownerId = ownerId
//            nextVC.token = token
//            nextVC.paymentClientToken  =  paymentClientToken
//            nextVC.screenIdentifier = screenIdentifier
//            nextVC.eventTypeIcon = eventTypeIcon
            
            //hold for now 1/22/21
            nextVC.eventName = eventName
            nextVC.eventDateTime = eventDateTime
//            nextVC.eventCode = eventCode
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.eventOwnerProfileId = ownerId
            nextVC.token = token
            nextVC.encryptedAPIKey = ApiKey
            nextVC.paymentClientToken  =  paymentClientToken
//            //nextVC.ownerId = 31
//            nextVC.isAttendingEventId = 0
//            nextVC.screenIdentifier = screenIdentifier
            nextVC.isPaymentMethodAvailable = isPaymentMethodGeneralAvailable
            nextVC.isPaymentMethodAvailableEvent = defaultEventPaymentMethod
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.myProfileData = profileData
            nextVC.refreshscreendelegate = self
            nextVC.country = country
            
            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "QRCode" {
            print("CONSTANCE UZOR QRY CODE3")
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayQRCodeViewController") as! DisplayQRCodeViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDate = eventDateTime
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventType = eventType
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.encryptedAPIKey = ApiKey
            nextVC.paymentClientToken  =  paymentClientToken
            nextVC.country = country
            
            
            self.navigationController?.pushViewController(nextVC , animated: true)
        }

    }

}

extension HomeViewController:   MyEventsCustomCellDelegate  {
    func callInviteFriendsFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool,  eventId: Int64, profileId: Int64, ownerId: Int64, token: String, ApiKey: String, paymentClientToken: String, screenIdentifier: String, eventTypeIcon: String, address1: String, address2: String, city: String, state: String, zipCode: String, country: String, eventState: Int, eventType: Int, eventType2: String, isRsvprequired: Bool, isSingleReceiver: Bool, isForBusiness: Bool, defaultEventPaymentMethod: Int, defaultEventPaymentCustomName: String) {
    
//    }
//
//    func callInviteFriendsFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, paymentClientToken: String, screenIdentifier: String, eventTypeIcon: String, address1: String,
//                                   address2: String,
//                                   city: String,
//                                   state: String,
//                                   zipCode: String,
//                                   country: String,
//                                   eventState: Int,
//                                   eventType: String) {
        //print("I am ready to seque ")
        
        if screenIdentifier == "MyEvents" {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
            
            nextVC.eventName = eventName
            nextVC.eventId = eventId
            nextVC.eventDateTime = eventDateTime
            nextVC.eventCode = eventCode
            nextVC.profileId = profileId
            nextVC.token = token
            nextVC.encryptedAPIKey = ApiKey
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.paymentClientToken  =  paymentClientToken
            nextVC.encryptedDeviceId = encryptedDeviceId
            

            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "QRCode" {
            
            print("CONSTANCE UZOR QRY CODE2")
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayQRCodeViewController") as! DisplayQRCodeViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDate = eventDateTime
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventType = eventType2
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.encryptedAPIKey = ApiKey
            nextVC.paymentClientToken  =  paymentClientToken
            nextVC.country = country
            
            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "EditEvent" {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "UpdateEventViewController") as! UpdateEventViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDateTime = eventDateTime
            //nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            //nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.encryptedAPIKey = ApiKey
            nextVC.refreshscreendelegate = self
            
           
            //nextVC.paymentClientToken  =  paymentClientToken
            
//            var eventName: String?
//            var eventDateTime: String?
            nextVC.eventZipCode = zipCode
            nextVC.eventAddress1 = address1
            nextVC.eventAddress2 = address2
            nextVC.eventCity = city
            nextVC.eventType =  getEventTypeName(eventTypeId:eventType)//String(eventType)
            nextVC.eventState = state
            nextVC.eventCountry = country
//            var eventCode: String?
            nextVC.eventStatus = isActiveFlag
//            var eventId: Int64?
//            var profileId: Int64?
//            var token: String?
            nextVC.isEventEdited = false
            //var refreshscreendelegate: RefreshScreenDelegate?
            nextVC.isRSVPRequired = isRsvprequired
            nextVC.isSingleReceiverEvent = isSingleReceiver
            nextVC.refreshscreendelegate = self
            nextVC.eventCurrentState = eventState
            
            
            self.navigationController?.pushViewController(nextVC , animated: true)
            
        }

    }

}

extension HomeViewController:  HasPaymentMethodDelegate {
    func hasPaymentMethod(hasPaymentMethod: Bool, paymentMethodId: Int) {
        isPaymentMethodGeneralAvailable = hasPaymentMethod
        print("HasPaymentMethodDelegate was called isPaymentMethodGeneralAvailable  = \(isPaymentMethodGeneralAvailable )")
        
    }
}

extension HomeViewController:   ProcessSprayTransDelegate  {
    func updateSprayTransaction(receiverProfileId: Int64, gifterProfileId: Int64, eventId: Int64, giftAmount: Int, hasPaymentMethod: Bool) {
        if giftAmount > 0 {
            print(" gift amount = \(giftAmount) process spray trans was called - receiverId = \(receiverProfileId)")
            
        }
        
    }
}

extension HomeViewController:  RefreshScreenDelegate {
    func refreshScreen(isRefreshScreen: Bool) {
       
        isRefreshData = isRefreshScreen
        print("refreshData Blabablabalba  function was called = \(isRefreshData)")
        print(isRefreshData)
        //print("refreshHomeScreenDate = \(isShowScreen)")
    }


}

extension HomeViewController: SideSelectionDelegate {
    func didTapChoice(name: String) {
        //print("image = \(image)")
        print("name = \(name)")
        //print("colore = \(colore)")
        
    }
}


extension HomeViewController{
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

public extension Optional {

    var isNil: Bool {

        guard case Optional.none = self else {
            return false
        }

        return true

    }

    var isNull: Bool {

        return !self.isNil

    }

}

extension HomeViewController: UITabBarControllerDelegate {
   /* not going to use this - it crashes when you select an item immediately... I will get back to this
     later 7/23
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            let tabBarIndex = tabBarController.selectedIndex
            if tabBarIndex == 0 {
                print("home INDEX TAB WAS SELECTED = \(tabBarIndex )")
                clearData()
                
                //get user profile info... set haspyament flag and other varialbe
                getProfileData(profileId: profileId)
                //getMyEvents()
                getDataForInfoUIView()
                //getPrefData()
                 print("BACK BUTTON TRIGGERED VIEWDID APPEAR isRefreshData  = \(isRefreshData )")
                
                // get profile data for eventOwner - this is the event coming from the scaned QR cod
                if eventOwnerId > 0 {
                    getOtherProfileData(profileId: eventOwnerId)
                }
            }
       } */
}

//extension UIApplication {
//    var statusBarView: UIView? {
//        if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
//    }
//}
