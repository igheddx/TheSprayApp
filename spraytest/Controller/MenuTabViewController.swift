//
//  MenuTabViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/27/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class MenuTabViewController: UITabBarController {
    
    var profileId: Int64?
    var token: String?
    var paymentClientToken: String = ""
    
    var dataTransferFrom = "transfer this string"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewControllers = viewControllers else {
                return
        }
            
        for viewController in viewControllers {
            if let menuNavigationController = viewController as? MenuNavigationController {
                if let menuViewController = menuNavigationController.viewControllers.first as? MenuViewController {
                    menuViewController.profileId = profileId
                    menuViewController.token = token
                    menuViewController.paymentClientToken = paymentClientToken
                }
            }
        }
            
            //go to login windows
        for viewController in viewControllers {
            if let menuTabViewController = viewController as? MenuTabViewController {
                if let loginViewController = menuTabViewController.viewControllers?.first as? LoginViewController {
    //                    loginViewController.profileId = profileId
    //                    loginViewController.token = token
                }
            }
        }

                
        for viewController in viewControllers {
            if let homeNavigationController = viewController as? HomeNavigationViewController {
                if let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController {
                    homeViewController.profileId = profileId
                    homeViewController.token = token
                    homeViewController.paymentClientToken = paymentClientToken
                }
            }
        }
        
        
        for viewController in viewControllers {
            if let dashboardNavigationController = viewController as? DashboardNavigationViewController {
                if let dashboardViewController = dashboardNavigationController.viewControllers.first as? DashboardViewController {
                    dashboardViewController.profileId = profileId!
                    dashboardViewController.token = token!
                    dashboardViewController.paymentClientToken = paymentClientToken
                }
            }
        }
    
    }
}



