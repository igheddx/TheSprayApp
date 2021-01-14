//
//  MyInvitationsTableViewCell.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 8/13/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit


class MyInvitationsTableViewCell: UITableViewCell {

    @IBOutlet weak var myInviteCardView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventCityStateZipCountryLabel: UILabel!
    @IBOutlet weak var eventCodeLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!

    @IBOutlet weak var rsvpButton: MyCustomButton! //UIButton!
   
       
    var myInvitationCustomCellDelegate: MyInvitationCustomCellDelegate?
       

    static let identifier = "MyInvitationsTableViewCell"
       
       
    var myEventName: String?
    var myEventDateTime: String?
    var myEventCode: String?
    var myisActiveFlag: Bool?
    var myEventId: Int64?
    var myProfileId: Int64?
    var myOwnerId: Int64?
    var myToken: String?
    var myPaymentClientToken: String?
    var myEventTypeIcon: String = ""
    
       static func nib() -> UINib {
           return UINib(nibName: "MyInvitationsTableViewCell", bundle: nil)
       }
       
    public func configure(with eventName: String, eventAddress: String, eventDateTime: String, eventCityStateZipCountry: String, eventCode: String, isActiveFlag: Bool, imageName: String, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, paymentClientToken: String) {
           
           
        myEventName = eventName
        myEventDateTime = eventDateTime
        myEventCode = eventCode
        myisActiveFlag = isActiveFlag
        myEventId = eventId
        myProfileId = profileId
        myOwnerId = ownerId
        myToken = token
        myPaymentClientToken = paymentClientToken
        myEventTypeIcon = imageName
               
       eventNameLabel.text = eventName
       eventAddressLabel.text = eventAddress
       eventDateTimeLabel.text = eventDateTime
       eventCityStateZipCountryLabel.text = eventCityStateZipCountry
       eventCodeLabel.text = eventCode
       eventImage.image = UIImage(named: imageName)
        
        myInviteCardView.layer.borderColor  = UIColor.lightGray.cgColor
        myInviteCardView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        myInviteCardView.layer.shadowOpacity  = 1.0
        myInviteCardView.layer.masksToBounds = false
        myInviteCardView.layer.cornerRadius = 8.0
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


       @IBAction func rsvpButtonPressed(_ sender: AnyObject) {
           
          print("my attempt to segue")
           if(self.myInvitationCustomCellDelegate != nil){ //Just to be safe.
            self.myInvitationCustomCellDelegate?.callEventSettingFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "RSVP", eventTypeIcon:  myEventTypeIcon)
           }
       }
       
    @IBAction func qrCodeButtonPressed(_ sender: AnyObject) {
       
        if(self.myInvitationCustomCellDelegate != nil){ //Just to be safe.
            print("my attempt to segue- QRCode3")
            self.myInvitationCustomCellDelegate?.callEventSettingFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "QRCode", eventTypeIcon:  myEventTypeIcon)
        } else {
            print("self.myInvitationCustomCellDelegate is NILL\(self.myInvitationCustomCellDelegate)")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
