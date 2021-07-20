
import UIKit
import Stripe
import SwiftKeychainWrapper
import LocalAuthentication
import CommonCrypto

class MobileBrand {
    var brandName: String?
    var modelName: [String]?
    
    init(brandName: String, modelName: [String]){
        self.brandName = brandName
        self.modelName = modelName
    }
}
class MenuViewController: UIViewController {

    
    @IBOutlet weak var menuImage: UIImageView!
    
    //@IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    @IBOutlet weak var labelTest: UILabel!
    var profileId: Int64?
    var token: String?
    var paymentClientToken: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableArray = ["Create Event", "Add Bank Account", "Settings", "Notification", "Log Out"]
    var segueIdentifiers = ["toCreateEventVC", "toAddBankAccountVC", "toNotificationVC", "toSettingsVC"]
    
    var mobileBrand = [MobileBrand]()
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        let context = LAContext()
        CheckIfBiometricEnabled()
        if isBiometricEnabled == true {
            print("isBiometricEnabled = true")
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
            let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
            if isKeyChainInUse == true  {
    
                self.isKeyChainInUse = KeychainWrapper.standard.bool(forKey: "isKeyChainInUse")!
                print("iskeychaininuse \(self.isKeyChainInUse )")
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
            biometricCellDesc = "Enable Biometric"
            biometricCellIcon = "touchid_icon"
//            biometricLbl.text = "Enable Biometric"
//            displayBiometricSelection(imageName: "")
//            displayRememberMeSelection()
        }
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "Menu"
   
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        print("profileId \(profileId!)")
        print("DOMINIC OZIE IGHEDOAS")
        print("token \(token!)")
        menudata.removeAll()
        MenuListData()
        displayData()
       // menudata.append(MenuData(sectionName: "More Actions...", sectionDetails: [MenuSections(name: "Create Event", image: "createEventIon")])!)
       
        
        //mobileBrand.append(MobileBrand.init(brandName: "Apple", modelName: ["iPhone1", "iPhone2","iPhone3", "iPhone XC", "iPhone JJ"]))
         mobileBrand.append(MobileBrand.init(brandName: "Sumsung", modelName: ["Sam1", "Sam2","Sam3"]))
        
        
        //labelTest.text = String(profileId!)
        //call MenuListData function arry
        //and set it equal to the menulist object
      
        //MenuListData()
        tableView.delegate = self
        tableView.dataSource = self
        
        //print("menu = \(menu)")
        
        //tableView.delegate = self
        //tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //menulists = MenuListData()
        
        setstatusbarbgcolor.setBackground()
        deSelectReloadData()
        AppUtility.lockOrientation(.portrait)
        
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
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
    
    func addMyPayment(paymentMethodToken
                        : String, customName: String, paymentOptionType: Int64, paymentDescription: String, paymentExpiration: String) {
        
        let addPayment = AddPayment(paymentMethodToken: paymentMethodToken, isUpdate: false, customName: customName, paymentType:1, paymentDescription: paymentDescription, paymentExpiration: "8/10/2030", profileId: profileId)
        
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
        
        tableView.reloadData()
    }
    
    func MenuListData ()  {
        
       
        var userProfileImage: String = ""
        //UserDefaults.standard.set("userprofile", forKey: "userProfileImage")
        
        userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")! //"noimage"
        
        print("userProfileImage = \(userProfileImage)")
        userDisplayName = UserDefaults.standard.string(forKey: "userDisplayName")!
        
        if userProfileImage == "userprofile" {

            profileImage = UIImage(named: userProfileImage)
            print("noimage")
            
        } else {
            //let userProfileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            //newAvatarImage = UIImage(named: userProfileImage!)
            
            profileImage = convertBase64StringToImage(imageBase64String: userProfileImage)
            print("there is an image???")
        }
        print("profileImage =\(profileImage)")
        //profileImage = UIImage(named:  userProfileImage)
        
        let menuprofiledata1 = MenuSections(id: "profile", name: "Profile", image: userProfileImage, viewcontroller: "toMyProfileVC")
        menusectionprofile.append(menuprofiledata1)
        let menudata0 = MenuData(sectionName: "PROFILE", sectionDetails: menusectionprofile)
        
        
        let menumoreactiondata1 = MenuSections(id: "createevent", name: "Create Event", image: "createEventIcon", viewcontroller: "toCreateEventVC")
        let menumoreactiondata2 = MenuSections(id: "addpaymentmethod", name: "Add Payment Method", image: "paymentInfoIcon", viewcontroller: "toAddBankAccountVC")
        
        menusectionmoreactions.append(menumoreactiondata1)
        menusectionmoreactions.append(menumoreactiondata2)
        
        let menudata1 = MenuData(sectionName: "MORE ACTIONS", sectionDetails: menusectionmoreactions)
        

        let menunotificationdata1 = MenuSections(id: "mynotification", name: "My Notifications", image: "notificationIcon", viewcontroller: "toMyNotificationVC")
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

       
        print(menudata)
      }
    
    func displayData() {
        for data in menudata  {
           

           }
    }
   
}

extension  MenuViewController: UITableViewDataSource, UITableViewDelegate  {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print(" menudata[section].sectionName.count = \( menudata[section].sectionName.count)")
        //return   mobileBrand[section].modelName!.count
       return   menudata[section].sectionDetails.count  //!.count
       
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return mobileBrand.count
        return menudata.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 75
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
        
        print("indexPath.row = \(indexPath.row)")
           //cell.textLabel?.text = mobileBrand[indexPath.section].modelName![indexPath.row]
        if menudata[indexPath.section].sectionDetails[indexPath.row].id == "profile" {
            cell.menuName.text = userDisplayName
        } else  {
            cell.menuName.text = menudata[indexPath.section].sectionDetails[indexPath.row].name
        }
        
        if menudata[indexPath.section].sectionDetails[indexPath.row].id == "profile" {
            print("PROFILE \(menudata[indexPath.section].sectionDetails[indexPath.row].name)")
    
            cell.menuImage.frame = CGRect(x: 5, y: 5, width: 60, height: 60)
            //myAvatar.backgroundColor = UIColor.black
            cell.menuImage.contentMode =  UIView.ContentMode.scaleToFill// ScaleToFill
            cell.menuImage.layoutIfNeeded()
            cell.menuImage.layer.borderWidth = 1
            cell.menuImage.layer.masksToBounds = false
            cell.menuImage.layer.borderColor =  UIColor.black.cgColor //UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor //UIColor.black.cgColor
            cell.menuImage.layer.cornerRadius = cell.menuImage.frame.height/2
            cell.menuImage.clipsToBounds = true
            
            
            cell.menuImage.image = profileImage// UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
        } else {
            cell.menuImage.frame = CGRect(x: 7, y: 5, width: 40, height: 40)
            cell.menuImage.image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
        }
        
        if menudata[indexPath.section].sectionDetails[indexPath.row].id == "biometric" {
            let switchView = UISwitch(frame: .zero)
           switchView.setOn(false, animated: true)
           switchView.tag = indexPath.row // for detect which row switch Changed
           switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
           cell.accessoryView = switchView
        }
        
        //print(menudata[indexPath.section].sectionDetails[indexPath.row].name!)
        //cell.detailTextLabel.text = menu[indexPath.section].sectionDetails.name
//
        return cell
        //}
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //return mobileBrand[section].brandName
        return menudata[section].sectionName
        //return "test"
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menudata[indexPath.section].sectionDetails[indexPath.row].id == "logout" {
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to Log Out?", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (action) in self.callLoginScreen()}))
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
        } else  {
            KeychainWrapper.standard.set(false, forKey: "isEnablebiometricNextLogin")
            let alert = UIAlertController(title: "Please Confirm", message: "You are about to disable your Face ID. If you continue, to use these features again, you will need to re-enroll", preferredStyle: .actionSheet)

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
        isKeyChainInUse = false
    }
    
    
    func launchSetUpPaymentMethod() {
      
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "SetupPaymentMethodViewController") as! SetupPaymentMethodViewController

       

        nextVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        nextVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext
    

        //nextVC.eventId = self.eventId
        nextVC.profileId = profileId!
        nextVC.token = token!
        nextVC.paymentClientToken = paymentClientToken!
        nextVC.launchedFromMenu = true
        nextVC.encryptedAPIKey = encryptedAPIKey
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
        self.present(nextVC, animated: true, completion: nil)
        
    }
    func callLoginScreen() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        let window = UIApplication.shared.windows.first

        // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
        let nav = UINavigationController(rootViewController: loginVC!)
        window?.rootViewController = nav
        
       self.navigationController?.popToRootViewController(animated: true)

    }
    
    //Decoding Base64 Image
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }

}


extension UICollectionView {
    func deselectAllItems(animated: Bool = false) {
        for indexPath in self.indexPathsForSelectedItems ?? [] {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }
}

extension MenuViewController{
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "toCreateEventVC" { //create event view controller
                let NextVC = segue.destination as! CreateEventViewController
                NextVC.profileId = profileId!
                NextVC.token = token!
                NextVC.paymentClientToken = paymentClientToken
                NextVC.encryptedAPIKey = encryptedAPIKey
                

            } else if(segue.identifier == "backToHome") {
//                      let NextVC = segue.destination as! LoginViewController
//                      NextVC.logout  = true
                        
                    let NextVC = segue.destination as! ProfileViewController
                        //targetController.data = "hello from ReceiveVC !"
                            //NextVC.logout  = true
                NextVC.profileId = profileId!
                NextVC.token = token!
                NextVC.encryptedAPIKey = encryptedAPIKey
                            
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
                //targetController.data = "hello from ReceiveVC !"
                    //NextVC.logout  = true
            }
    
    }
}

//******************************** hold for later **********************
//extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return menulists.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let menulist = menulists[indexPath.row]
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
//        cell.setMenuList(menuitem: menulist)
//
//
//        return cell
//    }
//
//
//}
//
//
//extension MenuViewController{
//func tableview(_ tableview: UITableViewCell, didSelecteRowAt indexPath: IndexPath) {
//    //tableView.deselectRow(at: indexPath, animated: true)
//    print("I was selected")
//          }
//}
//
//
//extension MenuViewController {
//          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//            if segue.identifier == "CreateEventVC" {
//
//                //if let indexPath = self.tableVi
//                if let indexPath = self.tableView.indexPathForSelectedRow {
//                    //let menulist = menulists[indexPath.row]
//                    let itemselect = menulists[indexPath.row]
//
//                    print(itemselect.title)
//                    if itemselect.title == "Add Event" {
//                        let NextVC = segue.destination as! CreateEventViewController
//                        NextVC.createEventTitle = itemselect.title
//                    } else {
//                        print("Do nothing")
//                    }
//
//
//            }
//    }
//    }
//}
