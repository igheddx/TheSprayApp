//
//  SprayViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/16/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import AVFoundation


class SprayViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var swipeCount = 0
    var imgCount = 0
    var currencySymbol: String = "$"
    var sprayAmount = 0
    var sprayAmountDuringAutoReplenish = 0
    var player: AVAudioPlayer!
    var startingBalance: Int = 10
    var currencyDenomination: Int = 0
    var sprayIncrementAmt: String = ""
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var paymentClientToken: String?
    var eventId: Int64 = 0
    var ownerId: Int64 = 0
    var profileId: Int64 = 0
    var giftReceiverId: Int64 = 0
    var token: String = ""
    var eventTypeIcon: String = ""
    var currencyImageSide1: String = ""
    var currencyImageSide2: String = ""
    
    @IBOutlet weak var sprayCurrencyImage: UIImageView!
    var incomingGiftReceiverName: String!
    var gifterBalance: Int = 0
    var gifterTotalTransAmount: Int = 0
    
    var sprayDelegate: SprayTransactionDelegate?
    
    var db:DBHelper = DBHelper()
    var senderspraybalance: [SenderSprayBalance] = []
    
    var isAutoReplenishFlag: Bool?
    var withdrawAmount: Int = 0
    var autoReplenishAmount: Int?
    var notificationAmount: Int?
    var paymentMethod: Int?
    var isOkToReplenish: Bool = false
    
    var customtextfield = CustomTextField()
    //var totalGiftedLbl: TotalGiftedLbl()
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var giftReceiverName: UILabel!
    @IBOutlet weak var giftAmountReceived: UILabel!
    @IBOutlet weak var gifterStartingBalance: UILabel!
    
    @IBOutlet weak var currencyDenomLabel: UILabel!
  
    @IBOutlet weak var giftAmountLabel: UILabel!
    
    @IBOutlet weak var sprayIncrementAmount: UILabel!
    
    @IBOutlet weak var myBalanceLbl: UILabel!
    @IBOutlet weak var totalGiftedLbl: UILabel!
    
    var sprayTotalLblAmt: UILabel?
    var myBalanceLblAmt: UILabel?
    var sprayInfoOnNavbarTitle: UILabel?
    
    lazy var titleStackView: UIStackView = {
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.text = "Title"
            let subtitleLabel = UILabel()
            subtitleLabel.textAlignment = .center
            subtitleLabel.text = "Subtitle"
            let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
            stackView.axis = .vertical
            return stackView
        }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        print("receiverId = \(giftReceiverId)")
        
//        let logo = UIImage(named: "profileIcon")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
        
        // Do any additional setup after loading the view.
            //let image = UIImage(named: "profileIcon")
            //navigationItem.titleView = UIImageView(image: image)
        
       // imgImage.image = UIImage(named: currencyImageSide1)
       // super.viewDidLoad()
            // Do any additional setup after loading the view.
//            let imageView = UIImageView(frame: CGRect(x: 300, y: 0, width: 38, height: 38))
//        imageView.contentMode = .scaleAspectFit
//            let image = UIImage(named: "profileIcon")
//            imageView.image = image
//            navigationItem.titleView = imageView
//        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
//
//         let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
//         imageView.contentMode = .scaleAspectFit
//         let image = UIImage(named: "profileIcon.png")
//         imageView.image = image
//         logoContainer.addSubview(imageView)
//         navigationItem.titleView = logoContainer
      
        
        navBarData2()
        //self.title = "This is a \nmultiline title"
           // setupNavigationMultilineTitle()
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: .red, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
//
        //navigationItem.titleView = titleStackView
        //self.navigationItem.title = "Gift Amount: $20 My Balance: $100"              //  totalGiftedLbl = TotalGiftedLbl(frame: CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2, width: 100, height: 20))
                // self.view.addSubView(totalGiftedLbl)
        
        print("currencyImage1 =\(currencyImageSide1) --currencyImage2 =\(currencyImageSide2) ")
        backgroundScreenDataReset()
        print("Evenname = \(eventName)")
        print("Dominic Ighedosa gifterTotalTransAmount \(gifterTotalTransAmount)")
        print("gifterBalance \(gifterBalance)")
        //UINavigationBar.appearance().backgroundColor = UIColor.black
        //self.navigationController?.navigationBar.barTintColor = .black
        //self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.tintColor = UIColor.white
       
        //self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //UINavigationBar.appearance().isTranslucent = false
        //self.navigationController?.navigationBar.isTranslucent = false
       
        //sprayIncrementAmount.center = CGPoint(x: 137, y: 371)
        //sprayIncrementAmount.textAlignment = .center
        //giftAmountLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        //giftAmountLabel.center = CGPoint(x: 270, y: 100)
        //label2.textAlignment = .center
        
        
//        let sprayIncrementAmount = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
//        sprayIncrementAmount.center = CGPoint(x: 160, y: 250)
//        sprayIncrementAmount.textAlignment = .center
        /* spray increment label*/
        //sprayIncrementAmount.text = sprayIncrementAmt
//        sprayIncrementAmount.font = sprayIncrementAmount.font.withSize(50)
//        sprayIncrementAmount.font = UIFont(name:"HelveticaNeue-Bold", size: 50.0)
//        self.view.addSubview( sprayIncrementAmount)
//
        //sprayIncrementAmount.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        //centralBallance.center = CGPoint(x: 3000, y: 379)
        
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        label2.center = CGPoint(x: 270, y: 100)
        label2.textAlignment = .center
        label2.text = "$0"
        label2.font = label2.font.withSize(50)
        label2.font = UIFont(name:"HelveticaNeue-Bold", size: 50.0)
        //self.view.addSubview(label2)
        
        label2.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        //centralBallance.center = CGPoint(x: 3000, y: 379)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        label3.center = CGPoint(x: 200, y: 50)
        label3.textAlignment = .center
        label3.text = "Spraying, Dominic Ighedosa"
        label3.font = label3.font.withSize(17)
        label3.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
       // self.view.addSubview(label3)
        
        
        
        
        //navigationController?.setNavigationBarHidden(true, animated: true)
        
        print("paymentMethod = \(paymentMethod!)")
        print("isAutoReplenishFlag= \(isAutoReplenishFlag!)")
        print("autoReplenishAmount= \(autoReplenishAmount!)")
        
        
        //currencyDenomLabel.text = sprayIncrementAmt
        currencyDenomination = Int(getIntOnlyFromTextField(value: sprayIncrementAmt))!
        
        //giftReceiverName.text = "Now spraying, " + incomingGiftReceiverName
        //giftAmountReceived.text = String("$\(sprayAmount)")
        
   
        imgImage.isUserInteractionEnabled = true
        
        let swiftRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftRight.direction = UISwipeGestureRecognizer.Direction.right
        imgImage.addGestureRecognizer(swiftRight)
        
        let swiftLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftLeft.direction = UISwipeGestureRecognizer.Direction.left
        imgImage.addGestureRecognizer(swiftLeft)
        
        let swiftUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftUp.direction = UISwipeGestureRecognizer.Direction.up
        imgImage.addGestureRecognizer(swiftUp)
        
        let swiftDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftDown.direction = UISwipeGestureRecognizer.Direction.down
        imgImage.addGestureRecognizer(swiftDown)
                
    }
    
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
        //navBarData()

           if view.traitCollection.horizontalSizeClass == .compact {
               titleStackView.axis = .vertical
               titleStackView.spacing = UIStackView.spacingUseDefault
           } else {
               titleStackView.axis = .horizontal
               titleStackView.spacing = 20.0
           }
       }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        backgroundScreenDataReset()
        
        //setupNavigationMultilineTitle()
        
        let isEditEventSettingRefreshSprayVC = defaults.bool(forKey: "isEditEventSettingRefreshSprayVC")
        //refresh screen when coming from other screen
        print("isEditEventSettingRefreshSprayVC=\(isEditEventSettingRefreshSprayVC)")
        if isEditEventSettingRefreshSprayVC == true {
           
            
            //reset the value to false
            defaults.set(false, forKey: "isEditEventSettingRefreshSprayVC")
        }
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
            
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        
        
        if parent == nil {
            print("gifter balance before the left screen \(gifterBalance)")
            /*send receiver balance based if autoflag is set and continue to
             replenish is set*/
//            var receiverBalanceAmtAfterSpray: Int = 0
//            if isAutoReplenishFlag == true && isOkToReplenish == true {
//                receiverBalanceAmtAfterSpray = sprayAmountDuringAutoReplenish
//            } else {
//                receiverBalanceAmtAfterSpray  = sprayAmount
//            }
            sprayDelegate?.sprayGifterBalance(balance: gifterBalance )
            sprayDelegate?.sprayReceiverBalance(balance: sprayAmountDuringAutoReplenish)
            sprayDelegate?.sprayReceiverId(receiverId: giftReceiverId)
            sprayDelegate?.processSprayTransaction(eventId: Int(eventId), senderId: Int(profileId), receiverId: Int(giftReceiverId), senderAmountRemaining: gifterBalance, receiverBalanceAfterSpray: sprayAmountDuringAutoReplenish, isAutoReplenish: isAutoReplenishFlag!, paymentMethod: paymentMethod!)
            debugPrint("Back Button pressed.")
        }
    }
    
    func setupNavigationMultilineTitle() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        for sview in navigationBar.subviews {
            for ssview in sview.subviews {
                guard let label = ssview as? UILabel else { break }
                if label.text == self.title {
                    label.numberOfLines = 2
                    //label.lineBreakMode = .byWordWrapping
                    label.sizeToFit()
                    UIView.animate(withDuration: 0.3, animations: {
                        navigationBar.frame.size.height = 57 + label.frame.height
                    })
                }
            }
        }
        
//        let label: UILabel = UILabel(frame: CGRectMake(0, 0, 400, 50))
//        label.backgroundColor = UIColor.clearColor()
//        label.numberOfLines = 2
//        label.font = UIFont.boldSystemFontOfSize(16.0)
//        label.textAlignment = .Center
//        label.textColor = UIColor.whiteColor()
//        label.text = "This is a\nmultiline string for the navBar"
//        self.navigationItem.titleView = label
    }
    
    func navBarData2() {
        sprayInfoOnNavbarTitle = UILabel()
        sprayInfoOnNavbarTitle!.backgroundColor = .clear
        sprayInfoOnNavbarTitle!.numberOfLines = 3
        sprayInfoOnNavbarTitle!.font = UIFont.boldSystemFont(ofSize: 11.0)
        sprayInfoOnNavbarTitle!.textAlignment = .center
        sprayInfoOnNavbarTitle!.textColor = .white
        sprayInfoOnNavbarTitle!.text = "Now Spraying, Dominic Ighedosa \n Total Gifted: $40\n My Balance: $200"
        

        
        self.navigationItem.titleView = sprayInfoOnNavbarTitle
    }
    
    func navBarData() {
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: 170, y: -20, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            let firstFrame2 = CGRect(x: 267, y: -20, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            
            let secondFrame = CGRect(x: navigationBar.frame.width/2 - 14, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            let secondFrame2 = CGRect(x: 269, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            
    //            totalGiftedLbl.frame = firstFrame
    //            giftAmountReceived.frame = firstFrame2
    //            giftAmountReceived.text = "$\(sprayAmount)"
    //            myBalanceLbl.frame = secondFrame
    //            gifterStartingBalance.frame = secondFrame2
    //            gifterStartingBalance.text = "$\(gifterBalance)"
            //totalGiftedLbl.frame = firstFrame
           
            let sprayTotalLbl = UILabel(frame: firstFrame)
            sprayTotalLbl.text = "Total Gifted:"
            sprayTotalLbl.font  = UIFont(name:"HelveticaNeue", size: 12.0)
            sprayTotalLbl.textColor = UIColor.white

            
            sprayTotalLblAmt = UILabel(frame: firstFrame2)
            sprayTotalLblAmt!.text = "0"
            sprayTotalLblAmt!.font  = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
            sprayTotalLblAmt!.textColor = UIColor.white

            let myBalanceLbl = UILabel(frame: secondFrame)
            myBalanceLbl.text = "My Balance:"
            myBalanceLbl.font  = UIFont(name:"HelveticaNeue", size: 12.0)
            myBalanceLbl.textColor = UIColor.white


            myBalanceLblAmt = UILabel(frame: secondFrame2)
            myBalanceLblAmt!.text = "000"
            myBalanceLblAmt!.font  = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
            myBalanceLblAmt!.textColor = UIColor.white
            
//            switch type {
//            case "sprayamount":
//                print("sprayTotalLblAmt.text before udpate=\(sprayTotalLblAmt?.text ?? "no value")")
//                sprayTotalLblAmt!.text = ""
//                print("sprayTotalLblAmt.text after value ==  \(sprayTotalLblAmt!.text!)")
//                sprayTotalLblAmt!.text = ""
//                print("sprayTotalLblAmt.text after new data is set \(sprayTotalLblAmt!.text!)")
//                //print("sprayTotalLblAmt.text =\(sprayTotalLblAmt.text!)")
//                navigationBar.addSubview(sprayTotalLblAmt!)
//            case "balance":
//                myBalanceLblAmt!.text = ""
//                myBalanceLblAmt!.text = ""
//                print("myBalanceLblAmt.text = \(myBalanceLblAmt!.text!)")
//                navigationBar.addSubview(myBalanceLblAmt!)
//            default:
//                sprayTotalLblAmt!.text = "N/A"
//
//            }

            navigationBar.addSubview(sprayTotalLbl)
            navigationBar.addSubview(sprayTotalLblAmt!)
            navigationBar.addSubview(myBalanceLbl)
            navigationBar.addSubview(myBalanceLblAmt!)
        }
    }
    func updateSprayInfoOnNavbarTitle() {
        if let sprayInfo = self.sprayInfoOnNavbarTitle {
            let navbarTitle = "Now spraying, \(incomingGiftReceiverName!) \n Total Gifted: $\(sprayAmount) \n Available Balance: $\(gifterBalance)"
            sprayInfo.text = navbarTitle
            //sprayTotalAmt.text = "\(data)"
            //sprayTotalAmt.text = data
  
        }
    }
    
    //call func to update receiver amount after spice
    func updateSprayTotalLblAmt(data: String) {
        if let sprayTotalAmt = self.sprayTotalLblAmt {
            sprayTotalAmt.text = ""
            //sprayTotalAmt.text = "\(data)"
            //sprayTotalAmt.text = data
            print("data =\(data)")
        }
    }
    
    func randomString(length: Int) -> String {
      let letters = "0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    //call func to update gifter balance after swipe
    func updateMyBalanceLblAmt(data: String) {
//        if let myBalanceAmt = self.myBalanceLblAmt {
//            myBalanceAmt.text! = "103"
//            //myBalanceAmt.text = randomString(length: 5)
//            //myBalanceAmt.text = data
//            //myBalanceAmt.text = "\(data)"
//            //myBalanceAmt.text = data
//            print("data =\(data)")
//        }
        self.myBalanceLblAmt?.text = ""
        self.myBalanceLblAmt?.text = data
    }
    func getIntOnlyFromTextField(value: String) -> String {
        
        let index = value.firstIndex(of: ".") ?? value.endIndex
        let result: String = String(value[..<index])
        //remove currency symbol from string
        let range = result.index(result.startIndex, offsetBy: 1)..<result.endIndex
        let output = value[range]
        let finalResult = String(output)
        
        print(finalResult)
        return finalResult
    }
    
    func backgroundScreenDataReset() {
        //initialize
        isOkToReplenish = defaults.bool(forKey: "isContinueAutoReplenish")
        sprayCurrencyImage.image = UIImage(named: currencyImageSide1)
        sprayAmount = 0
        sprayAmountDuringAutoReplenish = 0
        //giftAmountReceived.text = String("$\(sprayAmount)")
        getGifterTotalTransBalance()
        updateSprayInfoOnNavbarTitle()
        //navBarData(data: "$\(sprayAmount)", type:"sprayamount")
        //navBarData(data: "$\(gifterBalance)", type:"balance")
        //navBarData()
//        updateSprayTotalLblAmt(data: "")
//        updateMyBalanceLblAmt(data: "")
    }
    
    func updateSprayTransaction(sprayAmount: Int) {
        let AddSprayTrans = SprayTransactionModel(eventId: eventId, senderId: profileId, recipientId:giftReceiverId, amount: sprayAmount, success: true, errorCode: "", errorMessage: "")
        
        print("AddSprayTrans \(AddSprayTrans)")
        let request = PostRequest(path: "/api/SprayTransaction/add", model: AddSprayTrans , token: token)

        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _):
                
                //call these functions after spray transaction is complete
                //these func will get updated balance
                
               // getGifterData()
              
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //hold on to this function for now
    func getAvailableSprayAmount() -> Int {
        var availablebalance: Int = 0
        if gifterBalance > gifterTotalTransAmount {
            
            availablebalance = gifterBalance - gifterTotalTransAmount
        } else if isAutoReplenishFlag == true {
            if gifterBalance <= gifterTotalTransAmount {
                availablebalance = gifterBalance  + autoReplenishAmount!
            }
        }
        return availablebalance
    }
    func getGifterTotalTransBalanceOld()   {
        
        var availablebalance: Int = 0
        //var theGifterTotalTransBalance: Int = 0
        let request = Request(path: "/api/Event/transactiontotal/\(profileId)/\(eventId)", token: token)
               
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let gifterBalance):
                
                    //return paymentmethod1
                //self.gifterData = gifterBalance
                let decoder = JSONDecoder()
                do {
                   let gifterBalanceJson: GifterTransactionTotal = try decoder.decode(GifterTransactionTotal.self, from: gifterBalance)
                   
                    //for gifter in gifterBalanceJson {
                    if  gifterBalanceJson.eventId == eventId &&  gifterBalanceJson.profileId == profileId {
                           //theGifterTotalTransBalance = gifter.totalAmountAllTransactions
                        self.gifterTotalTransAmount =  gifterBalanceJson.totalAmountAllTransactions
                        print("self.gifterTotalTransAmount = \(gifterBalanceJson.totalAmountAllTransactions)")
                        
                    }
                   //}
                      
               } catch {
                   print(error)
               }
                //self.getEventPref2(paymenttypeData: paymentmethod1)
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }

    }
    
    
        
 
    
    func getGifterTotalTransBalance()   {
        //var theGifterTotalTransBalance: Int = 0
        let request = Request(path: "/api/Event/transactiontotal/\(profileId)/\(eventId)", token: token)
               
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let gifterBalance):
                
                let decoder = JSONDecoder()
                do {
                   let gifterBalanceJson: GifterTransactionTotal = try decoder.decode(GifterTransactionTotal.self, from: gifterBalance)
                   
                    //for gifter in gifterBalanceJson {
                    if  gifterBalanceJson.eventId == eventId &&  gifterBalanceJson.profileId == profileId {
                           //theGifterTotalTransBalance = gifter.totalAmountAllTransactions
                        self.gifterTotalTransAmount =  gifterBalanceJson.totalAmountAllTransactions
                        print("self.gifterTotalTransAmount = \(gifterBalanceJson.totalAmountAllTransactions)")
                        
                        //
                        self.getEventPref3()
                    }
                   //}
                      
               } catch {
                   print(error)
               }
                //self.getEventPref2(paymenttypeData: paymentmethod1)
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }
    }
    
    func getEventPref3() {
            //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
            let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token)
            
            Network.shared.send(request) { (result: Result<Data, Error>)   in
                switch result {
                    case .success(let eventPreferenceData):
                        let decoder = JSONDecoder()
                        do {
                            let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                            for eventPrefData in eventPreferenceJson {
                                if eventPrefData.eventId == self.eventId && eventPrefData.profileId == self.profileId {
                                    
                                    //
                                    if self.gifterTotalTransAmount > 0 {
                                        self.gifterBalance = eventPrefData.maxSprayAmount - self.gifterTotalTransAmount
                                        print("Balance is from self.balance = eventPrefData.maxSprayAmount - self.gifterTotalTransAmount = \(self.gifterBalance)")
                                    } else {
                                        print("self.balance = \(self.gifterBalance)  before balance value is set")
                                        self.gifterBalance = eventPrefData.maxSprayAmount
                                        print("Balance is from self.balance = eventPrefData.maxSprayAmount = \(self.gifterBalance)")
                                        
                                    }
                                        
                                    //self.gifterStartingBalance.text = String("$\(self.gifterBalance)")
                                    //self.navBarData(data: "$\(self.gifterBalance)", type: "balance")
                                    //self.updateMyBalanceLblAmt(data: "")
                                    //self.updateMyBalanceLblAmt(data: String(self.gifterBalance))
                                    self.updateSprayInfoOnNavbarTitle()
                                    //display message when balance is 0
//                                    if self.balance <= 0 {
//                                        self.eventSettingBtn.isHidden = false
//                                        self.generalMessageLabel.text = "You Are Out of Funds. Select Edit Event Settings button to update your funds."
//                                    } else {
//                                        self.eventSettingBtn.isHidden = true
//                                        self.generalMessageLabel.text = ""
//                                        self.tableView.reloadData()
//                                    }
                                    self.withdrawAmount = eventPrefData.maxSprayAmount
                                    self.isAutoReplenishFlag = eventPrefData.isAutoReplenish
                                    self.autoReplenishAmount = eventPrefData.replenishAmount
                                    self.notificationAmount = eventPrefData.notificationAmount
                                    self.paymentMethod = eventPrefData.paymentMethod
                                    
                                    
                                }
    //                            if self.senderspraybalance.count > 0 {
    //                                print("there is senders amount remainng...")
    //                                for s in self.senderspraybalance {
    //                                    self.balance = s.senderAmountRemaining
    //                                    print("there is senders amount remainng... \(self.balance ?? 0)")
    //
    //                                    print("eventId = \(s.eventId)")
    //                                    print("senderId = \(s.senderId)")
    //                                    print("paymentType = \(s.paymentType)")
    //                                    print("paymentType = \(s.senderAmountRemaining)")
    //                                    print("autoReplenis = \(s.isAutoReplenish)")
    //                                    print("transaction datea = \(s.transactionDateTime)")
    //
    //
    //
    //                                    self.balance = s.senderAmountRemaining
    //                                    print("asasdd there is senders amount remainng... \(self.balance ?? 0)")
    //                                }
    //                            } else {
    //                               // if eventPrefData.maxSprayAmount == 0 || eventPrefData.maxSprayAmount.
    //                                self.balance = eventPrefData.maxSprayAmount
    //                            }
                                
                               
                            }
                
                        } catch {
                            print(error)
                        }
                    case .failure(let error):
                    print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
                }
            }
        }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { print("Torch isn't available"); return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            // Optional thing you may want when the torch it's on, is to manipulate the level of the torch
            if on { try device.setTorchModeOn(level:1.0) }
            device.unlockForConfiguration()
        } catch {
            print("Torch can't be used")
        }
    }
    //another option for knowing when back button was selectec
//    override func viewWillDisappear(_ animated: Bool) {
//       if self.isMovingFromParentViewController {
//           self.delegate.updateData( data)
//       }
//       }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "cashRegisterSound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
            
    func getUIAlertAction(actionValue: UIAlertAction) {
        if actionValue.title! == "Ok, Replenish" {
            isOkToReplenish = true
        } else {
            isOkToReplenish = false
        }
        print(actionValue.title!)
    }
    
    @objc func swipeGesture(sendr: UISwipeGestureRecognizer) {
       
        
        let currencyArray = [#imageLiteral(resourceName: "currencySide2B"),#imageLiteral(resourceName: "currencySide1B"),#imageLiteral(resourceName: "currencySide3B")]
        //            if let swipeGesture = sendr as? UISwipeGestureRecognizer {
        //                switch swipeGesture.direction {
        //                case UISwipeGestureRecognizer.Direction.up:
        //                    print("swipe right")
        //                    //currencyImage = UIImage[0]
        //
        //                    sprayAmount += 1
        //
        //                    if swipeCount == 0 {
        //                        imgImage.image = currencyArray[swipeCount]
        //                        playSound()
        //                        swipeCount += 1
        //                        print(swipeCount)
        //                    } else if swipeCount == 1 {
        //                        imgImage.image = currencyArray[swipeCount]
        //                         playSound()
        //                        swipeCount = 0
        //                         print(swipeCount)
        //                    }
        //                default:
        
        //
        if let swipeGesture = sendr as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                //case UISwipeGestureRecognizer.Direction.right:
                // print("swipe right")
                //swipeCount += 1
                //imgImage.image = UIImage(named: "currency2")
                //case UISwipeGestureRecognizer.Direction.left:
                //print("swipe left")
                //swipeCount += 1
            //imgImage.image = UIImage(named: "currency")
            case UISwipeGestureRecognizer.Direction.up:
                
                if gifterBalance >= currencyDenomination {
                    print("SWIPE 1")
                    if (isAutoReplenishFlag == true && notificationAmount! != 0 && (notificationAmount! == gifterBalance) && isOkToReplenish == false) {
                        print("SWIPE 2")
                        //imgImage.image  = currencyArray[2]
                        let alert = UIAlertController(title: "Warning!", message: "You have a balance of $\(gifterBalance) remaining. Your fund will replenish by $\(autoReplenishAmount!) when you run out of money.", preferredStyle: .actionSheet)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: getUIAlertAction))
                        //alert.addAction(UIAlertAction(title: "Don't Replenish", style: .cancel, handler: getUIAlertAction))
                        
                        

                        self.present(alert, animated: true)
                    } else  if currencyDenomination > gifterBalance && isAutoReplenishFlag == true && isOkToReplenish == true{
                        setAutoReplenishAction()
                        // hold this for now - gifterBalance = gifterBalance + autoReplenishAmount!
                        
                        print("Swipe 3 \(gifterBalance)")
                        //gifterStartingBalance.text = String("$\(gifterBalance)")
                        //navBarData(data: "$\(gifterBalance)", type: "balance")
                        //updateMyBalanceLblAmt(data: "$\(gifterBalance)")
                        // hold this for nowupdateSprayInfoOnNavbarTitle()
                        print("SWIPE 3")
                    } else {
//                        if gifterBalance == 0 && isAutoReplenishFlag == true {
//                            gifterBalance = autoReplenishAmount!
//                            gifterStartingBalance.text = String("$\(autoReplenishAmount!)")
                        //} else
                        //if currencyDenomination > gifterBalance {
                            //imgImage.image  = UIImage(named: currencyImageSide1)//currencyArray[2]
                           //update receive transaction before use goes
                            //and increase their funds
//                            if sprayAmount > 0 {
//                                updateSprayTransaction()
//
//                                //reset sprayamount
//                                sprayAmount = 0
//                                giftAmountReceived.text = String("$\(sprayAmount)")
//                            }
//                            let alert = UIAlertController(title: "Out of funds!", message: "Would you like to replenish your funds so that you can continue with gifting? Select Yes to conitnue or No to return to the Home screen", preferredStyle: .actionSheet)
//
//                            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in self.goToEventSetthings()}))
//                            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in self.goToHome()}))
//                            //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//
//                            self.present(alert, animated: true)
//                            print("Balance is Zero")
                        //} else  {
                                
                        print("SWIPE 4")
                        if swipeCount == 0  {
                            print("SWIPE 5")
                            playSound()
                            imgImage.image  = UIImage(named: currencyImageSide2)//currencyArray[swipeCount]
                            UIView.transition(with: self.imgImage,
                             duration: 0.5,
                             options: .transitionCurlUp,
                             animations: {
                                self.imgImage.image = UIImage(imageLiteralResourceName: self.currencyImageSide1)
                                   }, completion: nil)
                            
                            toggleTorch(on: true)
                           
                            
                            print("swipe up \(swipeCount)")
                            swipeCount += 1
                            
                            /*capture spray increment in sprayAmountDuringAutoReplenish when autorepplenish is True - this will be used to only update
                             amount sprayed during auto replenish... the total amount sprayed will remain the samee
                            */
                                
                            //if isAutoReplenishFlag == true && isOkToReplenish == true {
                                sprayAmount += currencyDenomination
                                sprayAmountDuringAutoReplenish += currencyDenomination
//                            } else {
//                                sprayAmount += currencyDenomination
//                            }
                            print("SWIPE 5 sprayAmountDuringAutoReplenish \(sprayAmountDuringAutoReplenish)")
                            
                            
                            //giftAmountReceived.text = String("$\(sprayAmount)")
                            //navBarData(data: "$\(sprayAmount)", type: "sprayamount")
                            //updateSprayTotalLblAmt(data: "$\(sprayAmount)")
                            updateSprayInfoOnNavbarTitle()
                            
                            gifterBalance = gifterBalance  - currencyDenomination
                            print("swip5 5 \(gifterBalance)")
                            //gifterStartingBalance.text =  String("$\(gifterBalance)")
                            //navBarData(data: "$\(gifterBalance)", type: "balance")
//                            updateMyBalanceLblAmt(data: "")
//                            updateMyBalanceLblAmt(data: String(gifterBalance))
                            updateSprayInfoOnNavbarTitle()
                            
//                                if gifterBalance >= 1 {
//                                    gifterBalance = gifterBalance  - currencyDenomination
//                                    gifterStartingBalance.text =  String("$\(gifterBalance)")
//                                } else {
//                                    gifterBalance = startingBalance - currencyDenomination
//                                    gifterStartingBalance.text =  String("$\(gifterBalance)")
//                                }
                            
                            print("gifterBalance under  IF  = \(gifterBalance)")
                            
                        } else if swipeCount == 1 {
                            print("SWIPE 6")
                            playSound()
                            imgImage.image  = UIImage(named: currencyImageSide1)//currencyArray[swipeCount]
                            UIView.transition(with: self.imgImage,
                             duration: 0.5,
                             options: .transitionCurlUp,
                             animations: {
                                self.imgImage.image = UIImage(imageLiteralResourceName: self.currencyImageSide2)
                                   }, completion: nil)
                           
                            toggleTorch(on: false)
                            print("swipe up \(swipeCount)")
                            swipeCount = 0
                            //sprayAmount += currencyDenomination
                            
                            /*capture spray increment in sprayAmountDuringAutoReplenish when autorepplenish is True - this will be used to only update
                             amount sprayed during auto replenish... the total amount sprayed will remain the samee
                            */
                                
                            //if isAutoReplenishFlag == true && isOkToReplenish == true {
                                sprayAmount += currencyDenomination
                                sprayAmountDuringAutoReplenish += currencyDenomination
//                            } else {
//                                sprayAmount += currencyDenomination
//                            }
                            print("SWIPE 6 sprayAmountDuringAutoReplenish \(sprayAmountDuringAutoReplenish)")
                            //giftAmountReceived.text = String("$\(sprayAmount)")
                            //navBarData(data: "$\(sprayAmount)", type: "sprayamount")
                            //updateSprayTotalLblAmt(data: "$\(sprayAmount)")
                            gifterBalance = gifterBalance  - currencyDenomination
                            //gifterStartingBalance.text =  String("$\(gifterBalance)")
                            //navBarData(data: "$\(gifterBalance)", type: "balance")
                            updateSprayInfoOnNavbarTitle()
                            //updateMyBalanceLblAmt(data: String(gifterBalance))
//                                if gifterBalance >= currencyDenomination {
//                                    gifterBalance = gifterBalance  - currencyDenomination
//                                    gifterStartingBalance.text =  String("$\(gifterBalance)")
//                                } else {
//                                    gifterBalance = startingBalance - currencyDenomination
//                                    gifterStartingBalance.text =  String("$\(gifterBalance)")
//                                }
                            
                            print("gifterBalance under ELSE IF = \(gifterBalance)")
                        }
                        
                        //}

                    }
                
                    //when there's not enough funds
                } else {
                    if isAutoReplenishFlag == true {
                        print("SWIPE 7")
                        //defaults.self(false, forkey: "isContinueAutoReplenish")
                        let isContinueAutoReplenish = defaults.bool(forKey: "isContinueAutoReplenish")
                        if isContinueAutoReplenish == true {
                            print("SWIPE 8")
                            setAutoReplenishAction()
                            updateSprayTransaction(sprayAmount: sprayAmountDuringAutoReplenish)
                            print("sprayAmountDuringAutoReplenish \(sprayAmountDuringAutoReplenish)")
                            sprayAmountDuringAutoReplenish = 0
                            
                            print("SWIPE 8 sprayAmountDuringAutoReplenish \(sprayAmountDuringAutoReplenish)")
                        } else {
                            print("SWIPE 9")
                            if sprayAmount > 0 {
                                print("SWIPE 9B")
                                //updateSprayTransaction(sprayAmount: sprayAmount)
                                updateSprayTransaction(sprayAmount: sprayAmountDuringAutoReplenish)
                                
                                //reset sprayamount
                                //sprayAmount = 0
                                sprayAmountDuringAutoReplenish = 0
                                //sprayAmountDuringAutoReplenish  = 0
                                //giftAmountReceived.text = String("$\(sprayAmount)")
                               // navBarData(data: "$\(sprayAmount)", type: "sprayamount")
                                updateSprayInfoOnNavbarTitle()
                                //updateSprayTotalLblAmt(data: "$\(sprayAmount)")
                            }
                            
                            /*display blank out of fund screen */
                            imgImage.image  = UIImage(named: "outofunds")//currencyArray[swipeCount]
                            
                            /*present alert to inform use that they have
                             auto replenish on if they accep then set it else */
                            let alert = UIAlertController(title: "Auto Replenish!", message: "You have Auto Replenish ON. Woul you like to continue with Auto Replenish? NOTE: If you select Yes, we will automatially increase your available funds by $\(autoReplenishAmount!) each time you run out of money.", preferredStyle: .actionSheet)

                            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in self.setAutoReplenishAction()}))
                            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in self.goToHome()}))
                            
                            self.present(alert, animated: true)
                        }
                        
                    } else {
                        print("SWIPE 10")
                        if sprayAmount > 0 {
                            print("SWIPE 11")
                            //updateSprayTransaction(sprayAmount: sprayAmount)
                            updateSprayTransaction(sprayAmount: sprayAmountDuringAutoReplenish)
                            
                            //reset sprayamount
                            //sprayAmount = 0
                            sprayAmountDuringAutoReplenish = 0
                            
                            //sprayAmountDuringAutoReplenish = 0
                            //giftAmountReceived.text = String("$\(sprayAmount)")
                        }
                        /*display blank out of fund screen */
                        imgImage.image  = UIImage(named: "outofunds")//currencyArray[swipeCount]
                        let alert = UIAlertController(title: "Not enough funds!", message: "Would you like to replenish your funds so that you can continue with gifting? Select Yes to conitnue or No to return to the Home screen", preferredStyle: .actionSheet)

                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in self.goToEventSetthings()}))
                        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in self.goToHome()}))
                        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                        self.present(alert, animated: true)
                        print("Balance is Zero")
                    }
                    
                }
                    //imgImage.image = UIImage(named: "currency2")
                    //                case UISwipeGestureRecognizer.Direction.up:
                    //                     playSound()
                    //                    swipeCount += 1
                    //                    print("swipe up 2 \(swipeCount)")
                //imgImage.image = UIImage(named: "currency2")
                default:
                    break
                   
                                 
                    
                }
                    
            
            //messageSwipeCount.text = String ("\(currencySymbol) \(sprayAmount)")
        }
                
                
}
            
            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             // Get the new view controller using segue.destination.
             // Pass the selected object to the new view controller.
             }
             */
    func getLatestWithdrawalAmount(){
        
        //get the total amount that the gifter has given
        //for this event
        //getGifterTotalTransBalance()
        
        
        //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token)
        
        Network.shared.send(request) { (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                        for eventPrefData in eventPreferenceJson {
                            print("Event Id = \(eventPrefData.eventId)")
                            print("Incoming Event Id = \(String(describing: self.eventId))")
                            if eventPrefData.eventId == self.eventId {
                                let latestWithdrawalAmt = eventPrefData.maxSprayAmount
                                self.withdrawAmount = 0
                                self.withdrawAmount = latestWithdrawalAmt
                                self.saveEventPreference(paymentMethodId: self.paymentMethod!)
                                break
                            }
                        }
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
                             
    
    func setAutoReplenishAction() {
        
        /*reset currency image after agreeing to auto replenish or adding more funds */
        imgImage.image  = UIImage(named: currencyImageSide1)//currencyArray[swipeCount]
        
        //increase gifterBalance
        gifterBalance =  autoReplenishAmount!
        //gifterStartingBalance.text =  String("$\(gifterBalance)")
        //navBarData(data: "$\(gifterBalance)", type: "balance")
        //updateMyBalanceLblAmt(data: "$\(gifterBalance)")
        updateSprayInfoOnNavbarTitle()
        //update gift preference amount
        
        getLatestWithdrawalAmount()
        
        //let defaults = UserDefaults.standard
        //getGifterTotalTransBalance() //we don't need this
        defaults.set(true, forKey: "isContinueAutoReplenish") //whenauto replish is enabled while using app
        isOkToReplenish = defaults.bool(forKey: "isContinueAutoReplenish")
    }
    func saveEventPreference(paymentMethodId: Int) {
        print("SaveEventPreference was called #1")
        //withdrawAmount = Int(withdrawAmountTextField.text!)!
//        guard let autoReplenishAmount = Int(autoReplenishAmountTextField.text!) else  {
//            return
//        }
//        autoReplenishAmount = Int(autoReplenishAmountTextField.text!) ?? 0
//        notificationAmount = Int(notificationAmountTextField.text!) ?? 0
        
//        if autoReplenishSwitch.isOn == true {
//            isAutoReplenish = true
//        } else {
//            isAutoReplenish = false
//        }
        //print("paymentType= \(paymentType)")
        let newWithdrawAmount = withdrawAmount + autoReplenishAmount!
        let addEventPreference = EventPreference(eventId: eventId, profileId: profileId, paymentMethod: paymentMethodId, maxSprayAmount: newWithdrawAmount, replenishAmount: autoReplenishAmount!, notificationAmount:  notificationAmount!, isAutoReplenish: isAutoReplenishFlag!)

        print("Add  \(addEventPreference)")
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref); break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
    
    func goToEventSetthings() {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let pvc = storyboard.instantiateViewController(withIdentifier: "outOffundsVC") as! OutOfFundsViewController
//            pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            self.present(pvc, animated: true, completion: nil)
//
        defaults.set(true, forKey: "isEditEventSettingRefreshSprayVC")
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventContainer") as! EventSettingContainerViewController
        //nextVC.selectionDelegate = self
       
        
        
       // defaults.set(true, forKey: "isEditEventSettingRefresh")
        
        //nextVC.refreshscreendelegate = self
//
        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventCode = eventCode
        nextVC.eventId = eventId
        nextVC.profileId = profileId
        //nextVC.ownerId = ownerId
        nextVC.token = token
        nextVC.paymentClientToken  =  paymentClientToken
        //nextVC.ownerId = 31
//
        nextVC.isAttendingEventId = 1 //1 is a default value to indicate that RSVP is true
        nextVC.screenIdentifier = "Spray"
//
        nextVC.eventTypeIcon = eventTypeIcon
//
       self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    func goToHome() {
        
    }
}


public extension UIImageView{
    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
}
