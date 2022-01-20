//
//  MyEventsTableViewCell.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 8/15/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class MyEventsTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var myEventCardView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventCityStateZipCountryLabel: UILabel!
    @IBOutlet weak var eventCodeLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!

    @IBOutlet weak var closeEventSwitch: UISwitch!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    @IBOutlet weak var inviteFriendsButton1:  MyCustomButton2! //UIButton!
  
      
    var myEventsCustomCellDelegate: MyEventsCustomCellDelegate?
      

    static let identifier = "MyEventsTableViewCell"
      
      
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
    var myEventTypeIcon: String = ""
    var myAddress1: String = ""
    var myAddress2: String = ""
    var myCity: String = ""
    var myState: String = ""
    var myZipCode: String = ""
    var myCountry: String = ""
    var myEventState: Int?
    var myEventType: Int?
    var myEventType2: String = "" //description
    var myIsRsvprequired: Bool?
    var myIsSingleReceiver: Bool?
    var myIsForBusiness: Bool?
    
    var myDefaultEventPaymentMethod: Int = 0
    var myDefaultEventPaymentCustomName: String = ""
    var encryptedAPIKey: String = ""
    
    static func nib() -> UINib {
          return UINib(nibName: "MyEventsTableViewCell", bundle: nil)
    }
      
    public func configure(with eventName: String,
                          eventAddress: String,
                          eventDateTime: String,
                          eventCityStateZipCountry: String,
                          eventCode: String,
                          isActiveFlag: Bool,
                          imageName: String,
                          eventId: Int64,
                          profileId: Int64,
                          ownerId: Int64,
                          token: String,
                          ApiKey: String,
                          paymentClientToken: String,
                          address1: String,
                          address2: String,
                          city: String,
                          state: String,
                          zipCode: String,
                          country: String,
                          eventState: Int,
                          eventType: Int,
                          eventType2: String, isRsvprequired: Bool, isSingleReceiver: Bool,
                          isForBusiness: Bool, defaultEventPaymentMethod: Int = 0, defaultEventPaymentCustomName: String = "") {
          
          
        myEventName = eventName
        myEventDateTime = eventDateTime
        myEventCode = eventCode
        myisActiveFlag = isActiveFlag
       
        myEventId = eventId
        myProfileId = profileId
        myOwnerId = ownerId
        myToken = token
        myApiKey = ApiKey
        myPaymentClientToken = paymentClientToken
        myEventTypeIcon = imageName
        
        myAddress1 = address1
        myAddress2 = address2
        myCity = city
        myState = state
        myZipCode = zipCode
        myCountry = country
        myEventState = eventState
        myEventType = eventType
        myEventType2 = eventType2
        
        myIsRsvprequired = isRsvprequired
        myIsSingleReceiver = isSingleReceiver
        myIsForBusiness = isForBusiness
        
        myDefaultEventPaymentMethod = defaultEventPaymentMethod
        myDefaultEventPaymentCustomName = defaultEventPaymentCustomName
        
        eventNameLabel.text = eventName
        eventAddressLabel.text = eventAddress
        eventDateTimeLabel.text = eventDateTime
        eventCityStateZipCountryLabel.text = eventCityStateZipCountry
        eventCodeLabel.text = eventCode
        eventImage.image = UIImage(named: imageName)
        
        myEventCardView.layer.borderColor   = UIColor.gray.cgColor
        myEventCardView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        myEventCardView.layer.shadowOpacity  = 0.25
        myEventCardView.layer.masksToBounds = false
        myEventCardView.layer.cornerRadius = 8.0
    }
    func viewDidLayoutSubviews() {
       
    }
      override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code

//        inviteFriendsButton.layer.borderWidth = 1
//        inviteFriendsButton.layer.borderColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0).cgColor
//        inviteFriendsButton.layer.cornerRadius = 4
//        inviteFriendsButton.layer.shadowColor = UIColor.white.cgColor
//        inviteFriendsButton.layer.shadowOffset = CGSize(width: 2, height: 2)
//        inviteFriendsButton.layer.shadowRadius = 5
//        inviteFriendsButton.layer.shadowOpacity = 0.5
//        inviteFriendsButton.layer.masksToBounds = true
        selectedBackgroundView = {
            let view = UIView.init()
            view.backgroundColor = .white
            return view
        }()
        
//        eventImage.frame = CGRect.init(x: 8, y: 41, width: 90, height: 90)
//        //myAvatar.backgroundColor = UIColor.black
//        eventImage.contentMode =  UIView.ContentMode.scaleToFill// ScaleToFill
//        eventImage.layoutIfNeeded()
//        eventImage.layer.borderWidth = 1
//        eventImage.layer.masksToBounds = false
//        eventImage.layer.borderColor =  UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor //UIColor.black.cgColor
//        eventImage.layer.cornerRadius = eventImage.frame.height/2
//        eventImage.clipsToBounds = true
        
        
       
      }

    @IBAction func closeEvent(_ sender: UISwitch) {
        if sender.isOn == true {
            //let closeEvent = AuthenticateUser(username: self.username, password: self.password)
            //let request = PostRequest(path: "/api/Event/close", model: closeEvent, token: "")
            
           
//
//             Network.shared.send(request) { (result: Result<Empty, Error>)  in
//                switch result {
//                case .success(let user):
//                  break
//
//                case .failure(let error):
//                    print(error)
//                }
                
               
            //}
        } else {
            
        }
        
    }
    
    @IBAction func inviteFriendsButtonPressed(_ sender: AnyObject) {
          
         
          if(self.myEventsCustomCellDelegate != nil){
            print("my attempt to segue - InviteFrieds")//Just to be safe.
            self.myEventsCustomCellDelegate?.callInviteFriendsFromCell(eventName: myEventName!,
               eventDateTime: myEventDateTime!,
               eventCode: myEventCode!,
               isActiveFlag: myisActiveFlag!,
               eventId: myEventId!,
               profileId: myProfileId!,
               ownerId: myOwnerId!,
               token: myToken!,
               ApiKey: myApiKey!,
               paymentClientToken:  myPaymentClientToken!,
               screenIdentifier: "MyEvents",
               eventTypeIcon: myEventTypeIcon,
               address1: myAddress1,
               address2: myAddress2,
               city: myCity,
               state: myState,
               zipCode: myZipCode,
               country: myCountry,
               eventState: myEventState!,
               eventType: myEventType!,
               eventType2: myEventType2, isRsvprequired: myIsRsvprequired!, isSingleReceiver: myIsSingleReceiver!,
               isForBusiness: myIsForBusiness!, defaultEventPaymentMethod: myDefaultEventPaymentMethod, defaultEventPaymentCustomName: myDefaultEventPaymentCustomName
            )
          }
      }
      
    @IBAction func qrCodeButtonPressed(_ sender: AnyObject) {
        
        if(self.myEventsCustomCellDelegate != nil){
            print("my attempt to segue - Events Table QR")//Just to be safe.
            self.myEventsCustomCellDelegate?.callInviteFriendsFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, ApiKey: myApiKey!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "QRCode", eventTypeIcon:  myEventTypeIcon,
                                                                       address1: myAddress1,
                                                                       address2: myAddress2,
                                                                       city: myCity,
                                                                       state: myState,
                                                                       zipCode: myZipCode,
                                                                       country: myCountry,
                                                                       eventState: myEventState!,
                                                                       eventType: myEventType!,
                                                                       eventType2: myEventType2, isRsvprequired: myIsRsvprequired!, isSingleReceiver: myIsSingleReceiver!,
                                                                       isForBusiness: myIsForBusiness!,defaultEventPaymentMethod: myDefaultEventPaymentMethod, defaultEventPaymentCustomName: myDefaultEventPaymentCustomName)
        }
    }

    @IBAction func editEvent(_ sender: AnyObject) {
        
        if(self.myEventsCustomCellDelegate != nil){
            print("my attempt to segue - Events Table editEvent ")//Just to be safe.
            self.myEventsCustomCellDelegate?.callInviteFriendsFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, ApiKey: myApiKey!,paymentClientToken:  myPaymentClientToken!, screenIdentifier: "EditEvent", eventTypeIcon:  myEventTypeIcon,
                                                                       address1: myAddress1,
                                                                       address2: myAddress2,
                                                                       city: myCity,
                                                                       state: myState,
                                                                       zipCode: myZipCode,
                                                                       country: myCountry,
                                                                       eventState: myEventState!,
                                                                       eventType: myEventType!,
                                                                       eventType2: myEventType2, isRsvprequired: myIsRsvprequired!, isSingleReceiver: myIsSingleReceiver!,
                                                                       isForBusiness: myIsForBusiness!, defaultEventPaymentMethod: myDefaultEventPaymentMethod, defaultEventPaymentCustomName: myDefaultEventPaymentCustomName)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
