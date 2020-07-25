//
//  MenuViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
  

    
    
    //@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelTest: UILabel!
    var profileId: Int64?
    var token: String?
    
    var tableArray = ["Create Event", "Add Bank Account", "Settings", "Notification", "Log Out"]
    var segueIdentifiers = ["A", "B", "C", "D"]
    
    var menulists: [MenuList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //labelTest.text = displayString!
        
        //labelTest.text = String(profileId!)
        //call MenuListData function arry
        //and set it equal to the menulist object
        menulists = MenuListData()
        
        //tableView.delegate = self
        //tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        menulists = MenuListData()
        
    }
    func MenuListData () -> [MenuList] {
          
          var tempMenu: [MenuList] = []
          
        let menu1 = MenuList(title: "Add Event")
        let menu2 = MenuList(title: "Setting")
        let menu3 = MenuList(title: "Add Bank Account")
        let menu4 = MenuList(title:  "Notifications")
        let menu5 = MenuList(title:  "Log Out")
        
        tempMenu.append(menu1)
        tempMenu.append(menu2)
        tempMenu.append(menu3)
        tempMenu.append(menu4)
        tempMenu.append(menu5)
        
        return tempMenu
          
      }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")! as UITableViewCell
        cell.textLabel?.text = tableArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableArray[indexPath.row] == "Log Out" {
            let alert = UIAlertController(title: "Log Out", message: "Ready to logout?", preferredStyle: .actionSheet)

                             alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                                     self.callLoginScreen()
                             }))
                             alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                             self.present(alert, animated: true)
                             print("Balance is Zero")
        }
        else {
            performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
        }
        
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Menu"
    }
    
    func callLoginScreen() {
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
       let mainStoryboard = UIStoryboard(name: "login", bundle: Bundle.main)
          if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "login") as? LoginViewController  {
              self.present(viewController, animated: true, completion: nil)
        }
        
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

extension MenuViewController{
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "A" {
                let NextVC = segue.destination as! CreateEventViewController
                NextVC.profileId = profileId
                NextVC.token = token
                

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
