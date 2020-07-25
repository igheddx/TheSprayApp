//

//  HomeViewController.swift

//  spraytest

//

//  Created by Ighedosa, Dominic on 5/28/20.

//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.

//



import UIKit
//import SVProgressHUD





class HomeViewController: UIViewController {

    var lable1: String?
    //test
    var isEventEdited: Bool = false
    //protocol example still good
    //var clickedPath: IndexPath? = nil
    
    
    
    
    
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var updateAttendee: Attendees?
    var attendeeFlagWasSet: Bool = false
    

    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var lablemessage: UILabel!

    @IBOutlet weak var lablemessage: UILabel!
    var videos: [Video] = []
    //var events = [EventList]()
    
    //var eventsOwned = [EventsOwned]()
    
    
    
    
    
    
    
    var token: String?
    var profileId: Int64?
    var eventResult = [EventResult]()
    var homescreeneventdata = [HomeScreenEventDataModel]()
    var eventproperty: [EventProperty] = []
    var eventsownedmodel = [EventProperty]()
    var eventsattendingmodel = [EventProperty]()
    var eventsinvitedmodel = [EventProperty]()
    var isAttending = [isAttendingModel]()
    var isattendingdata = [isAttendingData]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //SVProgressHUD.setDefaultMaskType(.black)
        //SVProgressHUD.show(withStatus: "Authenticating...")
        
        //call getMyevent func when the screen loads
        
        if isEventEdited == false {
            // print("View Did Load Inside false isEventEdited = \(isEventEdited)")
            getMyEvents()
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // print("View Did Appear isEventEdited = \(isEventEdited)")
        if isEventEdited == true {
            clearData()
        }
    }
    
    
    
    func clearData(){
        eventsownedmodel.removeAll()
        eventsinvitedmodel.removeAll()
        eventsattendingmodel.removeAll()
        homescreeneventdata.removeAll()
        isAttending.removeAll()
        isattendingdata.removeAll()
        //getMyEvents()
    }
    
    
    
    //review this later....
    
    @IBAction func inviteButtonPressed(_ sender: Any) {
        
        
        
        let vc = InviteFriendViewController(nibName: "InviteFriendViewController", bundle: nil)
        
        vc.messageLabel?.text  = "Next level blog photo booth, tousled authentic tote bag kogi"
        
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
//
//    func updateIsAttendingFlag(eventId: Int64, profileId: Int64, ownerId: Int64, completion: @escaping (Bool) -> Void)  {
//
//        var isAttendingFlagIsSuccessful: Bool = false
//
//        //print("I call update Is Attedning Flag")
//
//        //print(token!)
//
//        //let addAttendee = AddAttendees(profileId: ownerId, eventId: eventId, eventAttendees: [Attendees(profileId: profileId, eventId: eventId, isAttending: true)])
//
//        let updateAttendee = Attendees(profileId: profileId, eventId: eventId, isAttending: true)
//
//        //print(updateAttendee)
//
//        let request = PostRequest(path: "/api/Event/updateattendee", model: updateAttendee, token: token!)
//
//
//
//        Network.shared.send(request) { (result: Result<Empty, Error>)  in
//
//            switch result {
//
//            case .success( _):
//
//                isAttendingFlagIsSuccessful = true
//
//                completion(isAttendingFlagIsSuccessful)
//
//            case .failure(let error):
//
//                isAttendingFlagIsSuccessful = false
//
//                completion(isAttendingFlagIsSuccessful)
//
//                //print(error.localizedDescription)
//
//            }
//
//        }
//
//        //clearData()
//
//        //tableView.reloadData()
//
//        //return isAttendingFlagIsSuccessful
//
//    }
    
    
    
//    func getAttendingFlag(eventId: Int64, profileId: Int64) {
//
//        let request = Request(path: "/api/Event/attendees?eventId=\(eventId)", token: token!)
//
//
//
//        Network.shared.send(request) { (result: Result<Data, Error>)  in
//
//            switch result {
//
//            case .success(let attending):
//
//                // print(" IGHEDOSA \(event.self)")
//
//                //print(result)
//
//                //print(" GET ATTENDING FLAG \(attending)")
//
//
//
//                self.checkAttendeeFlag(data: attending, profileId: profileId)
//
//            case .failure(let error):
//
//                //self.textLabel.text = error.localizedDescription
//
//                print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
//
//
//
//            }
//
//
//
//        }
//
//
//
//
//
//    }
    
    
    
    
    
//    func checkAttendeeFlag(data: Data, profileId: Int64)  {
//
//        var foundAttendee: Bool = false
//
//        print("attendee data in check attendinflag =\(data)")
//
//        let decoder = JSONDecoder()
//
//        do {
//
//            let attendees: [Attendees]  = try decoder.decode([Attendees].self, from: data)
//
//            var index: Int = 0
//
//            for attendee in attendees {
//
//                print("kelly profileId = \(attendee.profileId) and regulare proile = \(profileId)" )
//
//                if attendee.profileId == profileId {
//
//                    print("profile id of the person that logs in = \(profileId)")
//
//                    print("profile id of the person that logs in from the attendee array = \(attendees[index].profileId )")
//
//                    print("the index number = \(index)")
//
//                    attendeeFlagWasSet = true
//
//                    foundAttendee = true
//
//
//
//                    let getData = isAttendingData(profileId: profileId, eventId: attendee.eventId, isAttending: attendee.isAttending, category: "" )
//
//                    // print(getData)
//
//                    isattendingdata.append(getData)
//
//
//
//                    index = index + 1
//
//                }
//
//                print(" isattendingdata = \(isattendingdata)")
//
//
//
//                for m in isattendingdata {
//
//                    var o: Int = 0
//
//                    var p: Int = 0
//
//
//
//                    for _ in eventsinvitedmodel {
//
//                        if m.eventId == eventsinvitedmodel[o].eventId {
//
//
//
//                            eventsinvitedmodel[o].isAttending   = m.isAttending
//
//                            print("Event Invited is Flag = \(eventsinvitedmodel[o].isAttending!)")
//
//                        }
//
//                        o = o + 1
//
//                    }
//
//
//
//                    for _ in eventsattendingmodel {
//
//                        if m.eventId == eventsattendingmodel[p].eventId {
//
//
//
//                            eventsattendingmodel[p].isAttending   = m.isAttending
//
//
//
//                            print("Event Attending is Flag = \(eventsattendingmodel[p].isAttending!)")
//
//                        }
//
//                        p = p + 1
//
//                    }
//
//                }
//
//            }
//
//
//
//            print("eventsattendingmodel = \(eventsattendingmodel)")
//
//            print("eventsinvitedmodel = \(eventsinvitedmodel)")
//
//
//
//            tableView.reloadData()
//
//
//
//        } catch  {
//
//            //print(" this is the error \(error.localizedDescription)")
//
//        }
//
//
//
//
//
//        //return foundAttendee
//
//    }
//
    
    
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
        
    
        
        let decoder = JSONDecoder()
        
        do {
            
            let eventjson = try decoder.decode(EventListModel.self, from: json)
            
            
            
            
            
//            for _ in eventjson.result.eventsOwned
//
//            {
//
//                let eventId = eventjson.result.eventsOwned[i].eventId
//
//                let ownerId = eventjson.result.eventsOwned[i].ownerId
//
//                let name = eventjson.result.eventsOwned[i].name
//
//                let dateTime = eventjson.result.eventsOwned[i].dateTime
//
//                let address1 = eventjson.result.eventsOwned[i].address1
//
//                let address2 = eventjson.result.eventsOwned[i].address2
//
//                let city = eventjson.result.eventsOwned[i].city
//
//                let zipCode = eventjson.result.eventsOwned[i].zipCode
//
//                let country = eventjson.result.eventsOwned[i].country
//
//                let state = eventjson.result.eventsOwned[i].state
//
//                let eventState = eventjson.result.eventsOwned[i].eventState
//
//                let eventCode = eventjson.result.eventsOwned[i].eventCode
//
//                let isActive = eventjson.result.eventsOwned[i].isActive
                for i in eventjson.result.eventsOwned {
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
                
                
                
                
                    let dataCollection = EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, isAttending: nil, dataCategory: "owned")
                
                
                
                eventsownedmodel.append(dataCollection)
                
                // print(i)
                
                //i = i + 1
                
                //print("PARAM COLLECTION \(dataCollection)")
                
            }
            
            
            
            
            
            //print("PARAM COLLECTIONssss \(eventsownedmodel)")
            
            
            
            for x in eventjson.result.eventsInvited {
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
                
                let dataCollection2 = EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, isAttending: nil, dataCategory: "invited")
                

                eventsinvitedmodel.append(dataCollection2)
                

               // x = x + 1
                
                //print("PARAM COLLECTION EVENT INVITED = \(dataCollection2)")
                
                
                
               // let data = isAttendingModel(profileId: profileId!, eventId: eventId, category: "eventsInvited")
                
              //  isAttending.append(data)
                
            }
            
            
            
            for y in eventjson.result.eventsAttending {
                //print("y = \(y)")
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
                
                
                
                //                var isGoing: Bool?
                
                //
                
                //                getAttendingFlag(eventId: eventId, profileId: profileId!)
                
                //                if attendeeFlagWasSet == true {
                
                //                    isGoing =  true
                
                //                } else {
                
                //                    isGoing = false
                
                //                }
                
                //
                
                //                print("the value of isGoing =\(isGoing)")
                
                //
                
                
                
                //            findChat(string: "inputString", completion: { chat in
                
                //                if let chat = chat {
                
                //                    //use the return value
                
                //                } else {
                
                //                    //handle nil response
                
                //                }
                
                //            })
                
                
                
                let dataCollection3 =  EventProperty(eventId: eventId, ownerId: ownerId, name: name, dateTime: dateTime, address1: address1, address2: address2, city: city, zipCode: zipCode, country: country, state: state, eventState: eventState, eventCode: eventCode, isActive: isActive, isAttending: nil, dataCategory: "attending")
                
                
                
                eventsattendingmodel.append(dataCollection3)
                
                //y = y + 1
                
                //print(" EVENTS ATTENDDING  \(dataCollection3)")
                
                let data = isAttendingModel(profileId: profileId!, eventId: eventId, category: "eventsAttending")
                
                isAttending.append(data)
                
                attendeeFlagWasSet = false
                
                
                
            }
            
        } catch {
            
            //print(error)
            
        }
        
        
        
        
        
        
        
        let homescreeneventdata1 = HomeScreenEventDataModel(eventCategory: "My Events", eventProperty: eventsownedmodel)
        let homescreeneventdata2 = HomeScreenEventDataModel(eventCategory: "My Invitations", eventProperty: eventsinvitedmodel)
        let homescreeneventdata3 = HomeScreenEventDataModel(eventCategory: "My RSVP", eventProperty: eventsattendingmodel)
        
        

      if eventsownedmodel.count > 0 {
          homescreeneventdata.append(homescreeneventdata1!)
      }
      if eventsinvitedmodel.count > 0 {
          homescreeneventdata.append(homescreeneventdata2!)
      }
      if eventsattendingmodel.count > 0 {
          homescreeneventdata.append(homescreeneventdata3!)
      }
      
        
        
        
        
        
        

//        for i in isAttending {
//
//            if i.profileId == profileId {
//
//                getAttendingFlag(eventId: i.eventId, profileId: i.profileId)
//
//                print("event id = \(i.eventId)")
//
//            }
//
//        }
//
//
//
//        let simpleClosure:(String) -> (String) = { name in
//
//
//
//            let greeting = "Hello, World! " + "Program"
//
//            return greeting
//
//        }
//
//        let result = simpleClosure("Hello, World")
//
//        print(result)
//
        
      
        
        
        
        
        //
        
        //        print("The value of is attending data = \(isattendingdata)")
        
        //        print("The value of is attending Model = \(isAttending)")
        
        //
        
        
        
        
        
        
        
        //print(" HOME SCREEN DATA events owned \\((homescreeneventdata)")
        
        // print(" HOME SCREEN DATA events owned \(eventsownedmodel)")
        
        // print(homescreeneventdata.count)
        
        
        
        
        
        
        
        //me()
        
        tableView.delegate = self
               tableView.dataSource = self
               tableView.reloadData()
        
    }
    
    
    
    
    
  
    
    
    //    override func shouldPerformSegueWithIdentifier(identifier: String,sender: AnyObject?) -> Bool {
    
    //
    
    //        return true
    
    //    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        
    {
        
        
        
        
        
        if segue.identifier == "test" {
            
            
            
            let controller = segue.destination as? InviteFriendViewController
            
            
            
            
            
        }
        
        
        
        
        
        if let indexPathA = tableView.indexPathForSelectedRow {
            
            guard let destinationVC = segue.destination as? EventUpdateViewController else {return}
            
            let selectedRow = indexPathA.row
            
            destinationVC.eventName =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].name!
            
            
            
            destinationVC.eventDateTime = homescreeneventdata[indexPathA.section].eventProperty[selectedRow].dateTime!
            
            destinationVC.eventZipCode =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].zipCode!
            
            destinationVC.eventAddress1 =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].address1!
            
            destinationVC.eventAddress2 =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].address2!
            
            destinationVC.eventCity =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].city!
            
            destinationVC.eventState =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].state!
            
            destinationVC.eventCountry =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].country!
            
            destinationVC.eventCode =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].eventCode!
            
            destinationVC.eventId =  homescreeneventdata[indexPathA.section].eventProperty[selectedRow].eventId
            
            destinationVC.profileId =  profileId
            
            destinationVC.token =  token
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    @objc func checkButtonTapped(_ sender: AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPathB = self.tableView.indexPathForRow(at: buttonPosition)
        
        if indexPathB != nil {
            
            //print("I am here")
            
            let theEventName = homescreeneventdata[indexPathB!.section].eventProperty[indexPathB!.row].name!
            
            let theEventDateTime = homescreeneventdata[indexPathB!.section].eventProperty[indexPathB!.row].dateTime!
            
            let theEventCode = homescreeneventdata[indexPathB!.section].eventProperty[indexPathB!.row].eventCode!
            
            let theEventId = homescreeneventdata[indexPathB!.section].eventProperty[indexPathB!.row].eventId
            
            let theProfileId = profileId
            
            
            
            
            
            let inviteFriendsVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
            
            self.navigationController?.pushViewController(inviteFriendsVC, animated: true)
            
            inviteFriendsVC.eventName = theEventName
            
            inviteFriendsVC.eventDateTime = theEventDateTime
            
            inviteFriendsVC.eventCode = theEventCode
            
            inviteFriendsVC.eventId = theEventId
            
            inviteFriendsVC.profileId = theProfileId
            
            inviteFriendsVC.token = token!
            

            
            //self.performSegue(withIdentifier: "test", sender: sender)
            
        }
        
    }
    
    
    @objc func checkButtonTapped3(_ sender: UIButton) {
        print("I am here")
           let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
           let indexPathC = self.tableView.indexPathForRow(at: buttonPosition)
           if indexPathC != nil {
               
               //print("I am here")
               
               let theEventName = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].name!
               let theEventDateTime = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].dateTime!
               let theEventCode = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].eventCode!
               let theEventId = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].eventId
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
    
    @objc func buttonAction(sender: Any) {

    }
    
    
    @IBAction func eventSettingButtonTapped(_ sender: AnyObject) {
        let buttonPosition2 = sender.convert(CGPoint.zero, to: self.tableView)
                         let indexPathE = self.tableView.indexPathForRow(at: buttonPosition2)
                         if indexPathE != nil {

                             print("I am here")
                             
                             let theEventName = homescreeneventdata[indexPathE!.section].eventProperty[indexPathE!.row].name!
//                             let theEventDateTime = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].dateTime!
//                             let theEventCode = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].eventCode!
//                             let theEventId = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].eventId
//                             let theProfileId = profileId
                             
                           // SettingNavigationController
                            
                          
                            
                            print("The event name \(theEventName)")
                             let selectRSVPVC = self.storyboard?.instantiateViewController(withIdentifier: "EventSettingViewController") as! EventSettingViewController
                             self.navigationController?.pushViewController(selectRSVPVC , animated: true)
                            
                              selectRSVPVC.eventName = theEventName
                             
//                            for viewController in viewControllers {
//                                     if let menuNavigationController = viewController as? MenuNavigationController {
//                                         if let menuViewController = menuNavigationController.viewControllers.first as? MenuViewController {
//                                             menuViewController.profileId = profileId
//                                             menuViewController.token = token
//                                         }
//                                     }
//
//                                 }
                            
                            
//                            let nav : UINavigationController = UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "EventSettingTableViewController") as! EventSettingTableViewController)
//
//                            self.navigationController?.present(nav, animated: true, completion: nil)
                            
                            
                            
//                             selectAttendeeVC.eventDateTime = theEventDateTime
//                             selectAttendeeVC.eventCode = theEventCode
//                             selectAttendeeVC.eventId = theEventId
//                             selectAttendeeVC.profileId = theProfileId
//                             selectAttendeeVC.token = token!
                             
                             //self.performSegue(withIdentifier: "test", sender: sender)
                         }
    }
    
    @IBAction func shareBtnPressed(_ sender: AnyObject) {
        
   
        
    }
    
    
    @IBAction func checkButtonTapped2(_ sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
                    let indexPathC = self.tableView.indexPathForRow(at: buttonPosition)
                    if indexPathC != nil {
                        
                        //print("I am here")
                        
                        let theEventName = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].name!
                        let theEventDateTime = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].dateTime!
                        let theEventCode = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].eventCode!
                        let theEventId = homescreeneventdata[indexPathC!.section].eventProperty[indexPathC!.row].eventId
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
            attendeeEventName =  homescreeneventdata[indexPathD!.section].eventProperty[selectedRow].name!
            attendeeEventId = homescreeneventdata[indexPathD!.section].eventProperty[selectedRow].eventId
            attendeeOwnerId = homescreeneventdata[indexPathD!.section].eventProperty[selectedRow].ownerId
            

            // print("I am here - ready to call fun")
            // let isAttendingFlagIsSet: Bool =
//           updateIsAttendingFlag(eventId: attendeeEventId, profileId: profileId!, ownerId: attendeeOwnerId, completion: { isAttendingFlagIsSuccessful in
//                if isAttendingFlagIsSuccessful == true {
//                } else {
//
//                }
//            })
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return homescreeneventdata.count
        
        // return eventsowned.
        
        // return eventsowned
        
        //return 0
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return videos.count
        
        return homescreeneventdata[section].eventProperty.count
        
        //return eventResult.count
        
        //return 0
        
    }
    
    

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("muy homescreen count \(homescreeneventdata.count)")
        //let event =  homescreeneventdata[indexPath.row] //videos[indexPath.row]
        
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        

        if homescreeneventdata[indexPath.section].eventCategory == "My Events" {
            
            if homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dataCategory! == "owned" {
            print("i am here \(homescreeneventdata[indexPath.section].eventCategory)")
            let lbl  = UILabel(frame: CGRect(x: 47, y: 229, width: 262, height: 21))
            lbl.backgroundColor = UIColor.white
            lbl.textColor = UIColor.black
            lbl.textAlignment = NSTextAlignment.center
            lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
            

            lbl.text = "Invite Friends"
            lbl.tag = indexPath.row
            cell.contentView.addSubview(lbl)
            
            
            
            let inviteIconImage = UIImage(named:"addusericon1")!
            
            let button = UIButton(frame: CGRect(x: 316, y: 224, width: 55, height: 31))
            
            button.backgroundColor = UIColor.white
            
            button.tag =  indexPath.row
            
            button.setTitle("invite", for: .normal)
            
            //button.setTitle("Invite", forState: .Normal)
            
            button.setImage(inviteIconImage, for: .normal)
            
            //button.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
            
            button.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
            
            cell.contentView.addSubview(button)
            
            //self.view.addSubview(button)
            
            
            
            }
        }
            
          //  else  if homescreeneventdata[indexPath.section].eventCategory == "My Invitations" {
//
//            let lbl  = UILabel(frame: CGRect(x: 47, y: 229, width: 262, height: 21))
//
//            lbl.backgroundColor = UIColor.white
//            lbl.textColor = UIColor.black
//            lbl.textAlignment = NSTextAlignment.center
//            lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
//            lbl.text = "attending = " // \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].isAttending)"
//            lbl.tag = indexPath.row
//
//            cell.contentView.addSubview(lbl)
//
//            let switchDemo = UISwitch(frame:CGRect(x: 316, y: 224, width: 47, height: 31))
//            //if   homescreeneventdata[indexPath.section].eventProperty[indexPath.row].isAttending == true {
//
//                // print("my switch button is on \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].isAttending)")
//
//                switchDemo.isOn = true
//
//                switchDemo.setOn(true, animated: true)
//
//           // } else {
//
//              //  switchDemo.isOn = false
//
//              //  switchDemo.setOn(false, animated: true)
//
//                //print("my is attending is false \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].isAttending)")
//
//            //}
//
//            switchDemo.tintColor = .white
//
//
//
//
//
//
//
//            switchDemo.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
//
//            switchDemo.tag = indexPath.row // homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//
//            // self.view!.addSubview(switchDemo)
//
//            cell.contentView.addSubview(switchDemo)
//
//
//
//            //print("IS ATTENDING = \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].isAttending)" )
//        }
        if homescreeneventdata[indexPath.section].eventCategory == "My RSVP" {
//
//
//
              let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell2") as! TableViewCell2
            
//            print("homescreeneventdata \(homescreeneventdata)")
//
//            print("i am here RSVP \(homescreeneventdata[indexPath.section].eventCategory)")
//            let moneyButton = UIButton(frame: CGRect(x: 160, y: 230, width: 80, height: 80))
//            let moneyIconImage = UIImage(named:"moneyIcon")!
//            moneyButton.backgroundColor = UIColor.white
//
//            moneyButton.tag =  indexPath.row
//
//            moneyButton.setTitle("money", for: .normal)
//
//            //button.setTitle("Invite", forState: .Normal)
//
//            moneyButton.setImage(moneyIconImage, for: .normal)
//
//            //button.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
//
//            moneyButton.addTarget(self, action: #selector(checkButtonTapped2(_:)), for: .touchUpInside)
//
//            cell.contentView.addSubview(moneyButton)
            cell.eventNameLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!

                   cell.eventAddressLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2!

                   cell.eventCityStateZipCountryLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +

                       homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!





                   cell.eventDateTimeLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!

                   cell.eventCodeLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!

                   cell.eventImage.image = UIImage(named: "birthdayicon1")

                   
                   
                   
                   
                  // cell.accessoryType = .disclosureIndicator
                   
                   
                   
                   
                   
                   
                   
                   cell.layer.borderColor = UIColor.gray.cgColor
                   
                   cell.layer.borderWidth = 3.0
            
            return cell
//
     }
//
             //cell2.eventName.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
            cell.eventNameLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!

          cell.eventAddressLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2!

          cell.eventCityStateZipCountryLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +

              homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!





          cell.eventDateTimeLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!

          cell.eventCodeLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!

          cell.eventImage.image = UIImage(named: "birthdayicon1")

          
          
          
          
          cell.accessoryType = .disclosureIndicator
          
          
          
          
          
          
          
          cell.layer.borderColor = UIColor.gray.cgColor
          
          cell.layer.borderWidth = 3.0

        return cell
        
        
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return homescreeneventdata[section].eventCategory
        
        //return "test"
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        
        view.backgroundColor = .lightGray
        
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width, height: 20))
        
        //lbl.text = "Events Owned"
        
        lbl.text = homescreeneventdata[section].eventCategory
        
        lbl.font = UIFont.boldSystemFont(ofSize: 32.0)
        
        //view.addSubview(lbl)
        view.addSubview(lbl)
        
        return view
        
    }
    
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if homescreeneventdata[indexPath.section].eventCategory == "My Events" {
            
            performSegue(withIdentifier: "goToEventEdit", sender: self)
            
            
            
        }
        
    }
    
}
