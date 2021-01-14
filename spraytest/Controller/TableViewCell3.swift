//
//  TableViewCell3.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 8/10/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class TableViewCell3: UITableViewCell {

   
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
    

    static let identifier = "TableViewCell3"
    
    
    var myEventName: String?
    
    var myEventDateTime: String?
    var myEventCode: String?
    var myisActiveFlag: Bool?
    var myEventId: Int64?
    var myProfileId: Int64?
    var myOwnerId: Int64?
    var myToken: String?
    var myPaymentClientToken: String?
    var myIsAttendingEventId: Int64?
    var myEventTypeIcon: String = ""
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell3", bundle: nil)
    }
    
    public func configure(with eventName: String, eventAddress: String, eventDateTime: String, eventCityStateZipCountry: String, eventCode: String, isActiveFlag: Bool, imageName: String, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, paymentClientToken: String, isAttendingEventId: Int64) {
        
        
        myEventName = eventName
        myEventDateTime = eventDateTime
        myEventCode = eventCode
        myisActiveFlag = isActiveFlag
        myEventId = eventId
        myProfileId = profileId
        myOwnerId = ownerId
        myToken = token
        myPaymentClientToken = paymentClientToken
        myIsAttendingEventId = isAttendingEventId
        myEventTypeIcon = imageName
            
        eventNameLabel.text = eventName
        eventAddressLabel.text = eventAddress
        eventDateTimeLabel.text = eventDateTime
        eventCityStateZipCountryLabel.text = eventCityStateZipCountry
        eventCodeLabel.text = eventCode
        eventImage.image = UIImage(named: imageName)
        
       
        
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
            
    print("my attempt to segue")
    if(self.customCellDelegate != nil){ //Just to be safe.
        self.customCellDelegate?.callSegueFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "ReadyToSpray", isAttendingEventId: myIsAttendingEventId!, eventTypeIcon: myEventTypeIcon)
    }
}
    //}
    
    
    @IBAction func editEventSettingButtonPressed(_ sender: AnyObject) {
        print("my attempt to segue Edit Spray Go Events Settings")
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.callSegueFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "EventSettings", isAttendingEventId: myIsAttendingEventId!, eventTypeIcon: myEventTypeIcon)
        }
    }
    
    @IBAction func eventMetricsButtonPressed(_ sender: AnyObject) {
        print("my attempt to segue -Spray  Event Metrics ")
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.callSegueFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "EventMetrics", isAttendingEventId: myIsAttendingEventId!, eventTypeIcon: myEventTypeIcon)
        }
    }
    
    
    @IBAction func qrCodeButtonPressed(_ sender: Any) {
        print("my attempt to segue  Spray Go to QRCode")
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.callSegueFromCell(eventName: myEventName!, eventDateTime: myEventDateTime!, eventCode: myEventCode!, isActiveFlag: myisActiveFlag!, eventId: myEventId!, profileId: myProfileId!, ownerId: myOwnerId!, token: myToken!, paymentClientToken:  myPaymentClientToken!, screenIdentifier: "QRCode", isAttendingEventId: myIsAttendingEventId!, eventTypeIcon: myEventTypeIcon)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
