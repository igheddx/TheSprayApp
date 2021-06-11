//
//  GoSprayViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/29/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//


import JJFloatingActionButton
import UIKit
import AVFoundation
import Stripe

struct CurrencyDenom {
    let amount: Int
    let value: String
    let currencyImage: String
}
class GoSprayViewController: UIViewController, UIViewControllerTransitioningDelegate, STPAddCardViewControllerDelegate {
    
    var window: UIWindow?
    let actionButton = JJFloatingActionButton()
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var giftAmountReceivedLbl: UILabel!
    @IBOutlet weak var giftBalanceLbl: UILabel!
    @IBOutlet weak var giftReceiverNameLbl: UILabel!
    
    let defaults = UserDefaults.standard
    var player: AVAudioPlayer!
    var currencydenom = [CurrencyDenom]()
    var availablePaymentData = [PaymentTypeData2]()
    var activeCurrencyDenom: Int = 0
    var index: Int = 0
    var currentIndex: Int = 0
    var goLeft: Bool = false
    var goRight: Bool = false
    var currencySymbol: String = "$"
    
    var eventId: Int64 = 0
    var eventName: String = ""
    var eventOwnerName: String = ""
    var eventOwnerProfileId: Int64 = 0
    var profileId: Int64 = 0
    
    var giftReceiverId: Int64 = 0
    var token: String = ""
    var giftAmountReceived: Int = 0
    var paymentClientToken: String = ""
    
    var sprayTotalLblAmt: UILabel?
    var displayNamelbl: UILabel?
    
    var gifterBalance: Int = 0
    var gifterTotalTransAmount: Int = 0
    var isAutoReplenishFlag: Bool = false
    var withdrawAmount: Int = 0
    var autoReplenishAmount: Int = 0
    var notificationAmount: Int =  0
    var paymentMethod: Int = 0
    var isContinueAutoReplenishSet: Bool = false
    var isContinueAutoReplenishPlusCurrencyDenomSet: Bool = false
    var sprayAmount = 0
    var sprayAmountSecondary: Int = 0
    var sprayAmountDuringAutoReplenish = 0
    var isOkToReplenish: Bool = false
    var isFlashLightFlag: Bool = true
    var completionAction: String = ""
    var paymentCustonName: String = "" //this is used when stripe payment is entered
   
    var receiverName: String = ""
    var currencyCode: String = ""
    var isPaymentMethodAvailable: Bool = false
    var isSingleReceiverEvent: Bool = false //2/13 this flag will be used to check if event is for band/street performer/waiter if sothe flag will == true
    var hasPaymentMethodEvent: Bool = false //hold for now 3/18
    var isRsvprequired: Bool = false
    //var isSingleReceiver: Bool = false
    var defaultEventPaymentMethod: Int = 0
    var defaultEventPaymentCustomName: String = ""
    
    var refreshscreendelegate: RefreshScreenDelegate?
    var haspaymentdelegate: HasPaymentMethodDelegate?
    var processspraytrandelegate: ProcessSprayTransDelegate?
    
    var setRefreshScreen: Bool = false
    //var isRefreshScreen: Bool = false
    var encryptedAPIKey: String = ""
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
    //typealias launchStripePaymentScreen = ()  -> Void
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.2, *) {
            print("i am here statusBarManager")
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.init(red: 155/250, green: 166/250, blue: 149/250, alpha: 1)
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            print("i am here - nope didn't work statusBarManager")
            //   var statusBarManager: UIView? {
            //      return value(forKey: "statusBarManager") as? UIView
            //    }
             UIApplication.shared.statusBarManager?.backgroundColor = UIColor.init(red: 155/250, green: 166/250, blue: 149/250, alpha: 1)
            
        }

        
        print("paymentClientToken aasfdsdf =  \(paymentClientToken)")
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationController?.navigationBar.barTintColor = UIColor.orange
//                self.navigationController?.navigationBar.tintColor = UIColor.orange
//
        
        getCurrencyData()
        initializationTask()
        getPrefData(profileId: profileId)
       
        
        
        giftReceiverNameLbl.text = receiverName
        
        print("spray amount on view did load \(sprayAmount)")
        print("gift balance lbl on view did load \(giftBalanceLbl.text)")
        currencyImage.isUserInteractionEnabled = true
        let swiftRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftRight.direction = UISwipeGestureRecognizer.Direction.right
        currencyImage.addGestureRecognizer(swiftRight)
        
        let swiftLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftLeft.direction = UISwipeGestureRecognizer.Direction.left
        currencyImage.addGestureRecognizer(swiftLeft)
        
        let swiftUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftUp.direction = UISwipeGestureRecognizer.Direction.up
        currencyImage.addGestureRecognizer(swiftUp)
        
        let swiftDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftDown.direction = UISwipeGestureRecognizer.Direction.down
        currencyImage.addGestureRecognizer(swiftDown)
        // Do any additional setup after loading the view.
        
        

//        actionButton.addItem(title: "item 1", image: UIImage(named: "First")?.withRenderingMode(.alwaysTemplate)) { item in
//          // do something
//            print("itme 1 was selected")
//            self.launchSprayCandidate()
//        }
//
//        actionButton.addItem(title: "item 2", image: UIImage(named: "Second")?.withRenderingMode(.alwaysTemplate)) { item in
//          // do something
//            print("itme 2 was selected")
//            //self.launchSprayCandidate()
//        }
//
       
        // last 4 lines can be replaced with
        // actionButton.display(inViewController: self)
        
        //getCurrencyData()
        //initializationTask()
//        getPrefData(profileId: profileId)
//
//
//
//        giftReceiverNameLbl.text = receiverName //this is a maybe
//
//        if isPaymentMethodAvailable == true || hasPaymentMethodEvent == true {
//            self.getAvailablePaymentData()
//        }
//
//        if completionAction == "gotostripe" {
//            print("COMPLETION ACTION = \(completionAction)")
//            //launchEventPaymentScreen(completionAction: "launchpaymentscreen")
//            circleMenu()
//            launchStripePaymentScreen()
//        } else if completionAction == "callspraycandidate" {
//            circleMenu()
//            launchSprayCandidate()
//        } else if isSingleReceiverEvent == true {
//            //circleMenu()
//            if isPaymentMethodAvailable == false && hasPaymentMethodEvent == false {
//
//                self.completionAlert(message: "Missing Payment Method. Please Add Payment Method to Continue With Spray! \n Please wait...", timer: 3, launchStripePaymentScreen: launchStripePaymentScreen)
//               // launchStripePaymentScreen()
//            }
//        } else if isSingleReceiverEvent == false {
//            if isPaymentMethodAvailable == false && hasPaymentMethodEvent == false  {
//                self.completionAlert(message: "Missing Payment Method. Please Add Payment Method to Continue With Spray! \n Please wait...", timer: 3, launchStripePaymentScreen: launchStripePaymentScreen)
//                //launchStripePaymentScreen()
//            } else {
//                launchSprayCandidate()
//                circleMenu()
//            }
//        }
       

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        if sprayAmountSecondary > 0 {
            updateSprayTransaction(sprayAmount: sprayAmountSecondary, completionAction: "")
            print("Action my GoSprayView is gone")
        } else {
            print("No Action my GoSprayView is gone")
        }
       
        AppUtility.lockOrientation(.all)
        if #available(iOS 13.2, *) {
            print("i am here statusBarManager")
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.init(red: 255/250, green: 255/250, blue: 255/250, alpha: 1)
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            print("i am here - nope didn't work statusBarManager")
            //   var statusBarManager: UIView? {
            //      return value(forKey: "statusBarManager") as? UIView
            //    }
             UIApplication.shared.statusBarManager?.backgroundColor = UIColor.init(red: 255/250, green: 255/250, blue: 255/250, alpha: 1)
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        if isPaymentMethodAvailable == true || hasPaymentMethodEvent == true {
            self.getAvailablePaymentData()
            print("completion AAA")
        }
        
        if completionAction == "gotostripe" {
            print("COMPLETION ACTION = \(completionAction)")
            //launchEventPaymentScreen(completionAction: "launchpaymentscreen")
            circleMenu()
            launchStripePaymentScreen()
            print("completion G")
//        } else if isSingleReceiverEvent == false {
//            circleMenu()
//            launchSprayCandidate()
//            print("completion F")
        } else if isSingleReceiverEvent == true {
            print("completion E")
            //circleMenu()
            if isPaymentMethodAvailable == false && hasPaymentMethodEvent == false {
           
//                self.completionAlert(message: "Missing Payment Method. Please Add Payment Method to Continue With Spray! \n Please wait...", timer: 3, launchStripePaymentScreen: launchStripePaymentScreen)
               launchStripePaymentScreen()
                print("completion D")
            }
        } else if isSingleReceiverEvent == false {
            print("completion C")
            if isPaymentMethodAvailable == false && hasPaymentMethodEvent == false  {
//                self.completionAlert(message: "Missing Payment Method. Please Add Payment Method to Continue With Spray! \n Please wait...", timer: 3, launchStripePaymentScreen: launchStripePaymentScreen)
                
                launchStripePaymentScreen()
                print("completion B")
            } else {
                print("completion A")
                launchSprayCandidate()
                circleMenu()
            }
        }
       
    }
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            debugPrint("Back Button pressed Home.")
            
            //print("isRefreshData from container screen \(isRefreshData)")
            //selectionDelegate.didTapChoice(name: "Dominic")
            refreshscreendelegate?.refreshScreen(isRefreshScreen: setRefreshScreen)
            processspraytrandelegate?.updateSprayTransaction(receiverProfileId: giftReceiverId, gifterProfileId: profileId, eventId: eventId, giftAmount: sprayAmountSecondary, hasPaymentMethod: true)
            //refreshscreendelegate?.refreshScreen(isRefreshScreen: isRefreshData)
            //sprayDelegate?.sprayEventSettingRefresh(isEventSettingRefresh: true)
         
        }
    }
    
    func circleMenu(){
        //actionButton.backgroundColor = UIColor(red: 155/256, green: 166/256, blue: 149/256, alpha: 1.0)
        actionButton.circleView.color = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0) //UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
            //hunter green - UIColor(red: 155/256, green: 166/256, blue: 149/256, alpha: 1.0)
        actionButton.addItem(title: "", image: UIImage(systemName: "person.2.fill")) { item in
            //print("itme 3 was selected")
            self.launchSprayCandidate()
        }
        
//        actionButton.buttonState.rawValue
//        print(actionButton.buttonState.rawValue)
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

    }
    func completionAlert(message: String, timer: Int, launchStripePaymentScreen:() -> Void) {
        let delay = Double(timer) //* Double(NSEC_PER_SEC)
      let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
      present(alert, animated: true, completion: nil)
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
       alert.dismiss(animated: true)
        
        //call payment after timer expires
        self.launchStripePaymentScreen()
      }
     }
    func launchStripePaymentScreen(){
        print("the value of COMPLETION ACTION = \(completionAction)")
        //launch stripe payment screen
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//
//        let navigationController = UINavigationController(rootViewController: addCardViewController)
//          present(navigationController, animated: true)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "SetupPaymentMethodViewController") as! SetupPaymentMethodViewController

       

        nextVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        nextVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext
    

        nextVC.eventId = self.eventId
        nextVC.profileId = self.profileId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.eventName = eventName
        nextVC.eventOwnerName = eventOwnerName
        nextVC.eventOwnerId = eventOwnerProfileId
//        nextVC.eventDateTime = eventDateTime
//        nextVC.eventTypeIcon = eventTypeIcon
//        nextVC.autoReplenishFlg = autoReplenishFlg
//        nextVC.autoReplenishAmt = autoReplenishAmt
        
        nextVC.refreshscreendelegate = self
        nextVC.haspaymentdelegate = self
        //nextVC.refreshscreendelegate = self
        nextVC.setuppaymentmethoddelegate = self
        nextVC.paymentClientToken = paymentClientToken
        nextVC.isSingleReceiverEvent = isSingleReceiverEvent
        
       // nextVC.currentAvailableCredit =  availableBalance
        self.present(nextVC, animated: true, completion: nil)
        
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetupPaymentMethodViewController") as! SetupPaymentMethodViewController
      
            
       // self.navigationController?.pushViewController(nextVC , animated: true)
        //}
    }
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
        print("AFTER STRIPE CANCEL - \(completionAction)")
        if completionAction == "launchpaymentscreen" {
            print("I was cancelled")
            launchEventPaymentScreen(completionAction: completionAction)
        }
        
    }
    //old addCardView remove late 4/1/2021
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
//        dismiss(animated: true)
//
//        //add payment info
//        addMyPayment(paymentMethodToken: paymentMethod.stripeId, customName: paymentMethod.label, paymentOptionType: 0, paymentDescription: paymentMethod.image.description, paymentExpiration: "")
//
//        paymentCustonName = paymentMethod.label
//        print("label \(paymentMethod.label)")
//        print("stripe Id \(paymentMethod.stripeId)")
//        print("image \(paymentMethod.image)")
//    }
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
//        addMyPayment(paymentMethodToken: paymentMethod.stripeId, customName: paymentMethod.label, paymentOptionType: 0, paymentDescription: paymentMethod.image.description, paymentExpiration: "08/17/2030")
//
        print("label \(paymentMethod.label)")
        print("stripe Id \(paymentMethod.stripeId)")
        print("image \(paymentMethod.image)")
        
        
        
        
        if paymentmethodCustNameExist(customName: paymentMethod.label) == false {
            addMyPayment(paymentMethodToken: paymentClientToken, customName: paymentMethod.label, paymentOptionType: 0, paymentDescription: paymentMethod.image.description, paymentExpiration: "08/17/2030")
            setRefreshScreen = true
            
        } else {
            //self.completionAlert(message: "Payment Method \(paymentMethod.label) Already Exist.  Available Credit and Continue.", timer: 3, completionAction: "completionAction")
            setRefreshScreen = true
            let paymentMethodId =  getPaymenthMethodId(customName: paymentMethod.label)
            let paymentDescription = paymentMethod.label
            
            self.addGeneralPaymentPref(paymentMethodId:paymentMethodId, paymentDescription: paymentDescription)
            haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId:Int(paymentMethodId))
            print("DUPLICATE PAYMENT METHOD")
            //giftAmountSegConrol.selectedSegmentIndex = 2
            //segmentedControl.selectedSegmentIndex = index
            //availableBalance = 15
            //currentBalance.text = "$" + String(self.availableBalance)
            
            //closeScreen()
            //currentBalance.text = "$" + String(updatedBalance)
            //btnSelectPayment.setTitle(paymentMethod.label, for: .normal)
           
        }
        
        
        
//        print("label \(paymentMethod.label)")
//        print("stripe Id \(paymentMethod.stripeId)")
//        print("image \(paymentMethod.image)")
    }
    
    func addMyPayment(paymentMethodToken
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        
       // self.launchSprayCandidate()
        
        let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: "08/17/2030", profileId: profileId)
        
        //hold 2/13 uncomment later
        let request = PostRequest(path: "/api/PaymentMethod/add", model: addPayment , token: token, apiKey: encryptedAPIKey, deviceId: "")
        

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let newpaymentdata):
                self.getAvailablePaymentData()
                let decoder = JSONDecoder()
                do {
                    let newPaymentJson: PaymentTypeData = try decoder.decode(PaymentTypeData.self, from: newpaymentdata)
                    self.addGeneralPaymentPref(paymentMethodId: newPaymentJson.paymentMethodId!, paymentDescription: customName)
                    haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(newPaymentJson.paymentMethodId!))
                    //for data in newPaymentJson {

                       
                    //}

               } catch {
                   print(error)
               }
                //newpayment.
                //break
                //this will return payment methodId...
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
//        Network.shared.send(request) { (result: Result<Data, Error>)  in
//            switch result {
//            case .success( _):
//                //after payment method is added call check available paymentdataload available payment data
//                self.getAvailablePaymentData()
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        launchHomeScreen()
        
//        let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//        nextVC.profileId = profileId
//        nextVC.token = token
//
//        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    func addGeneralPaymentPref(paymentMethodId: Int64, paymentDescription: String) {
        
        //self.launchSprayCandidate()
        self.paymentMethod = Int(paymentMethodId) //this paymentMethodId is use verify if a gifter has a payment method on file before spray transaction is added and preference is updated
        let updatedPaymentMethodId = paymentMethodId
        let updatedGiftAmount = 15
        let updatedAutoReplenishFlag = false
        let updatedAutoReplenishAmount: Int = 0
        let currencyCode = "usd"
        
        let addEventPreference = EventPreference(eventId: 0, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencyCode)
            
        //set.btnSelectPayment.setTitle(paymentDescription)
       
        
        print("ADD EVENT PREFERENCE 2 \(addEventPreference)")
//        updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
        //closeScreen()
        
        //hold 2/13 - for now...
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref);
                
                //let updatedBalance = gifterBalance + updatedGiftAmount
                
                //giftAmountSegConrol.selectedSegmentIndex = 2
                //segmentedControl.selectedSegmentIndex = index
                //giftBalanceLbl.text = currencySymbol + String(gifterBalance)
                let availableSprayAmount = self.sprayAmount + updatedGiftAmount
                //call launch spray candidate - in the future i will add logic here to
                //only launch if not street performer, waiter, or band
                gifterBalance = availableSprayAmount
                if self.isSingleReceiverEvent == false {
                    print("IS SINGELE RECEIVER EVENT = FALSE")
                    self.giftBalanceLbl.text = currencySymbol + String(availableSprayAmount) //String(updatedGiftAmount)
                    self.sprayAmount = availableSprayAmount  //updatedGiftAmount
                    self.receiverName = ""
                    self.launchSprayCandidate()
                } else {
                    //change the name to the real person when you get it 2/27
                    self.giftReceiverNameLbl.text = self.eventOwnerName
                    print("updatedGiftAmount \(availableSprayAmount)")
                    self.giftBalanceLbl.text = currencySymbol + String(availableSprayAmount)
                    self.sprayAmount = availableSprayAmount
                    self.receiverName = self.eventOwnerName
                    //self.launchSprayCandidate()
                }
                //clear completionAction value
                /* hod this haspaymentdelege for now 4/5 */
                //haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: event)
                completionAction = ""
                //currentBalance.text = "$" + String(self.availableBalance)
                
                //currentBalance.text = "$" + String(updatedBalance)
                //btnSelectPayment.setTitle(paymentDescription, for: .normal)
                
                //self.btnSelectPayment.setTitle(self.getPaymenthMethodName(paymentmethodid: eventPrefData.paymentMethodDetails.paymentMethodId), for: .normal)
                
                
                //self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish

               
                
                //call launch spray candidate - in the future i will add logic here to
                //only launch if not street performer, waiter, or band
//                if self.completionAction == "allreceiver" {
//
//                    self.giftBalanceLbl.text = String(updatedGiftAmount)
//                    self.sprayAmount = updatedGiftAmount
//                    self.receiverName = ""
//                    self.launchSprayCandidate()
//                } else {
//                    //change the name to the real person when you get it 2/27
//                    self.giftReceiverNameLbl.text = self.eventOwnerName
//                    print("updatedGiftAmount \(updatedGiftAmount)")
//                    self.giftBalanceLbl.text = String(updatedGiftAmount)
//                    self.sprayAmount = updatedGiftAmount
//                    self.receiverName = self.eventOwnerName
//                    //self.launchSprayCandidate()
//                }
                //hold for no2 3/27
                //self.callGoSpray()
                
                break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
    func addEventPrefPayment() {
        
        //self.launchSprayCandidate()
        
        let updatedPaymentMethodId = getPaymenthMethodId(customName: paymentCustonName)
        let updatedGiftAmount = 15
        let updatedAutoReplenishFlag = false
        let updatedAutoReplenishAmount: Int = 0
        
        let addEventPreference = EventPreference(eventId: eventId, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencyCode)

        print("ADD EVENT PREFERENCE \(addEventPreference)")
//        updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
        //closeScreen()
        
        //hold 2/13 - for now...
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref);

                //call launch spray candidate - in the future i will add logic here to
                //only launch if not street performer, waiter, or band
                if self.completionAction == "allreceiver" {
                    
                    self.giftBalanceLbl.text = currencySymbol + String(updatedGiftAmount)
                    self.sprayAmount = updatedGiftAmount
                    self.receiverName = ""
                    self.launchSprayCandidate()
                } else {
                    //change the name to the real person when you get it 2/27
                    self.giftReceiverNameLbl.text = self.eventOwnerName
                    print("updatedGiftAmount \(updatedGiftAmount)")
                    self.giftBalanceLbl.text = currencySymbol + String(updatedGiftAmount)
                    self.sprayAmount = updatedGiftAmount
                    self.receiverName = self.eventOwnerName
                    //self.launchSprayCandidate()
                }
                
                break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
   
    //check if name of paymentmethod exist
    func paymentmethodCustNameExist(customName: String) -> Bool {

        var hasCustomMethodName: Bool = false
        for i in availablePaymentData {
            if i.customName == customName {
                hasCustomMethodName = true
                break
            }
        }
        return  hasCustomMethodName
    }
    
    //get paymentMethodId for payment description selected
    func getPaymenthMethodId(customName: String) -> Int64 {
        var thePaymentMethodId: Int64 = 0
        for i in availablePaymentData {
            if i.customName == customName {
                thePaymentMethodId = i.paymentMethodId!
                break
            }
        }
        return thePaymentMethodId
    }
    
    func getAvailablePaymentData() {
        
        //clean up
        availablePaymentData.removeAll()
        let request = Request(path: "/api/PaymentMethod/all/\(profileId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
        switch result {
           case .success(let paymentmethod1):
               //self.parse(json: event)
             let decoder = JSONDecoder()
             do {
                let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                for paymenttypedata in paymentJson {
                    if paymenttypedata.customName != "" {
                        let adddata = PaymentTypeData2(paymentMethodId: paymenttypedata.paymentMethodId!,
                        profileId: paymenttypedata.profileId,paymentType: paymenttypedata.paymentType,
                         customName: paymenttypedata.customName,paymentDescription: paymenttypedata.paymentDescription,paymentExpiration: paymenttypedata.paymentExpiration,defaultPaymentMethod: paymenttypedata.defaultPaymentMethod,paymentImage: paymenttypedata.paymentDescription)
                        self.availablePaymentData.append(adddata)
                        
                        //display the default payment on the dropdown list
//                        if paymenttypedata.defaultPaymentMethod == true {
//                            self.btnSelectPayment.setTitle(paymenttypedata.customName, for: .normal)
//                        }
//
                        
                        print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
                        print("customName = \(paymenttypedata.customName!)")
                        print("paymenttype = \(paymenttypedata.paymentType!)")
                        
                        print("paymenttypedata.paymentType! = \(paymenttypedata.paymentType!)")
                        print("paymenttypedata.paymentMethodId = \(paymenttypedata.paymentMethodId!)")
                        print("paymenttypedata.defaultPaymentMethod = \(paymenttypedata.defaultPaymentMethod!)")
                    }
                    
                }
             } catch {
                print(error)
             }
            
            //now that we have available payment option - at least 1 - we will add withrawal amount and payment method for the event
            //self.addEventPrefPayment() hold on to this for now... 4/1/2021 - we don't need it
            case .failure(let error):
               print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
           }
       }
    }
    
    func launchSprayCandidate() {
        print("I AM INSIDE LAUNCH SPRAY CANDIDATE")
//      print
//        print("launch spry candidate was called")
//        let viewController = ChildViewController()
//               present(viewController, animated: true, completion: nil)
//        var storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var pvc = storyboard.instantiateViewController(withIdentifier: "CustomTableViewController") as! UITableViewController
//
//        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
//               pvc.transitioningDelegate = self
//        pvc.view.backgroundColor = UIColor.red
//
//        self.present(pvc, animated: true, completion: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectPersonToSpray") as! SelectPersonToSprayViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.eventId = eventId
        vc.profileId = profileId
        vc.eventOwnerProfileId = eventOwnerProfileId
        vc.token = token
        vc.encryptedAPIKey = encryptedAPIKey
        vc.receiverInfoDelegate = self
        present(vc, animated: true, completion: nil)
    }

//    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
//        }
 
    func getCurrencyData() {
        currencydenom.removeAll()
        let currencyData1 = CurrencyDenom(amount: 1, value: "$1.00", currencyImage: "currencySide1B")
        currencydenom.append(currencyData1)
        
        let currencyData2 = CurrencyDenom(amount: 5, value: "$5.00", currencyImage: "5dollarSide1")
        currencydenom.append(currencyData2)
        
        let currencyData3 = CurrencyDenom(amount: 10, value: "$10.00", currencyImage: "10dollarSide1")
        currencydenom.append(currencyData3)
        
        let currencyData4 = CurrencyDenom(amount: 20, value: "$20.00", currencyImage: "20dollarSide1")
        currencydenom.append(currencyData4)
        
        let currencyData5 = CurrencyDenom(amount: 50, value: "$50.00", currencyImage: "50dollarSide1")
        currencydenom.append(currencyData5)
        
        let currencyData6 = CurrencyDenom(amount: 100, value: "$100.00", currencyImage: "100dollarSide1")
        currencydenom.append(currencyData6)
    }
    
    func theRightSwipe(myindex: Int){
        var i: Int = 0
        if index >= 0 {
            //var i: Int = 0
            //indicate when we transition
            if goLeft == true {
                i = index + 1
                index = i
                if i > currencydenom.count - 1 || i == currencydenom.count - 1 {
                    if i > currencydenom.count - 1 {
                        i = 0
                        index = i
                    } else {
                        i = index
                        index = i
                    }

                    print("JJ \(i)")
                }
                print("AA \(i)")
                goLeft = false
            } else  {
                print("index R = \(index)")
                i = index
                index = i
                if i > currencydenom.count - 1 || i == currencydenom.count - 1  {
                    if i > currencydenom.count - 1 {
                        i = 0
                        index = i
                    } else {
                        i = index
                        index = i
                    }
                    
                    print("KK \(i)")
                }
                print("BB \(i)")
            }
            print("value of index in Right \(index)")
            print("second value of index in Right \(i)")
            //displayResult.text = currencydenom[i].value
            currentIndex = i
            currencyImage.image = UIImage(named: currencydenom[i].currencyImage)
            UIView.transition(with: self.currencyImage,
             duration: 0.5,
             options: .transitionCrossDissolve,
             animations: { [self] in
                self.currencyImage.image = UIImage(imageLiteralResourceName: self.currencydenom[i].currencyImage)
                   }, completion: nil)
            i = index + 1
            index = i
            print("INDEX AT THE END \(index)")
            goRight = true
        } else {
            index = currencydenom.count - 1
            print("zero i\(index)")
            print("CC \(index)")
        }

    }
  
    
    func theLeftSwipe(myindex: Int){
        var i: Int = 0
        if index >= 0 {
            //var i: Int = 0
            //indicate when we transition
            if goRight == true {
                i = index - 2
                index = i
                if i < 0 || i == 0 {
                    if i == 0 {
                        i = 0
                        index = i
                    } else {
                        index = currencydenom.count - 1
                        i = currencydenom.count - 1
                    }
                    print("J \(i)")
                }
                print("A \(i)")
                goRight = false
            } else  {
                i = index - 1
                index = i
                if i < 0 || i == 0 {
                    if i == 0 {
                        i = 0
                        index = i
                    } else {
                        index = currencydenom.count - 1
                        i = currencydenom.count - 1
                    }
                    
                    print("K \(i)")
                }
                print("B \(i)")
            }
            print("value of index in Left \(index)")
            print("second value of index in Left \(i)")
            currentIndex = i
            currencyImage.image = UIImage(named: currencydenom[i].currencyImage)
            UIView.transition(with: self.currencyImage,
             duration: 0.5,
             options: .transitionCrossDissolve,
             animations: { [self] in
                self.currencyImage.image = UIImage(imageLiteralResourceName: self.currencydenom[i].currencyImage)
                   }, completion: nil)
            
            
            
            goLeft = true
        } else {
            index = currencydenom.count - 1
            print("zero i\(index)")
            print("C \(index)")
        }
    }
    
    func initializationTask() {
        //initialize
        isContinueAutoReplenishSet = defaults.bool(forKey: "isContinueAutoReplenish")
        isContinueAutoReplenishPlusCurrencyDenomSet = defaults.bool(forKey: "isContinueAutoReplenishPlusCurrencyDenomSet")
        //sprayCurrencyImage.image = UIImage(named: currencyImageSide1)
        sprayAmount = 0
        sprayAmountSecondary = 0
        sprayAmountDuringAutoReplenish = 0
        //giftAmountReceived.text = String("$\(sprayAmount)")
        
        //default currency image
        currencyImage.image = UIImage(named: currencydenom[index].currencyImage)
        currentIndex = index
        index = index + 1
        print("INDEX AT THE END \(index)")
        goRight = true
        
        giftBalanceLbl.text = currencySymbol + String(gifterBalance)
        giftAmountReceivedLbl.text = currencySymbol + "0"
        getGifterTotalTransBalance()
        
        //updateSprayInfoOnNavbarTitle()
        //navBarData(data: "$\(sprayAmount)", type:"sprayamount")
        //navBarData(data: "$\(gifterBalance)", type:"balance")
        //navBarData()
//        updateSprayTotalLblAmt(data: "")
//        updateMyBalanceLblAmt(data: "")
    }
    
    func getGifterTotalTransBalance()   {
        //var theGifterTotalTransBalance: Int = 0
        let request = Request(path: "/api/Event/transactiontotal/\(profileId)/\(eventId)", token: token, apiKey: encryptedAPIKey)
               
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
                        print("E")
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
    
    //I don't need this right now - may come back to this later
    //already getting spray amount from homeviewcontroller
    func getPrefData(profileId: Int64)  {
        let request = Request(path: "/api/Event/prefs/\(profileId)/0", token: token, apiKey: encryptedAPIKey)
        
        print("request \(request)")
        Network.shared.send(request) { (result: Result<Data, Error>)   in
            switch result {
                case .success(let eventPreferenceData):
                    print("I am here 1")
                    let decoder = JSONDecoder()
                    do {
                        let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                       
                       
                        
                        for eventPrefData in eventPreferenceJson {
                           // if eventPrefData.profileId == self.profileId {
                            print("checkIfGeneralPaymentMethod")
                            
                            print("self.balance = \(self.gifterBalance)  before balance value is set")
                            self.gifterBalance =  eventPrefData.maxSprayAmount
                            self.giftBalanceLbl.text = self.currencySymbol + String(self.gifterBalance)
                            print("Balance is from self.balance = eventPrefData.maxSprayAmount = \(self.gifterBalance)")
                                

                            self.withdrawAmount = eventPrefData.maxSprayAmount
                            self.isAutoReplenishFlag = eventPrefData.isAutoReplenish
                            self.autoReplenishAmount = eventPrefData.replenishAmount
                            self.notificationAmount = eventPrefData.notificationAmount
                            self.paymentMethod = eventPrefData.paymentMethod
                                
                           // }
                        }
        
                   

                    } catch {
                        print(error)
                    }

                case .failure(let error):
                print(" DOMINIC IGHEDOSA 1 ERROR \(error.localizedDescription)")
            }
        }
    }
    
    func getEventPref3() {
            //var eventprefdate:  [EventPreferenceData] = [] //paymentmethod1
        //removeevntId
            let request = Request(path: "/api/Event/prefs/\(profileId)/0", token: token, apiKey: encryptedAPIKey)
            
        Network.shared.send(request) { [self] (result: Result<Data, Error>)   in
                switch result {
                    case .success(let eventPreferenceData):
                        print("A")
                        let decoder = JSONDecoder()
                        do {
                            let eventPreferenceJson: [EventPreferenceData2] = try decoder.decode([EventPreferenceData2].self, from: eventPreferenceData)
                            
                            /*if no data, check if general payment method assigned to profile exist
                            i dont think ineed the  eventPreferenceJson.count  check because i'm addressing this in the homeviewcontroller
                             hold for now 3/18
                             */
                            if eventPreferenceJson.count ==  0  {
                                print("check if general paymentthod exis ")
                                getPrefData(profileId: profileId)
                            } else {
                                for eventPrefData in eventPreferenceJson {
                                    //not sure if i need this... may have to remove laterself.balance = 3/3
                                    //if eventPrefData.eventId == self.eventId && eventPrefData.profileId == self.profileId {
  
                                        print("self.balance = \(self.gifterBalance)  before balance value is set")
                                        self.gifterBalance =  eventPrefData.maxSprayAmount
                                        self.giftBalanceLbl.text = self.currencySymbol + String(self.gifterBalance)
                                        print("Balance is from self.balance = eventPrefData.maxSprayAmount = \(self.gifterBalance)")

                                        self.withdrawAmount = eventPrefData.maxSprayAmount
                                        self.isAutoReplenishFlag = eventPrefData.isAutoReplenish
                                        self.autoReplenishAmount = eventPrefData.replenishAmount
                                        self.notificationAmount = eventPrefData.notificationAmount
                                        self.paymentMethod = eventPrefData.paymentMethod
                                        isPaymentMethodAvailable = true //if i have a record then i must have a paymentmethod
                                
                                        
                                   // }
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
    
    func launchEventPaymentScreen(completionAction:String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EventPayment2ViewController") as! EventPayment2ViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.eventId = eventId
        vc.profileId = profileId
        vc.token = token
        vc.encryptedAPIKey = encryptedAPIKey
        vc.updategfitamountdelegate = self
        vc.completionAction = "launchpaymentscreen"
        vc.haspaymentdelegate = self
        //vc.receiverInfoDelegate = self
        vc.paymentClientToken = paymentClientToken
        present(vc, animated: true, completion: nil)
    }
   
    func updateEventPreference(paymentMethodId: Int, updatedWithdrawAmount: Int, completionAction: String) {
        print("Update preference")
        //let newWithdrawAmount = withdrawAmount + autoReplenishAmount!
        let addEventPreference = EventPreference(eventId: 0, profileId: profileId, paymentMethod: paymentMethodId, maxSprayAmount: updatedWithdrawAmount, replenishAmount: autoReplenishAmount, notificationAmount:  notificationAmount, isAutoReplenish: isAutoReplenishFlag, currency: currencyCode)

        print("Add  \(addEventPreference)")
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref);
                haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: paymentMethodId)
                if completionAction == "callhome" {
                    self.launchHomeScreen()
                    self.sprayAmount = 0
                    self.sprayAmountSecondary = 0
                } else if completionAction == "addfunds" {
                    self.launchEventPaymentScreen(completionAction: "")
                    self.sprayAmountSecondary = 0
                } else if completionAction == "" {
                    self.sprayAmountSecondary = 0
                }
                break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
    
    func updateSprayTransaction(sprayAmount: Int, completionAction: String) {
        print("UPDATE SPRAY TRANSACTION")
        //only log spray transaction if there is a spray amount
        //greater than 0 and there is a payment method
        //if sprayAmount > 0 && self.paymentMethod! > 0 { -- i don't need this again
        //a paymentmethod must be on file before a person can spray
        if sprayAmount > 0 && self.paymentMethod > 0 {
            let AddSprayTrans = SprayTransactionModel(eventId: eventId, senderId: profileId, recipientId:giftReceiverId, amount: sprayAmountSecondary, success: true, errorCode: "", errorMessage: "")
            
            print("AddSprayTrans \(AddSprayTrans)")
            let request = PostRequest(path: "/api/SprayTransaction/add", model: AddSprayTrans , token: token, apiKey: encryptedAPIKey, deviceId: "")

            Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
                switch result {
                case .success( _):
                    haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: self.paymentMethod)
                    self.updateEventPreference(paymentMethodId: self.paymentMethod, updatedWithdrawAmount: self.gifterBalance, completionAction: completionAction)
                    //call these functions after spray transaction is complete
                    //these func will get updated balance
                    
                   // getGifterData()
                    logAlert(messageType: "sender")
                    logAlert(messageType: "receiver")
                    
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            if completionAction == "addfunds" {
                self.launchEventPaymentScreen(completionAction: "")
                //call launch add funds screen
            } else if completionAction == "callhome" {
                launchHomeScreen()
            }
        }
        
        func logAlert(messageType: String) {
            print("log alert was called")
            var alertText: String = ""
            // get the current date and time
            let currentDateTime = Date()

            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long

            // get the date time String from the date object
            formatter.string(from: currentDateTime)
            
            var myprofileid: Int64 = 0
            if messageType == "receiver" {
                alertText = "You were sprayed $\(sprayAmountSecondary) on \(formatter.string(from: currentDateTime))"
                myprofileid = giftReceiverId
            } else if messageType == "sender" {
                alertText = "You sprayed \(giftReceiverNameLbl.text!)  $\(sprayAmountSecondary) on \(formatter.string(from: currentDateTime))"
                myprofileid = profileId
            }
           
            
            let alertt = AlertModel(alertType: 1, alertText: alertText, alertName: "SprayTrans", entityLink: 0, isViewed: false, isActive: true, profileId: myprofileid)
            
//            SprayTransactionModel(eventId: eventId, senderId: profileId, recipientId:giftReceiverId, amount: sprayAmountSecondary, success: true, errorCode: "", errorMessage: "")
            
            //print("AddSprayTrans \(AddSprayTrans)")
            let request = PostRequest(path: "/api/Alert/add", model: alertt, token: token, apiKey: encryptedAPIKey, deviceId: "")

            Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
                switch result {
                case .success( _):
                   
                  
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        //don't do this yet
//        if completionAction == "addfunds" {
//            self.launchEventPaymentScreen(completionAction: "")
//            //call launch add funds screen
//        } else if completionAction == "callhome" {
//            launchHomeScreen()
//        }
        
       
    }
    func launchHomeScreen() {
        
        //defaults.set(true, forKey: "isEditEventSettingRefreshSprayVC")
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //nextVC.selectionDelegate = self
       
        
        
       // defaults.set(true, forKey: "isEditEventSettingRefresh")
        
        
//
       // nextVC.eventName = eventName
       // nextVC.eventDateTime = eventDateTime
       // nextVC.eventCode = eventCode
        //nextVC.eventId = eventId
       
       // nextVC.paymentClientToken  =  paymentClientToken
        //nextVC.ownerId = 31
//
        //nextVC.isAttendingEventId = 1 //1 is a default value to indicate that RSVP is true
       // nextVC.screenIdentifier = "Spray"
//
        //nextVC.eventTypeIcon = eventTypeIcon
//
      
        //refreshscreendelegate?.refreshScreen(isRefreshScreen: true)
        
//        if((self.presentingViewController) != nil){
//            self.dismiss(animated: false, completion: nil)
//            
//          }
        
       //self.navigationController?.pushViewController(nextVC , animated: true)
        let mainStoryBoard: UIStoryboard = UIStoryboard(name:
            "Main", bundle: nil)
        let nextVC: HomeViewController =  mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController" ) as! HomeViewController
        //innerPage.lbldesc = "We made its"
        nextVC.profileId = profileId
        //nextVC.ownerId = ownerId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        //nextVC.refreshscreendelegate = self
        //nextVC.refreshscreendelegate = self
        self.window?.rootViewController = nextVC
        self.window?.makeKeyAndVisible()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func displayOutOfFundsAlert(){
        let alert = UIAlertController(title: "Out of funds!", message: "You are currently out of funds. To add more funds select Add More Funds. ", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Add More Funds", style: .default, handler: { [self] (action) in self.updateSprayTransaction(sprayAmount: sprayAmountSecondary, completionAction: "addfunds")}))
        alert.addAction(UIAlertAction(title: "I Am Done", style: .default, handler: { [self] (action) in self.updateSprayTransaction(sprayAmount: sprayAmountSecondary, completionAction: "callhome")}))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        print("Balance is Zero")
        print("gifter balance = \(gifterBalance)")
    }
    func displayAutoReplenishAlert() {
        let alert = UIAlertController(title: "Auto Replenish!", message: "Your available credit is low but you have Auto Replenish enabled. Would you like to continue with Auto Replenish? NOTE: If you select Yes, we will automatially increase balance by $\(autoReplenishAmount) each time you run out of funds.", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Yes, Keep It Going", style: .default, handler: { (action) in self.setAutoReplenishAction(action: "autoreplenish")}))
        alert.addAction(UIAlertAction(title: "No, I Am Done", style: .default, handler: { (action) in self.launchHomeScreen()}))
        
        self.present(alert, animated: true)
    }
    
    func displayAutoReplenishAlertHighCurrencyDenom() {
        let alert = UIAlertController(title: "Auto Replenish!", message: "Your available credit is low but you have Auto Replenish enabled. In addition, your currency denomination is greater than your available credit. Would you like to increase your available credit to match the currency denomination plus your Auto Replenish amount?  NOTE: If you select Yes, we will automatially increase your balance by $\(autoReplenishAmount) plus the currency denomination $\(activeCurrencyDenom).", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Yes, Keep It Going", style: .default, handler: { (action) in self.setAutoReplenishAction(action: "currenydenom")}))
        alert.addAction(UIAlertAction(title: "No, I Am Done", style: .default, handler: { (action) in self.launchHomeScreen()}))
        
        self.present(alert, animated: true)
    }
    
    func displayNoReceiverNameAlert() {
        let alert = UIAlertController(title: "Missing Recipient Name", message: "Please select a recipient name to continue.", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "OK, Select Recipient", style: .default, handler: { (action) in self.launchSprayCandidate()}))
       alert.addAction(UIAlertAction(title: "Return Home", style: .default, handler: { (action) in self.launchHomeScreen()}))
        
        self.present(alert, animated: true)
    }
    
    
    func setAutoReplenishAction(action: String) {
        
        /*reset currency image after agreeing to auto replenish or adding more funds */
        if action == "currenydenom" {
            //increase gifterBalance
            gifterBalance = gifterBalance + autoReplenishAmount + activeCurrencyDenom
            
            defaults.set(true, forKey: "isContinueAutoReplenishPlusCurrencyDenomSet")
            isContinueAutoReplenishPlusCurrencyDenomSet = defaults.bool(forKey: "isContinueAutoReplenishPlusCurrencyDenomSet")
        } else if action == "autoreplenish" {
            
            //increase gifterBalance
            gifterBalance = gifterBalance + autoReplenishAmount
            
            defaults.set(true, forKey: "isContinueAutoReplenish") //whenauto replish is enabled while using app
            isOkToReplenish = defaults.bool(forKey: "isContinueAutoReplenish")
            isContinueAutoReplenishSet = defaults.bool(forKey: "isContinueAutoReplenish")
        }
        
        giftBalanceLbl.text = currencySymbol + String(gifterBalance)
        //gifterStartingBalance.text =  String("$\(gifterBalance)")
        //navBarData(data: "$\(gifterBalance)", type: "balance")
        //updateMyBalanceLblAmt(data: "$\(gifterBalance)")
        //updateSprayInfoOnNavbarTitle()
        //update gift preference amount
        
        //getLatestWithdrawalAmount()
        
        //let defaults = UserDefaults.standard
        //getGifterTotalTransBalance() //we don't need this
   
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
    func playSound() {
        let url = Bundle.main.url(forResource: "cashRegisterSound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
         
    @objc func swipeGesture(sendr: UISwipeGestureRecognizer) {
        if let swipeGesture = sendr as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
          
                case UISwipeGestureRecognizer.Direction.up:
                    print("test")
                    
                    activeCurrencyDenom = currencydenom[currentIndex].amount
                    print("activeCurrencyDenom =\(activeCurrencyDenom)")
                    print("giftBalance =\(gifterBalance)")
                    
                    print("eventId =\(eventId)")
                   // print("paymentMethodId =\(paymentMethod!)")
                    if completionAction == "gotostripe" {
                        //launchEventPaymentScreen(completionAction: "launchpaymentscreen")
                        circleMenu()
                        let alert2 = UIAlertController(title: "Need Payment Method", message: "You currently do not have a Payment Method selected for this Event. A Payment Metheod is required to participate in the fun of Spraying. Would you like to add a Payment Method?", preferredStyle: .alert)


                        alert2.addAction(UIAlertAction(title: "Yes, Let's Do It", style: .default, handler: { [self] (action) in self.launchStripePaymentScreen()}))
                        
                    
                        alert2.addAction(UIAlertAction(title: "No, Not Yet", style: .cancel, handler: nil))
                        
                        self.present(alert2, animated: true)
                        
                    } else if isSingleReceiverEvent == false && receiverName == "" {
                        displayNoReceiverNameAlert()
                        print("Must select name of gift receiver")
                    } else if activeCurrencyDenom > gifterBalance && gifterBalance > 0 {
                        //if gifterBalance > 0  {
//                            if isAutoReplenishFlag == true {
//                                if isContinueAutoReplenishPlusCurrencyDenomSet == true {
//                                    gifterBalance = gifterBalance +  autoReplenishAmount + activeCurrencyDenom
//                                } else  {
//                                    displayAutoReplenishAlertHighCurrencyDenom()
//                                }
//                            } else {
                                let alert2 = UIAlertController(title: "Insufficient Credit", message: "You do not have a enough credit to perform this spray swipe. Would you like to add more credit to continue to fun of spraying?", preferredStyle: .alert)

                                //update transaction.
                                alert2.addAction(UIAlertAction(title: "Yes, Add More Credits", style: .default, handler: { [self] (action) in self.updateSprayTransaction(sprayAmount: sprayAmountSecondary, completionAction: ""); self.launchEventPaymentScreen(completionAction:"")}))
                                
                            
                                alert2.addAction(UIAlertAction(title: "No, Not Now", style: .cancel, handler: nil))
                                
                                self.present(alert2, animated: true)
                           // }
                        //} else  {
                            
                        //}
                        
                        
                    } else {
                        print("gifterBalance \(gifterBalance)")
                        if gifterBalance < activeCurrencyDenom {
                            //
                            print("AA")
                            if isAutoReplenishFlag == true {
                                print("BB")
                                //check if auto replenish = true is stored in user defaults... if so continue to increment by the autoreplenish amount
                                if isContinueAutoReplenishSet == true {
                                        //automatically increment by replenis amount
                                    print("CC")
                                    //increase gifterBalance
                                    gifterBalance = gifterBalance +  autoReplenishAmount
                                    giftBalanceLbl.text = currencySymbol + String(gifterBalance)
                                    
                                    UIView.transition(with: self.currencyImage,
                                     duration: 0.5,
                                     options: .transitionCurlUp,
                                     animations: { [self] in
                                        self.currencyImage.image = UIImage(imageLiteralResourceName: self.currencydenom[currentIndex].currencyImage)
                                           }, completion: nil)
                                    
                                    playSound()
                                    toggleTorch(on: isFlashLightFlag)
                                    setRefreshScreen = true
                                    if isFlashLightFlag == true {
                                        isFlashLightFlag = false
                                    } else if isFlashLightFlag == false {
                                        isFlashLightFlag = true
                                    }
                                    
                                    //use this point to update transaction
                                    updateSprayTransaction(sprayAmount: sprayAmountSecondary, completionAction: "")
                                } else {
                                    //set the user default value
                                    //increment balance by auto replenisn amount
                                    print("DD")
                                    displayAutoReplenishAlert()
                                }
                                
                            } else  {
                                //let user know that they are out of funds
                                //provide option to exit or go to eventpayment2 to increase their funds
                                displayOutOfFundsAlert()
                                print("EE")
                            }
                        } else {
                            giftAmountReceived = giftAmountReceived + activeCurrencyDenom
                            giftAmountReceivedLbl.text = currencySymbol + String(giftAmountReceived)
                            print(giftAmountReceived)
                           
                            sprayAmount = sprayAmount + activeCurrencyDenom
                            sprayAmountSecondary = sprayAmountSecondary + activeCurrencyDenom
                            
                            let newbalance = gifterBalance - activeCurrencyDenom
                            giftBalanceLbl.text = currencySymbol + String(newbalance)
                            
                            gifterBalance = newbalance
                            
                            UIView.transition(with: self.currencyImage,
                             duration: 0.3,
                             options: .transitionCurlUp,
                             animations: { [self] in
                                self.currencyImage.image = UIImage(imageLiteralResourceName: self.currencydenom[currentIndex].currencyImage)
                                   }, completion: nil)
                            
                            playSound()
                            toggleTorch(on: isFlashLightFlag)
                            if isFlashLightFlag == true {
                                isFlashLightFlag = false
                            } else if isFlashLightFlag == false {
                                isFlashLightFlag = true
                            }
                            setRefreshScreen = true
                            print("FF")
                        }
                    print("my currency \(currencydenom[currentIndex].amount)")
        
                    }
                case UISwipeGestureRecognizer.Direction.left:
                    theLeftSwipe(myindex: index)
                   
                case UISwipeGestureRecognizer.Direction.right:
                    theRightSwipe(myindex: index)
                    
                   
                default:
                break
                }
            }
    }
    
  
    func navBarData() {
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: 170, y: -20, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            let firstFrame2 = CGRect(x: 267, y: -20, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            
//            let secondFrame = CGRect(x: navigationBar.frame.width/2 - 14, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
//            let secondFrame2 = CGRect(x: 269, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            

            displayNamelbl = UILabel(frame: firstFrame)
            displayNamelbl!.text = ""
            displayNamelbl!.font  = UIFont(name:"HelveticaNeue", size: 12.0)
            displayNamelbl!.textColor = UIColor.white

            
            sprayTotalLblAmt = UILabel(frame: firstFrame2)
            sprayTotalLblAmt!.text = "0"
            sprayTotalLblAmt!.font  = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
            sprayTotalLblAmt!.textColor = UIColor.white
//
//            let myBalanceLbl = UILabel(frame: secondFrame)
//            myBalanceLbl.text = "My Balance:"
//            myBalanceLbl.font  = UIFont(name:"HelveticaNeue", size: 12.0)
//            myBalanceLbl.textColor = UIColor.white
//
//
//            myBalanceLblAmt = UILabel(frame: secondFrame2)
//            myBalanceLblAmt!.text = "000"
//            myBalanceLblAmt!.font  = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
//            myBalanceLblAmt!.textColor = UIColor.white
//
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

            navigationBar.addSubview(displayNamelbl!)
            navigationBar.addSubview(sprayTotalLblAmt!)
//            navigationBar.addSubview(myBalanceLbl)
//            navigationBar.addSubview(myBalanceLblAmt!)
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

    
}
protocol ModalPresentationControllerDelegate: class {
    func updateFrameOfPresentedViewInContainerView(frame: CGRect) -> CGRect
}
// MARK: ChildViewController

class ChildViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
        view.backgroundColor = .lightGray
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
}

extension ChildViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(delegate: self, presentedViewController: presented, presenting: presenting)
    }
}

extension ChildViewController: ModalPresentationControllerDelegate {
    func updateFrameOfPresentedViewInContainerView(frame: CGRect) -> CGRect {
        CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height/2)
    }
}

class ModalPresentationController: UIPresentationController {
    private weak var modalPresentationDelegate: ModalPresentationControllerDelegate!

    convenience
    init(delegate: ModalPresentationControllerDelegate,
         presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?) {
        self.init(presentedViewController: presentedViewController,
                  presenting: presentingViewController)
        self.modalPresentationDelegate = delegate
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        get { modalPresentationDelegate.updateFrameOfPresentedViewInContainerView(frame: super.frameOfPresentedViewInContainerView) }
    }
}
//class HalfSizePresentationController : UIPresentationController {
//    func frameOfPresentedViewInContainerView() -> CGRect {
//        return CGRect(x: 0, y: containerView!.bounds.height/2, width: containerView!.bounds.width, height: containerView!.bounds.height/2)
//    }
//}


extension GoSprayViewController:   UpdatedGiftAmountDelegate  {
    func sendLatestGiftAmount(latestGiftAmount: Int, latestIsAutoReplenishFlag: Bool, latestAutoReplenishAmount: Int) {
        print("sendLatestGiftAmount I am here")
        gifterBalance = latestGiftAmount
        giftBalanceLbl.text = currencySymbol + String(gifterBalance)
        isAutoReplenishFlag = latestIsAutoReplenishFlag
        autoReplenishAmount = latestAutoReplenishAmount
    }
    
   
//    func sendReceiverInfo(receiverProfileId: Int64, receivername: String, eventId: Int64, profileId: Int64) {
//        print("my name is \(receivername)")
//        giftAmountReceived = 0
//        //self.displayNamelbl?.text = "Now Spraying, " + receivername
//        //self.sprayTotalLblAmt?.text = " -- $0.00"
//        self.navigationItem.title = "Now Spraying, " + receivername
//    }
}


extension GoSprayViewController:   SprayReceiverDelegate  {
    func sendReceiverInfo(receiverProfileId: Int64, receivername: String, eventId: Int64, profileId: Int64) {
        print("my name is \(receivername)")
        giftAmountReceived = 0
        giftReceiverId = receiverProfileId
        //self.displayNamelbl?.text = "Now Spraying, " + receivername
        //self.sprayTotalLblAmt?.text = " -- $0.00"
        giftReceiverNameLbl.text = receivername
        receiverName = receivername
        giftAmountReceivedLbl.text = "$" + String(giftAmountReceived)
        //self.navigationItem.title = "Now Spraying, " + receivername
    }
}


extension GoSprayViewController:  HasPaymentMethodDelegate {
    func hasPaymentMethod(hasPaymentMethod: Bool, paymentMethodId: Int) {
        isPaymentMethodAvailable = hasPaymentMethod
        print("HasPaymentMethodDelegate was called isPaymentMethodAvailable = \(isPaymentMethodAvailable)")
        if paymentMethodId > 0 {
            paymentMethod = paymentMethodId
        }
    }
}

extension GoSprayViewController: JJFloatingActionButtonDelegate {
  
        func floatingActionButtonWillOpen(_ button: JJFloatingActionButton) {
            
        }
        func floatingActionButtonDidOpen(_ button: JJFloatingActionButton) {
            print("floatingActionButtonDidOpen")
        }
        func floatingActionButtonWillClose(_ button: JJFloatingActionButton) {
            
        }
        func floatingActionButtonDidClose(_ button: JJFloatingActionButton) {
            
        }
}

extension UIApplication {

   var statusBarManager: UIView? {
      return value(forKey: "statusBarManager") as? UIView
    }

}

extension GoSprayViewController:  RefreshScreenDelegate {
    func refreshScreen(isRefreshScreen: Bool) {
       
        self.setRefreshScreen = isRefreshScreen
        print("refreshData Blabablabalba  function was called = \(self.setRefreshScreen)")
        print(self.setRefreshScreen)
        //print("refreshHomeScreenDate = \(isShowScreen)")
        if self.setRefreshScreen == true {
            
            getGifterTotalTransBalance()
            //initializationTask()
            
            print("I REFERESHED THE SCREEN")
            //customeFieldStyling()
//            getAvailablePaymentData()
//            //eventNameLabel.text = eventName + "\n \(eventDateTime)"
//            //loadSprayAmountOptions()
//            // Do any additional setup after loading the view.
//            getEventPref()
//            updateEventInfo()
        }
    }


}

extension GoSprayViewController:  SetupPaymentMethodDelegate {
    func passData(eventId: Int64, profileId: Int64, token: String, ApiKey: String, eventName: String, eventDateTime: String, eventTypeIcon: String, paymentClientToken: String, isSingleReceiverEvent: Bool, eventOwnerName: String, eventOwnerId: Int64) {
        self.eventId = eventId
        self.profileId = profileId
        self.eventName = eventName
        //self.eventDateTime = eventDateTime
        //self.eventTypeIcon = eventTypeIcon
        self.paymentClientToken = paymentClientToken
        self.isSingleReceiverEvent = isSingleReceiverEvent
    
        if self.isSingleReceiverEvent == false {
            launchSprayCandidate()
            circleMenu()
        } else {
            giftReceiverNameLbl.text = eventOwnerName
            
            giftAmountReceived = 0
            giftReceiverId = eventOwnerId
            //self.displayNamelbl?.text = "Now Spraying, " + receivername
            //self.sprayTotalLblAmt?.text = " -- $0.00"
            receiverName =  eventOwnerName
            giftAmountReceivedLbl.text = "$" + String(giftAmountReceived)
            
        }
        print("I am inside SetupPaymentMethodDelegate")
        
        print("view did appear isRefreshScreen = \(setRefreshScreen)")
        //I called viewDidAppear
        
    }
    

}
//extension GoSprayViewController:  RefreshScreenDelegate {
//    func refreshScreen(isRefreshScreen: Bool) {
//        print("refreshData function was called")
//        //refreshScreen = isRefreshScreen
//    }
//////
//////        func refreshScreen(isRefreshScreen: Bool) {
//////
//////
//////
//////            //print("refreshHomeScreenDate = \(isShowScreen)")
//////        }
//}
//public extension UIImageView{
//    func setImage(_ image: UIImage?, animated: Bool = true) {
//        let duration = animated ? 0.3 : 0.0
//        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
//            self.image = image
//        }, completion: nil)
//    }
//}
