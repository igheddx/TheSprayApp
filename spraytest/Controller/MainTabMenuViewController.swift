//
//  MainTabMenuViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/27/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class MainTabMenuViewController: UIViewController {
    
    var userName: String?
    var passWord: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let viewControllers = viewControllers else {
        return
    }
    

  if let a = viewControllers.first as? EventTableViewController {
                   // a.userName = userName
                    
                }
                
                // called whenever a tab button is tapped
                   func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

                       if let firstVC = viewController as? HomeScreenViewController {
                           //firstVC.doSomeAction()
                        //firstVC.popoverPresentationController
                        firstVC.navigationController?.popToRootViewController(animated: true)
                            //self.navigationController?.popToRootViewControllerAnimated(true)
                       }

    //                   if viewController is FirstViewController {
    //                       print("First tab")
    //                   } else if viewController is SecondViewController {
    //                       print("Second tab")
    //                   }
                   }

                   // alternate method if you need the tab bar item
                func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
                       // ...
                    print("dominic")
                   }
                
    //
    //            for viewController in viewControllers {
    //                if let a = viewController as? MenuTableViewController {
    //                    if let b = a.
    //                    a.userName  = userName
    //                    a.password = passWord
    //                }
    //
    ////                if let profileNavigationController = viewController as? MenuTableViewController{
    ////                    if let profileViewController = profileNavigationController.viewControllers.first as? MenuTableViewController {
    ////                        profileViewController.userName = userName
    ////                        profileViewController.password = passWord
    //                    }
    //                }
    //            }
                
    }
    }
