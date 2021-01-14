//
//  MenuViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit



class MobileBrand {
    var brandName: String?
    var modelName: [String]?
    
    init(brandName: String, modelName: [String]){
        self.brandName = brandName
        self.modelName = modelName
    }
}
class MenuViewController: UIViewController {
    
//
//  struct MenuSectionMorActions {
//      var name: String?
//      var image: String?
//  }
//
//  struct MenuSectionNotifications {
//      var name: String?
//      var image: String?
//  }
//  struct MenuSectionLogout {
//      var name: String?
//      var image: String?
//  }


    
    
    //@IBOutlet weak var tableView: UITableView!
    
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
    
    var menulists: [MenuList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //labelTest.text = displayString!
        
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
        
       
        deSelectReloadData()
        
    }
    
    func deSelectReloadData() {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        
        tableView.reloadData()
    }
    
    func MenuListData ()  {
        
        let menuprofiledata1 = MenuSections(name: "Profile", image: "profileIcon", viewcontroller: "toMyProfileVC")
        menusectionprofile.append(menuprofiledata1)
        let menudata0 = MenuData(sectionName: "PROFILE", sectionDetails: menusectionprofile)
        
        
        let menumoreactiondata1 = MenuSections(name: "Create Event", image: "createEventIcon", viewcontroller: "toCreateEventVC")
        let menumoreactiondata2 = MenuSections(name: "Close/Cancel Event.", image: "paymentInfoIcon", viewcontroller: "toAddBankAccountVC")
        
        menusectionmoreactions.append(menumoreactiondata1)
        menusectionmoreactions.append(menumoreactiondata2)
        
        let menudata1 = MenuData(sectionName: "MORE ACTIONS", sectionDetails: menusectionmoreactions)
        
       
        
        let menunotificationdata1 = MenuSections(name: "My Notifications", image: "notificationIcon", viewcontroller: "toMyNotificationVC")
        menusectionnotification.append(menunotificationdata1)
       
        let menusettingsdata1 = MenuSections(name: "My Settings", image: "mysettingicon", viewcontroller: "toMySettingsVC")
        menusectionnotification.append(menusettingsdata1)
        
        let menudata2 = MenuData(sectionName: "SETTINGS", sectionDetails: menusectionnotification)
        
        
        let menulogoutdata1 = MenuSections(name: "Log Out", image: "logoutIcon", viewcontroller: "toLoginVC")
        
        menusecdtionlogout.append(menulogoutdata1)
        let menudata3 = MenuData(sectionName: "LOG OUT", sectionDetails: menusecdtionlogout)
        
        
        menudata.append(menudata0!)
        menudata.append(menudata1!)
        menudata.append(menudata2!)
        menudata.append(menudata3!)
        
        
        
        
        print("menudata1 = \(menudata1)")
        //HomeScreenEventDataModel(eventCategory: "My Events", eventProperty: eventsownedmodel)
        
        //menudata.append(menudata1!)
//        
//        let menuData1 = MenuData(sectionName: "More Actions...", sectionDetails: [SectionData(name: "Create Event", image: "createEventIcon")])
//        
//         let menuData2 = MenuData(sectionName: "More Actions...", sectionDetails: [SectionData(name: "Add Payment Info", image: "paymentInfoIcon")])
//        
//         let menuData3 = MenuData(sectionName: "Settings...", sectionDetails: [SectionData(name: "Notifications", image: "notificationIcon")])
//         
//        let menuData4 = MenuData(sectionName: "Log Out...", sectionDetails: [SectionData(name: "LogOut", image: "logOutIcon")])
//         
//        menudata.append(menuData1)
//            menudata.append(menuData2)
//            menudata.append(menuData3)
//          menudata.append(menuData4)
//        
//
//        print("menu \(menudata)")
//        print("menu count\(menudata.count)")
          
//        let menu1 = MenuList(title: "Add Event")
//        let menu2 = MenuList(title: "Setting")
//        let menu3 = MenuList(title: "Add Bank Account")
//        let menu4 = MenuList(title:  "Notifications")
//        let menu5 = MenuList(title:  "Log Out")
//
//        tempMenu.append(menu1)
//        tempMenu.append(menu2)
//        tempMenu.append(menu3)
//        tempMenu.append(menu4)
//        tempMenu.append(menu5)
        
        
        
     
       // tableView.reloadData()
       
        print(menudata)
      }
    
    func displayData() {
        for data in menudata  {
           
//            print ("data.sectionName.count \(data.sectionName.count)")
//            print ("menu count = \(menudata.count)")
            
            
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")! as UITableViewCell
        
//        if(indexPath.row > menu.count-1){
//            return UITableViewCell()
//          }
//        else{

//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.tag = indexPath.row
//        let item = items[indexPath.row] //Thread 1: Fatal error: Index out of range
//        cell.textLabel?.text = item.title
//
//        return cell
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
        
        print("indexPath.row = \(indexPath.row)")
           //cell.textLabel?.text = mobileBrand[indexPath.section].modelName![indexPath.row]
        cell.menuName.text = menudata[indexPath.section].sectionDetails[indexPath.row].name
        
        if menudata[indexPath.section].sectionDetails[indexPath.row].name == "Profile" {
            print("PROFILE \(menudata[indexPath.section].sectionDetails[indexPath.row].name)")
            cell.menuImage.layer.cornerRadius = 20
            cell.menuImage.layer.masksToBounds = true
            cell.menuImage.image = UIImage(named: "dominic")
        } else {
            cell.menuImage.image = UIImage(named: menudata[indexPath.section].sectionDetails[indexPath.row].image!)
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
        if menudata[indexPath.section].sectionDetails[indexPath.row].name == "Log Out" {
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to Log Out?", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (action) in self.callLoginScreen()}))
            //alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler:  { action in self.performSegue(withIdentifier: "backToHome", sender: self) }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in self.deSelectReloadData()}))
            self.present(alert, animated: true)
        }
        else {
            performSegue(withIdentifier: menudata[indexPath.section].sectionDetails[indexPath.row].viewcontroller!, sender: self)
        }
        
    }

    /*let loginViewController = storyboard.instantiateViewControllerWithIdentifier("Login") as! UIViewController
    let homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeNav") as! UIViewController

    if isLoggedIn {
        self.window?.rootViewController = homeViewController
    }
    else {
        self.window?.rootViewController = loginViewController
    }*/
    
    
    
    func callLoginScreen() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        let window = UIApplication.shared.windows.first

        // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
        let nav = UINavigationController(rootViewController: loginVC!)
        window?.rootViewController = nav
        
        //self.navigationController?.popToRootViewController(animated: true)
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        //self.navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: { () -> Void in })
       self.dismiss(animated: true, completion: nil)
        self.present(controller, animated: true, completion: nil) */
         
       
//        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuTabViewController") as! MenuTabViewController
//        self.navigationController?.pushViewController(loginVC, animated: true)
       self.navigationController?.popToRootViewController(animated: true)
//
       
        
//
         
        
        //let newViewController =  LoginViewController()// MenuTabViewController()
        //self.navigationController?.pushViewController(newViewController, animated: true)
        //(newViewController, animated: true) //pushViewController(newViewController, animated: true)

        
//        let next:LoginViewController = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
//        self.navigationController?.pushViewController(next, animated: true)
//
        //let secondViewController:LoginViewController = LoginViewController()
//        let sec: LoginViewController = LoginViewController(nibName: nil, bundle: nil)
//        self.present(sec, animated: true, completion: nil)
        
        
        
//
//       let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//          if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "backToHome") as? LoginViewController  {
//
//              self.present(viewController, animated: true, completion: nil)
//        }
//
//        if let destVC = segue.destination as? UINavigationController,
//            let targetController = destVC.topViewController as? LoginViewController  {
//            //targetController.data = "hello from ReceiveVC !"
//        }
//
//        let destinationNavigationController = segue.destination as! UINavigationController
//        let targetController = destinationNavigationController.topViewController
//
        
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "LoginViewController", bundle: nil)
//        let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
//        self.present(balanceViewController, animated: true, completion: nil)
//
        //LoginViewController.modalPresentationStyle = .fullScreen
        
        
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//           if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "yourVcName") as? UIViewController {
//               self.present(viewController, animated: true, completion: nil)
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
                NextVC.profileId = profileId
                NextVC.token = token
                NextVC.paymentClientToken = paymentClientToken
          

                //if let indexPath = self.tableVi
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


            } else if(segue.identifier == "backToHome") {
//                      let NextVC = segue.destination as! LoginViewController
//                      NextVC.logout  = true
                        
                    let NextVC = segue.destination as! ProfileViewController
                        //targetController.data = "hello from ReceiveVC !"
                            //NextVC.logout  = true
                NextVC.profileId = profileId!
                    NextVC.token = token!
                            
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
