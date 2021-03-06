//
//  SetupPaymentMethodViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 4/11/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//


import UIKit
import Stripe

let backendUrl = "https://projectxapiapp.azurewebsites.net/" //http://127.0.0.1:4242/"


class SetupPaymentMethodViewController: UIViewController, STPAuthenticationContext, UITextFieldDelegate {
    var paymentIntentClientSecret: String?
    var setupIntentClientSecret: String?
    var paymentClientToken: String = ""
    var profileId: Int64 = 0
    var eventId: Int64 = 0
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventTypeIcon: String = ""
    var isSingleReceiverEvent: Bool = false
    var availablePaymentData = [PaymentTypeData2]()
    var refreshscreendelegate: RefreshScreenDelegate?
    var setuppaymentmethoddelegate: SetupPaymentMethodDelegate?
    var haspaymentdelegate: HasPaymentMethodDelegate?
    var customtextfield = CustomTextField()
    var formValidation =   Validation()
    var last4Digit: String = ""
    var expireDate: String = ""
    var token: String = ""
    var isRefreshScreen: Bool = false
    var currentAvailableCredit: Int = 0 
    var autoReplenishFlg: Bool = false
    var autoReplenishAmt: Int = 0
    var newPaymentMethodId: Int64 = 0
    var launchedFromMenu: Bool = false
    var eventOwnerName: String = ""
    var eventOwnerId: Int64 = 0
    //var completionAction: String = ""
    var encryptedAPIKey: String = ""
    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    
    lazy var paymentTitle:UILabel = {
        let paymentLabel = UILabel()
        
        paymentLabel.textAlignment = .center
        paymentLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        paymentLabel.text = "Add Payment Method"
        paymentLabel.textColor = UIColor.black
        return paymentLabel
    }()
    
    lazy var cardNickNameTextField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Card Nick Name"
        textField.keyboardType = UIKeyboardType.default
        textField.layer.cornerRadius = 5
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 22)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)//.systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Add Payment Method", for: .normal)
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "Add Payment Method..."
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        print("paymentClientToken = \(paymentClientToken)")
        
        cardNickNameTextField.delegate = self
        //textFiled.delegate = self
        
        cardNickNameTextField.addTarget(self, action: #selector(SetupPaymentMethodViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        availablePaymentData.removeAll()
        getAvailablePaymentData()
        
        StripeAPI.defaultPublishableKey = "pk_test_51I4w7tH6yOvhR5k1FrjaRKUcGG3LLzcuTx1LOWJj6bprUylHErpYHXsSRFxfdepAxz3KDbPLp2cDjpP54AWdc9qG00C8jcO2o4" //"pk_test_51I4w7tH6yOvhR5k1FrjaRKUcGG3LLzcuTx1LOWJj6bprUylHErpYHXsSRFxfdepAxz3KDbPLp2cDjpP54AWdc9qG00C8jcO2o4"

        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [paymentTitle, cardTextField, cardNickNameTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
          stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
          view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
          stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
        ])
        //startCheckout()
        setupIntentClientSecret = paymentClientToken
        self.paymentIntentClientSecret = paymentClientToken
        
        print("self.paymentIntentClientSecret = \(self.paymentIntentClientSecret)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if launchedFromMenu == false {
            refreshscreendelegate?.refreshScreen(isRefreshScreen:isRefreshScreen)
            setuppaymentmethoddelegate?.passData(eventId: eventId, profileId: profileId, token: token, ApiKey: encryptedAPIKey,  eventName: eventName, eventDateTime: eventName, eventTypeIcon: eventTypeIcon, paymentClientToken: paymentClientToken, isSingleReceiverEvent: isSingleReceiverEvent, eventOwnerName: eventOwnerName, eventOwnerId: eventOwnerId)
            haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(newPaymentMethodId))
        }
        
        
        print("View did disappear from setupPayment \(isRefreshScreen)")
    }
    override func viewWillDisappear(_ animated: Bool) {
        //remove setupPayment VC from the stack when going back to home VC
       // navigationController!.removeViewController(SetupPaymentMethodViewController.self)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

        if text?.utf16.count==0{
            switch textField{
            case cardNickNameTextField :
                customtextfield.borderForTextField(textField: cardNickNameTextField, validationFlag: true)
                cardNickNameTextField.becomeFirstResponder()
            default:
                break
            }
        }else{
            switch textField{
            case cardNickNameTextField :
                customtextfield.borderForTextField(textField: cardNickNameTextField, validationFlag: false)
            default:
                break
                
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case cardNickNameTextField :
                cardNickNameTextField.resignFirstResponder()
            default:
                break
        }
        return true
    }
  func displayAlert(title: String, message: String, restartDemo: Bool = false) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel))
      self.present(alert, animated: true, completion: nil)
    }
  }

    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
  func startCheckout() {
    // Create a PaymentIntent as soon as the view loads
    let url = URL(string: backendUrl + "create-payment-intent")!
    let json: [String: Any] = [
      "items": [
          ["id": "xl-shirt"]
      ]
    ]
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: json)
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let response = response as? HTTPURLResponse,
        response.statusCode == 200,
        let data = data,
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
        let clientSecret = json["clientSecret"] as? String else {
            let message = error?.localizedDescription ?? "Failed to decode response from server."
            self?.displayAlert(title: "Error loading page", message: message)
            return
      }
      print("Created PaymentIntent")
      self?.paymentIntentClientSecret = clientSecret
    })
    task.resume()
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
    
    //use this to get payment description/name
    func getPaymenthMethodName(paymentmethodid: Int) -> String {
        var thePaymentMethodName: String = ""
        for i in availablePaymentData {
            if i.paymentMethodId! == paymentmethodid {
                thePaymentMethodName = i.customName!
                break
            }
        }
        return thePaymentMethodName
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
    
    func getAvailablePaymentData() {
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
                       profileId: paymenttypedata.profileId,
                       paymentType: paymenttypedata.paymentType,
                       customName: paymenttypedata.customName,
                       paymentDescription: paymenttypedata.paymentDescription,
                       paymentExpiration: paymenttypedata.paymentExpiration,
                       defaultPaymentMethod: paymenttypedata.defaultPaymentMethod,
                       paymentImage: paymenttypedata.paymentDescription)
                        self.availablePaymentData.append(adddata)
                        
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
            //self.tableView.reloadData()
            case .failure(let error):
               print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
           }
       }
    }
    //set textfield focus and highlight border set
    func textFieldFocus(textField: UITextField) {
        textField.becomeFirstResponder()
        customtextfield.borderForTextField(textField: textField, validationFlag: true)
    }
    func displayAlertMessage(displayMessage: String, textField: UITextField) {
        let alert2 = UIAlertController(title: "Missing Information", message: displayMessage, preferredStyle: .alert)
        //alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] (action) in self.textFieldFocus(textField: textField)}))
        
        self.present(alert2, animated: true)
        
    }
    
    @objc func pay() {
        guard let cardNickName = cardNickNameTextField.text

        else {
            return
        }
        let isValidateCardNickName = self.formValidation.validateName2(name2: cardNickName).isValidate
        if (isValidateCardNickName == false) {

            let message = "Card Nick Name is Required"
            displayAlertMessage(displayMessage: message, textField: cardNickNameTextField)

            return
        } else {
            customtextfield.borderForTextField(textField: cardNickNameTextField, validationFlag: false)
        }

        
        if isValidateCardNickName == true {
            // Collect card details
            let cardParams = cardTextField.cardParams
            
            print("setupIntentClientSecret = \(setupIntentClientSecret)")
            print("description = \(cardParams.description)")
            print("last 4 = \(cardParams.last4)")
            print("exp year = \(cardParams.expYear)")
            print("exp month = \(cardParams.expMonth)")
            print("number = \(cardParams.number)")
            print("token = \(cardParams.token)")
            print("token = \(cardParams.additionalAPIParameters["card"])")
            // Fill in any billing details...
            let billingDetails = STPPaymentMethodBillingDetails()

            // Create SetupIntent confirm parameters with the above
            let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: billingDetails, metadata: nil)
            let setupIntentParams = STPSetupIntentConfirmParams(clientSecret: setupIntentClientSecret!)
                   setupIntentParams.paymentMethodParams = paymentMethodParams
            // Complete the setup
            let paymentHandler = STPPaymentHandler.shared()
            paymentHandler.confirmSetupIntent(setupIntentParams, with: self) { [self] status, setupIntent, error in
            switch (status) {
            case .failed:
                // Setup failed
                self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                break
            case .canceled:
                // Setup canceled
                self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                break
            case .succeeded:
                // Setup succeeded
                last4Digit = cardParams.last4!
                expireDate = "02-24-2024" //cardParams.expMonth!.stringValue + "-" + "24-20" + cardParams.expYear!.stringValue
                //self.displayAlert(title: "Payment succeeded", message: setupIntent?.description ?? "")
                print("setupIntent?.paymentMethodID \(setupIntent?.paymentMethodID)")
                
                let paymentCustName = cardNickNameTextField.text! + " ... " + last4Digit
                let paymentNickName = cardNickNameTextField.text!
                if paymentmethodCustNameExist(customName: paymentCustName) == false {
                    
                    print(" i am calling add my payment")
                    addMyPayment(paymentMethodToken: (setupIntent?.paymentMethodID)!, customName: paymentCustName, paymentOptionType: 0, paymentDescription:  paymentNickName, paymentExpiration: expireDate)
                   } else {
                       print("DUPLICATE PAYMENT METHOD")
                       //giftAmountSegConrol.selectedSegmentIndex = 2
                       //segmentedControl.selectedSegmentIndex = index
                       //availableBalance = 15
                      // currentBalance.text = "$" + String(self.availableBalance)
               
                       //currentBalance.text = "$" + String(updatedBalance)
                       //btnSelectPayment.setTitle(paymentMethod.label, for: .normal)
               
                       //self.paymentMethodIcon.image = UIImage(named: paymentMethod.label)
               
               
                       //self.completionAlert(message: "Payment Method \(paymentMethod.label) Already Exist. Please Update Your Available Credit and Continue.", timer: 5, completionAction: completionAction)
                   }
                   
                //print(setupIntent?.allResponseFields["card"].)
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
  }
    func completionAlert(message: String, timer: Int, completionAction:String) -> Void {
        let delay = Double(timer) //* Double(NSEC_PER_SEC)
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            alert.dismiss(animated: true)
            if completionAction == "goback" {
                self.dismiss(animated: true, completion: nil)
                //self.launchEventPaymentScreen()
            }
        }
    }
    
    func launchEventPaymentScreen() {
//        func launchEventPaymentScreen(eventId2: Int64, eventName2: String, eventDateTime2: String, completionAction: String, eventTypeIcon: String, isPaymentMethodAvailable: Bool, hasPaymentMethod: Bool, isRsvprequired: Bool, isSingleReceiver: Bool, defaultEventPaymentMethod: Int, defaultEventPaymentCustomName: String) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "EventPaymentViewController") as! EventPaymentViewController
            //hold for now 1/29/2021
        nextVC.eventId = eventId
        nextVC.profileId = profileId
        nextVC.token = token
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.eventName = eventName
        nextVC.eventDateTime = eventDateTime
        nextVC.eventTypeIcon = eventTypeIcon
        
        nextVC.isSingleReceiverEvent = isSingleReceiverEvent
//            nextVC.eventDateTime = eventDateTime2
//            nextVC.completionAction = completionAction
//            nextVC.eventTypeIcon = eventTypeIcon
//            nextVC.isPaymentMethodAvailable = isPaymentMethodAvailable
        
        nextVC.paymentClientToken = paymentClientToken

        self.navigationController?.pushViewController(nextVC , animated: true)
        //self.navigationController!.popViewController(nextVC, animated: true)
       
    }
//
    func addMyPayment(paymentMethodToken
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        //if i want to add default payment method, use the paymentmethod Id from this call to setup AddPref...
        //paymentmethodtoken is from the stripe UI
        let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: paymentExpiration, profileId: profileId)

        print("addPayment \(addPayment)")
        let request = PostRequest(path: "/api/PaymentMethod/add", model: addPayment , token: token, apiKey: encryptedAPIKey, deviceId: "")

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let newpaymentdata):
                let decoder = JSONDecoder()
                do {
                    let newPaymentJson: PaymentTypeData = try decoder.decode(PaymentTypeData.self, from: newpaymentdata)
                    
                    //getAvailablePaymentData() //refresh availablePaymentData object
                    //if currentAvailableCredit == 0 {
                        print("I do not have a blance")
                        addGeneralPaymentPref(paymentMethodId: newPaymentJson.paymentMethodId!, paymentDescription: customName)
                        newPaymentMethodId =  newPaymentJson.paymentMethodId!
                   // } else {
                      //  print("I have a balance")
                      //  isRefreshScreen = true
                      //  refreshscreendelegate?.refreshScreen(isRefreshScreen:isRefreshScreen)
                        //self.completionAlert(message: "Payment Was Added. You Have a Credit of $15 to Start With.", timer: 2, completionAction: "goback")
                      //  self.completionAlert(message: "Payment Was Added", timer: 2, completionAction: "goback")
                    //}
                    
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
    
    func addGeneralPaymentPref(paymentMethodId: Int64, paymentDescription: String) {
        
        //self.launchSprayCandidate()
        var updatedGiftAmount: Int = 0
        if currentAvailableCredit == 0 {
            updatedGiftAmount = 15
     
        } else {
            updatedGiftAmount = currentAvailableCredit

        }
        var autoReplenishFlg1: Bool = false
        var autoReplenishAmt1: Int = 0
        if launchedFromMenu == false {
            autoReplenishFlg1 = self.autoReplenishFlg
            autoReplenishAmt1 = self.autoReplenishAmt
        } else {
            autoReplenishFlg1 = false
            autoReplenishAmt1 = 0
        }
        let updatedPaymentMethodId = paymentMethodId
        //let updatedGiftAmount = 15
        let updatedAutoReplenishFlag = autoReplenishFlg1
        let updatedAutoReplenishAmount: Int = autoReplenishAmt1
        let currencyCode = "usd"
        
        let addPaymentPref = EventPreference(eventId: 0, profileId: profileId, paymentMethod: Int(updatedPaymentMethodId), maxSprayAmount: updatedGiftAmount, replenishAmount: updatedAutoReplenishAmount, notificationAmount:  0, isAutoReplenish: updatedAutoReplenishFlag, currency: currencyCode)
            
        //set.btnSelectPayment.setTitle(paymentDescription)
       
        
        print("ADD EVENT PREFERENCE \(addPaymentPref)")
//        updategfitamountdelegate?.sendLatestGiftAmount(latestGiftAmount: updatedGiftAmount, latestIsAutoReplenishFlag: updatedAutoReplenishFlag, latestAutoReplenishAmount: updatedAutoReplenishAmount)
        //closeScreen()
        
        //hold 2/13 - for now...
        let request = PostRequest(path: "/api/Event/addprefs", model: addPaymentPref, token: token, apiKey: encryptedAPIKey, deviceId: "")
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let eventpref): print(eventpref);
                
                //updatedBalance = availableBalance + getSprayAmountInt(amountId: giftAmountSegConrol.selectedSegmentIndex, category: "addreplenishamount")
                
//                giftAmountSegConrol.selectedSegmentIndex = 2
//                //segmentedControl.selectedSegmentIndex = index
//                availableBalance = updatedGiftAmount
//                currentBalance.text = "$" + String(self.availableBalance)
//
//                //currentBalance.text = "$" + String(updatedBalance)
//                btnSelectPayment.setTitle(paymentDescription, for: .normal)
//                paymentMethodIcon.image = UIImage(named: paymentDescription)
//

                
                isRefreshScreen = true
                
                self.completionAlert(message: "Payment Was Added. You Have a SprayCredit of $\(updatedGiftAmount) to Start With.", timer: 2, completionAction: "goback")
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
    // Collect card details
//    let cardParams = cardTextField.cardParams
//    print("cardParams \(cardParams)")
//    let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
//    let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
//    print("paymentIntentClientSecret \(paymentIntentClientSecret)")
//    paymentIntentParams.paymentMethodParams = paymentMethodParams
    
  
    
    
    // Submit the payment
//    let paymentHandler = STPPaymentHandler.shared()
//    paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
//      switch (status) {
//      case .failed:
//          self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
//          break
//      case .canceled:
//          self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
//          break
//      case .succeeded:
//          self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "")
//          break
//      @unknown default:
//          fatalError()
//          break
//      }
//    }
//  }
}

