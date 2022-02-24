//
//  InfoBoard2TableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/1/22.
//  Copyright © 2022 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class InfoBoard3TableViewCell: UITableViewCell {

    let defaults = UserDefaults.standard
    
   // @IBOutlet weak var infoUICardView: UIView!
  
    
    @IBOutlet weak var infoUICardView2: UIView!
    
    //@IBOutlet weak var infoUICardView2: UIView!
    @IBOutlet weak var oustandingTransferUIView: UIView!
    @IBOutlet weak var pendingPayoutUIView: UIView!
    
    @IBOutlet weak var customerOnboardingBtn: PayoutBtn!
    
    @IBOutlet weak var totalGiftedUIView: UIView!
    @IBOutlet weak var totalReceivedUIView: UIView!
    
    @IBOutlet weak var outstandingTransferAmtLbl: UILabel!
    @IBOutlet weak var pendingPayountAmtLbl: UILabel!
    
    @IBOutlet weak var totalGiftedAmtLbl: UILabel!
    
    
    @IBOutlet weak var amountDisplayedLbl: UILabel!
    @IBOutlet weak var amountTitleLbl: UILabel!
    //var myInvitationCustomCellDelegate: MyInvitationCustomCellDelegate?
    var customCellDelegate: MyCustomCellDelegator?
    static let identifier = "InfoBoard3TableViewCell"
    
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
        return UINib(nibName: "InfoBoard3TableViewCell", bundle: nil)
    }
    
    public func configure(with outstandingTransferAmt: String, pendingPayoutAmt: String, totalGiftedAmt: String, totalReceivedAmt: String, currency: String, paymentCustomerId: String, paymentConnectedActId: String) {
        
        print("SHINJA - pendingPayoutAmt - \(pendingPayoutAmt) --- \(currency)")
        infoUICardView2.layer.borderColor  = UIColor.gray.cgColor
        infoUICardView2.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        infoUICardView2.layer.shadowOpacity  = 0.1
        infoUICardView2.layer.masksToBounds = false
        infoUICardView2.layer.cornerRadius = 8.0
        
        currencySymbol = Currency.shared.findSymbol(currencyCode: currency)
        
        if pendingPayoutAmt != "0.0" {
            amountTitleLbl.text = "...pending payout amount"
            amountDisplayedLbl.text = currencySymbol + pendingPayoutAmt
        }
        
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

        
    }
    

    
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