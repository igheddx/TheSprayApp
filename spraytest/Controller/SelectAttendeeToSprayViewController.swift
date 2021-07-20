//
//  SelectAttendeeToSprayViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/16/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import Contacts


class SelectAttendeeToSprayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var sprayIncrementTextField: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventCodeLabel: UILabel!
    
    @IBOutlet weak var generalMessageLabel: UILabel!
    @IBOutlet weak var eventTypeImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var eventSettingBtn: MyCustomButton!
    
    var customtextfield = CustomTextField()
    
    var db:DBHelper = DBHelper()
    var senderspraybalance: [SenderSprayBalance] = []
    
    var message: String = ""
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var profileId: Int64?
    var eventId: Int64?
    var ownerId: Int64?
    var token: String = ""
    var paymentClientToken: String?
    var eventTypeIcon: String = ""
    
    var gifterBalanceAfterSpray: Int = 0
    var receiverBalanceAfterSpray: Int = 0
    var theReceiverId: Int64?
    var giftReceiverId: Int64?
    var attendeeNameSelected: String = ""
    var attendeePhoneSelected: String = ""
    var gifterData: Data?
    var gifterTotalTransAmount: Int = 0
   
    var isAutoReplenishFlag: Bool?
    var autoReplenishAmount: Int?
    var notificationAmount: Int?
    var paymentMethod: Int?
    var sprayIncrementAmt: String = "$1.00"
    var currencyImageSide1: String = ""
    var currencyImageSide2: String = ""
    
    var contactStore = CNContactStore()
    var service = [CNContactStore]()
    var contacts = [Contact]()
    var contact = [Contact]()
    var rsvpAttendees = [RSVPAttendees]()
    var rsvpAttendees2 = [RSVPAttendees]()
    
    var balance: Int = 0
    var balanceFromPref: Int?
    var refreshScreen: Bool = false
    var eventSettingRefresh: Bool = false
    
    var refreshscreendelegate: RefreshScreenDelegate?
    var  testDelegate: GetClearEventDataDelegate?
   
    
    //@IBOutlet weak var messageLabel: UILabel!
    
    var searchCountry = [String]()
    var searching = false
    var encryptedAPIKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero) //use to remove lines when no cell is returned
        searchBar.text = ""
        /*make the search bar background white*/
        self.searchBar.isTranslucent = false
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.barTintColor = .white
        
        eventSettingBtn.isHidden = true
        //print("gifterBalanceAfterSpray \(gifterBalanceAfterSpray)")
        senderspraybalance = db.readSenderSprayBalanceById(eventId: eventId!, senderId: Int64(profileId!))
       
        
        //set default value
        sprayIncrementTextField.text = sprayIncrementAmt
        searchBar.text = ""
        customtextfield.borderForTextField(textField: sprayIncrementTextField, validationFlag: false)
        let imageName = getCurrencyImage(currencyValue: sprayIncrementAmt)
        currencyImageSide1 = imageName.0
        currencyImageSide2 = imageName.1

//        if senderspraybalance.count > 0 {
//            for s in senderspraybalance {
//                balance = s.senderAmountRemaining
//                print("sender amount remaining when not getting getEventPreference = \(s.senderAmountRemaining)")
//            }
//        }
        
//        rsvpAttendees.removeAll()
//        rsvpAttendees2.removeAll()
        
        //getEventPreference(spraybalance: senderspraybalance)
        getGifterTotalTransBalance()
       
        
       // getGifterData()
       
        //gifterTotalTransAmount = getGifterTotalTransBalance(gifterTotalTransData: gifterData!)!
        print("gifterTotalTransAmount = \(gifterTotalTransAmount )")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.allowsMultipleSelectionDuringEditing = true self.navigationItem.rightBarButtonItem = editButtonItem
        tableView.allowsMultipleSelection = true
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Authorize")
            }
        }
        
       
        //fetchContacts()

        eventNameLabel?.text = eventName
        eventDateTimeLabel?.text = eventDateTime
        eventCodeLabel?.text = eventCode
        eventTypeImage.image = UIImage(named: eventTypeIcon)
        //messageLabel?.text = message
        //print(messageLabel.text!)
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appear gifterBalanceAfterSpray \(gifterBalanceAfterSpray)")
        print("View did appear receiverBalanceAfterSpray \(receiverBalanceAfterSpray) refresh = \(refreshScreen)")
        
       
        let isEditEventSettingRefresh = defaults.bool(forKey: "isEditEventSettingRefresh")
        //refresh screen when coming from other screen
        print("eventSettingRefresh=\(eventSettingRefresh)")
        if isEditEventSettingRefresh == true {
            //receiverBalanceAfterSpray = 0 may indicate
            //that i may not be coming from sprayscreen
            print("eventSettingRefresh=\(eventSettingRefresh)")
            //if receiverBalanceAfterSpray == 0 {
                //we will set the gifterbalanceAfterSpray to 0
                //because we want to force a refresh of the balance
                //inside the getEventPref3() method
                print("eventSettingRefresh=\(eventSettingRefresh)")
                gifterBalanceAfterSpray = 0
                getGifterTotalTransBalance()
            //}
            //reset the value to false
            defaults.set(false, forKey: "isEditEventSettingRefresh")
        }
//            rsvpAttendees.removeAll()
//            rsvpAttendees2.removeAll()
//            //updateSprayTransaction()
//            getEventPref3()
////            getIt {
////                fetchRSVPAttendees(eventId: eventId!)
////            }
//
//
//            tableView.reloadData()
//        }
        tableView.reloadData()
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    func getCurrencyImage(currencyValue: String) -> (String, String) {
        print("currencyValue \(currencyValue)")
        switch currencyValue {
            
            case "1":
                let currencyImage1 = "currencySide1B"
                let currencyImage2 = "currencySide2B"
                
                return (currencyImage1, currencyImage2)
            case "5":
    
                let currencyImage1 = "5dollarSide1"
                let currencyImage2 = "5dollarSide2"
                
                return (currencyImage1, currencyImage2)
            case "10":
                let currencyImage1 = "10dollarSide1"
                let currencyImage2 = "10dollarSide2"
                
                return (currencyImage1, currencyImage2)
            case "20":
                let currencyImage1 = "20dollarSide1"
                let currencyImage2 = "20dollarSide2"
                
                return (currencyImage1, currencyImage2)
            case "50":
                let currencyImage1 = "50dollarSide1"
                let currencyImage2 = "50dollarSide2"
                
                return (currencyImage1, currencyImage2)
            case "100":
                let currencyImage1 = "100dollarSide1"
                let currencyImage2 = "100dollarSide2"
                
                return (currencyImage1, currencyImage2)
            
        default:
            let currencyImage1 = "currencySide1B"
            let currencyImage2 = "currencySide2B"
            
            return (currencyImage1, currencyImage2)
        }
        
    }
    func getIntOnlyFromTextField(value: String) -> String {
        
        let index = value.firstIndex(of: ".") ?? value.endIndex
        let result: String = String(value[..<index])
        //remove currency symbol from string
        let range = result.index(result.startIndex, offsetBy: 1)..<result.endIndex
        let output = value[range]
        let finalResult = String(output)
        
        print(finalResult)
        return finalResult
    }
    @IBAction func increaseSprayIncrementBtnPressed(_ sender: Any) {
        //based on country selected provide bills option - hold for now
        //U.S $1, $5,$10, $20, $50, $100
        let value = getIntOnlyFromTextField(value: sprayIncrementTextField.text!)
        print("The Value \(value)")
        switch value {
        case "1":
            sprayIncrementAmt = "$5.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        case "5":
            sprayIncrementAmt = "$10.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
            
            print("currencyImageSide1 =\(currencyImageSide1)")
            print("currencyImageSide2 =\(currencyImageSide2)")
        case "10":
            sprayIncrementAmt = "$20.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        case "20":
            sprayIncrementAmt = "$50.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        case "50":
            sprayIncrementAmt = "$100.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        default:
            sprayIncrementAmt = "$1.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        }
       
       
    }
    @IBAction func decreaseSprayIncrementBtnPressed(_ sender: Any) {
        //based on country selected provide bills option - hold for now
        //U.S $1, $5,$10, $20, $50, $100
        let value = getIntOnlyFromTextField(value: sprayIncrementTextField.text!)
        print("The Value \(value)")
        switch value {
        case "100":
            sprayIncrementAmt = "$50.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        case "50":
            sprayIncrementAmt = "$20.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        case "20":
            sprayIncrementAmt = "$10.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        case "10":
            sprayIncrementAmt = "$5.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        case "5":
            sprayIncrementAmt = "$1.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        default:
            sprayIncrementAmt = "$1.00"; sprayIncrementTextField.text! =  sprayIncrementAmt
            let imageName = getCurrencyImage(currencyValue: getIntOnlyFromTextField(value: sprayIncrementAmt))
            currencyImageSide1 = imageName.0
            currencyImageSide2 = imageName.1
        }
       
    }
    
    @IBAction func goToEditEventSetting(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventContainer") as! EventSettingContainerViewController
        //nextVC.selectionDelegate = self
       
        
        //user data flag to determine when to refresh teh selectAttendeeViewController
        //after coming back from the EditEventSettings ViewController
        defaults.set(true, forKey: "isEditEventSettingRefresh")
        
        nextVC.refreshscreendelegate = self
 
        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventCode = eventCode
        nextVC.eventId = eventId
        nextVC.profileId = profileId
        nextVC.ownerId = ownerId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.paymentClientToken  =  paymentClientToken
        //nextVC.ownerId = 31
        
        nextVC.isAttendingEventId = 1 //1 is a default value to indicate that RSVP is true
        nextVC.screenIdentifier = "Spray"
        
        nextVC.eventTypeIcon = eventTypeIcon
        
       self.navigationController?.pushViewController(nextVC , animated: true)
    }
 
    func getIt(myClosure:() -> Void) {
        updateSprayTransaction()
        myClosure()
        return
        
    }
    
    
    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func getGifterData()  {

        let request = Request(path: "/api/Event/transactiontotal/\(profileId!)/\(eventId!)", token: token, apiKey: encryptedAPIKey)
               
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let gifterBalance):
                    //return paymentmethod1
                self.gifterData = gifterBalance
                //self.getEventPref2(paymenttypeData: paymentmethod1)
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }
        
    }
    func getGifterTotalTransBalance()   {
        //var theGifterTotalTransBalance: Int = 0
        let request = Request(path: "/api/Event/transactiontotal/\(profileId!)/\(eventId!)", token: token, apiKey: encryptedAPIKey)
               
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let gifterBalance):
                
                    //return paymentmethod1
                self.gifterData = gifterBalance
                let decoder = JSONDecoder()
                do {
                   let gifterBalanceJson: GifterTransactionTotal = try decoder.decode(GifterTransactionTotal.self, from: gifterBalance)
                   
                    //for gifter in gifterBalanceJson {
                    if  gifterBalanceJson.eventId == eventId &&  gifterBalanceJson.profileId == profileId {
                           //theGifterTotalTransBalance = gifter.totalAmountAllTransactions
                        self.gifterTotalTransAmount =  gifterBalanceJson.totalAmountAllTransactions
                        print("self.gifterTotalTransAmount = \(gifterBalanceJson.totalAmountAllTransactions)")
                        
                        self.getEventPref3()
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
    
    
    func updateSprayTransaction() {
        let AddSprayTrans = SprayTransactionModel(eventId: eventId!, senderId: profileId!, recipientId:giftReceiverId!, amount: receiverBalanceAfterSpray, success: true, errorCode: "", errorMessage: "")
        
        print("AddSprayTrans \(AddSprayTrans)")
        let request = PostRequest(path: "/api/SprayTransaction/add", model: AddSprayTrans , token: token, apiKey: encryptedAPIKey, deviceId: "")

        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _):
                
                //call these functions after spray transaction is complete
                //these func will get updated balance
                
               // getGifterData()
              
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func getEventPref3() {
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId!)", token: token, apiKey: encryptedAPIKey)
        
        Network.shared.send(request) { (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                        for eventPrefData in eventPreferenceJson {
                            if eventPrefData.eventId == self.eventId && eventPrefData.profileId == self.profileId {
                                
                                //
                                if self.gifterBalanceAfterSpray > 0 {
                                    self.balance = self.gifterBalanceAfterSpray
                                    print("Balance is from self.gifterBalanceAfterSpray = \(self.balance)")
                                } else if self.gifterTotalTransAmount > 0 {
                                    self.balance = eventPrefData.maxSprayAmount - self.gifterTotalTransAmount
                                    print("Balance is from self.balance = eventPrefData.maxSprayAmount - self.gifterTotalTransAmount = \(self.balance)")
                                } else {
                                    print("self.balance = \(self.balance)  before balance value is set")
                                    self.balance = eventPrefData.maxSprayAmount
                                    print("Balance is from self.balance = eventPrefData.maxSprayAmount = \(self.balance)")
                                    
                                }
                                    
                               
                                
                                //display message when balance is 0
                                if self.balance <= 0 {
                                    self.eventSettingBtn.isHidden = false
                                    self.generalMessageLabel.text = "You Are Out of Funds. Select Edit Event Settings button to update your funds."
                                } else {
                                    self.eventSettingBtn.isHidden = true
                                    self.generalMessageLabel.text = ""
                                    self.tableView.reloadData()
                                }
                                //self.balance = eventPrefData.maxSprayAmount
                                self.isAutoReplenishFlag = eventPrefData.isAutoReplenish
                                self.autoReplenishAmount = eventPrefData.replenishAmount
                                self.notificationAmount = eventPrefData.notificationAmount
                                self.paymentMethod = eventPrefData.paymentMethod
                                
                                
                            }
//                            if self.senderspraybalance.count > 0 {
//                                print("there is senders amount remainng...")
//                                for s in self.senderspraybalance {
//                                    self.balance = s.senderAmountRemaining
//                                    print("there is senders amount remainng... \(self.balance ?? 0)")
//
//                                    print("eventId = \(s.eventId)")
//                                    print("senderId = \(s.senderId)")
//                                    print("paymentType = \(s.paymentType)")
//                                    print("paymentType = \(s.senderAmountRemaining)")
//                                    print("autoReplenis = \(s.isAutoReplenish)")
//                                    print("transaction datea = \(s.transactionDateTime)")
//
//
//
//                                    self.balance = s.senderAmountRemaining
//                                    print("asasdd there is senders amount remainng... \(self.balance ?? 0)")
//                                }
//                            } else {
//                               // if eventPrefData.maxSprayAmount == 0 || eventPrefData.maxSprayAmount.
//                                self.balance = eventPrefData.maxSprayAmount
//                            }
                            
                           
                        }
                        print("FETCHING DATA")
                        self.rsvpAttendees.removeAll()
                        self.rsvpAttendees2.removeAll()
                        self.fetchRSVPAttendees(eventId: self.eventId!)
                        self.tableView.reloadData()
                                
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
    
    
    func getEventPreference(spraybalance: [SenderSprayBalance]) {
       let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId!)", token: token, apiKey: encryptedAPIKey)
       Network.shared.send(request) { (result: Result<Data, Error>)  in
        switch result {
           case .success(let eventPreferenceData):
           //self.parse(json: event)
           let decoder = JSONDecoder()
           do {
                             
               let eventPreferenceJson: [EventPreferenceData] = try decoder.decode([EventPreferenceData].self, from: eventPreferenceData)
             
               for eventPrefData in eventPreferenceJson {
                    
//                    if self.senderspraybalance.count > 0 {
//                        print("there is senders amount remainng...")
//                        for s in self.senderspraybalance {
//                            self.balance = s.senderAmountRemaining
//                            print("there is senders amount remainng... \(self.balance)")
//                        }
//                    } else {
//                       // if eventPrefData.maxSprayAmount == 0 || eventPrefData.maxSprayAmount.
//                        self.balance = eventPrefData.maxSprayAmount
//                    }
                
                
                    self.balance = eventPrefData.maxSprayAmount
                    self.isAutoReplenishFlag = eventPrefData.isAutoReplenish
                    self.autoReplenishAmount = eventPrefData.replenishAmount
                    self.notificationAmount = eventPrefData.notificationAmount
                    self.paymentMethod = eventPrefData.paymentMethod
                   
                  }
               } catch {
                   print(error)
               }
           case .failure(let error):
               print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }
       
//    func fetchContacts() {
//        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
//        let request = CNContactFetchRequest(keysToFetch: key)
//        
//        var x: Int = 0
//        do {
//            x = x + 1
//            try contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
//                let name = contact.givenName
//                let familynName = contact.familyName
//                let number = contact.phoneNumbers.first?.value.stringValue
//            
//                let contactToAppend = Contact(name: name + " " + familynName, phone: number!, isRSVP: isRSVP, isInvited: isInvited)
//            //print("CONCAT = \(contactToAppend)")
//                //let contactToAppend2 = Contact(name: name + " " + familynName + " " + number!)
//                //self.contact.append(contactToAppend2)
//                self.contacts.append(contactToAppend)
//                //print(self.contacts)
//        
//            })
//        } catch let err {
//            print("failed to enumerate contacts", err)
//        }
//        
//    
//       // tableView.reloadData()
//        
//        print(contacts)
//    }
//    
    
    func fetchRSVPAttendees(eventId: Int64) {
        let request = Request(path: "/api/Event/attendees?eventId=\(eventId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
                case .success(let rsvpattendees):
                     let decoder = JSONDecoder()
                     do {
                        let attendeesJson: [RSVPAttendees] = try decoder.decode([RSVPAttendees].self, from: rsvpattendees)
                        for data in attendeesJson {
                            
                            //add rsp attendeese except the current profile
                            //you don't want to spray yourself
                            if data.profileId != self.profileId! {
                                let dataOutPut = RSVPAttendees(profileId: data.profileId, firstName: data.firstName + " " + data.lastName, lastName: data.lastName, email: data.email, phone: data.phone, eventId: data.eventId, isAttending: data.isAttending)
                                self.rsvpAttendees.append(dataOutPut)
                            }
                            
                            //self.tableView.reloadData()
                        }
                        print("FETCHING DATA = \(self.rsvpAttendees)")
                        self.tableView.reloadData()
                    } catch {
                        print(error)
                    }
                   
                     print("rsvpattendees =\(self.rsvpAttendees)")
                case .failure(let error):
                    //self.textLabel.text = error.localizedDescription
                    print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }
    

    
    struct Invitees {
        var name: String
//        var firstName: String
//        var lastName: String
//        var email: String
        var phone: String
        var sentInvite: Bool
    }
    
    var invitees = [Invitees]()



    @objc func saveClicked(){
        var i: Int = 0
        var email: String = ""
        for invite in invitees {
            
            email = String("me555\(i)mail.com")
            
            print("the invite = \(invite.name)")
            let Invite = SendInvite(profileId: nil, email: email, phone: invite.phone, eventCode: eventCode)
            
            let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token, apiKey: encryptedAPIKey, deviceId: "")
        
            
            Network.shared.send(request) { (result: Result<Data, Error>)  in
                switch result {
                case .success( _):
                    
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            print(Invite)
            i=i+1
        }
        if invitees.count == i {
            print("Update is complete")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
      1
   
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searching {
//            return contact.count
//        } else {
//            return contacts.count
//        }
        if searching {
            return rsvpAttendees2.count
            print("rsvpAttendees2.count \(rsvpAttendees2.count)")
        } else {
            return rsvpAttendees.count
            print("rsvpAttendees.count \(rsvpAttendees.count)")
        }
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
       
       
        //let contactToDisplay = contact[indexPath.row]
       
        
        if balance > 0 {
            print("balance =\(balance)")
           cell.accessoryType = .disclosureIndicator
            tableView.allowsSelection = true
        } else {
            print("balance =\(balance) no .disclosure indicatore")
            tableView.allowsSelection = false
        }
        if searching {
            cell.textLabel?.text = rsvpAttendees2[indexPath.row].firstName + " \(rsvpAttendees2[indexPath.row].profileId)"
            cell.detailTextLabel?.text = rsvpAttendees2[indexPath.row].lastName
            attendeeNameSelected = rsvpAttendees2[indexPath.row].firstName
            giftReceiverId = rsvpAttendees2[indexPath.row].profileId
        } else {
            cell.textLabel?.text = rsvpAttendees[indexPath.row].firstName + " \(rsvpAttendees[indexPath.row].profileId)"
            cell.detailTextLabel?.text = rsvpAttendees[indexPath.row].lastName
            attendeeNameSelected = rsvpAttendees[indexPath.row].firstName
            giftReceiverId = rsvpAttendees[indexPath.row].profileId
            
//            cell.textLabel?.text = contact[indexPath.row].name
//            cell.detailTextLabel?.text = contact[indexPath.row].phone
//            attendeeNameSelected = contact[indexPath.row].name
//               } else {
//            cell.textLabel?.text = contacts[indexPath.row].name
//            attendeeNameSelected = contacts[indexPath.row].name
//            cell.detailTextLabel?.text = contacts[indexPath.row].phone
            
             //cell.accessoryType = .disclosureIndicator
             //contactToDisplay.givenName + "  " + contactToDisplay.familyName
                   //cell.detailTextLabel?.text = contactToDisplay.number
        }
//        let switchView = UISwitch(frame: .zero)
//        switchView.setOn(false, animated: true)
//        switchView.tag = indexPath.row
//        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
//
//        cell.accessoryView = switchView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if balance > 0 {
            print("balance =\(balance)")
            performSegue(withIdentifier: "goToSpray", sender: self)
              self.dismiss(animated: true, completion: nil)
        } else {
            print("balance =\(balance)")
        }
//         if searching {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
////            myItemsArray[indexPath.row].isChecked  = false
////            myItemsArray[indexPath.row].name = contacts[indexPath.row].name
//            print(" Remove = \(contact[indexPath.row].name) --- Index = \([indexPath.row]) ")
//            //myItemsArray = Items(isChecked: true, name: contacts[indexPath.row].name)
//            //let inviteeRecord = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, sentInvite: true)
//             self.invitees[indexPath.row] = Invitees(name: contact[indexPath.row].name, phone: contact[indexPath.row].phone, sentInvite: false)
//            //invitees.append(inviteeRecord)
//           // invitees.remove(at: indexPath.row)
//
//        }else {
//             tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//            let inviteeRecord = Invitees(name: contact[indexPath.row].name, phone: contact[indexPath.row].phone, sentInvite: true)
//            invitees.append(inviteeRecord)
//             print(" Add = \(contact[indexPath.row].name) --- Index = \([indexPath.row]) ")
//
//            //myItemsArray[indexPath.row - 1].isChecked  = true
//            //myItemsArray[indexPath.row - 1].name = contacts[indexPath.row].name
//
//        }
//         } else {
//             if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
//                        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
//            //            myItemsArray[indexPath.row].isChecked  = false
//            //            myItemsArray[indexPath.row].name = contacts[indexPath.row].name
//                        print(" Remove = \(contacts[indexPath.row].name) --- Index = \([indexPath.row]) ")
//                self.invitees[indexPath.row] = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, sentInvite: false)
//                        //myItemsArray = Items(isChecked: true, name: contacts[indexPath.row].name)
//                        //let inviteeRecord = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, sentInvite: true)
//                        //invitees.append(inviteeRecord)
//                       // invitees.remove(at: indexPath.row)
//                print("my invitees object SENT INVITES = FALSE = \(invitees)")
//
//                    }else {
//                         tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//                        let inviteeRecord = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, sentInvite: true)
//                        print(" Add = \(contacts[indexPath.row].name) --- Index = \([indexPath.row]) ")
//                        invitees.append(inviteeRecord)
//                        //myItemsArray[indexPath.row - 1].isChecked  = true
//                        //myItemsArray[indexPath.row - 1].name = contacts[indexPath.row].name
//
//                 print("my invitees object SENT INVITES = FALSE = \(invitees)")
//                    }
            
       // }
            
       // print("printing invities object = \(invitees)")
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
        
    }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
   //func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    // return getfooterView()
//        if searching {
//             return getfooterView()
//        } else {
//            return nil
//        }
       
//        guard section == 0 else { return nil }
//
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0))
//        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 44.0))
//        // here is what you should add:
//        doneButton.center = footerView.center
//
//        doneButton.setTitle("Send Invites", for: .normal)
//        doneButton.backgroundColor = .lightGray
//        doneButton.layer.cornerRadius = 10.0
//       // doneButton. shadow = true
//        doneButton.addTarget(self, action: #selector(hello(sender:)), for: .touchUpInside)
//        footerView.addSubview(doneButton)
//         contentView.addSubview(doneButton)
//        return footerView
     //   return nil
   // }
    
   /* func getfooterView() -> UIView
    {
        let Header = UIView(frame: CGRect(x: 0, y: 0, width: Double(self.tableView.frame.size.width), height: 45))
       Header.backgroundColor = UIColor(named: "#2AF8AC")
       
        
        
       // let Header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0))
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 44.0))
        //button.frame = CGRect(x: 0, y: 0, width: Header.frame.size.width , height: Header.frame.size.height)
        button.backgroundColor = .gray
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(saveClicked), for: UIControl.Event.touchUpInside)

        Header.addSubview(button)
       Header.bringSubviewToFront(button)
        return Header
    } */
    
    @objc func SubmitAction()  {
    print("Hello");
        let selectedRows = self.tableView.indexPathsForSelectedRows
        if selectedRows != nil {
            for var selectionIndex in selectedRows! {
                while selectionIndex.item >= rsvpAttendees.count {
                    selectionIndex.item -= 1
                    print("Dominic IGhedoas")
                }
                //tableView(tableView, commit: .delete, forRowAt: selectionIndex)
            }
        }

    }
    
    
    @objc func switchChanged(_ sender: UISwitch!) {
        print("attendee name selected  = =\(attendeeNameSelected)")
        print("table row swith changed \(sender.tag)")
        print("the swith is \(sender.isOn ? "ON" : "OFF")")
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
    
        if segue.identifier == "goToSpray" {
            //if let indexPath = self.tableVi
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let NextVC = segue.destination as! SprayViewController
                if searching {
                    print("BALANCE AT SEGUE 1 = \(balance)")
                    NextVC.incomingGiftReceiverName =   rsvpAttendees2[indexPath.row].firstName //contact[indexPath.row].name
                    NextVC.eventName = eventName
                    NextVC.eventDateTime = eventDateTime
                    NextVC.eventCode = eventCode
                    NextVC.paymentClientToken = paymentClientToken!
                    NextVC.eventTypeIcon = eventTypeIcon
                    //nextVC.paymentClientToken  =  paymentClientToken
                    NextVC.gifterBalance = balance
                    NextVC.sprayDelegate = self
                    NextVC.eventId = eventId!
                    NextVC.profileId = profileId!
                    NextVC.giftReceiverId = rsvpAttendees2[indexPath.row].profileId
                    NextVC.gifterTotalTransAmount = gifterTotalTransAmount
                    NextVC.token = token
                    NextVC.encryptedAPIKey = encryptedAPIKey
                    NextVC.isAutoReplenishFlag = isAutoReplenishFlag
                    NextVC.autoReplenishAmount = autoReplenishAmount
                    NextVC.notificationAmount = notificationAmount
                    NextVC.sprayIncrementAmt = sprayIncrementAmt
                    NextVC.currencyImageSide1 = currencyImageSide1
                    NextVC.currencyImageSide2 = currencyImageSide2
                    NextVC.paymentMethod = paymentMethod
                } else {
                    print("BALANCE AT SEGUE 2 = \(balance)")
                    NextVC.eventName = eventName
                    NextVC.eventDateTime = eventDateTime
                    NextVC.eventCode = eventCode
                    NextVC.paymentClientToken = paymentClientToken!
                    NextVC.eventTypeIcon = eventTypeIcon
                    NextVC.incomingGiftReceiverName =  rsvpAttendees[indexPath.row].firstName // contacts[indexPath.row].name
                    NextVC.gifterBalance = balance
                    NextVC.gifterTotalTransAmount = gifterTotalTransAmount
                    NextVC.sprayDelegate = self
                    NextVC.eventId = eventId!
                    NextVC.profileId = profileId!
                    NextVC.giftReceiverId = rsvpAttendees[indexPath.row].profileId //giftReceiverId!
                    NextVC.token = token
                    NextVC.encryptedAPIKey = encryptedAPIKey
                    NextVC.isAutoReplenishFlag = isAutoReplenishFlag
                    NextVC.autoReplenishAmount = autoReplenishAmount
                    NextVC.notificationAmount = notificationAmount
                    NextVC.sprayIncrementAmt = sprayIncrementAmt
                    NextVC.currencyImageSide1 = currencyImageSide1
                    NextVC.currencyImageSide2 = currencyImageSide2
                    NextVC.paymentMethod = paymentMethod
                }
            }
        }
    }
}

extension SelectAttendeeToSprayViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
            //searchActive = false
        self.searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //contact = contacts.filter({$0.name.prefix(searchText.count) == searchText})
        
        
        if searchText.count > 0 {
            rsvpAttendees2 =  rsvpAttendees.filter({$0.firstName.lowercased().prefix(searchText.count) == searchText.lowercased()})
            
            print("rsvpAttendees2 func searchbar = \(rsvpAttendees2)")
        } else {
            self.rsvpAttendees2.removeAll()
            //contact = contacts
            print("TABLE REFRESH WAS CALLED")
            //tableView.reloadData()
//            self.contact.removeAll()
//            self.contacts.removeAll()
//            self.rsvpAttendees.removeAll()
//            self.invitees.removeAll()
//            self.getInvitedGuest(eventId: self.eventId!)
        }
        
        
       // contacts = contacts.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
//            //= //countryNameARr.fitler({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
//        contact = contacts.filter {
//            (service: ContactStruct) -> Bool in
////        let index = find(value: "Eddie", in: contacts)
////        print(index)
////            return
////            co
////            if let name = service.givenName.lowercased().prefix(searchText.count) == searchText.lowercased()
////            return false
//        }
//
        
        //*** this is good
    
        
        searching = true
        tableView.reloadData()
    }
    
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        
        //rsvpAttendees2.removeAll()
        /*reset data*/
        //rsvpAttendees2 = rsvpAttendees
        tableView.reloadData()
        
        print("I was cancelled")
    }
}


extension SelectAttendeeToSprayViewController: SprayTransactionDelegate {
    func processSprayTransaction(eventId: Int, senderId: Int,  receiverId: Int, senderAmountRemaining: Int, receiverBalanceAfterSpray: Int, isAutoReplenish: Bool, paymentMethod: Int) {
        refreshScreen = true
        
        print("The Receiver ID = \(receiverId)")
        //only do this if an attendee receives a gift
        if receiverBalanceAfterSpray > 0 {
            let AddSprayTrans = SprayTransactionModel(eventId: Int64(eventId), senderId: Int64(senderId), recipientId: Int64(receiverId), amount: receiverBalanceAfterSpray, success: true, errorCode: "", errorMessage: "")
            
            print("AddSprayTrans \(AddSprayTrans)")
            let request = PostRequest(path: "/api/SprayTransaction/add", model: AddSprayTrans , token: token, apiKey: encryptedAPIKey, deviceId: "")

            Network.shared.send(request) { (result: Result<Data, Error>)  in
                switch result {
                case .success( _):
                    self.getGifterTotalTransBalance()
                    //call these functions after spray transaction is complete
                    //these func will get updated balance
                    
                   // getGifterData()
                  
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
       
        
        
         let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy HH:mm"
        let transactionDateTime = df.string(from: Date())
        
//        senderspraybalance = db.readSenderSprayBalanceById(eventId: Int64(Int(eventId)), senderId: Int64(Int(senderId)))
//        if senderspraybalance.count == 0 {
//            print("GO AHEAD AND INSERT INTO senderspraybalance")
//
//            db.insertSenderSprayBalanceTable(eventId: eventId, senderId: senderId, senderAmountRemaining: senderAmountRemaining, isAutoReplenish:1,  transactionDateTime: transactionDateTime, paymentType: paymentMethod)
//
//            senderspraybalance = db.readSenderSprayBalanceById(eventId: Int64(Int(eventId)), senderId: Int64(Int(senderId)))
//            if senderspraybalance.count > 0 {
//                for s in senderspraybalance {
//                    print("sender amount remaining after insert =\(s.senderAmountRemaining)")
//                    balance = s.senderAmountRemaining
//                }
//            }
//
//        } else {
//            print("GO AHEAD AND UPDATE")
//            db.updateSprayBalanceById(eventId: Int64(eventId), senderId: Int64(senderId), senderAmountRemaining: senderAmountRemaining, isAutoReplenish: isAutoReplenish)
//
//            senderspraybalance = db.readSenderSprayBalanceById(eventId: Int64(Int(eventId)), senderId: Int64(Int(senderId)))
//            if senderspraybalance.count > 0 {
//                for s in senderspraybalance {
//                   balance = s.senderAmountRemaining
//
//                    print("sender amount remaining after update  = \(s.senderAmountRemaining)")
//                }
//            }
//
//
//
//        }
    }
    
    func sprayGifterBalance(balance: Int) {
        gifterBalanceAfterSpray = balance
        print(" AWELE IGHEDOSA = \(gifterBalanceAfterSpray)")
    }
    
    func sprayReceiverBalance(balance: Int) {
        receiverBalanceAfterSpray = balance
         print(" NAYLA IGHEDOSA = \(receiverBalanceAfterSpray)")
    }
    
    func sprayReceiverId(receiverId: Int64) {
        theReceiverId = receiverId
        
    }
    
    func sprayEventSettingRefresh(isEventSettingRefresh: Bool) {
        eventSettingRefresh = isEventSettingRefresh
        print("I WAS CALLED")
    }
    
    
    
}

extension SelectAttendeeToSprayViewController:  RefreshScreenDelegate {
    func refreshScreen(isRefreshScreen: Bool) {
        print("refreshData function was called")
        refreshScreen = isRefreshScreen
    }
////
////        func refreshScreen(isRefreshScreen: Bool) {
////
////
////
////            //print("refreshHomeScreenDate = \(isShowScreen)")
////        }
}
