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
    
    
    var menudata = [MenuData]()
    var menusectionmoreactions = [MenuSections]()
    var menusectionnotification = [MenuSections]()
    var menusecdtionlogout = [MenuSections]()
    var menusectionprofile = [MenuSections]()
    var menulists: [MenuList] = []
    var biometricCellIcon: String = ""
    var userDisplayName: String = ""
    var profileImage: UIImage?
    var biometricCellDesc: String = ""
    var isKeyChainInUse: Bool = false
    var isBiometricSwitchFlag: Bool = false
    var isBiometricEnabled: Bool = false
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuListData ()
        view.addSubview(tableView)
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let context = LAContext()
        CheckIfBiometricEnabled()
        
        let isKeyChainInUse = isKeyPresentInUserDefaults(key: "isKeyChainInUse")
        
        
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
        
        tableView.frame = view.bounds
        tableView.delegate = self
        
        
        func  isKeyPresentInUserDefaults(key: String) -> Bool {
            guard let _ = KeychainWrapper.standard.object(forKey: key) else {
             return false;
            }

           return true;
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
        
        userProfileImage = "" //UserDefaults.standard.string(forKey: "userProfileImage")! //"noimage"
        
        print("userProfileImage = \(userProfileImage)")
        userDisplayName = "noimage"//UserDefaults.standard.string(forKey: "userDisplayName")!
        
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
        
        
        let menuprofiledata1 = MenuSections(id: "profile", name: "Profile", image: userProfileImage, viewcontroller: "toMyProfileVC")
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

       
        print(menudata)
        tableView.reloadData()
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
            let imageView = UIImageView(image: UIImage(named: "userprofile"))
            
            imageView.tintColor = .systemBlue
            imageView.contentMode = .scaleAspectFit
            header.addSubview(imageView)
            imageView.frame = CGRect(x: 5, y: 5, width: header.frame.height-10, height: header.frame.size.height-10)
        
           
            let label = UILabel(frame: CGRect(x: 10 + imageView.frame.size.width, y: 5, width: header.frame.size.width - 15 - imageView.frame.size.width, height: header.frame.size.height-10))
            
            header.addSubview(label)
            
            label.text = menudata[section].sectionName
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
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return menudata.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   menudata[section].sectionDetails.count  //!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = menudata[indexPath.section].sectionDetails[indexPath.row].name
        
        if menudata[indexPath.section].sectionName == "SETTINGS" {
            if menudata[indexPath.section].sectionDetails[indexPath.row].id == "biometric" {
                
                print("SWITCH - \(menudata[indexPath.section].sectionDetails[indexPath.row].id)")
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(false, animated: true)
                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
            }
        }
       //"Hello world section \(indexPath.section)" //menudata[indexPath.section].sectionDetails[indexPath.row].name
        //"Hello world: \(indexPath.section) | row: \(indexPath.row)"
        
        return cell
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
