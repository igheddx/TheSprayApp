//
//  Menu2ViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/13/22.
//  Copyright © 2022 Ighedosa, Dominic. All rights reserved.
//
import UIKit
import Stripe
import SwiftKeychainWrapper
import LocalAuthentication
import CommonCrypto


class Menu2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuImage: UIImageView!
    
    //@IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    @IBOutlet weak var labelTest: UILabel!
    var profileId: Int64?
    var token: String?
    var paymentClientToken: String?

    var menudata = [MenuData]()
    var menusectionmoreactions = [MenuSections]()
    var menusectionnotification = [MenuSections]()
    var menusecdtionlogout = [MenuSections]()
    var menusectionprofile = [MenuSections]()
    var encryptedAPIKey: String = ""
    var profileImage: UIImage?
    var menulists: [MenuList] = []
    //var myProfileData: [MyProfile] = []
    var userDisplayName: String = ""
    var isBiometricEnabled: Bool = false
    var setupUsernamePasswordKeychain: Bool = false
    var isKeyChainInUse: Bool = false
    var isBiometricSwitchFlag: Bool = false
    var biometricCellDesc: String = ""
    var biometricCellIcon: String = ""
    var setstatusbarbgcolor = StatusBarBackgroundColor()
    var myProfileData: [MyProfile] = []
    
    var displayName: String = ""
    var paymentCustomerId: String = ""
    var paymentConnectedActId: String = ""
    var isRefreshScreen: Bool = false
    

    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
                                                        
        //getProfileData(profileId1: profileId!, token1: token!)
        print("viewDidLoad isBiometricSwitchFlag = \(isBiometricSwitchFlag)")
        print("viewDidLoad isBiometricEnabled = \(isBiometricEnabled)")
        
        processBiometric()
        displayName = UserDefaults.standard.string(forKey: "userDisplayName")!
        /*only call on load*/
        print("MenuVC isRefreshScreen = \(isRefreshScreen)")
        if isRefreshScreen == false {
            print("False onload")
            MenuListData()
        }
        view.addSubview(tableView)
        tableView.dataSource = self
        
    
        tableView.register(Menu2TableViewCell.nib(), forCellReuseIdentifier: Menu2TableViewCell.identifier)
        
        let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
        
        
       
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "Menu"
   
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.frame = view.bounds
        tableView.delegate = self
        
        
        func  isKeyPresentInUserDefaults(key: String) -> Bool {
            guard let _ = KeychainWrapper.standard.object(forKey: key) else {
             return false;
            }

           return true;
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
   
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //menulists = MenuListData()
        //MenuListData()
        
        setstatusbarbgcolor.setBackground()
        print("I was called avartar2 isRefreshScreen  = \(isRefreshScreen )")
        if isRefreshScreen == true {
            
            for view in tableView.subviews {
                print("table view delete 1")
                //if view is UITableView {
                    print("table view delete 2")
                   view.removeFromSuperview()
               //}
            }
            view.addSubview(tableView)
            tableView.dataSource = self
            
            
            print("isRefreshScreen ViewDidApper - MenuViewController")
            MenuListData()
        } else {
            print("MenuListData was not called")
        }
       
        
        
        //deSelectReloadData()
        for cell in tableView.visibleCells {
            cell.setSelected(false, animated: true)
        }
      
        /*unhide tabbar when coming from Create Event*/
        if self.tabBarController?.tabBar.isHidden == true {
            self.tabBarController?.tabBar.isHidden = false
        }

        //tableView.reloadData()
        AppUtility.lockOrientation(.portrait)
        
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    /*check if biometric is enabled - determine biometric label for cell*/
    func processBiometric() {
        let context = LAContext()
        CheckIfBiometricEnabled()
        if isBiometricEnabled == true {
            print("isBiometricEnabled ===== true")
            if ( context.biometryType == .touchID ) {
                 print("touch Id enabled")
//                    biometricLbl.text = "Login With Touch Id"
//                    displayBiometricSelection(imageName: "touchid_icon")
                biometricCellDesc = "Change Touch ID Setting"
                biometricCellIcon = "touchid_icon"
            }
            if ( context.biometryType == .faceID) {
//                    biometricLbl.text = "Login With Face ID"
//                    displayBiometricSelection(imageName: "faceid_icon")
                biometricCellDesc = "Change Face ID Setting"
                biometricCellIcon = "faceid_icon"
                print("face Id is enabled")
            } else {
                print("stone age")
            }
            
            //launch auto biometric if not logout and keychainInUse = true
            let isKeyChainInUserDefaults = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
            if isKeyChainInUserDefaults == true  {
    
                self.isKeyChainInUse = KeychainWrapper.standard.bool(forKey: "isKeyChainInUse")!
                print("iskeychaininuse  \(self.isKeyChainInUse )")
                if (self.isKeyChainInUse  == true) {
                    isBiometricSwitchFlag = true
                    let usernamekeychainToDisplay = KeychainWrapper.standard.string(forKey: "usernameKeyChain")
                    let username =  KeychainWrapper.standard.string(forKey: "usernameKeyChain")
                    let password =  KeychainWrapper.standard.string(forKey: "passwordKeyChain")
                    
                    isBiometricSwitchFlag = true
                    
                    print("USERNAME =\(username)")
                    print("USERNAME =\(password)")
                    

                } else {
                    isBiometricSwitchFlag = false
                }
            } else  {
                isBiometricSwitchFlag = false
//                biometricLbl.text = "Enable Biometric"
//                displayBiometricSelection(imageName: "")
//                displayRememberMeSelection()
                
            }
        
        
        } else  {
            print("isBiometricEnabled ===== true")
            biometricCellDesc = "Enable Biometric"
            biometricCellIcon = "touchid_icon"
//            biometricLbl.text = "Enable Biometric"
//            displayBiometricSelection(imageName: "")
//            displayRememberMeSelection()
        }
    }
    /*call this function to refresh - not using this now */
    func getProfileData(profileId1: Int64, token1: String) {
        let request = Request(path: "/api/profile/\(profileId1)", token: token1, apiKey: encryptedAPIKey)

        Network.shared.send(request) { [self] (result: Result<ProfileData2, Error>)  in
        switch result {
        case .success(let profileData):
            
            var defaultEventPaymentCustomName: String = ""
            if let custName = profileData.defaultPaymentMethodCustomName  {
                defaultEventPaymentCustomName = custName
            } else {
                defaultEventPaymentCustomName = ""
            }
            
        
            print("BIG PHONE NUMBER \(profileData.phone)")
            //add profile record into object to be used later
            let data1 = MyProfile(token: "", profileId: profileId1, firstName: profileData.firstName, lastName: profileData.lastName, userName: profileData.userName, email: profileData.email, phone: profileData.phone, avatar: profileData.avatar, paymentCustomerId: profileData.paymentCustomerId, paymentConnectedActId: profileData.paymentConnectedActId, success: true, returnUrl: "", refreshUrl: "",  hasValidPaymentMethod: profileData.hasValidPaymentMethod, defaultPaymentMethod: profileData.defaultPaymentMethod, defaultPaymentMethodCustomName: defaultEventPaymentCustomName)
            self.myProfileData.append(data1)
            
            //checkOnboardingStatus()
            getProfileNamePicture()
           // break
        case .failure(let error):
           //self.textLabel.text = error.localizedDescription
            self.theAlertView(alertType: "GenericError", message: error.localizedDescription + " - /api/profile")
            }
        }
    }
    
    //this is used to get profile name and picture from the myprofile object..
    //this is displayed at the top of the nagvigation bar in the homeviewcontroller
    func getProfileNamePicture() {
        
        //get profileName
        var avatarStr: String = ""
        var newAvatarImage: UIImage?
        var userDisplayName: String = ""
        if myProfileData.isEmpty {
            UserDefaults.standard.set("userprofile", forKey: "userProfileImage")
            UserDefaults.standard.set("", forKey: "userDisplayName")
            avatarStr = "noimage" //UserDefaults.standard.string(forKey: "userProfileImage")! //"noimage"
            displayName = UserDefaults.standard.string(forKey: "userDisplayName")!
            print("no avatar")
            paymentCustomerId = ""
            paymentConnectedActId = ""
            
        } else {
            for name in myProfileData {
                UserDefaults.standard.set(name.firstName, forKey: "userDisplayName")
                userDisplayName = UserDefaults.standard.string(forKey: "userDisplayName")!
                displayName = userDisplayName //name.firstName
                
                print("I am inside myProfile loop")
                if let avatarStr1 = name.avatar {
                    avatarStr = avatarStr1
                    UserDefaults.standard.set(avatarStr, forKey: "userProfileImage")
                   
                } else {
                    avatarStr = "noimage"
                    UserDefaults.standard.set("userprofile", forKey: "userProfileImage")
                    print("no image here")
                    break
                }
               
//                if let  paymentCustId = name.paymentCustomerId {
//                    paymentCustomerId = paymentCustId
//                } else  {
//                    paymentCustomerId = ""
//                }
//
//                if let  paymentConnectedId = name.paymentConnectedActId {
//                   paymentConnectedActId = paymentConnectedId
//                } else  {
//                    paymentConnectedActId = ""
//                }
                
                    
            }
        }
       
        
        if avatarStr == "noimage" {
            let userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            newAvatarImage = UIImage(named: userProfileImage!)
            print("noimage")
            
        } else {
            print("there is an image???")
            let userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            //newAvatarImage = UIImage(named: userProfileImage!)
            print("there is an image??? - \(userProfileImage)")
            newAvatarImage = convertBase64StringToImage(imageBase64String: userProfileImage!)
            print("there is an image???")
        }
       
        
//        if let myAvatar2 = myAvatar2 {
//
//            myAvatar.image = convertBase64StringToImage(imageBase64String: myAvatar2)
//        } else {
//            myAvatar.image = UIImage(named: "userprofile")
        //}
//        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//           let customView = UIView(frame: frame)
//           let imageView = UIImageView(image: newAvatarImage)
//           imageView.frame = frame
//           imageView.layer.cornerRadius = imageView.frame.height * 0.5
//           imageView.layer.masksToBounds = true
//        imageView.tintColor = UIColor.white
//           customView.addSubview(imageView)
//        if #available(iOS 14.0, *) {
//
//            let rbar = UIBarButtonItem(title: displayName, style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleClick))
//            let item =  UIBarButtonItem(customView: customView)
//            rbar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
//            navigationItem.rightBarButtonItems = [item, rbar]
            
//            navigationItem.rightBarButtonItems = [
//                UIBarButtonItem(customView: customView), UIBarButtonItem(title: displayName, style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleClick))
//
//            ]
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
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
//
        let alert2 = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        alert2.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //alert2.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert2, animated: true)
    }
    
    
    
    func CheckIfBiometricEnabled() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.isBiometricEnabled = true
            print("isBiometricEnabled = true")
        } else {
            //no biometric
            self.isBiometricEnabled = false
            print("isBiometricEnabled = false")
        }
    }
    func  isKeyPresentInUserDefaults(key: String) -> Bool {
        guard let _ = KeychainWrapper.standard.object(forKey: key) else {
         return false;
        }

       return true;
    }
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    /*no longer use 7/23/2021*/
    func addMyPayment(paymentMethodToken
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        
        let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: "8/10/2030", currency: "usd", profileId: profileId)
        
        let request = PostRequest(path: "/api/PaymentMethod/add", model: addPayment , token: token!, apiKey: encryptedAPIKey, deviceId: "")

        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        addMyPayment(paymentMethodToken: paymentMethod.stripeId, customName: paymentMethod.label, paymentOptionType: 0, paymentDescription: paymentMethod.image.description, paymentExpiration: "8/10/2030")
        
        print("label \(paymentMethod.label)")
        print("stripe Id \(paymentMethod.stripeId)")
        print("image \(paymentMethod.image)")
        
        print("allResponseFields \(paymentMethod.allResponseFields)")
        print("allResponseFields describing \(String(describing: paymentMethod.allResponseFields["card"]))")
        print("card and brand \(paymentMethod.card!.brand.rawValue)")
        print("stripe Id \(paymentMethod.stripeId)")
        print("stripe Id \(paymentMethod.stripeId)")
        let data = paymentMethod.allResponseFields
        
        for (name, path) in data {
            print("The path to '\(name)' is '\(path)'.")
        }
    }
    
    func deSelectReloadData() {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        
        if isRefreshScreen == false {
            tableView.reloadData()
        }
       
    }
    
    func MenuListData ()  {
        
        menudata.removeAll()
        menusectionprofile.removeAll()
        menusectionmoreactions.removeAll()

        menusectionnotification.removeAll()
        menusecdtionlogout.removeAll()
        
        
        var userProfileImage: String?
        //UserDefaults.standard.set("userprofile", forKey: "userProfileImage")
        
        userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")! //"noimage"
        
        print("userProfileImage = \(userProfileImage)")
        userDisplayName = UserDefaults.standard.string(forKey: "userDisplayName")!
        
        if userProfileImage == "userprofile" {

            profileImage = UIImage(named: userProfileImage!)
            print("noimage")
            
        } else {
            //let userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            //newAvatarImage = UIImage(named: userProfileImage!)
            
           
            print("there is an image??? I am here \(userProfileImage)")
            //profileImage = convertBase64StringToImage(imageBase64String:  "userprofile")
            profileImage = UIImage(named: userProfileImage!)
        }
        print("profileImage =\(profileImage)")
        //profileImage = UIImage(named:  userProfileImage)
        
//        menusectionprofile.removeAll()
//        menusectionmoreactions.removeAll()
//        menusectionprofile.removeAll()
//        menusecdtionlogout.removeAll()
        
        
        let menuprofiledata1 = MenuSections(id: "profile", name: "My Profile", image: userProfileImage, viewcontroller: "toMyProfileVC")
        menusectionprofile.append(menuprofiledata1)
        let menudata0 = MenuData(sectionName: "PROFILE", sectionDetails: menusectionprofile)
        
        
        let menumoreactiondata1 = MenuSections(id: "createevent", name: "Create Event", image: "createEventIcon", viewcontroller: "toCreateEventVC")
        let menumoreactiondata2 = MenuSections(id: "addpaymentmethod", name: "Add Payment Method", image: "paymentInfoIcon", viewcontroller: "toAddBankAccountVC")
        
        menusectionmoreactions.append(menumoreactiondata1)
        menusectionmoreactions.append(menumoreactiondata2)
        
        let menudata1 = MenuData(sectionName: "MORE ACTIONS", sectionDetails: menusectionmoreactions)
        

        let menunotificationdata1 = MenuSections(id: "mynotification", name: "My Sounds", image: "notificationIcon", viewcontroller: "toMyNotificationVC")
        menusectionnotification.append(menunotificationdata1)
       
        let menusettingsdata1 = MenuSections(id: "biometric", name: biometricCellDesc, image: biometricCellIcon, viewcontroller: "toMySettingsVC")
        menusectionnotification.append(menusettingsdata1)
        
        let menudata2 = MenuData(sectionName: "SETTINGS", sectionDetails: menusectionnotification)
        
        
        let menulogoutdata1 = MenuSections(id: "logout", name: "Log Out", image: "logoutIcon", viewcontroller: "toLoginVC")
        
        menusecdtionlogout.append(menulogoutdata1)
        let menudata3 = MenuData(sectionName: "LOG OUT", sectionDetails: menusecdtionlogout)
        
       
        menudata.append(menudata0!)
        menudata.append(menudata1!)
        menudata.append(menudata2!)
        menudata.append(menudata3!)
        
        print("menudata1 = \(menudata1)")

        tableView.reloadData()
        print("menudata.count = \(menudata.count)")
        
    }
    
    //Decoding Base64 Image
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func displayData() {
        for data in menudata  {
        }
    }
   
//    func CheckIfBiometricEnabled() {
//        let context = LAContext()
//        var error: NSError?
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            self.isBiometricEnabled = true
//            print("isBiometricEnabled = true")
//        } else {
//            //no biometric
//            self.isBiometricEnabled = false
//            print("isBiometricEnabled = false")
//        }
//    }


//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100
//    }
    
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section Title \(section)"
        
    }*/
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print("my section \(section)")
        // cell.menuImage.image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        header.backgroundColor = .secondarySystemBackground
        if menudata[section].sectionName == "PROFILE" {
            
         
            //let imageView = UIImageView(image: UIImage(systemName: "house"))
            let userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            //newAvatarImage = UIImage(named: userProfileImage!)
            
            print("userProfileImage = \(UserDefaults.standard.string(forKey: "userProfileImage"))")
            print("called - convertBase64StringToImage")
            
            let imageView = UIImageView()
            
            if userProfileImage == "userprofile" {
                imageView.image = UIImage(named: "userprofile")
            } else {
                imageView.image = convertBase64StringToImage(imageBase64String: userProfileImage!)
            }
            //let imageView = UIImageView(image: convertBase64StringToImage(imageBase64String: userProfileImage!))
            
            //let imageView = UIImageView(image: UIImage(named: convertBase64StringToImage(imageBase64String: userProfileImage!)))
            
            imageView.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
            //myAvatar.backgroundColor = UIColor.black
           imageView.contentMode =  UIView.ContentMode.scaleToFill// ScaleToFill
            imageView.layoutIfNeeded()
            imageView.layer.borderWidth = 1
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor =  UIColor.black.cgColor //UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor //UIColor.black.cgColor
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
            
            
            //imageView.tintColor = .systemBlue
            //imageView.contentMode = .scaleAspectFit
            header.addSubview(imageView)
            //imageView.frame = CGRect(x: 5, y: 5, width: header.frame.height-10, height: header.frame.size.height-10)
        
            
           
            let label = UILabel(frame: CGRect(x: 10 + imageView.frame.size.width, y: 5, width: header.frame.size.width - 15 - imageView.frame.size.width, height: header.frame.size.height-10))
            
            header.addSubview(label)
            
            label.text = "Hi, \(displayName)" //menudata[section].sectionName
            label.font = .systemFont(ofSize: 22, weight: .thin)
           
            
            
        } else {
            let label = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 25))
            
            header.addSubview(label)
            
            label.text = menudata[section].sectionName
            label.font = .systemFont(ofSize: 22, weight: .thin)
        }
       
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 60
     }
    func numberOfSections(in tableView: UITableView) -> Int {
        return menudata.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   menudata[section].sectionDetails.count  //!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        if menudata[indexPath.section].sectionName == "SETTINGS" {
           
           
            if menudata[indexPath.section].sectionDetails[indexPath.row].id == "biometric" {
                
                let cell0 = tableView.dequeueReusableCell(withIdentifier: Menu2TableViewCell.identifier, for: indexPath) as! Menu2TableViewCell
                
                cell0.textLabel?.text = menudata[indexPath.section].sectionDetails[indexPath.row].name
                cell0.imageView?.image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
                cell0.imageView!.frame = CGRect(x: 7, y: 5, width: 10, height: 10)
                
                print("SWITCH - \(menudata[indexPath.section].sectionDetails[indexPath.row].id)")
                let switchView = Switch1(frame: .zero) // UISwitch(frame: CGRect(x: 5, y: 5, width: 20, height: 25))
                switchView.setOn(isBiometricSwitchFlag, animated: true)
                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                cell0.accessoryView = switchView
                
               
                return cell0
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                cell.textLabel?.text = menudata[indexPath.section].sectionDetails[indexPath.row].name
                cell.imageView?.image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
                cell.imageView!.frame = CGRect(x: 7, y: 5, width: 10, height: 10)
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = menudata[indexPath.section].sectionDetails[indexPath.row].name
            
            //don't show image for profile
            if menudata[indexPath.section].sectionDetails[indexPath.row].id != "profile" {
                cell.imageView?.image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
                cell.imageView!.frame = CGRect(x: 7, y: 5, width: 10, height: 10)
            }
            
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        //let imageName = "yourImage.png"
//        let image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
//        let imageView = UIImageView(image: image)
//
//
//        view.addSubview(imageView)
//        imageView.frame = CGRect(x: 7, y: 5, width: 40, height: 40)
//
        //cell.menuImage.frame = CGRect(x: 7, y: 5, width: 40, height: 40)
        //cell.menuImage.image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
        
        
        
        //cell!.imageView?.image = UIImage(named:"ImageName")
        
        /*if menudata[indexPath.section].sectionName == "SETTINGS" {
            if menudata[indexPath.section].sectionDetails[indexPath.row].id == "biometric" {
                
                cell.textLabel?.text = menudata[indexPath.section].sectionDetails[indexPath.row].name
                
                print("SWITCH - \(menudata[indexPath.section].sectionDetails[indexPath.row].id)")
                let switchView = UISwitch(frame: .zero) // UISwitch(frame: CGRect(x: 5, y: 5, width: 20, height: 25))
                switchView.setOn(false, animated: true)
                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
            } else {
                cell.accessoryView = .none
            }
        }
       //"Hello world section \(indexPath.section)" //menudata[indexPath.section].sectionDetails[indexPath.row].name
        //"Hello world: \(indexPath.section) | row: \(indexPath.row)"
        
        return cell*/
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menudata[indexPath.section].sectionDetails[indexPath.row].id == "logout" {
            let alert = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action) in self.callLoginScreen()}))
            //alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler:  { action in self.performSegue(withIdentifier: "backToHome", sender: self) }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in self.deSelectReloadData()}))
            self.present(alert, animated: true)
        } else if menudata[indexPath.section].sectionDetails[indexPath.row].id == "addpaymentmethod" {
            launchSetUpPaymentMethod()
        } else if menudata[indexPath.section].sectionDetails[indexPath.row].id == "biometric" {
            print("do nothing")
        } else {
            performSegue(withIdentifier: menudata[indexPath.section].sectionDetails[indexPath.row].viewcontroller!, sender: self)
        }
        
    }
    @objc func switchChanged(_ sender : UISwitch!){
        if sender.isOn == true {
            KeychainWrapper.standard.set(true, forKey: "isEnablebiometricNextLogin")
            KeychainWrapper.standard.set(true, forKey: "isKeyChainInUse")
            
            print("isEnablebiometricNextLogin = \(KeychainWrapper.standard.bool(forKey: "isEnablebiometricNextLogin"))")
           
            print("isKeyChainInuse \(KeychainWrapper.standard.bool(forKey: "isKeyChainInuse"))")
            
        }
        
        if sender.isOn == false {
            
            print("isKeyChainInuse - first \(KeychainWrapper.standard.bool(forKey: "isKeyChainInuse"))")
            
            print("switch is off - \(sender.isOn)")
            KeychainWrapper.standard.removeObject(forKey: "isKeyChainInUse")
            KeychainWrapper.standard.removeObject(forKey: "isEnablebiometricNextLogin")
            
            KeychainWrapper.standard.set(false, forKey: "isEnablebiometricNextLogin")
            KeychainWrapper.standard.set(false, forKey: "isKeyChainInUse")
            
            print("isEnablebiometricNextLogin = \(KeychainWrapper.standard.bool(forKey: "isEnablebiometricNextLogin"))")
           
            print("isKeyChainInuse \(KeychainWrapper.standard.bool(forKey: "isKeyChainInuse"))")
            
            let alert = UIAlertController(title: "Please Confirm", message: "You are about to disable your Face ID. If you continue, you will have to re-enroll in Face ID again.", preferredStyle: .actionSheet)

            //alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [self] (action) in }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [self] (action) in disableBiometric()}))

            self.present(alert, animated: true)
        }
        
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
    }
    
    func disableBiometric() {
        removeCredentialFromKeyChain()
    }
    func removeCredentialFromKeyChain(){
        KeychainWrapper.standard.removeObject(forKey: "usernameKeyChain")
        KeychainWrapper.standard.removeObject(forKey: "passwordKeyChain")
        KeychainWrapper.standard.removeObject(forKey: "isKeyChainInUse")
        KeychainWrapper.standard.set(false, forKey: "isKeyChainInUse")
        print("key chain in use remove from menu2  \(KeychainWrapper.standard.set(false, forKey: "isKeyChainInUse"))")
        isKeyChainInUse = false
    }
    
    func launchSetUpPaymentMethod() {
 
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "SetupPaymentMethodViewController") as! SetupPaymentMethodViewController
        
        if #available(iOS 15.0, *) {
            if let presentationController = nextVC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()] /// set here!
            }
        } else {
            // Fallback on earlier versions
            nextVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
            nextVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        
        //nextVC.eventId = self.eventId
        nextVC.profileId = profileId!
        nextVC.token = token!
        nextVC.paymentClientToken = paymentClientToken!
        nextVC.launchedFromMenu = true
        nextVC.encryptedAPIKey = encryptedAPIKey
        nextVC.myProfileData = myProfileData
//        nextVC.eventName = eventName
//        nextVC.eventDateTime = eventDateTime
//        nextVC.eventTypeIcon = eventTypeIcon
//        nextVC.autoReplenishFlg = autoReplenishFlg
//        nextVC.autoReplenishAmt = autoReplenishAmt
//
//
//        nextVC.refreshscreendelegate = self
//        nextVC.setuppaymentmethoddelegate = self
//        nextVC.paymentClientToken = paymentClientToken
//        nextVC.currentAvailableCredit =  availableBalance
        //self.present(nextVC, animated: true, completion: nil)
        self.present(nextVC, animated: true)
        
    }
    func callLoginScreen() {
        self.navigationController!.viewControllers.removeAll()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        let window = UIApplication.shared.windows.first

        loginVC?.logout = true
        
        // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
        let nav = UINavigationController(rootViewController: loginVC!)
        window?.rootViewController = nav
        
       self.navigationController?.popToRootViewController(animated: true)

    }
    
    //Decoding Base64 Image
//    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
//        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
//        let image = UIImage(data: imageData!)
//        return image!
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UICollectionView {
    func deselectAllItems(animated: Bool = false) {
        for indexPath in self.indexPathsForSelectedItems ?? [] {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }
}

extension Menu2ViewController{
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "toCreateEventVC" { //create event view controller
                let NextVC = segue.destination as! CreateEventViewController
                NextVC.profileId = profileId!
                NextVC.token = token!
                NextVC.paymentClientToken = paymentClientToken
                NextVC.encryptedAPIKey = encryptedAPIKey
                NextVC.myProfileData = myProfileData
                

            } else if(segue.identifier == "backToHome") {
//                      let NextVC = segue.destination as! LoginViewController
//                      NextVC.logout  = true
                        
                    let NextVC = segue.destination as! ProfileViewController
                        //targetController.data = "hello from ReceiveVC !"
                            //NextVC.logout  = true
                NextVC.profileId = profileId!
                NextVC.token = token!
                NextVC.encryptedAPIKey = encryptedAPIKey
                NextVC.refreshProfileImageDelegate = self
                
                            
            } else if(segue.identifier == "toAddBankAccountVC")  { //add bank account
                
            } else if(segue.identifier == "toNotificationVC")  { //notification view controller
                
            } else if(segue.identifier == "toSettingsVC")  { //setting view controller
            
            } else if(segue.identifier == "toMyProfileVC") {
                
//                if let  NextVC = segue.destination as? MainNavigationViewController,
//                let targetController =  NextVC.topViewController as? LoginViewController  {
//                    let NextVC = segue.destination as! ProfileViewController
//
                let NextVC = segue.destination as! ProfileViewController
                NextVC.profileId = profileId!
                NextVC.token = token!
                NextVC.encryptedAPIKey = encryptedAPIKey
                NextVC.refreshProfileImageDelegate = self
                //targetController.data = "hello from ReceiveVC !"
                    //NextVC.logout  = true
            }
    
    }
}

extension Menu2ViewController:  RefreshProfileImageDelegate {
    func profileImage(avatar: String, isRefresh: Bool) {
       
        print("I was called avartar1 = \(isRefresh)")
        
        let userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")
        print("userProfileImage \(userProfileImage)")
        //newAvatarImage = UIImage(named: userProfileImage!)
        //var newAvatarImage: UIImage?
        //profileImage = convertBase64StringToImage(imageBase64String: userProfileImage!)
        
        /* only refresh if isRefresh is set to true*/
        if isRefresh == true {
            isRefreshScreen = isRefresh
            //profileImage = convertBase64StringToImage(imageBase64String: avatar)
            print("there is an image??? - Dominic ")
            
            
//            menusectionprofile.removeAll()
//            menusectionmoreactions.removeAll()
//            menusectionprofile.removeAll()
//            menusecdtionlogout.removeAll()
//            menusectionnotification.removeAll()
//            menudata.removeAll()
        }
        
        
        //MenuListData()
        
    }
}

