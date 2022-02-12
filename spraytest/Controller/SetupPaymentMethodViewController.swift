//
//  SetupPaymentMethodViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 4/11/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//


import UIKit
import Stripe

let backendUrl = "https://projectxapi-dev.azurewebsites.net/" //http://127.0.0.1:4242/"


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
    var myProfileData: [MyProfile] = []
    
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
    var cardImage1: String = ""
    var image = UIImage(named: "")
    var countrylist: [CountryList] = []
    var activePickerViewTextField = UITextField()
    var pickerView = UIPickerView()
    var country: String = ""
    var countryData = CountryData()
    var source: String = ""
    
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
    lazy var countryTextField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Country"
        textField.keyboardType = UIKeyboardType.default
        textField.layer.cornerRadius = 5
        textField.text = country
        textField.frame.size.height = 45
        textField.layer.cornerRadius = 6.0
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.borderStyle = .none
        //CGRect frameRect.size.height = 100; // <-- Specify the height you want here.
        //textField.frame = frameRect;
        
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    lazy var paymentMessageLbl:UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        //textField.placeholder = "Card Nick Name"
        //textField.keyboardType = UIKeyboardType.default
        //textField.layer.cornerRadius = 5
        //textField.returnKeyType = UIReturnKeyType.done
        //textField.autocorrectionType = UITextAutocorrectionType.no
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "The Spray App partners with Stripe for secure payments.  \n Your credit/debit card will be charged the amount you sprayed."
        //textField.borderStyle = UITextField.BorderStyle.roundedRect
        //textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        //lable.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return lable
    }()
    
    
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        //button.backgroundColor = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)//.systemBlue
        //button.backgroundColor = UIColor(red: 7/256, green: 104/256, blue: 159/256, alpha: 1.0)
        //button.backgroundColor = UIColor(red: 177/256, green: 23/256, blue: 23/256, alpha: 1.0)
        //button.backgroundColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        button.backgroundColor = UIColor(red: 99/256, green: 61/256, blue: 189/256, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderWidth = 0.5
        
        button.layer.cornerRadius = 4
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("Add Payment Method", for: .normal)
        //button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
        

    }()

//    lazy var cardImageView: UIImageView = {
//        //let imageView = UIImageView(type: .custom)
//        //image = UIImage(named: cardImage1)
//        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width:50, height: 50))
//        imageView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        imageView.tintColor = .black
////        button.layer.cornerRadius = 5
////        button.backgroundColor = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)//.systemBlue
////        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
////        button.setTitle("Add Payment Method", for: .normal)
////        button.layer.borderWidth = 1.0
//        //imageView.addTarget(self, action: #selector(pay), for: .touchUpInside)
//        return imageView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("OLD paymentClientToken = \(paymentClientToken)")
        
        
        getclienToken()
        
        print("MY PROFILE DATA = \(myProfileData)")
//        if let stripeKey = Bundle.main.infoDictionary?["STRIPEAPI_PUBLISHABLEKEY"] as? String {
//            STRIPEAPI_PUBLISHABLEKEY = stripeKey
//        } else {
//            print("NO STRIPEAPI_PUBLISHABLEKEY")
//        }
        print("STRIPE_KEY =\(STRIPE_KEY)")
    
        
        self.navigationItem.title = "Add Payment Method..."
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
       
        
        cardNickNameTextField.delegate = self
        countryTextField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        //textFiled.delegate = self
        
        pickerView.backgroundColor = .white
        
        cardNickNameTextField.addTarget(self, action: #selector(SetupPaymentMethodViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(SetupPaymentMethodViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        availablePaymentData.removeAll()
        getAvailablePaymentData()
        
        StripeAPI.defaultPublishableKey = STRIPE_KEY //"pk_test_51I4w7tH6yOvhR5k1FrjaRKUcGG3LLzcuTx1LOWJj6bprUylHErpYHXsSRFxfdepAxz3KDbPLp2cDjpP54AWdc9qG00C8jcO2o4" //"pk_test_51I4w7tH6yOvhR5k1FrjaRKUcGG3LLzcuTx1LOWJj6bprUylHErpYHXsSRFxfdepAxz3KDbPLp2cDjpP54AWdc9qG00C8jcO2o4"

        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [paymentTitle, countryTextField, cardTextField, paymentMessageLbl, payButton])
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
       
        
        print("self.paymentIntentClientSecret = \(self.paymentIntentClientSecret)")
        
        
        countrylist.removeAll()
        loadCountryList()
        dismissPickerView()
    }
    
    func getclienToken() {
        
        var firstName: String = ""
        var lastName: String = ""
        var profileId: Int64 = 0
        var email: String = ""
        var phone: String = ""
        var userName: String = ""
        
        for myprofile in myProfileData {
            firstName = myprofile.firstName
            lastName = myprofile.lastName
            email = myprofile.email
            phone = myprofile.phone
            userName = myprofile.email
            profileId = myprofile.profileId
        }
        
         //call payment initialization
         self.initializePayment(token: token, profileId: profileId , firstName: firstName, lastName: lastName, userName: userName, email: email, phone: "")
        
        print("My name is getClientToken - I was called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //getclienToken()
    }
    override func viewDidDisappear(_ animated: Bool) {
        if launchedFromMenu == false {
            print("I AM CALLING EVENTPAYENT2VIEWE OR GO TO SPRAY launched from menu is false?")
            refreshscreendelegate?.refreshScreen(isRefreshScreen:isRefreshScreen)
            setuppaymentmethoddelegate?.passData(eventId: eventId, profileId: profileId, token: token, ApiKey: encryptedAPIKey,  eventName: eventName, eventDateTime: eventName, eventTypeIcon: eventTypeIcon, paymentClientToken: paymentClientToken, isSingleReceiverEvent: isSingleReceiverEvent, eventOwnerName: eventOwnerName, eventOwnerId: eventOwnerId, source: source)
            haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(newPaymentMethodId))
        } else {
            print("VidewDidDisapper luanchedfromMenu = true")
            refreshscreendelegate?.refreshScreen(isRefreshScreen:isRefreshScreen)
            setuppaymentmethoddelegate?.passData(eventId: eventId, profileId: profileId, token: token, ApiKey: encryptedAPIKey,  eventName: eventName, eventDateTime: eventName, eventTypeIcon: eventTypeIcon, paymentClientToken: paymentClientToken, isSingleReceiverEvent: isSingleReceiverEvent, eventOwnerName: eventOwnerName, eventOwnerId: eventOwnerId, source: source)
            haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(newPaymentMethodId))
        }
        
        
        print("View did asfasfdsafsafsadfsdf disappear from setupPayment \(isRefreshScreen)")
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
    
    //Initialize payment
    func initializePayment(token: String, profileId: Int64, firstName: String, lastName: String, userName: String, email: String, phone: String) {
        let initPayment = InitializePaymentModel(token: token, profileId: profileId, firstName: firstName, lastName: lastName, userName: userName, email: email, phone: phone)
  
        var encryptedAPIKeyUserName: String = ""
        
        var encryptdecrypt = EncryptDecrpyt()
        encryptedAPIKeyUserName = encryptdecrypt.encryptDecryptAPIKey(type: "username", value: userName, action: "encrypt")

        
        print("new API Key = \(encryptedAPIKeyUserName)")
        //let encryptedAPIKey = userName + "|" + self.encryptedAPIKey
        let request = PostRequest(path: "/api/profile/initialize", model: initPayment, token: token, apiKey: encryptedAPIKeyUserName, deviceId: "")
         
        print("request = \(request)")
        print("initPayment = \(initPayment)")
        
          Network.shared.send(request) { (result: Result<InitializePaymentData, Error>)  in
             switch result {
             case .success(let paymentInit):
                
                 
                 self.paymentClientToken = ""
                 self.paymentClientToken = paymentInit.clientToken!
                
                 /*assign new client token everytime the screen appears*/
                 self.setupIntentClientSecret = self.paymentClientToken
                 self.paymentIntentClientSecret = self.paymentClientToken
                 
                 
                 
                 print("NEW paymentClientToken = \(self.paymentClientToken)")
                 
                 //print("payment client token DOMINIC = \(self.paymentClientToken)")
                //capture profile data
               // self.getProfileData(profileId1: profileId, token1: token)

               
             case .failure(let error):
                 //self.labelMessage.text = error.localizedDescription
                self.theAlertView(alertType: "InitializeError", message: error.localizedDescription + " - /api/profile/initialize")
             }
         }
        //closing loading
       // self.dismiss(animated: false, completion: nil)
    }
    
    /*alert message*/
    func theAlertView(alertType: String, message: String){
        var alertTitle: String = ""
        var alertMessage: String = ""
        if alertType == "IncorrecUserNamePassword" {
            alertTitle = "Login Error"
            alertMessage = "You entered an invalid login ID or Password 1. \n"
            
        
        } else if alertType == "MissingFields" {
            alertTitle = "Login Error"
            alertMessage = "You entered an invalid login ID or Password 2. \n"
        } else if alertType == "InitializeError" {
            alertTitle = "Login Error"
            alertMessage = "Something went wrong with the initialization. Please try again later. \n \(message)"
        } else if alertType == "GenericError" {
            alertTitle = "Error"
            alertMessage = "Something went wrong with the initialization. Please try again later. \n \(message)"
        }  else if alertType == "GenericError2" {
            alertTitle = "Error"
            alertMessage = message
        }
       
        
        
//        self.loginButton.isEnabled = true
//        self.loginButton.setTitle("Sign In", for: .normal)
//        self.usernameTextField.isEnabled = true
//        self.passwordTextField.isEnabled = true
//        //self.loginButton.loadIndicator(false)
//        self.loginButton.loadIndicator(false)
        
        let alert2 = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert2, animated: true)
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
       print("NUMBER", cardTextField.cardNumber)
       print("EXP MONTH", cardTextField.expirationMonth)
       print("EXP YEAR", cardTextField.expirationYear)
       print("CVC", cardTextField.cvc)
        print("Brand Type", STPCardValidator.brand(forNumber: cardTextField.cardNumber!))
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
    
    func loadCountryList() {
        let data0 = CountryList(countryCode: "OO", countryName: "Select Country")
        countrylist.append(data0)
        let data1 = CountryList(countryCode: "usd", countryName: "United States")
        countrylist.append(data1)
        let data2 = CountryList(countryCode: "ngn", countryName: "Nigeria")
        countrylist.append(data2)
        let data3 = CountryList(countryCode: "gbp", countryName: "United Kingdom")
        countrylist.append(data3)
        let data4 = CountryList(countryCode: "inr", countryName: "India")
        countrylist.append(data4)
        
    }
    
    func getCountryCode(countryName: String) -> String {
        var myCountryCode: String = ""
        for country in countrylist {
            print("my country name is \(country.countryName)")
            if countryName == country.countryName {
                myCountryCode = country.countryCode
                print(" i got a country code =\(country.countryCode) ")
                break
            }
        }
        print("myCountryCode = \(myCountryCode)")
       return myCountryCode
    }
    
//    func createPickerView() {
//           let pickerView = UIPickerView()
//           pickerView.delegate = self
//           //textFiled.inputView = pickerView
//    }
    func dismissPickerView() {
//       let toolBar = UIToolbar()
//       toolBar.sizeToFit()
//       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
//       toolBar.setItems([button], animated: true)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.action))
        toolBar.isUserInteractionEnabled = true
        toolBar.setItems([doneBtn], animated: true)
        //textFiled.inputAccessoryView = toolBar
       
        countryTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
        customtextfield.borderForTextField(textField: countryTextField, validationFlag: false)
          view.endEditing(true)
    }
  func startCheckout() {
    // Create a PaymentIntent as soon as the view loads
    let url = URL(string: backendUrl + "create-payment-intent")!
    let json: [String: Any] = [
      "items": [
          ["id": "Spray-Transaction"]
        //["id": "xl-shirt"]
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
            self!.LoadingStop()
            self?.displayAlert(title: "Error loading page", message: message)
            return
      }
        print("Created PaymentIntent")
        self?.paymentIntentClientSecret = clientSecret
        print("self?.paymentIntentClientSecret = clientSecret \(self?.paymentIntentClientSecret )")
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
                       currency: paymenttypedata.currency,
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        activePickerViewTextField = textField
       if activePickerViewTextField == countryTextField {
            activePickerViewTextField.inputView = pickerView
        }
        
    }
    func displayAlertMessage(displayMessage: String, textField: UITextField) {
        let alert2 = UIAlertController(title: "Missing Information", message: displayMessage, preferredStyle: .alert)
        //alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] (action) in self.textFieldFocus(textField: textField)}))
        
        self.present(alert2, animated: true)
        
    }
    
    @objc func pay() {
        // LoadingStart() comment this out
            print("pay was called")
        
        let currencyCode = getCountryCode(countryName: countryTextField.text!)
        
        print("the currency code = \(currencyCode)")
        
        guard let countryName = countryTextField.text
              //,
              //let cardInfo = cardTextField
        else {
            return
        }
        
        var isCountrySelected: Bool = false
        var isCardInfoAdded: Bool = false
        //let isValidateCardNumber = self.formValidation.validateName2(name2: countryName).isValidate
        let cardParams = cardTextField.cardParams
        let last4Digit = cardParams.last4
        if (last4Digit == "") {
            isCardInfoAdded = false
            let message = "Card Information is Required"
            
            let alert2 = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
            //alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert2, animated: true)
            
            //displayAlertMessage(displayMessage: message, textField: countryTextField)
            
            cardTextField.becomeFirstResponder()
            return
        } else {
            isCardInfoAdded = true
            //cardTextField.becomeFirstResponder()
        }
        
        
        if countryName == "Select Country" || countryName == "" {
            isCountrySelected = false
            let message = "Country Name is Required"
            displayAlertMessage(displayMessage: message, textField: countryTextField)
            countryTextField.becomeFirstResponder()
            
            return
        } else  {
            customtextfield.borderForTextField(textField: countryTextField, validationFlag: false)
            isCountrySelected = true
        }
        
        /*let isValidateCountry = self.formValidation.validateName2(name2: countryName).isValidate
        if (isValidateCountry == false) {

            let message = "Card Nick Name is Required"
            displayAlertMessage(displayMessage: message, textField: cardNickNameTextField)

            return
        } else {
            customtextfield.borderForTextField(textField: cardNickNameTextField, validationFlag: false)
        } */

        //let isValidateCardNickName = true //set to true temporarily - remove later 6/9
       if isCountrySelected == true && isCardInfoAdded == true {
            // Collect card details
            let cardParams = cardTextField.cardParams
            let cardIcon = cardTextField.brandImage
            
            let last4Digit = cardParams.last4
            //let cardimage = STPImageLibrary.cardBrandImage(for: cardIcon)
            let cardNumber = cardTextField.cardNumber
            let cardBrand = STPCardValidator.brand(forNumber: cardNumber!)
        
            let cardImage = STPImageLibrary.cardBrandImage(for: cardBrand)
            //let cardImageType = convertImageToBase64String (img: cardImage)
            //self.IBImageViewCardType?.image = cardImage
            
            print("setupIntentClientSecret = \(setupIntentClientSecret)")
            print("description = \(cardParams.description)")
            print("last 4 = \(cardParams.last4)")
            print("exp year = \(cardParams.expYear)")
            print("exp month = \(cardParams.expMonth)")
            print("number = \(cardParams.number)")
            print("token = \(cardParams.token)")
            print("token = \(cardParams.additionalAPIParameters["card"])")
            
        
        print("Brand Type", STPCardValidator.brand(forNumber: cardTextField.cardNumber!))
        // Fill in any billing details...
            let billingDetails = STPPaymentMethodBillingDetails()

            // Create SetupIntent confirm parameters with the above
            let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: billingDetails, metadata: nil)
            let setupIntentParams = STPSetupIntentConfirmParams(clientSecret: setupIntentClientSecret!)
                   setupIntentParams.paymentMethodParams = paymentMethodParams
           
           print("setupIntentParams = \(setupIntentParams)")
           // Complete the setup
            let paymentHandler = STPPaymentHandler.shared()
            paymentHandler.confirmSetupIntent(setupIntentParams, with: self) { [self] status, setupIntent, error in
            switch (status) {
            case .failed:
                // Setup failed
                LoadingStop()
                self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                break
            case .canceled:
                LoadingStop()
                // Setup canceled
                self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                break
            case .succeeded:
                // Setup succeeded
                let last4Digit = "**** **** **** \(cardParams.last4!)"
                //expireDate = "02-24-2024" //cardParams.expMonth!.stringValue + "-" + "24-20" +
                
                let cardExpirationYear = Int(cardTextField.formattedExpirationYear!)
                let cardExpirationMonth = Int(cardTextField.formattedExpirationMonth!)
                let day = lastDay(ofMonth: cardExpirationMonth!, year: cardExpirationYear!)  // 28
                //lastDay(ofMonth: 06, year: 23)  // 29

//
//
//                let month = 06
//                let year = 23
//                print(lastDay(ofMonth: 06, year: 23) )
//                print(lastDay(ofMonth: 07, year: 23))
//
//                //let day = lastDay(ofMonth: month, year: year)
//                print(day)
                let expireDateString = "\(day)/\(cardExpirationMonth ?? 12)/\(cardExpirationYear ?? 2999)"
                expireDate = formattedDateFromString(dateString:expireDateString, withFormat: "yyyy-MM-dd")!
                print("my expiration date =\(expireDate)")
                
                cardParams.expYear!.stringValue
                //self.displayAlert(title: "Payment succeeded", message: setupIntent?.description ?? "")
                print("setupIntent?.paymentMethodID \(setupIntent?.paymentMethodID)")
                print("last 4 \(last4Digit)")
//               12
               // if paymentmethodCustNameExist(customName: paymentCustName) == false {
                    
                print("DOMINIC \(cardParams.description)")
                //print(" IMAGE = \(cardimage?.description)")
                print(" IMAGE2 = \(cardImage)")
               // image = cardImage
                
                print("cardExpirationYear \(cardExpirationYear)")
                print("cardExpirationMonth \(cardExpirationMonth)")
                
                
                //cardImage1 = cardimage?.
                    print(" i am calling add my payment")
                    //comment this out for now 6/9
                let currencyCode = getCountryCode(countryName: countryTextField.text!)
                
                print("the currency code = \(currencyCode)")
                
                addMyPayment(paymentMethodToken: (setupIntent?.paymentMethodID)!, customName: last4Digit, paymentOptionType: 1, paymentDescription: "", paymentExpiration: expireDate, currencyCode: currencyCode)
                  // } else {
                       print("DUPLICATE PAYMENT METHOD")
                       //giftAmountSegConrol.selectedSegmentIndex = 2
                       //segmentedControl.selectedSegmentIndex = index
                       //availableBalance = 15
                      // currentBalance.text = "$" + String(self.availableBalance)
               
                       //currentBalance.text = "$" + String(updatedBalance)
                       //btnSelectPayment.setTitle(paymentMethod.label, for: .normal)
               
                       //self.paymentMethodIcon.image = UIImage(named: paymentMethod.label)
               
               
                       //self.completionAlert(message: "Payment Method \(paymentMethod.label) Already Exist. Please Update Your Available Credit and Continue.", timer: 5, completionAction: completionAction)
                  // }
                   
                //print(setupIntent?.allResponseFields["card"].)
                break
            @unknown default:
                fatalError()
                break
           }
        }
    }
    
  }
    
    func convertImageToBase64String (img: UIImage) -> String {
        //return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        //let strBase64 =  img.pngData()?.base64EncodedString()
        //return strBase64!
        
        let imageData: Data? = img.jpegData(compressionQuality: 0.4)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        print(imageStr,"imageString")
        return imageStr //strBase64!
        //data.base64EncodedStringWithOptions([])
    }
    
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }

    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yy"

        if let date = inputFormatter.date(from: dateString) {

            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }
        return nil
    }
   

    
    
    func completionAlert(message: String, timer: Int, completionAction:String) -> Void {
        let delay = Double(timer) //* Double(NSEC_PER_SEC)
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            alert.dismiss(animated: true)
            if completionAction == "goback" {
                //self.redirect() commented out 10/9
                self.dismiss(animated: true, completion: nil)
                //self.launchEventPaymentScreen()
//                if((self.presentingViewController) != nil){
//                    self.dismiss(animated: false, completion: nil)
//                }
            }
        }
    }
    
    func redirect() {
        refreshscreendelegate?.refreshScreen(isRefreshScreen:isRefreshScreen)
        setuppaymentmethoddelegate?.passData(eventId: eventId, profileId: profileId, token: token, ApiKey: encryptedAPIKey,  eventName: eventName, eventDateTime: eventName, eventTypeIcon: eventTypeIcon, paymentClientToken: paymentClientToken, isSingleReceiverEvent: isSingleReceiverEvent, eventOwnerName: eventOwnerName, eventOwnerId: eventOwnerId, source: source)
        haspaymentdelegate?.hasPaymentMethod(hasPaymentMethod: true, paymentMethodId: Int(newPaymentMethodId))
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
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String, currencyCode: String) {
        //if i want to add default payment method, use the paymentmethod Id from this call to setup AddPref...
        //paymentmethodtoken is from the stripe UI
        /*paymentGatewayType  1=stripe 2 = paystack*/
        //let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: paymentExpiration, currency: currencyCode, profileId: profileId)
        let addPaymentNew = AddPaymentNew(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType: 1, paymentSubType: "", paymentDescription: paymentDescription, paymentExpiration: paymentExpiration, paymentGatewayType: 1, paystackAuthorizationCode: "", paystackEmail: "", currency: currencyCode, profileId: profileId)

        print("addPayment \(addPaymentNew)")
        let request = PostRequest(path: "/api/PaymentMethod/add", model: addPaymentNew, token: token, apiKey: encryptedAPIKey, deviceId: "")

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
            switch result {
            case .success(let newpaymentdata):
                let decoder = JSONDecoder()
                do {
                    let newPaymentJson: PaymentTypeData = try decoder.decode(PaymentTypeData.self, from: newpaymentdata)
                    
                    //getAvailablePaymentData() //refresh availablePaymentData object
                    //if currentAvailableCredit == 0 {
                        print("I do not have a blance")
                    addGeneralPaymentPref(paymentMethodId: newPaymentJson.paymentMethodId!, paymentDescription: customName, currencyCode: currencyCode)
                    print("new paymentMethod Id = \(newPaymentJson.paymentMethodId!)")
                        newPaymentMethodId =  newPaymentJson.paymentMethodId!
                    
                    isRefreshScreen = true
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
                    LoadingStop()
                   print(error)
               }
                //newpayment.
                //break
                //this will return payment methodId...
            case .failure(let error):
                LoadingStop()
                print(error.localizedDescription)
            }
        }
    }
    
    func addGeneralPaymentPref(paymentMethodId: Int64, paymentDescription: String, currencyCode: String) {
        
        //self.launchSprayCandidate()
        var updatedGiftAmount: Int = 0
        if currentAvailableCredit == 0 {
            //get default available credit amount by country/currencycode i.e U.S = $15, Nigeria = N1500
            updatedGiftAmount = countryData.getDefaultAvailableCredit(currencyCode: currencyCode)
     
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
        let currencyCode = currencyCode
        let currencySymbol =  Currency.shared.findSymbol(currencyCode: currencyCode)
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
                
                print("event Pref was addedd - DOMINIC")
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
                LoadingStop()
                self.completionAlert(message: "Payment Was Added. You Have a SprayCredit of \(currencySymbol)\(updatedGiftAmount) to Start With.", timer: 2, completionAction: "goback")
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
                print("LoadingStope - something went wrong")
                LoadingStop()
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

extension SetupPaymentMethodViewController{
   func LoadingStart(){
        ProgressDialog.alert = UIAlertController(title: nil, message: "Processing...", preferredStyle: .alert)
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating();

    ProgressDialog.alert.view.addSubview(loadingIndicator)
    present(ProgressDialog.alert, animated: true, completion: nil)
  }

  func LoadingStop(){
    ProgressDialog.alert.dismiss(animated: true, completion: nil)
  }
}

extension  SetupPaymentMethodViewController: UIPickerViewDataSource {
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activePickerViewTextField == countryTextField {
            return countrylist.count
        } else {
            return 0
        }
    }
}

extension  SetupPaymentMethodViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if activePickerViewTextField == countryTextField {
            return countrylist[row].countryName
        } else {
            return ""
        }
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activePickerViewTextField == countryTextField {
            countryTextField.text = countrylist[row].countryName//countryData[row]
        }
//        else if activePickerViewTextField == textFiled {
//            selectedCountry = countryList[row] // selected item
//            textFiled.text = selectedCountry
//        }
    }
}

