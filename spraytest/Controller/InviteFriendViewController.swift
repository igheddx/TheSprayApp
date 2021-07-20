//
//  InviteFriendViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 6/18/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
//import Contacts
import Contacts
import ContactsUI
import AVFoundation

class InviteFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventCodeLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var eventTypeImage: UIImageView!
    
    var message: String = ""
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var profileId: Int64?
    var eventId: Int64?
    var token: String = ""
    var eventTypeIcon: String = ""
    
    var attendeeNameSelected: String = ""
    var attendeePhoneSelected: String = ""
    
    
    var contactStore = CNContactStore()
    var service = [CNContactStore]()
    var contacts = [Contact]()
    var contact = [Contact]()
    var rsvpAttendees = [RSVPAttendees]()
    var rsvpAttendees2 = [RSVPAttendees]()
    var invitedGuest = [InvitedGuest]()
    var joineventfields: [JoinEventFields] = []
    var joineventlist: [JoinEventFields] = []
    var paymentClientToken: String = ""
    //@IBOutlet weak var messageLabel: UILabel!
    var encryptedDeviceId: String = ""
    var searchCountry = [String]()
    var searching = false
    var encryptedAPIKey: String = ""
    var resetCheckmark: Bool = false
    var isRecordUpdated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero) //use to remove lines when no cell is returned
        tableView.allowsMultipleSelection = true
        
        searchBar.text = ""
        /*make the search bar background white*/
        self.searchBar.isTranslucent = false
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.barTintColor = .white
      
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //tableView.allowsMultipleSelectionDuringEditing = true self.navigationItem.rightBarButtonItem = editButtonItem
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Authorize")
            }
        }
        contact.removeAll()
        contacts.removeAll()
        invitees.removeAll()
        
        
//        DispatchQueue.global().async { [self] in
//        let lock = DispatchSemaphore(value: 0)
//        // Load any saved meals, otherwise load sample data.
//            //getInvitedGuest(eventId: eventId!)
//        self.getInvitedGuest(eventId: eventId!, completion: {
//            lock.signal()
//        })
//        lock.wait()
//        // finished fetching data
//        }
        
        //getInvitedGuest(eventId: eventId!, completion: { () in print("Done") })
        getInvitedGuest(eventId: eventId!)
        //fetchContacts()
        
        //fetchContacts()
       
       
        
        eventNameLabel?.text = eventName
        eventDateTimeLabel?.text = eventDateTime
        //eventCodeLabel?.text = eventCode
        eventTypeImage.image = UIImage(named: eventTypeIcon)
       // messageLabel?.text = message
        //print(messageLabel.text!)
        
        
        // `contacts` Contains all details of Phone Contacts
           
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
            // Or to rotate and lock
            // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        contact.removeAll()
        contacts.removeAll()
        invitees.removeAll()
        
        getInvitedGuest(eventId: eventId!)
    }
    

    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    func loadingIndicator() {
          self.dismiss(animated: true, completion: nil)
                
                let alert = UIAlertController(title: nil, message: "Loading data.. Please wait...", preferredStyle: .alert)

                alert.view.tintColor = UIColor.black
 

                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.medium
                loadingIndicator.startAnimating();

                alert.view.addSubview(loadingIndicator)
                present(alert, animated: true, completion: nil)
    }
    func getInvitedGuest(eventId: Int64) {
        print("STEP 1 - getInvitedGuest")
        let request = Request(path: "/api/Event/invitations?eventId=\(eventId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
                case .success(let invitedGuest):
                    print("STEP 2 - getInvitedGuest")
                    //print("invitedGuest = \(invitedGuest)")
                    //self.loadingIndicator()
                     let decoder = JSONDecoder()
                     do {
                        let invitedGuestJson: [InvitedGuest] = try decoder.decode([InvitedGuest].self, from: invitedGuest)
                        for data in invitedGuestJson {
                            let dataOutPut = InvitedGuest(firstName: data.firstName, lastName: data.lastName, email: data.email, phone: data.phone, profileId: data.profileId)
                            print("STEP 3 - getInvitedGuest")
                            //print("DOMINIC IGHEDOA GETINVITEDGUTEST invitedGuest dataOutPut =\(dataOutPut)")
                            self.invitedGuest.append(dataOutPut)
                            //self.tableView.reloadData()
                            
                        }
                    } catch {
                        print(error)
                    }
                   
                     //print("invitedGuest =\(self.invitedGuest)")
                case .failure(let error):
                    //self.textLabel.text = error.localizedDescription
                    print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
            // call completion
            print("STEP 4 - fetchRSVPAttendees")
            self.fetchRSVPAttendees(eventId: eventId)
            
          
        }
       // self.dismiss(animated: false, completion: nil)
        print("STEP 5 fetchRSVPAttendees")
    }
    func fetchRSVPAttendees(eventId: Int64) {
        let request = Request(path: "/api/Event/attendees?eventId=\(eventId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
                case .success(let rsvpattendees):
                    print("rsvpattendees = \(rsvpattendees)")
                     let decoder = JSONDecoder()
                     do {
                        let attendeesJson: [RSVPAttendees] = try decoder.decode([RSVPAttendees].self, from: rsvpattendees)
                        for data in attendeesJson {
                            let dataOutPut = RSVPAttendees(profileId: data.profileId, firstName: data.firstName + " " + data.lastName, lastName: data.lastName, email: data.email, phone: data.phone, eventId: data.eventId, isAttending: data.isAttending)
                            print("STEP 10  fetchRSVPAttendees -  rsvpattendees dataOutPut =\(dataOutPut)")
                            self.rsvpAttendees.append(dataOutPut)
                            //self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                   
                     //print("rsvpattendees =\(self.rsvpAttendees)")
                case .failure(let error):
                    //self.textLabel.text = error.localizedDescription
                    print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
            self.fetContacts2()
            print("STEP 11  fetContacts2")
        }
        //print("DOMINIC - \(rsvpAttendees)")
    }
    
    
    func fetContacts2() {
        
      
        
        var isRSVP: Bool = false
        var isInvited: Bool = false
        
        var firstName: String = ""
        var lastName: String = ""
        var email: String = ""
        var phoneNumber: String = ""
        
        let contacts = self.getContactFromCNContact()
        for contact in contacts {
            
            firstName = contact.givenName
            lastName = contact.familyName
            
            if contact.phoneNumbers.count > 0 {
                for phone in contact.phoneNumbers {
                    phoneNumber = phone.value.stringValue
                    break
                }
            } else {
                phoneNumber = ""
            }
            
            //let phoneNumber = contact.phoneNumbers.first?.value.stringValue as Any
           
//            print(contact.middleName)
//            print(contact.familyName)
//            print(contact.givenName)
//            //print(contact.emailAddresses value as String)
//            print(contact.phoneNumbers.first?.value.stringValue as Any)
//
            if contact.emailAddresses.count > 0 {
                for mail in contact.emailAddresses {
                          // email.append(mail.value as String)
                    email = mail.value as String
                    //print("my email \(mail.value as String)")
                    break
                    
                }
            } else {
                 email = ""
            }
            
            if email != "" || phoneNumber != "" {
                print("i am here self.rsvpAttendees = \(self.rsvpAttendees)")
                for rsvp in self.rsvpAttendees {
                    print("contact phone =\(phoneNumber) RSVP phone \(rsvp.phone)")
                    let normalizedPhoneNumber = convertPhoneToString(phone: phoneNumber)
                    if  normalizedPhoneNumber == rsvp.phone {
                        isRSVP = true
                        break
                    } else if email == rsvp.email {  //if phone doesn't match, check email if it matches set var to true
                        isRSVP = true
                        break
                    }
                }
                
                //print("self.invitedGuest = \(self.invitedGuest)")
                for invited in self.invitedGuest {
                    let normalizedPhoneNumber = convertPhoneToString(phone: phoneNumber)
                    print("contact phone =\(phoneNumber) invited phone \(invited.phone) - converted phone number \(normalizedPhoneNumber)")
                    
                    if  normalizedPhoneNumber == invited.phone {
                        isInvited = true
                        print("isInvited PHONE NUMBER IS THE SAME \(isInvited)")
                        break
                    } else if email == invited.email { //if phone doesn't match, check email if it matches set var to true
                        isInvited = true
                        break
                    }
                }
                
                let contactToAppend = Contact(name: firstName + " " + lastName, phone: phoneNumber, email: email, isRSVP: isRSVP, isInvited: isInvited)
               print("contactToAppend  \(contactToAppend)")
                self.contacts.append(contactToAppend)
                //reset
                isInvited = false
                isRSVP = false
                
               // print("contactToAppend \(contactToAppend)")
            
            }
        }
        
        /*do this when invite is sent - we want to retain
         the search criteria and the results when the invite
         was subnitted
         */
        
        if isRecordUpdated == true {
            self.searchBar.becomeFirstResponder()
            let searchCriteria = searchBar.text!
            self.searchBar(self.searchBar, textDidChange: searchCriteria)
        }
       
        
        tableView.reloadData()
         print("STEP 12  fetContacts2() - tableView.reloadData()")
        
       
        
    //print("CONCAT = \(contactToAppend)")
        //let contactToAppend2 = Contact(name: name + " " + familynName + " " + number!)
        //self.contact.append(contactToAppend2)
       
    }
    func getContactFromCNContact() -> [CNContact] {

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            ] as [Any]

        //Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {

            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)

            } catch {
                print("Error fetching results for container")
            }
        }

        return results
    }
    func fetchContacts() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        
        var isRSVP: Bool = false
        var isInvited: Bool = false
        
        var x: Int = 0
        do {
            x = x + 1
            try contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
                let name = contact.givenName
                let familynName = contact.familyName
                let number = contact.phoneNumbers.first?.value.stringValue
                //let email = contact.emailAddresses[0].value as String
                
                for rsvp in self.rsvpAttendees {
                    if number! == rsvp.phone {
                        isRSVP = true
                        break
                    }
                }
                for invited in self.invitedGuest {
                    if number! == invited.phone {
                        isInvited = true
                        break
                    }
                }
                let contactToAppend = Contact(name: name + " " + familynName, phone: number!, email: "", isRSVP: isRSVP, isInvited: isInvited)
                
                //print("contactToAppend \(contactToAppend)")
            //print("CONCAT = \(contactToAppend)")
                //let contactToAppend2 = Contact(name: name + " " + familynName + " " + number!)
                //self.contact.append(contactToAppend2)
                self.contacts.append(contactToAppend)
                //print(self.contacts)
        
            })
        } catch let err {
            print("failed to enumerate contacts", err)
        }
        
    
       // tableView.reloadData()
        
       // print(contacts)
    }
    
    struct Invitees {
        var name: String
        var phone: String
        var email: String
        var sentInvite: Bool
    }
    
    var invitees = [Invitees]() //[JoinEvent]()
    var joinevent: [JoinEvent] = []
    
    //[EventProperty]()

    func random9DigitString() -> String {
        let min: UInt32 = 100_000_000
        let max: UInt32 = 999_999_999
        let i = min + arc4random_uniform(max - min + 1)
        return String(i)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func sendSMS(phone: String, message: String) {
        print("send SMS")
        //encryptedDeviceId = device.getDeviceId(userName: username!)
        
        let smsModel = SMSModel(phone: phone, email: "", code: "", message: message, profileId: 0)
        let request = PostRequest(path: "/api/otpverify/sendsms", model: smsModel, token: token, apiKey: encryptedAPIKey, deviceId: "")

            //encryptedDeviceId
        ///api/OtpVerify/sendsms
        print("my request \(request)")
        Network.shared.send(request) { [self] (result: Result<SMSData, Error>)  in
        switch result {
        case .success(let smsdata):
            if smsdata.success == true {
                //launchOTPVerifyVC(phone: phone)
                print("data was sent")
                
            } else  {
                //LoadingStop()
                theAlertView(alertType: "sms", message: "")
            }
            print("success")
        case .failure(let error):
            //LoadingStop()
            theAlertView(alertType: "sms", message: error.localizedDescription)
            }
        }
        
    }
    
    func theAlertView(alertType: String, message: String){
        var alertTitle: String = ""
        var alertMessage: String = ""
        if alertType == "sms" {
            //spinerTaskEnd()
            alertTitle = "SMS"
            alertMessage = "Something went wrong with the SMS. Please try again."
            
            
            
        } else if alertType == "MissingFields" {
            //spinerTaskEnd()
            alertTitle = "Login Error"
            alertMessage = "You entered an invalid login ID or Password. \n"
        } else if alertType == "InitializeError" {
            //spinerTaskEnd()
            alertTitle = "Login Error"
            alertMessage = "Something went wrong with the initialization. Please try again. \n"
        }

        let alert2 = UIAlertController(title: alertTitle, message: "\(alertMessage) \n \(message)", preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert2, animated: true)
    }
    
    func convertPhoneToString(phone: String) -> String {
        var phonestr3: String = ""
        let phonestr1 = phone.replacingOccurrences(of: "[\\(\\)^^+-]", with: "", options: .regularExpression, range: nil)
        //this needs to be refactored for international users
       
        let phonestr2 = phonestr1.replacingOccurrences(of: " ", with: "")
        
        print("phonestr2.count = \(phonestr2.count) phone \(phonestr2)")
         if phonestr2.count > 10 {
             print("it's greater than 10")
             let Dropcount = phonestr2.count - 10
             phonestr3 = "+1\(String(phonestr2.dropLast(Dropcount)))"
         } else {
            phonestr3 = "+1\(phonestr2)"
         }
        
        return phonestr3
    }

    @IBAction func sendInviteBtnPressed(_ sender: Any) {
        saveClicked()
    }
    @objc func saveClicked(){
        //var email: String = ""
       //print("invitees =\(invitees)")
        var postJoinEventData: Bool = false
        var emailBody: String = ""
        var emailSubject: String = ""
        for invite in invitees {
            
           // var html: String = "<html><body><p>Click here to download app: <a href=\"http://www.cnn.com/\">Download App</a></body></html>"
            
            emailBody = "Dear \(invite.name), you are cordially invited to \(self.eventName) event. The Event is on \(self.eventDateTime). EVENT CODE is \(self.eventCode). Please download the Spray App with the link below and RSVP. \n\n\n <html><body><p>Click here to download app: <a href=\"http://www.cnn.com/\">Download App</a></body></html>"
            
            emailSubject = "Invited to \(self.eventName) Event! EVENT CODE: \(self.eventCode)"
            
            print("my name DOMINIC IGH =  \(invite.name) and sentInvite \(invite.sentInvite)")
            print(" this is what the phone number looks like \(invite.phone)")
            if invite.sentInvite == false {
                //convert phone number to format for sending SMS
                let normalizedPhoneNumber = convertPhoneToString(phone: invite.phone)
                let dataCollection = JoinEventFields(profileId: 0, email: invite.email, phone: normalizedPhoneNumber , eventCode: eventCode)
                joineventlist.append(dataCollection)
                
                print("dataCollection \(dataCollection)")
                
                
                //this could be sent as a  list in the future
                if invite.email != "" {
                    //not using the commented out - this is for
                    //for sms
                    //let newphone = convertPhoneToString(phone: invite.phone)
                    
//                    print("my phone =\(newphone)")
//                    print("my email =\(invite.email)")
//
//                    print("the super new phone = \(newphone)")
                    //sendSMS(phone: newphone, message: emailBody)
                    
                    self.sendEmail(toEmail: invite.email , toFirstName: invite.name, toLastName: invite.name, subject: emailSubject, message: emailBody, ccList: [""])
                }
                
                
                postJoinEventData = true //set for false for now...
            }
            
            //this is for sending email to someone that you have already sent email to- hold on to this 7/9/2021
//            else {
//                //send email instead
//                let emailAddress = invite.email
//                print("my email address \(emailAddress)")
//
//                if emailAddress != "" {
//                    self.sendEmail(toEmail: emailAddress, toFirstName: invite.name, toLastName: invite.name, subject: emailSubject, message: emailBody, ccList: [""])
//                }
//
//            }
       
        }
        
        //only update data if condition is true
        if postJoinEventData == true {
            
            resetCheckmark = false //reset checkmarks after update
            isRecordUpdated = false
            
            let joinTheEvent = JoinEvent(joinList: joineventlist)
            //}
            let myjson = """
            {
                "joinList": [
                  {
                    "profileId": 0,
                    "email": "d1234a@mail.com",
                    "phone": "123-234-1999",
                    "eventCode": "RRQY2YRY"
                  }
                ]
              }
            """
            
            //print(myjson)
            //let inviteeJson = joinevent
            let request = PostRequest(path: "/api/Event/joinevent", model: joinTheEvent, token: token, apiKey: encryptedAPIKey, deviceId: "")
            
           // print("joinevent =\(joinTheEvent)")
            Network.shared.send(request) { (result: Result<Empty, Error>)  in
                switch result {
                case .success( let join):
                   // print(self.join.joinList[0].email)
                    
                    //self.messageLabel.text = "Congrats! Invitation has been sent."
                    //self.messageLabel.textColor = UIColor(red: 32/256, green: 106/256, blue: 93/256, alpha: 1.0)
                    print("AWELE IGHEDOSA - ")
                    self.resetCheckmark = true
                    self.isRecordUpdated = true
                    self.joineventlist.removeAll()
                    self.contact.removeAll()
                    self.contacts.removeAll()
                    self.rsvpAttendees.removeAll()
                    self.invitees.removeAll()
                    self.getInvitedGuest(eventId: self.eventId!)
                    //self.tableView.reloadData()
                    
                   
                    break
                case .failure(let error):
                    //self.messageLabel.text = "Something went terribly wrong. Please try again.."
                    print("This is the erro \(error.localizedDescription)")
                }
            }
        }
      
        //print("joinevent = \(joinevent)")
//        if invitees.count == i {
//            print("Update is complete")
//        }
        
    }
    
  
    
    func sendEmail(toEmail:String, toFirstName: String, toLastName: String, subject: String, message: String, ccList: [String]) {
        
        let sendEmailData = SendEmail(toEmail: toEmail, toFirstName: toFirstName, toLastName: toLastName, subject: subject, message: message, ccList: ccList)
        
        print("sendEmailData \(sendEmailData)")
        let request = PostRequest(path: "/api/Profile/email", model: sendEmailData, token: token, apiKey: encryptedAPIKey, deviceId: "")
    
        
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
      1
   
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return contact.count
//        } else {
//            return contacts.count
        } else {
            return 0
        }
        
    }
  

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendsCell") as! InviteFriendsTableViewCell

        if searching {
            
            if contact[indexPath.row].isRSVP == true || contact[indexPath.row].isInvited == true {
                cell.selectionStyle = .none
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            
            cell.nameLbl.text = contact[indexPath.row].name
            cell.name = contact[indexPath.row].name
            cell.avatarInitial.image = cell.imageWith(name: contact[indexPath.row].name)
            cell.phoneLbl.text = contact[indexPath.row].phone
            attendeeNameSelected = contact[indexPath.row].name
            if contact[indexPath.row].isRSVP == true {
                //cell.backgroundColor = .green
                cell.backgroundColor = UIColor(red: 206/255, green: 229/255, blue: 208/255, alpha: 1)
            } else if contact[indexPath.row].isInvited == true {
                cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 237/255, alpha: 1)
            } else if contact[indexPath.row].isInvited == true {
                cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 237/255, alpha: 1)
                
            } else {
                cell.backgroundColor = UIColor.white
                //cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.92, alpha: 1)
            }
            
        }
        
        /* comment out - going to search first to show data
        else {
            if contacts[indexPath.row].isRSVP == true || contacts[indexPath.row].isInvited == true {
                cell.selectionStyle = .none
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }

            cell.nameLbl.text = contacts[indexPath.row].name
            cell.name = contacts[indexPath.row].name
            cell.avatarInitial.image = cell.imageWith(name: contacts[indexPath.row].name)
            attendeeNameSelected = contacts[indexPath.row].name
            cell.phoneLbl.text = contacts[indexPath.row].phone

            if contacts[indexPath.row].isRSVP == true {
                //cell.backgroundColor = .green
                cell.backgroundColor = UIColor(red: 206/255, green: 229/255, blue: 208/255, alpha: 1)
            } else if contacts[indexPath.row].isInvited == true {
                cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 237/255, alpha: 1)
                //rgb(206, 229, 208)
            } else {
                cell.backgroundColor = UIColor.white
            }
        } */

        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if searching {
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
                
                let index = invitees.firstIndex{ $0.phone == contact[indexPath.row].phone && $0.name == contact[indexPath.row].name}
                if let index = index {
                    invitees.remove(at: index)
                }
            }
        }
        
        /*  comment out - going to search first to show data*
        else {
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
                let index = invitees.firstIndex{ $0.phone == contacts[indexPath.row].phone && $0.name == contacts[indexPath.row].name}
                if let index = index {
                    invitees.remove(at: index)
                    //print("invitees object after delete (non-search) = \(invitees)")
                }
            }
        } */
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)//UIColor.red
      
        
        if resetCheckmark == true {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        if searching {
           
//            tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
           
            
            if contact[indexPath.row].isRSVP == true || contact[indexPath.row].isInvited == true {
                
            
               
                
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
                
            } else {
                tableView.cellForRow(at: indexPath)?.selectedBackgroundView = bgColorView
                
                
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
                
            }
            
            
            let inviteeRecord = Invitees(name: contact[indexPath.row].name, phone: contact[indexPath.row].phone, email: contact[indexPath.row].email, sentInvite: contact[indexPath.row].isInvited)
            //self.invitees[indexPath.row] = Invitees(name: contact[indexPath.row].name, phone: contact[indexPath.row].phone, email: "me@mail.com", sentInvite: false)
            invitees.append(inviteeRecord)
            
         }
        
        /* comment out - going to search first to show data
         else {

            if contacts[indexPath.row].isRSVP == true || contacts[indexPath.row].isInvited == true {
                
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
                
            } else {
                
                //set background to light gray
                tableView.cellForRow(at: indexPath)?.selectedBackgroundView = bgColorView
                
                
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
                
            }
            let inviteeRecord = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, email: contacts[indexPath.row].email, sentInvite: contacts[indexPath.row].isInvited)
                        invitees.append(inviteeRecord)
        } */
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
//   func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//     //return getfooterView()
//    }
    
    func getfooterView() -> UIView
    {
        let Header = UIView(frame: CGRect(x: 0, y: 0, width: Double(self.tableView.frame.size.width), height: 90))
       Header.backgroundColor = UIColor(named: "#2AF8AC")
       
        
        
       // let Header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0))
        
        //let button = MainActionBtn(frame: CGRect(x: 110, y: 0, width: 130, height: 44.0))
            
        //let button = UIButton(frame: CGRect(x: 110, y: 0, width: 300, height: 40.0))
        let button = MyCustomButton(frame: CGRect(x: 50, y: 10, width: 300, height: 40.0))
        button.setTitleColor(UIColor.white, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        button.layer.borderWidth = 0.5
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        
        //61, 126, 166 – Hcolor
        button.backgroundColor = UIColor(red: 7/256, green: 104/256, blue: 159/256, alpha: 1.0)
            
            //old UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)
            //UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = true
        
        //button.frame = CGRect(x: 110, y: 0, width: 300, height: 40.0)
        //button.frame = CGRect(x: 0, y: 0, width: Header.frame.size.width , height: Header.frame.size.height)
        //button.backgroundColor = UIColor(red: 2/255.0, green: 132/255.0, blue: 130/255.0, alpha: 1.0)
        button.setTitle("Send Invite", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveClicked), for: UIControl.Event.touchUpInside)

        Header.addSubview(button)
        Header.bringSubviewToFront(button)
        return Header
    }
    
    @objc func SubmitAction()  {
    print("Hello");
        let selectedRows = self.tableView.indexPathsForSelectedRows
        if selectedRows != nil {
            for var selectionIndex in selectedRows! {
                while selectionIndex.item >= contacts.count {
                    selectionIndex.item -= 1
                    print("Dominic IGhedoas")
                }
                //tableView(tableView, commit: .delete, forRowAt: selectionIndex)
            }
        }

    }
    
    
    @objc func switchChanged(_ sender: UISwitch!) {
//        print("attendee name selected  = =\(attendeeNameSelected)")
//        print("table row swith changed \(sender.tag)")
//        print("the swith is \(sender.isOn ? "ON" : "OFF")")
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

extension InviteFriendViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
            //searchActive = false
        self.searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //contact = contacts.filter({$0.name.prefix(searchText.count) == searchText})
        if searchText.count > 0 {
            contact = contacts.filter({$0.name.prefix(searchText.count) == searchText})
            
            print("contact = \(contact)")
            print("text was selected ---")
        } else {
            self.contact.removeAll()
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
//        contact.removeAll()
//        contacts.removeAll()
        
        self.contact.removeAll()
        //contact = contacts
        print("TABLE REFRESH WAS CALLED")
        tableView.reloadData()
        
       // tableView.reloadData()
    }
}
