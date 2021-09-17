//
//  InfoBoardTableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/8/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class InfoBoardTableViewCell: UITableViewCell {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var infoUICardView: UIView!
    
    @IBOutlet weak var oustandingTransferUIView: UIView!
    @IBOutlet weak var pendingPayoutUIView: UIView!
    
    @IBOutlet weak var customerOnboardingBtn: PayoutBtn!
    @IBOutlet weak var totalGiftedUIView: UIView!
    @IBOutlet weak var totalReceivedUIView: UIView!
    
    @IBOutlet weak var outstandingTransferAmtLbl: UILabel!
    @IBOutlet weak var pendingPayountAmtLbl: UILabel!
    
    @IBOutlet weak var totalGiftedAmtLbl: UILabel!
    @IBOutlet weak var totalGiftReceivedAmtLbl: UILabel!
    
    
    @IBOutlet weak var onboardingMessageLbl: UILabel!
    //var myInvitationCustomCellDelegate: MyInvitationCustomCellDelegate?
    var customCellDelegate: MyCustomCellDelegator?
    static let identifier = "InfoBoardTableViewCell"
    
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
    var myEventPaymentMethod: Bool?
    var stripeBalanceAvailable = [AmountCurrency]() //new data
    var stripeBalancePending = [AmountCurrency]() //new data
    var encryptedAPIKey: String = ""
    var isAccountConnected: Bool = UserDefaults.standard.bool(forKey: "isAccountConnected")
    var currencySymbol: String = ""
    
    static func nib() -> UINib {
        return UINib(nibName: "InfoBoardTableViewCell", bundle: nil)
    }
    
    public func configure(with outstandingTransferAmt: String, pendingPayoutAmt: String, totalGiftedAmt: String, totalReceivedAmt: String, currency: String, paymentCustomerId: String, paymentConnectedActId: String) {
        
        currencySymbol = Currency.shared.findSymbol(currencyCode: currency)
        //self.paymentCustomerId = profileData.paymentCustomerId!
        //self.paymentConnectedActId = profileData.paymentConnectedActId
        
//        let outstandingTransferAmt: [StripeBalanceAmountCurrency]
//        let pendingPayoutAmt: [StripeBalanceAmountCurrency]
//        let totalGiftedAmt: [StripeBalanceAmountCurrency]
//        let totalReceivedAmt: [StripeBalanceAmountCurrency]
        
//        public func configure(with eventName: String, eventAddress: String, eventDateTime: String, eventCityStateZipCountry: String, eventCode: String, isActiveFlag: Bool, imageName: String, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, paymentClientToken: String) {
        print("outstandingTransferAmt \(outstandingTransferAmt)")
        outstandingTransferAmtLbl.text = currencySymbol + outstandingTransferAmt
        
        pendingPayountAmtLbl.text = currencySymbol + pendingPayoutAmt
        
        totalGiftedAmtLbl.text = currencySymbol + totalGiftedAmt
        totalGiftReceivedAmtLbl.text = currencySymbol + totalReceivedAmt
        
//        if outstandingTransferAmt != "0.0" {
//            outstandingTransferAmtLbl.font =  UIFont(name:"HelveticaNeue-Bold", size: 20.0)
//            outstandingTransferAmtLbl.textColor = UIColor(red: 178/256, green: 9/256, blue: 18/256, alpha: 1.0)
//        } else {
//            outstandingTransferAmtLbl.font =  UIFont(name:"HelveticaNeue", size: 20.0)
//
//        }
        /*hide button and lable when account is connected*/
        if isAccountConnected == true {
            onboardingMessageLbl.isHidden = true
            customerOnboardingBtn.isHidden = true
        }
        
        if  paymentConnectedActId == "" {
            outstandingTransferAmtLbl.font =  UIFont(name:"HelveticaNeue", size: 20.0)
            pendingPayountAmtLbl.font =  UIFont(name:"HelveticaNeue", size: 20.0)
            //comment button for now 4/25 will return to this later
//            customerOnboardingBtn.isHidden = false
//            onboardingMessageLbl.isHidden = false
        } else {
            pendingPayountAmtLbl.font =  UIFont(name:"HelveticaNeue-Bold", size: 20.0)
            outstandingTransferAmtLbl.font =  UIFont(name:"HelveticaNeue-Bold", size: 20.0)
            outstandingTransferAmtLbl.textColor = UIColor(red: 178/256, green: 9/256, blue: 18/256, alpha: 1.0)
//            customerOnboardingBtn.isHidden = true
//            onboardingMessageLbl.isHidden = true
        }
//        if pendingPayoutAmt != "0.0" {
//
//        } else {
//            pendingPayountAmtLbl.font =  UIFont(name:"HelveticaNeue", size: 20.0)
//        }
        
        if totalGiftedAmt != "0" {
            totalGiftedAmtLbl.font =  UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        } else {
            totalGiftedAmtLbl.font =  UIFont(name:"HelveticaNeue", size: 20.0)
        }
        
        if totalReceivedAmt != "0" {
            totalGiftReceivedAmtLbl.font =  UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        } else {
            totalGiftReceivedAmtLbl.font =  UIFont(name:"HelveticaNeue", size: 20.0)
        }
        
        
    
//        myEventName = eventName
//        myEventDateTime = eventDateTime
//        myEventCode = eventCode
//        myisActiveFlag = isActiveFlag
//        myEventId = eventId
//        myProfileId = profileId
//        myOwnerId = ownerId
//        myToken = token
//        myPaymentClientToken = paymentClientToken
//        //myIsAttendingEventId = isAttendingEventId
//        myEventTypeIcon = imageName
        //myEventPaymentMethod = hasPaymentMethod
//        eventNameLabel.text = eventName //+ "D \(String(myEventPaymentMethod!))"
//        eventAddressLabel.text = eventAddress
//        eventDateTimeLabel.text = eventDateTime
//        eventCityStateZipCountryLabel.text = eventCityStateZipCountry
//        eventCodeLabel.text = eventCode
//        eventImage.image = UIImage(named: imageName)
//
       
        //print("myEventPaymentMethod \(myEventPaymentMethod!)")
        
//        sprayCardView.layer.borderColor  = UIColor.lightGray.cgColor
//        sprayCardView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
//        sprayCardView.layer.shadowOpacity  = 1.0
//        sprayCardView.layer.masksToBounds = false
//        sprayCardView.layer.cornerRadius = 2.0
        
//        sprayCardView.layer.shadowColor = UIColor.lightGray.cgColor
//        sprayCardView.layer.borderWidth = 2.0
//        sprayCardView.layer.shadowRadius = 4.0
        infoUICardView.layer.borderColor  = UIColor.gray.cgColor
        infoUICardView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        infoUICardView.layer.shadowOpacity  = 1.0
        infoUICardView.layer.masksToBounds = false
        infoUICardView.layer.cornerRadius = 8.0
        
        
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


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func launchVC(vcName:String) {
//        if vcName == "createevent" {
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateEventViewController") as! CreateEventViewController
//
//           self.navigationController?.pushViewController(nextVC , animated: true)
        //}
    
        
    }
    
//    func getStripeBalance(){
//
//       // clearData()
//
//        let request = Request(path: "/api/Profile/balance/\(myProfileId)", token: myToken!)
//        
//        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
//            switch result {
//            case .success(let balance):
//                let decoder = JSONDecoder()
//
//                do {
//                    let stripeBalanceJson = try decoder.decode(StripeBalance.self, from: balance)
//
//                    for available in stripeBalanceJson.available {
//
//                        let data = StripeBalanceAmountCurrency(amount: available.amount, currency: available.currency)
//                        stripeBalanceAvailable.append(data)
//                    }
//
//                    for pending in stripeBalanceJson.pending {
//
//                        let data2 = StripeBalanceAmountCurrency(amount: pending.amount, currency: pending.currency)
//                        stripeBalancePending.append(data2)
//                    }
//
//                } catch {
//
//                }
//                //self.parse(json: balance)
//            case .failure(let error):
//                print(" DOMINIC G IGHEDOSA ERROR \(error.localizedDescription)")
//            }
//        }
//    }
//
    
    @IBAction func customerOnboardingBtnPressed(_ sender: Any) {
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.infoBoard(completionAction: "onboardcustomer")
        }
    }
    @IBAction func createEventBtnPressed(_ sender: Any) {
        
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.infoBoard(completionAction: "createevent") 
        }
    }
    
    
    @IBAction func joinEventBtnPressed(_ sender: Any) {
        if(self.customCellDelegate != nil){ //Just to be safe.
            self.customCellDelegate?.infoBoard(completionAction: "joinevent")
        }
    }
    
}
