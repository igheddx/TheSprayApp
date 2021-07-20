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
    var eventId: Int64 = 0
    var eventType: String = ""
    var eventTypeIcon: String =  ""
    var myProfileData: [MyProfile] = []
    var dataTransferFrom = "transfer this string"
    var stripeOnboardingMessage: String = ""
    var encryptedAPIKey: String = ""
    var encryptedDeviceId: String = ""
    
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
                    //menuViewController.myProfileData = myProfileData
                    menuViewController.paymentClientToken = paymentClientToken
                    menuViewController.encryptedAPIKey = encryptedAPIKey
                    
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

        /*for viewController in viewControllers {
            if let menuTabViewController = viewController as? MenuTabViewController {
                if let loginViewController = menuTabViewController.viewControllers?.first as? ScannerViewController {
    //                    loginViewController.profileId = profileId
    //                    loginViewController.token = token
                }
            }
        }*/
        
                
        for viewController in viewControllers {
            
            if let homeNavigationController = viewController as? HomeNavigationViewController {
                if let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController {
                    homeViewController.profileId = profileId!
                    homeViewController.token = token
                    homeViewController.paymentClientToken = paymentClientToken
                    homeViewController.eventId = eventId
                    homeViewController.eventType = eventType
                    homeViewController.eventTypeIcon2 = eventTypeIcon
                    homeViewController.myProfileData = myProfileData
                    homeViewController.stripeOnboardingMessage = stripeOnboardingMessage
                    homeViewController.encryptedAPIKey = encryptedAPIKey
                    homeViewController.encryptedDeviceId = encryptedDeviceId
                }
            }
        }
        
        
        /*menu tab for getting to dashboard - hold for now 7/11
        for viewController in viewControllers {
            print("viewControllers = \(viewControllers)")
            if let dashboardNavigationController = viewController as? DashboardNavigationViewController {
                if let dashboardViewController =
                    
                    dashboardNavigationController.viewControllers.first as? QRScanner2ViewController {
                    
                    print("I AM HERE")
//                    dashboardViewController.profileId = profileId!
//                    dashboardViewController.token = token!
//                    dashboardViewController.paymentClientToken = paymentClientToken
//                    dashboardViewController.encryptedAPIKey = encryptedAPIKey
                    
                }
            }
        }*/
         
        
        
        /*use this to call join event scannerViewController*/
        for viewController in viewControllers {
            if let dashboardNavigationController = viewController as? DashboardNavigationViewController {
                if let dashboardViewController = dashboardNavigationController.viewControllers.first as? QRScanner2ViewController {
                    dashboardViewController.completionAction = "postloginscan"
                    dashboardViewController.profileId = profileId!
                    dashboardViewController.myProfileData = myProfileData
                    dashboardViewController.token = token!
                    dashboardViewController.encryptedAPIKey = encryptedAPIKey
//                    dashboardViewController.profileId = profileId!
//                    dashboardViewController.completionAction = "postloginscan"
//                    dashboardViewController.token = token!
//                    dashboardViewController.myProfileData = myProfileData
//                    //dashboardViewController.paymentClientToken = paymentClientToken
//                    dashboardViewController.encryptedAPIKey = encryptedAPIKey

                }
            }
        }
//
        /*
        for viewController in viewControllers {
            if let menuTabViewController = viewController as? MenuTabViewController {
                if let scanViewController = menuTabViewController.viewControllers?.first as? ScannerViewController {
    //                    loginViewController.profileId = profileId
    //                    loginViewController.token = token
                    scanViewController.profileId = profileId!
                    scanViewController.completionAction = "postloginscan"
                    scanViewController.token = token!
                    scanViewController.myProfileData = myProfileData
                    //dashboardViewController.paymentClientToken = paymentClientToken
                    scanViewController.encryptedAPIKey = encryptedAPIKey
                }
            }
        }*/
        
      
    
    }
}



