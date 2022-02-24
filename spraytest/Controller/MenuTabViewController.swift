//
//  MenuTabViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/27/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class MenuTabViewController: UITabBarController, UITabBarControllerDelegate {
    
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
    var eventOwnerId: Int64 = 0
    var eventOwnerName: String = ""
    var isRefreshData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tabBarController?.delegate = self
        self.delegate = self
        
        guard let viewControllers = viewControllers else {
                return
        }
            
        for viewController in viewControllers {
            if let menuNavigationController = viewController as? MenuNavigationController {
                print("Tab Bar A")
                if let menuViewController = menuNavigationController.viewControllers.first as? Menu2ViewController {
                    print("Tab Bar B")
                    menuViewController.profileId = profileId
                    menuViewController.token = token
                    //menuViewController.myProfileData = myProfileData
                    menuViewController.paymentClientToken = paymentClientToken
                    menuViewController.encryptedAPIKey = encryptedAPIKey
                    menuViewController.myProfileData = myProfileData
                    
                }
            }
        }
            
            //go to login windows
        for viewController in viewControllers {
            print("Tab Bar C")
            if let menuTabViewController = viewController as? MenuTabViewController {
                print("Tab Bar D")
                if let loginViewController = menuTabViewController.viewControllers?.first as? LoginViewController {
    //                    loginViewController.profileId = profileId
    //                    loginViewController.token = token
                    print("Tab Bar E")
                } else if let QRViewController = menuTabViewController.viewControllers?.first as? QRScanner3ViewController {
                   // print("my completion ACT  \()")
                    print("Tab Bar F")
                    QRViewController.completionAction = "postloginscan"
                    QRViewController.profileId = profileId!
                    QRViewController.myProfileData = myProfileData
                    QRViewController.token = token!
                    QRViewController.encryptedAPIKey = encryptedAPIKey
                }
                
            } else  {
                print(" WASIU VC = \(viewController) D " )
                print("Tab Bar G")
                if let homeNavigationController = viewController as? HomeNavigationViewController {
                    print("Tab Bar GG")
                    if let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController {
                        print("Tab Bar GGG")
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
                    }   else if let QRViewController = homeNavigationController.viewControllers.first as? QRScanner3ViewController {
                        print("Tab Bar H")
                        QRViewController.completionAction = "postloginscan"
                        QRViewController.profileId = profileId!
                        QRViewController.myProfileData = myProfileData
                        QRViewController.token = token!
                        QRViewController.encryptedAPIKey = encryptedAPIKey
                    }
                }
            }
        }

        
        //go to login windows
    for viewController in viewControllers {
        print("Tab Bar CCC")
     
        if let QR = viewController as? QRScanner3ViewController{
            
          // print("my completion ACT  \()")
            print("Tab Bar FFF = \(paymentClientToken)")
            QR.completionAction = "postloginscan"
            QR.profileId = profileId!
            QR.myProfileData = myProfileData
            QR.token = token!
            QR.encryptedAPIKey = encryptedAPIKey
            QR.paymentClientToken = paymentClientToken
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
                print("Tab Bar I")
                if let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController {
                    print("Tab Bar J")
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
                }   else if let QRViewController = homeNavigationController.viewControllers.first as? QRScanner3ViewController {
                    print("Tab Bar K")
                    QRViewController.completionAction = "postloginscan"
                    QRViewController.profileId = profileId!
                    QRViewController.myProfileData = myProfileData
                    QRViewController.token = token!
                    QRViewController.encryptedAPIKey = encryptedAPIKey
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
         
        
        
        //use this to call join event scannerViewController
        for viewController in viewControllers {
            if let dashboardNavigationController = viewController as? DashboardNavigationViewController {
                if let dashboardViewController = dashboardNavigationController.viewControllers.first as? QRScanner3ViewController {
                    
                    print("CALLED QRScanner2ViewController")
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
        
        for viewController in viewControllers {
            if let menuTabViewController = viewController as? MenuTabViewController {
                print("Tab Bar M")
                if let scanViewController = menuTabViewController.viewControllers?.first as? QRScanner3ViewController {
                    print("Tab Bar N")
    //                    loginViewController.profileId = profileId
    //                    loginViewController.token = token
                    scanViewController.profileId = profileId!
                    scanViewController.completionAction = "postloginscan"
                    scanViewController.token = token!
                    scanViewController.myProfileData = myProfileData
                    //dashboardViewController.paymentClientToken = paymentClientToken
                    scanViewController.encryptedAPIKey = encryptedAPIKey
                    
//                    dashboardViewController.completionAction = "postloginscan"
//                    dashboardViewController.profileId = profileId!
//                    dashboardViewController.myProfileData = myProfileData
//                    dashboardViewController.token = token!
//                    dashboardViewController.encryptedAPIKey = encryptedAPIKey
//
                }
            }
        }
        
      
    
    }
    
    // UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("Selected item")
        print("Tab Bar O")
    }

    // UITabBarControllerDelegate
    private func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected view controller")
        print("Tab Bar P")
    }
    
    
   
}



