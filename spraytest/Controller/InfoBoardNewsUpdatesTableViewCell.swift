//
//  InfoBoardNewsUpdatesTableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/19/22.
//  Copyright © 2022 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class InfoBoardNewsUpdatesTableViewCell: UITableViewCell {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var newsLabel: UILabel!
    // @IBOutlet weak var infoUICardView: UIView!
  
    @IBOutlet weak var newsimage: UIImageView!
    
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
    @IBOutlet weak var totalGiftReceivedAmtLbl: UILabel!
    
    
    @IBOutlet weak var onboardingMessageLbl: UILabel!
    //var myInvitationCustomCellDelegate: MyInvitationCustomCellDelegate?
    var customCellDelegate: MyCustomCellDelegator?
    static let identifier = "InfoBoardNewsUpdatesTableViewCell"
    
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
    var count: Int = 0
    var countToExitTimer: Int = 0
    var sprayTimer: Timer? = nil
    var spraytimer = SprayTimer()
    
    
    static func nib() -> UINib {
        return UINib(nibName: "InfoBoardNewsUpdatesTableViewCell", bundle: nil)
    }
    
    public func configure(with outstandingTransferAmt: String, pendingPayoutAmt: String, totalGiftedAmt: String, totalReceivedAmt: String, currency: String, paymentCustomerId: String, paymentConnectedActId: String) {
        
        
        infoUICardView2.layer.borderColor  = UIColor.gray.cgColor
        infoUICardView2.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        infoUICardView2.layer.shadowOpacity  = 0.1
        infoUICardView2.layer.masksToBounds = false
        infoUICardView2.layer.cornerRadius = 8.0
        
        newsimage.image = UIImage(named: "newsimage1")
        newsLabel.text = "Better to give than to receive..."
        
       // let isKeyChainInUse = defaults(key: "myNewsImae")
        
        let newsImage = defaults.string(forKey: "myNewsImage")
        print("news Image = \(newsImage)")
       //sprayTimer?.invalidate()
        sprayTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        //spraytime.startTimer()
        //cell2.layer.shadowPath = UIBezierPath(roundedRect: sprayCardView.bounds, cornerRadius: cell2.contentView.layer.cornerRadius).cgPath
        
        //spraytimer.startTimer()
        print("news image = \(newsImage)")
    }
    
    /*function to displays image every 3 seconds*/
    @objc func fireTimer() {
        print("Timer fired!")
        
        count += 1
        countToExitTimer += 1
        
        if count == 1 {
            print("image 1")
            newsimage.image = UIImage(named: "newsimage1")
            newsLabel.text = "Better to give than to receive..."
        } else if count == 2 {
            print("image 2")
            newsimage.image = UIImage(named: "newsimage2")
            newsLabel.text = "Dancing in the street..."
       
        } else if count == 3 {
            print("image 2")
            newsimage.image = UIImage(named: "newsimage3")
            newsLabel.text = "Show your appreciation, spray your friends..."
            
           // count = 0
        }
        if countToExitTimer == 4 {
            sprayTimer?.invalidate()
            //count = 0
        }
        //menuImage.image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
        
        //print("my counter is \(count)")
//        runCount += 1
//
       
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
