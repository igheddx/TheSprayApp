//

//  HomeViewController.swift

//  spraytest

//

//  Created by Ighedosa, Dominic on 5/28/20.

//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.

//



import UIKit
//import SVProgressHUD


class HomeViewController: UIViewController, UITextFieldDelegate {

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
    var updateAttendee: Attendees?
    var attendeeFlagWasSet: Bool = false
    var eventtypeData: [EventTypeData] = []
   

    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var lablemessage: UILabel!

    @IBOutlet weak var lablemessage: UILabel!
    var videos: [Video] = []
    //var events = [EventList]()
    
    //var eventsOwned = [EventsOwned]()
    
    
    var token: String?
    var paymentClientToken: String = ""
    var profileId: Int64?
    var eventResult = [EventResult]()
    var homescreeneventdata_2 = [HomeScreenEventDataModel]() //old data
    var homescreeneventdata = [EventProperty]() //new data
    var eventproperty: [EventProperty] = []
    var eventsownedmodel = [EventProperty]()
    var eventsattendingmodel = [EventProperty]()
    var eventIdsattendingmodel = [Int]()
    var eventsinvitedmodel = [EventProperty]()
    var isAttending = [isAttendingModel]()
    var isattendingdata = [isAttendingData]()
    let eventTypeIcon = EventTypeIcon()
    
    
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "My Activity"
        //self.tableView.layer.borderWidth = 0
        //self.tableView.backgroundColor =  UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0)
        
          print("isRefreshData  viewdidLoad \(isRefreshData)")
        print("BACK BUTTON TRIGGERED VIEWDID DID LOAD")
       // print(convertDateFormatter(date: "2020-07-20T19:45:20.435"))

//        readyToSprayButtonPressed.layer.borderColor = UIColor.clear.cgColor
        tableView.register(TableViewCell3.nib(), forCellReuseIdentifier: TableViewCell3.identifier)
        tableView.register(MyInvitationsTableViewCell.nib(), forCellReuseIdentifier: MyInvitationsTableViewCell.identifier)
        tableView.register(MyEventsTableViewCell.nib(), forCellReuseIdentifier: MyEventsTableViewCell.identifier)
        
        super.viewDidLoad()
        //SVProgressHUD.setDefaultMaskType(.black)
        //SVProgressHUD.show(withStatus: "Authenticating...")
        
        //call getMyevent func when the screen loads
        // print("paymentClientToken - Home = \(paymentClientToken!)")
        if isEventEdited == false && isRefreshData == false {
            // print("View Did Load Inside false isEventEdited = \(isEventEdited)")
            getMyEvents()
        }
        homescreeneventdata_2.removeAll()
      
        addEventTypeData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("isRefreshData\(isRefreshData)")
        // print("View Did Appear isEventEdited = \(isEventEdited)")
//        if isEventEdited == true {
//            clearData()
//        }
        //uncommented this so that getMyEvents is not called on initial load of screen
        if isRefreshData == true {
           // print("isRefreshData Did Appear 1 = \(isRefreshData)")
             clearData()
             getMyEvents()
             print("BACK BUTTON TRIGGERED VIEWDID APPEAR isRefreshData  = \(isRefreshData )")
        }
       
        AppUtility.lockOrientation(.portrait)
       
         // print("isRefreshData  Did Appear 2 \(isRefreshData)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
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
        eventtypeData.append(EventTypeData(id: 7, eventTypeName: "Wedding Anniversary"))
        eventtypeData.append(EventTypeData(id: 3, eventTypeName: "Wedding"))
        eventtypeData.append(EventTypeData(id: 4, eventTypeName: "Baby Shower"))
        eventtypeData.append(EventTypeData(id: 5, eventTypeName: "Graduation"))
        eventtypeData.append(EventTypeData(id: 6, eventTypeName: "Naming Ceremony"))
        eventtypeData.append(EventTypeData(id: 8, eventTypeName: "Family Reunion"))
        eventtypeData.append(EventTypeData(id: 9, eventTypeName: "Concert"))
        eventtypeData.append(EventTypeData(id: 10, eventTypeName: "General Party"))
        eventtypeData.append(EventTypeData(id: 11, eventTypeName: "Coffee House"))
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
        vc.messageLabel?.text  = "Next level blog photo booth, tousled authentic tote bag kogi"
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func getMyEvents(){
        let request = Request(path: "/api/Event/myevents?profileid=\(profileId!)", token: token!)
        
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success(let event):
                self.parse(json: event)
            case .failure(let error):
                print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }
    
    
    
    //***** hold this for later *****
    
    func parse(json: Data) {
        print("parse JSON was calle \(json.count)")
        //eventjson.result.eventsOwned
        
       
        
        let decoder = JSONDecoder()
        
        do {
            
            let eventjson = try decoder.decode(EventListModel.self, from: json)
//                let isActive = eventjson.result.eventsOwned[i].isActive
            var j: Int = 0
                for i in eventjson.result.eventsOwned {
                    j = j + 1
                    if i.isActive == true {
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
                     
                     
                         let dataCollection = EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, eventType: eventType, isAttending: nil, dataCategory: "owned")
                     
                        homescreeneventdata.append(dataCollection)
                        print("MY COUNTER = \(j) = \(dataCollection)")
                        //eventsownedmodel.append(dataCollection)

                    }
            }
            

            for x in eventjson.result.eventsInvited {
                if x.isActive == true  {
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
                    let dataCollection2 = EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, eventType: eventType, isAttending: nil, dataCategory: "invited")
                    homescreeneventdata.append(dataCollection2)
                    //eventsinvitedmodel.append(dataCollection2)
                    
                }
            }
            
            
            for item in eventjson.result.eventIdsAttending {
                eventIdsattendingmodel.append(item)
            }
            
            
            for y in eventjson.result.eventsAttending {
                //print("y = \(y)")
                if y.isActive == true {
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
                
                
                let dataCollection3 =  EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, eventType: eventType, isAttending: nil, dataCategory: "attending")
                
                
                homescreeneventdata.append(dataCollection3)
                //eventsattendingmodel.append(dataCollection3)
                
                //y = y + 1
                
               // print(" EVENTS ATTENDDING  \(dataCollection3)")
                
                let data = isAttendingModel(profileId: profileId!, eventId: eventId, category: "eventsAttending")
                
                isAttending.append(data)
                
                attendeeFlagWasSet = false
                
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
            guard let destinationVC = segue.destination as? EventUpdateViewController else {return}
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

         
         let theEventName = homescreeneventdata[indexPathE!.row].name!
        let theEventId = homescreeneventdata[indexPathE!.row].eventId
        

        //print("The event name \(theEventName)")
         let selectRSVPVC = self.storyboard?.instantiateViewController(withIdentifier: "EventSettingViewController") as! EventSettingViewController
         self.navigationController?.pushViewController(selectRSVPVC , animated: true)
        
        selectRSVPVC.eventId = theEventId
        selectRSVPVC.eventName = theEventName
        selectRSVPVC.token = token!
        selectRSVPVC.paymentClientToken =  paymentClientToken
        selectRSVPVC.profileId = profileId!

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
            let profileIdData = profileId!
            let ownerIdData = homescreeneventdata[indexPath.row].ownerId
            let tokenData = token!
            
            let address1Data = homescreeneventdata[indexPath.row].address1!
            let address2Data = homescreeneventdata[indexPath.row].address2!
            let cityData = homescreeneventdata[indexPath.row].city!
            let stateData = homescreeneventdata[indexPath.row].state
            let zipCodeData = homescreeneventdata[indexPath.row].zipCode
            let countryData = homescreeneventdata[indexPath.row].country
            let eventStateData = homescreeneventdata[indexPath.row].eventState
            let eventTypeData =  homescreeneventdata[indexPath.row].eventType
            
            let paymentClientTokenData = paymentClientToken
    
//            cell2.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, isActiveFlag: isActiveFlagCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData, paymentClientToken: paymentClientTokenData, address1: address1Data, address2: address2Data, city: cityData, state: stateData, zipCode: zipCodeData, country: countryData, eventState: eventStateData, eventType: eventTypeData)
//
            cell2.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, isActiveFlag: isActiveFlagCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData, paymentClientToken: paymentClientTokenData, address1: address1Data, address2: address2Data, city: cityData, state: stateData!, zipCode: zipCodeData!, country: countryData!, eventState: eventStateData, eventType: eventTypeData!)
            
//                cell2.configure(with: eventNameCellData,
//                                eventAddress: eventAddressCellData,
//                                eventDateTime: eventDateTimeCellData,
//                                eventCityStateZipCountry: eventCityStateZipCountryCellData,
//                                eventCode: eventCodeCellData,
//                                isActiveFlag: isActiveFlagCellData,
//                                imageName: eventImageCellData,
//                                eventId: eventIdData,
//                                profileId: profileIdData,
//                                ownerId: ownerIdData,
//                                token: tokenData!,
//                                paymentClientToken: paymentClientTokenData,
//                                address1: address1Data,
//                                address2: address2Data,
//                                city: cityData,
//                                state: stateData,
//                                zipCode: zipCodeData,
//                                country: countryData,
//                                eventState: eventStateData,
//                                eventType: eventTypeData)
            
//            cell2.configure(with: eventNameCellData,
//                                  eventAddress: String,
//                                  eventDateTime: String,
//                                  eventCityStateZipCountry: String,
//                                  eventCode: String,
//                                  isActiveFlag: Bool,
//                                  imageName: String,
//                                  eventId: Int64,
//                                  profileId: Int64,
//                                  ownerId: Int64,
//                                  token: String,
//                                  paymentClientToken: String,
//                                  address1: String,
//                                  address2: String,
//                                  city: String,
//                                  state: String,
//                                  zipCode: String,
//                                  country: String,
//                                  eventState: Int,
//                                  eventType: String)
                                
                                
            
                
                print("eventDateTimeCellData = \(eventDateTimeCellData)")
                cell2.myEventsCustomCellDelegate = self
//                cell2.layer.borderColor = UIColor.gray.cgColor
//                cell2.layer.borderWidth = 3.0
                //cell2.accessoryType = .disclosureIndicator
    
//                cell2.layer.borderWidth = 2.0
//                cell2.layer.cornerRadius = 8.0
//                cell2.layer.borderColor  = UIColor.lightGray.cgColor
//                cell2.layer.masksToBounds = false
//                cell2.layer.shadowColor = UIColor.lightGray.cgColor
//                cell2.layer.shadowOffset = CGSize(width: 1, height: 1.0)
//                cell2.layer.shadowRadius = 4.0
//                cell2.layer.shadowOpacity  = 0.0
//                cell2.layer.shadowPath = UIBezierPath(roundedRect: cell2.bounds, cornerRadius: cell2.contentView.layer.cornerRadius).cgPath
            
                return cell2
    
         //}
     }
        
    if  homescreeneventdata[indexPath.row].dataCategory == "invited" {
        let cell3 = tableView.dequeueReusableCell(withIdentifier: MyInvitationsTableViewCell.identifier, for: indexPath) as! MyInvitationsTableViewCell
        cell3.myInvitationCustomCellDelegate = self
        print("RICHARD my invitation")
        //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
        if eventIdsattendingmodel.count == 0 {
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
            let profileIdData = profileId!
            let ownerIdData = homescreeneventdata[indexPath.row].ownerId
            let tokenData = token
            let paymentClientTokenData = paymentClientToken

            cell3.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, isActiveFlag: isActiveFlagCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)
        } else {
            for eventidattending in eventIdsattendingmodel {
                print("RICHARD my invitation eventidattending = \(eventidattending)")
                //print("eventidattending = \(eventidattending)")
                //print("eventId = \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId)")
                if eventidattending != homescreeneventdata[indexPath.row].eventId {
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
                    let profileIdData = profileId!
                    let ownerIdData = homescreeneventdata[indexPath.row].ownerId
                    let tokenData = token
                    let paymentClientTokenData = paymentClientToken

                    cell3.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, isActiveFlag: isActiveFlagCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)

                }
            }
        }
        
        
//        cell3.layer.borderWidth = 2.0
//        cell3.layer.cornerRadius = 8.0
//        cell3.layer.borderColor  = UIColor.lightGray.cgColor
//        cell3.layer.masksToBounds = false
//        cell3.layer.shadowColor = UIColor.lightGray.cgColor
//        cell3.layer.shadowOffset = CGSize(width: 1, height: 1.0)
//        cell3.layer.shadowRadius = 4.0
//        cell3.layer.shadowOpacity  = 0.0
//        cell3.layer.shadowPath = UIBezierPath(roundedRect: cell3.bounds, cornerRadius: cell3.contentView.layer.cornerRadius).cgPath
    
        return cell3
        
    }
        
                   
        
    if homescreeneventdata[indexPath.row].dataCategory == "attending" {
        var isAttendingEventIdCellData: Int = 0
        for eventidattending in eventIdsattendingmodel {
            if eventidattending == homescreeneventdata[indexPath.row].eventId {
                isAttendingEventIdCellData = eventidattending
            }
                
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier, for: indexPath) as! TableViewCell3
        //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
    
        let eventNameCellData = homescreeneventdata[indexPath.row].name!
        let eventAddressCellData = homescreeneventdata[indexPath.row].address1! + " " + homescreeneventdata[indexPath.row].address2!
        //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
        let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.row].dateTime!)


        let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.row].city! + ", " + homescreeneventdata[indexPath.row].state! + " " + homescreeneventdata[indexPath.row].zipCode! + " " +
         homescreeneventdata[indexPath.row].country!

        let eventCodeCellData = homescreeneventdata[indexPath.row].eventCode!
        
        let isActiveFlagCellData = homescreeneventdata[indexPath.row].isActive
        

        let eventImageCellData =  eventTypeIcon.getEventTypeIcon(eventTypeId: homescreeneventdata[indexPath.row].eventType!)
        let eventIdData = homescreeneventdata[indexPath.row].eventId
        let profileIdData = profileId!
        let ownerIdData = homescreeneventdata[indexPath.row].ownerId
        let tokenData = token
        let paymentClientTokenData = paymentClientToken
        print("paymentClientToken! \(paymentClientToken)")
        cell.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData,isActiveFlag: isActiveFlagCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData, isAttendingEventId: Int64(isAttendingEventIdCellData))

            cell.customCellDelegate = self
            //cell.myInvitationCustomCellDelegate = self
//            cell.layer.borderColor = UIColor.gray.cgColor
//
//            cell.layer.borderWidth = 2.0
//            cell.layer.cornerRadius = 8.0
//            cell.layer.borderColor  = UIColor.lightGray.cgColor
//            cell.layer.masksToBounds = false
//            cell.layer.shadowColor = UIColor.lightGray.cgColor
//            cell.layer.shadowOffset = CGSize(width: 1, height: 1.0)
//            cell.layer.shadowRadius = 4.0
//            cell.layer.shadowOpacity  = 0.0
//            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
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
    
}


extension HomeViewController:  MyCustomCellDelegator  {
    func callSegueFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, paymentClientToken: String, screenIdentifier: String, isAttendingEventId: Int64, eventTypeIcon: String) {
       
        
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
                let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectAttendeeToSprayViewController") as! SelectAttendeeToSprayViewController
                           
                    nextVC.eventName = eventName
                    nextVC.eventDateTime = eventDateTime
                    nextVC.eventCode = eventCode
                    nextVC.eventId = eventId
                    nextVC.profileId = profileId
                    nextVC.token = token
                    nextVC.eventTypeIcon = eventTypeIcon
                    nextVC.paymentClientToken = paymentClientToken
                           
                self.navigationController?.pushViewController(nextVC , animated: true)
            }
           
        } else if  screenIdentifier == "EventSettings" {
            
            //let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "EventSettingTableVC2") as! EventSettingTableViewController
            //let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
            //self.present(navController, animated:true, completion: nil)
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventContainer") as! EventSettingContainerViewController
            nextVC.selectionDelegate = self
            nextVC.refreshscreendelegate = self
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
            
            nextVC.eventName = eventName
            nextVC.eventDateTime = eventDateTime
            nextVC.eventCode = eventCode
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.paymentClientToken  =  paymentClientToken
            //nextVC.ownerId = 31
            nextVC.isAttendingEventId = isAttendingEventId
            nextVC.screenIdentifier = screenIdentifier
            nextVC.eventTypeIcon = eventTypeIcon
            
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
            nextVC.paymentClientToken  =  paymentClientToken
            //nextVC.ownerId = 31
//            nextVC.isAttendingEventId = isAttendingEventId
//            nextVC.screenIdentifier = screenIdentifier
//            nextVC.eventTypeIcon = eventTypeIcon
//            
             self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "QRCode" {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayQRCodeViewController") as! DisplayQRCodeViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDate = eventDateTime
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.paymentClientToken  =  paymentClientToken
            //nextVC.ownerId = 31
//            nextVC.isAttendingEventId = isAttendingEventId
//            nextVC.screenIdentifier = screenIdentifier
//            nextVC.eventTypeIcon = eventTypeIcon
//
             self.navigationController?.pushViewController(nextVC , animated: true)
        }

    }

}



extension HomeViewController:  MyInvitationCustomCellDelegate  {
    func callEventSettingFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, paymentClientToken: String, screenIdentifier: String, eventTypeIcon: String) {
       // print("I am ready to seque ")
        
        if screenIdentifier == "RSVP" {
            
            //let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventSettingTableVC") as! EventSettingTableViewController
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventContainer") as! EventSettingContainerViewController
            
//            nextVC.eventName = eventName
//            nextVC.eventId = eventId
//            nextVC.profileId = profileId
//            nextVC.ownerId = ownerId
//            nextVC.token = token
//            nextVC.paymentClientToken  =  paymentClientToken
//            nextVC.screenIdentifier = screenIdentifier
//            nextVC.eventTypeIcon = eventTypeIcon
            
            nextVC.eventName = eventName
            nextVC.eventDateTime = eventDateTime
            nextVC.eventCode = eventCode
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.paymentClientToken  =  paymentClientToken
            //nextVC.ownerId = 31
            nextVC.isAttendingEventId = 0
            nextVC.screenIdentifier = screenIdentifier
            nextVC.eventTypeIcon = eventTypeIcon
            
            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "QRCode" {
            print("CONSTANCE UZOR QRY CODE3")
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayQRCodeViewController") as! DisplayQRCodeViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDate = eventDateTime
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.paymentClientToken  =  paymentClientToken
            
            self.navigationController?.pushViewController(nextVC , animated: true)
        }

    }

}

extension HomeViewController:   MyEventsCustomCellDelegate  {
    func callInviteFriendsFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, paymentClientToken: String, screenIdentifier: String, eventTypeIcon: String, address1: String, address2: String, city: String, state: String, zipCode: String, country: String, eventState: Int, eventType: Int) {
    
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
            nextVC.eventTypeIcon = eventTypeIcon
            
            //nextVC.paymentClientToken  =  paymentClientToken
            

            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "QRCode" {
            
            print("CONSTANCE UZOR QRY CODE2")
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayQRCodeViewController") as! DisplayQRCodeViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDate = eventDateTime
            nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            nextVC.ownerId = ownerId
            nextVC.token = token
            nextVC.paymentClientToken  =  paymentClientToken
            
            self.navigationController?.pushViewController(nextVC , animated: true)
        } else if  screenIdentifier == "EditEvent" {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventUpdateViewController") as! EventUpdateViewController
            
            nextVC.eventName = eventName
            nextVC.eventCode = eventCode
            nextVC.eventDateTime = eventDateTime
            //nextVC.eventTypeIcon = eventTypeIcon
            nextVC.eventId = eventId
            nextVC.profileId = profileId
            //nextVC.ownerId = ownerId
            nextVC.token = token
            
           
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
            
            self.navigationController?.pushViewController(nextVC , animated: true)
            
        }

    }

}

extension HomeViewController:  RefreshScreenDelegate {
    func refreshScreen(isRefreshScreen: Bool) {
       
        isRefreshData = isRefreshScreen
        print("refreshData function was called = \(isRefreshData)")
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

