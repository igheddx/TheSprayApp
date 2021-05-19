
//
//  TableViewCell3.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 8/10/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class MySprayEventTableViewCell: UITableViewCell {

   
//    @IBOutlet weak var goSprayCardView: UIView!
    
    @IBOutlet weak var goSprayCardView: UIView!
    //@IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventCityStateZipCountryLabel: UILabel!
    @IBOutlet weak var eventCodeLabel: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!

    @IBOutlet weak var ReadyToSprayButton: UIButton!
    @IBOutlet weak var editEventSettingsButton: UIButton!
    
    @IBOutlet weak var eventMetricsButton: UIButton!
    var customCellDelegate: MyCustomCellDelegator?
    

    static let identifier = "MySprayEventTableViewCell"
    
    
    var myEventName: String?
    
    var myEventDateTime: String?
    var myEventCode: String?
    var myisActiveFlag: Bool?
    var myEventId: Int64?
    var myProfileId: Int64?
    var myOwnerId: Int64?
    var myToken: String?
    var myApiKey: String?
    var myPaymentClientToken: String?
    var myIsAttendingEventId: Int64?
    var myEventTypeIcon: String = ""
    var myEventPaymentMethod: Bool?
    var myEventType: String = ""
    var myIsRsvprequired: Bool!
    var myIsSingleReceiver: Bool!
    var myDefaultEventPaymentMethod: Int = 0
    var myDefaultEventPaymentCustomName: String = ""
    
    
    var isPaymentMethodForEvent: Bool = false
    var encryptedAPIKey: String = ""
    //var isPaymentMethodGeneral: Bool = false
    static func nib() -> UINib {
        return UINib(nibName: "MySprayEventTableViewCell", bundle: nil)
    }
    
    public func configure(with eventName: String, eventAddress: String, eventDateTime: String, eventCityStateZipCountry: String, eventCode: String, isActiveFlag: Bool, eventType: String, imageName: String, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, ApiKey: String, paymentClientToken: String, isAttendingEventId: Int64, hasPaymentMethod: Bool, isRsvprequired: Bool, isSingleReceiver: Bool, defaultEventPaymentMethod: Int, defaultEventPaymentCustomName: String) {
        
        
        myEventName = eventName
        myEventDateTime = eventDateTime
        myEventCode = eventCode
        myisActiveFlag = isActiveFlag
        myEventType = eventType
        myEventId = eventId
        myProfileId = profileId
        myOwnerId = ownerId
        myToken = token
        myApiKey = ApiKey
        myPaymentClientToken = paymentClientToken
        myIsAttendingEventId = isAttendingEventId
        myEventTypeIcon = imageName
        myEventPaymentMethod = isPaymentMethodForEvent //hasPaymentMethod
        myIsRsvprequired = isRsvprequired
        myIsSingleReceiver = isSingleReceiver
        myDefaultEventPaymentMethod = defaultEventPaymentMethod
        myDefaultEventPaymentCustomName = defaultEventPaymentCustomName
        
        eventNameLabel.text = eventName //+ "D \(String(myEventPaymentMethod!))"
        eventAddressLabel.text = eventAddress
        eventDateTimeLabel.text = eventDateTime
        eventCityStateZipCountryLabel.text = eventCityStateZipCountry
        eventCodeLabel.text = eventCode
        eventImage.image = UIImage(named: imageName)
        
       // checkIfEventPaymentMethod(eventId: myEventId!, profileId: myProfileId!)
        
       
       
        //let isPaymentMethodGeneral = checkIfGeneralEventPaymentMethod(profileId: myProfileId!)
       
       // print("isPaymentMethodGeneral =\(isPaymentMethodGeneral )")
        
        
        //print("myEventPaymentMethod \(myEventPaymentMethod!)")
        
//        sprayCardView.layer.borderColor  = UIColor.lightGray.cgColor
//        sprayCardView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
//        sprayCardView.layer.shadowOpacity  = 1.0
//        sprayCardView.layer.masksToBounds = false
//        sprayCardView.layer.cornerRadius = 2.0
        
//        sprayCardView.layer.shadowColor = UIColor.lightGray.cgColor
//        sprayCardView.layer.borderWidth = 2.0
//        sprayCardView.layer.shadowRadius = 4.0
        goSprayCardView.layer.borderColor  = UIColor.gray.cgColor
        goSprayCardView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        goSprayCardView.layer.shadowOpacity  = 1.0
        goSprayCardView.layer.masksToBounds = false
        goSprayCardView.layer.cornerRadius = 8.0
        
        
        //cell2.layer.shadowPath = UIBezierPath(roundedRect: sprayCardView.bounds, cornerRadius: cell2.contentView.layer.cornerRadius).cgPath
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        selectedBackgroundView = {
            let view = UIView.init()
            view.backgroundColor = .white
            return view
        }()
        
    }

    @IBAction func readyToSprayButtonPressed(_ sender: AnyObject) {
        
//        if  myIsAttendingEventId == 0 {
//            print("myIsAttendingEventId \(myIsAttendingEventId!)")
//                       let alert = UIAlertController(title: "RSVP", message: "Please RSVP so that you are participate in Spray.", preferredStyle: .actionSheet)
//
//                       alert.addAction(UIAlertAction(title: "RSVP", style: .default, handler: nil))
//                       alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
       // } else {
            
        print("myEventPaymentMethod! \(myEventPaymentMethod!)")
        
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.callSegueFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventType: myEventType, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, ApiKey: myApiKey!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "ReadyToSpray", isAttendingEventId: myIsAttendingEventId!, eventTypeIcon: myEventTypeIcon, hasPaymentMethod:  isPaymentMethodForEvent,  isRsvprequired: myIsRsvprequired, isSingleReceiver: myIsSingleReceiver, defaultEventPaymentMethod: myDefaultEventPaymentMethod, defaultEventPaymentCustomName: myDefaultEventPaymentCustomName)
        }
        //remove scanner VC from the stack when going back to home VC
       
    }
    //}
    
    //moving to loginViewController - will followup late 1/26/21
   // func checkEventPayment(eventId: Int64, profileId: Int64) -> Bool {
        
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        
        //print("before isPaymentMethodForEvent = \(isPaymentMethodForEvent)")
        //func getEventPaymentMethod() -> Bool {
    func checkIfEventPaymentMethod(eventId: Int64, profileId: Int64)  {
        let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: myToken!, apiKey: myApiKey!)
        
        print("request \(request)")
        Network.shared.send(request) { (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    print("I am here 1")
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                        print("I am here 2")
                        if eventPreferenceJson.count > 0 {
                            self.isPaymentMethodForEvent = true
                            //let a = true
                            print("self.isPaymentMethodForEvent = true \(self.isPaymentMethodForEvent)")
                            break
                        }
                        
                      // for eventPrefData in eventPreferenceJson {
//
                        //print("custom name \(eventPrefData.paymentMethodDetails.customName)")
                            //if eventPrefData.paymentMethodDetails.paymentMethodId == 9 {
//                                    print("paymentMethodId > 0 \(eventPrefData.paymentMethodDetails.paymentMethodId )  eventId = \(eventId)")
//                                    isPaymentMethodForEvent = true
//                                    print("paymentmethod >=21 During  \(isPaymentMethodForEvent)")
//                                    break
//                                } else {
//                                    //setting to true temporarily 3/2
//                                    isPaymentMethodForEvent = true
//                                    print("paymentmethod < 21 During  \(isPaymentMethodForEvent)")
//                                }
                       // }

                    } catch {
                        print(error)
                    }

                case .failure(let error):
                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }

    

    
    @IBAction func editEventSettingButtonPressed(_ sender: AnyObject) {
        print("my attempt to segue Edit Spray Go Events Settings")
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.callSegueFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventType: myEventType, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, ApiKey: myApiKey!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "EventSettings", isAttendingEventId: myIsAttendingEventId!, eventTypeIcon: myEventTypeIcon, hasPaymentMethod:  isPaymentMethodForEvent, isRsvprequired: myIsRsvprequired, isSingleReceiver: myIsSingleReceiver, defaultEventPaymentMethod: myDefaultEventPaymentMethod, defaultEventPaymentCustomName: myDefaultEventPaymentCustomName)
        }
    }
    
    @IBAction func eventMetricsButtonPressed(_ sender: AnyObject) {
        print("my attempt to segue -Spray  Event Metrics ")
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.callSegueFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventType: myEventType, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, ApiKey: myApiKey!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "EventMetrics", isAttendingEventId: myIsAttendingEventId!, eventTypeIcon: myEventTypeIcon, hasPaymentMethod:  isPaymentMethodForEvent, isRsvprequired: myIsRsvprequired, isSingleReceiver: myIsSingleReceiver, defaultEventPaymentMethod: myDefaultEventPaymentMethod, defaultEventPaymentCustomName: myDefaultEventPaymentCustomName)
        }
    }
    
    
    @IBAction func qrCodeButtonPressed(_ sender: Any) {
        print("my attempt to segue  Spray Go to QRCode")
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.callSegueFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventType: myEventType, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, ApiKey: myApiKey!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "QRCode", isAttendingEventId: myIsAttendingEventId!, eventTypeIcon: myEventTypeIcon, hasPaymentMethod:  isPaymentMethodForEvent, isRsvprequired: myIsRsvprequired, isSingleReceiver: myIsSingleReceiver, defaultEventPaymentMethod: myDefaultEventPaymentMethod, defaultEventPaymentCustomName: myDefaultEventPaymentCustomName)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

