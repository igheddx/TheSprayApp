//
//  EventSettingViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/22/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//
import BraintreeDropIn
import Braintree
import UIKit

class EventSettingViewController: UIViewController, UINavigationControllerDelegate  {

    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var paymentActionMessageLabel: UILabel!
    @IBOutlet weak var paymentSelectedLabel: UILabel!
    
    @IBOutlet weak var paymentIconImageView: UIImageView!
    @IBOutlet weak var addEditPaymentButton: UIButton!
    
    @IBOutlet weak var paymentNickNameTextField: UITextField!
    
    @IBOutlet weak var rsvpSwitch: UISwitch!
    
    @IBOutlet weak var withdrawAmountTextField: UITextField!
    @IBOutlet weak var autoReplenishSwitch: UISwitch!
    @IBOutlet weak var autoReplenishAmountTextField: UITextField!
    @IBOutlet weak var notificationAmountTextField: UITextField!
    
    @IBOutlet weak var paymentNickNameErrorLabel: UILabel!
    
    @IBOutlet weak var withdrawAmountErrorLabel: UILabel!
    
    @IBOutlet weak var replenishAmountErrorLabel: UILabel!
    
    @IBOutlet weak var alertAmountErrorLabel: UILabel!
    
    var refreshscreendelegate: RefreshScreenDelegate?
    var  testDelegate: GetClearEventDataDelegate?
    var sprayDelegate: SprayTransactionDelegate?
    
    
    //currency converter
    var amt = 0
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var withdrawAmount: Int = 0
    var withdrawAmount2: Int = 0
    var isAutoReplenish: Bool?
    var autoReplenishAmount: Int?
    var notificationAmount: Int?
    var paymentTypeFromPaymentType: Int64?
    var paymentMethodIdFromPreference: Int64?
    var paymentMethodIdFromGetPaymentType: Int64?
    
    var eventName: String = ""
    var token: String?
    var eventId: Int64?
    var profileId: Int64?
    var ownerId: Int64?
    var paymentClientToken: String?
    var paymentNickName: String?
    var isAttendingEventId: Int64?
    var eventTypeIcon: String = ""
    var screenIdentifier: String?
    
    var paymentOptionType: BTUIKPaymentOptionType?
    var paymentMethodNonce: BTPaymentMethodNonce?
    var paymentDescription: String?
    var isReadyToSavePayment: Bool = false

    
    //UIImageView(frame: CGRect(origin: .zero, size: size))
    
 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //print("token = \(token!)")
         //print("profile Id = \(profileId!)")
        
        
        paymentNickNameErrorLabel.isHidden = true
        withdrawAmountErrorLabel.isHidden = true
        replenishAmountErrorLabel.isHidden=true
        alertAmountErrorLabel.isHidden=true
        messageLabel.text = ""
        
        getPaymenttype()
        getEventPreference() //use to populate event preference screen
        
        navigationController?.delegate = self
        
        //turn off switch when coming from myInvitation screen
        if screenIdentifier == "RSVP" {
            rsvpSwitch.isOn = false
        }
        
        /*
        // MARK: isAttedingEventId is use to indicate that an attendee is currently RSVP.
        if the value of isAttendingEventId = 0, it means the attendee has removed their
        RSVP flag so we should set swift to off
        print("isAttendingEventId = \(isAttendingEventId!)")
        print("screenIdentifier = \(screenIdentifier!)") */
        
        if isAttendingEventId != 0 {
            rsvpSwitch.isOn = true
        } else {
             rsvpSwitch.isOn = false
        }
        
        self.borderForTextField(textField: paymentNickNameTextField, validationFlag: false)
        self.borderForTextField(textField: autoReplenishAmountTextField, validationFlag: false)
        self.borderForTextField(textField: notificationAmountTextField, validationFlag: false)
        self.borderForTextField(textField: withdrawAmountTextField, validationFlag: false)

        withdrawAmountTextField.delegate = self
        withdrawAmountTextField.placeholder = updateTextField()
        
//

//

//        print("ThIS IS MY BALANCE \(getBalance.balance)")
//
//
        //print("ThIS IS MY BALANCE \(getBalance.getEventPreference(profileId: profileId!, eventId: eventId!, token: token!))")
       //getEventPreference2(profileId: profileId!, eventId: eventId!, token: token!)
      
        //getEventPreference2(profileId: profileId!, eventId: eventId!, token: token!)
        //print("balance \(balance)")
        //print("my event name = \(eventName)")
       eventNameLabel?.text = eventName
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        
        
        if parent == nil {
            //when going back to selecAttenddee VC
            //pass 0 receiverBalance to force a refresh
            // on the screen
           
            
//            print("gifter balance before the left screen \(gifterBalance)")
//            sprayDelegate?.sprayGifterBalance(balance: gifterBalance )
//            sprayDelegate?.sprayReceiverBalance(balance: sprayAmount)
//            sprayDelegate?.sprayReceiverId(receiverId: giftReceiverId)
//            sprayDelegate?.processSprayTransaction(eventId: Int(eventId), senderId: Int(profileId), receiverId: Int(giftReceiverId), senderAmountRemaining: gifterBalance, receiverBalanceAfterSpray: sprayAmount, isAutoReplenish:0, paymentMethod: 5)
//            debugPrint("Back Button pressed.")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Event Setting - Dominic VIEW DID  Disappear")
           // When you want to send data back to the caller
           // call the method on the delegate
//           if let refreshscreendelegate = self.refreshscreendelegate {
//            refreshscreendelegate.refreshScreen(isRefreshScreen: true)
//            print("ViewWill Disappear")
//           }
        sprayDelegate?.sprayEventSettingRefresh(isEventSettingRefresh: true)
    }
    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)
        
        print("Event Setting - Dominic VIEW DISAPPEAR")
           // When you want to send data back to the caller
           // call the method on the delegate
//           if let refreshscreendelegate = self.refreshscreendelegate {
//            refreshscreendelegate.refreshScreen(isRefreshScreen: true)
//            print("ViewWill Disappear")
//           }
        sprayDelegate?.sprayEventSettingRefresh(isEventSettingRefresh: true)
            // Don't forget to reset when view is being removed
            AppUtility.lockOrientation(.all)
    }
    func updateTextField() -> String? {
        let number = Double(amt/100) + Double(amt%100)/100
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    private func addBottomLineToTextField(textField: UITextField) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 2/3, green: 2/3, blue: 2/3, alpha: 1.0).cgColor
        //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
        textField.borderStyle = .none
        
        textField.layer.addSublayer(bottomLine)
    }
    
    private func borderForTextField(textField: UITextField, validationFlag: Bool) {

        if validationFlag == false {
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 211/256, green: 211/256, blue: 211/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
            textField.borderStyle = .none
        } else {
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
            textField.borderStyle = .none
        }


        //textField.layer.addSublayer(bottomLine)

    }
    
    //use to go back after after update
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? HomeViewController)?.isRefreshData = true // Here you pass the to your original view controller
      }
    
    @IBAction func saveEventSettingButtonPressed(_ sender: Any) {
        //call addPayment when a new card is added
        if isReadyToSavePayment {
            //print("save payment")
            
            addPayment(paymentNonce: paymentMethodNonce!.nonce, paymentOptionType: Int64(paymentOptionType!.rawValue), paymentDescription: paymentDescription!, paymentExpiration: "12/31/2099")
        } else {
            //print("not ready to save payment")
        }
        
        print("paymentMethodIdFromGetPaymentType!  = \(paymentMethodIdFromGetPaymentType!)")
        //save preference if there is a payment method and the withdraw amount is not 0
       withdrawAmount2 = Int(withdrawAmountTextField.text!)!
        
        if paymentTypeFromPaymentType != 0 && withdrawAmount2 != 0 {
            saveEventPreference(paymentMethod: Int(Int64(paymentMethodIdFromGetPaymentType!)))
        } else {
            let alert = UIAlertController(title: "Message", message: "Withdraw amount and paymethod is required to Save your preference.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            //alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  { action in self.performSegue(withIdentifier: "backToHome", sender: self) }))

            self.present(alert, animated: true)
        }
        
        //do this when a user is coming from the Invitation section of the home screen
        //this mean that an attendee is tryig to RSVP. If they set RSVP to false, don't let them
        //move forward
        if rsvpSwitch.isOn == false && screenIdentifier == "RSVP" {
            let alert = UIAlertController(title: "RSVP", message: "You have not RSVP for this event? Select Cancel so that you can RSVP or select Exit to leave this screen.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler:  { action in self.performSegue(withIdentifier: "backToHome", sender: self) }))

            self.present(alert, animated: true)
                   //print("Balance is Zero")
        } else if rsvpSwitch.isOn == true && screenIdentifier == "RSVP"{  //this is first time RSVP
            
            let addAttendee = AddAttendees(profileId: ownerId!, eventId: eventId!, eventAttendees: [Attendees(profileId: profileId!, eventId: eventId!, isAttending: true)])
            
            //let updateAttendee = Attendees(profileId: profileId, eventId: eventId, isAttending: true)
            
            //print(updateAttendee)
            
            let request = PostRequest(path: "/api/Event/addattendees", model: addAttendee, token: token!)
                Network.shared.send(request) { (result: Result<Empty, Error>)  in
                        switch result {
                        case .success( _): break
                        //case .failure(let error):
                        case .failure(let error):
                            self.messageLabel.text = error.localizedDescription
                            //print(error.localizedDescription)
                    }
                }
        }
       
        //do this when an attendee set the switch to false indicating that they
        //no longer want to RSVP. The next time they return, the swith will be set
        //to false
        if screenIdentifier == "EventSettings" && rsvpSwitch.isOn == false && isAttendingEventId! != 0 {
            print("EventSettings IS TURNED OFF SETTING ISATTENDING = FALSE = \(rsvpSwitch.isOn)")
            let updateAttendee = Attendees(profileId: profileId!, eventId: eventId!, isAttending: false)
    
            let request = PostRequest(path: "/api/Event/updateattendee", model: updateAttendee, token: token!)
    
            Network.shared.send(request) { (result: Result<Empty, Error>)  in
                switch result {
                case .success( _): break
                case .failure(let error):
                    self.messageLabel.text = error.localizedDescription
                }
            }
        } else if screenIdentifier == "EventSettings" && rsvpSwitch.isOn == true && isAttendingEventId! == 0 {
            print("EventSettings is attending event id = 0 = \(rsvpSwitch.isOn)")
            let updateAttendee = Attendees(profileId: profileId!, eventId: eventId!, isAttending: true)
    
            let request = PostRequest(path: "/api/Event/updateattendee", model: updateAttendee, token: token!)
    
            Network.shared.send(request) { (result: Result<Empty, Error>)  in
                switch result {
                case .success( _): break
                case .failure(let error):
                    self.messageLabel.text = error.localizedDescription
                }
            }
        } else {
            print("There is nothing to chang")
        }
        
//
//        if (self.paymentOptionType!.rawValue > 0 && self.paymentMethodNonce!.nonce != nil) {
//            addPayment(paymentNonce: self.paymentMethodNonce!.nonce, paymentOptionType: Int64(self.paymentOptionType!.rawValue), paymentDescription: self.paymentDescription!, paymentExpiration: "12/1/2030")
//
//            print("paymentOption 2 = \(Int64(self.paymentOptionType!.rawValue))")
//                                print("paymentMethod! 2 = \(self.paymentMethodNonce!.nonce)")
//                                //print("paymentIcon = \(paymentIcon)")
//                                print("paymentDescription 2 = \(self.paymentDescription!)")
//        } else {
//            print("no event preference payment ")
//        }
//
        
        
    }
    


//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//        if parent == nil {
//            debugPrint("Back Button pressed Home.")
//
////            self.refreshscreendelegate?.refreshScreen(isRefreshScreen: true)
////
//        }
//    }


    @IBAction func addPaymentButtonPressed(_ sender: Any) {
         showDropIn(clientTokenOrTokenizationKey: paymentClientToken!)
        // self.performSegue(withIdentifier: "addPaymentVC", sender: nil)
       // performSegue(withIdentifier: "addPaymentVC", sender: self)
                   // self.dismiss(animated: true, completion: nil)
        
        
//        let addPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "addPaymentVC") as! AddPaymentViewController
//                                 self.navigationController?.pushViewController(addPaymentVC , animated: true)
//                                
                                  //selectRSVPVC.eventName = theEventName
    }
    
//    func getEventPreference2(profileId: Int64, eventId: Int64, token: String) {
//           var balance: Int = 0
//        print("I am in getPayment")
//        let request = Request(path: "/api/Event/prefs/\(profileId)/\(eventId)", token: token)
//
//                               Network.shared.send(request) { (result: Result<Data, Error>)  in
//
//                                   switch result {
//
//                                   case .success(let eventPreferenceData):
//
//                                       //self.parse(json: event)
//
//
//
//                                     let decoder = JSONDecoder()
//
//                                            do {
//
//                                                let eventPreferenceJson: [EventPreferenceData] = try decoder.decode([EventPreferenceData].self, from: eventPreferenceData)
//
//                                                  for eventPrefData in eventPreferenceJson {
//          //                                            print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
//          //                                            print("customName = \(paymenttypedata.customName!)")
//          //                                            print("paymenttype = \(paymenttypedata.paymentType!)")
//
//                                                      balance = eventPrefData.maxSprayAmount
//
//
//
//                                                      print("BALANCE = \(balance)")
//
//
//                                                      //self.withdrawAmountTextField.text! = String(eventPrefData.maxSprayAmount)
//          //                                            self.autoReplenishAmountTextField.text  = String(eventPrefData.replenishAmount)
//          //                                            self.notificationAmountTextField.text = String(eventPrefData.notificationAmount)
//          //                                            self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
//
//          //                                            self.paymentNickNameTextField.text = (paymenttypedata.customName!)
//          //                                          self.paymentSelectedLabel.text = paymenttypedata.paymentDescription
//          //                                          self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
//          //                                          self.paymentActionMessageLabel.text = "edit payment Information for this event..."
//          //
//                    //                                print("error message = \(paymentJson[x].errorMessage!)")
//                    //                                print("error code = \(paymentJson[x].errorCode!)")
//                                                  }
//
//                                            } catch {
//
//                                                print(error)
//
//                                            }
//
//
//                                   case .failure(let error):
//
//                                       print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
//
//                                   }
//
//                              }
//
//              }
//
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                self.paymentOptionType = result.paymentOptionType
                self.paymentMethodNonce = result.paymentMethod
                let paymentIcon = result.paymentIcon
                self.paymentDescription = result.paymentDescription
                
        
                self.paymentSelectedLabel.text = self.paymentDescription
                let size = CGSize(width: 20, height: 20)
                let view = result.paymentIcon as? BTUIKVectorArtView
                self.paymentIconImageView.image = view?.image(of: size)
                
                //self.addEditPaymentButton.setBackgroundImage(UIImage(named: "editIcon"), for: UIControl.State.normal)
                self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
                self.paymentActionMessageLabel.text = "edit payment Information for this event..."
                print("paymentOption= \(self.paymentOptionType!.rawValue)")
                print("paymentMethod! = \(self.paymentMethodNonce!.nonce)")
                print("paymentIcon = \(paymentIcon)")
                print("paymentDescription = \(self.paymentDescription!)")
                self.isReadyToSavePayment = true
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    

    func saveEventPreference(paymentMethod: Int) {
        withdrawAmount = Int(withdrawAmountTextField.text!)!
        autoReplenishAmount = Int(autoReplenishAmountTextField.text!)!
        notificationAmount = Int(notificationAmountTextField.text!)!
        
        if autoReplenishSwitch.isOn == true {
            isAutoReplenish = true
        } else {
            isAutoReplenish = false
        }
        print("paymentMethod = \(paymentMethod)")
        
        let addEventPreference = EventPreference(eventId: eventId!, profileId: profileId!, paymentMethod: paymentMethod, maxSprayAmount: withdrawAmount, replenishAmount: autoReplenishAmount!, notificationAmount:  notificationAmount!, isAutoReplenish: isAutoReplenish!)

        print("addEventPreference \(addEventPreference)")
        let request = PostRequest(path: "/api/Event/addprefs", model: addEventPreference, token: token!)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref); break
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
    func addPayment(paymentNonce: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        
        paymentNickName = paymentNickNameTextField.text!
        
        print("my payment Nicke Name =\(paymentNickName!)")
        let addPayment = AddPaymentType(nonce: paymentNonce, customName: paymentNickName, paymentType: paymentOptionType, paymentDescription: paymentDescription, paymentExpiration: paymentExpiration, profileId: profileId)
        
                    let request = PostRequest(path: "/api/PaymentMethod/add", model: addPayment , token: token!)
        
                    Network.shared.send(request) { (result: Result<Data, Error>)  in
                        switch result {
                        case .success( _): break
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
    }
    
    func getPaymenttype() {
        let request = Request(path: "/api/PaymentMethod/all/\(profileId!)", token: token!)
               
               Network.shared.send(request) { (result: Result<Data, Error>)  in
                   
                   switch result {
                       
                   case .success(let paymentmethod1):
                       //self.parse(json: event)
                     let decoder = JSONDecoder()
                     do {
                        let paymentJson: [PaymentTypeData] = try decoder.decode([PaymentTypeData].self, from: paymentmethod1)
                        for paymenttypedata in paymentJson {
                            print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
                            print("customName = \(paymenttypedata.customName!)")
                            print("paymenttype = \(paymenttypedata.paymentType!)")
                            
                            print("paymenttypedata.paymentType! = \(paymenttypedata.paymentType!)")
                            print("paymenttypedata.paymentMethodId = \(paymenttypedata.paymentMethodId!)")
                            if paymenttypedata.paymentType! == 5 {
                                self.paymentIconImageView.image = UIImage(named: "visaicon")
                            } else if paymenttypedata.paymentType! == 4 {
                                self.paymentIconImageView.image = UIImage(named: "mastercardicon")
                            }
                            self.paymentNickNameTextField.text = (paymenttypedata.customName!)
                            self.paymentSelectedLabel.text = paymenttypedata.paymentDescription
                            self.addEditPaymentButton.setImage(UIImage(named: "editIcon"), for: .normal)
                            self.paymentActionMessageLabel.text = "edit payment Information for this event..."
                            self.paymentTypeFromPaymentType = paymenttypedata.paymentType!
                            self.paymentMethodIdFromGetPaymentType = paymenttypedata.paymentMethodId!
//                                print("error message = \(paymentJson[x].errorMessage!)")
//                                print("error code = \(paymentJson[x].errorCode!)")
                        }

                    } catch {
                        
                        print(error)
                        
                    }
                    
                       
                   case .failure(let error):
                       
                       print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
                       
                   }
                   
               }
               
    }
    
    func getEventPreference() {
        let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId!)", token: token!)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
        switch result {
        case .success(let eventPreferenceData):
        let decoder = JSONDecoder()
            do {
                let eventPreferenceJson: [EventPreferenceData] = try decoder.decode([EventPreferenceData].self, from: eventPreferenceData)
                for eventPrefData in eventPreferenceJson {
                    self.withdrawAmountTextField.text! = String(eventPrefData.maxSprayAmount)
                    self.autoReplenishAmountTextField.text  = String(eventPrefData.replenishAmount)
                    self.notificationAmountTextField.text = String(eventPrefData.notificationAmount)
                    self.autoReplenishSwitch.isOn = eventPrefData.isAutoReplenish
                    self.paymentMethodIdFromPreference = Int64(eventPrefData.paymentMethod)
                    
                    
                }
            } catch {
                print(error)
            }
        case .failure(let error):
            print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
        }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if(segue.identifier == "addPaymentVC"){
            let NextVC = segue.destination as! AddPaymentViewController
            NextVC.token = token!
            NextVC.paymentClientToken = paymentClientToken!
            NextVC.eventName = eventName
            
        //                            NextVC.token = token2pass
        //                          displayVC.token = token2pass
        //                          displayVC.userdata = userdata
         } else if(segue.identifier == "backToHome") {
            let NextVC = segue.destination as! HomeViewController
            NextVC.token = token!
            NextVC.paymentClientToken = paymentClientToken!
            NextVC.profileId = profileId
        }
        
    }

}


extension EventSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string){
            amt = amt * 10 + digit
            if amt > 1_000_00 {
                let alert = UIAlertController(title: "Please enter value less than 1000", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                    self.amt = 0
                    self.withdrawAmountTextField.text = ""
                    
                }))
                present(alert, animated: true, completion: nil)
            } else  {
                withdrawAmountTextField.text = updateTextField()
            }
           
        }
        
        if string=="" {
            amt = amt/10
            withdrawAmountTextField.text = amt == 0 ? "" : updateTextField()
        }
        return false
    }
    
}
