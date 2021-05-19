//
//  AppDelegate.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 4/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import Stripe
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterDistribute

@main
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var mydeeplink:  MyDeepLink?
    
    var window: UIWindow?
    let stripeAccountOnboardingViewController = StripeAccountOnboardingViewController()
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AppCenter.start(withAppSecret: "ec81818c-6d8c-452d-9011-85b7ecbf8a5e", services:[
          Analytics.self,
            Crashes.self, Distribute.self
        ])
        
        StripeAPI.defaultPublishableKey = "pk_test_51I4w7tH6yOvhR5k1FrjaRKUcGG3LLzcuTx1LOWJj6bprUylHErpYHXsSRFxfdepAxz3KDbPLp2cDjpP54AWdc9qG00C8jcO2o4" //"pk_test_TYooMQauvdEDq54NiTphI7jx"
        
//        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.backgroundColor = .systemBackground
//        //When your app starts, configure the SDK with your Stripe publishable key so that it can make requests to the Stripe API.
//        
//        window?.rootViewController = stripeAccountOnboardingViewController
//        print("IGHEDOSA AWELE CONSTANCE CHINYE")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        /*
//         
//         <scheme>://<host>
//         thesprayapp://onboardingOk
//         thesprayapp://onboardingNotOk
//         
//         */
//         
//        print("I GOT TO THE APP DELEGATE URL")
//        //process the URL.
//        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
//            print("invalid URL")
//            return false
//        }
//        
//        print("components: \(components)")
//        
//        //create the deep link
//        guard let deepLink = DeepLink(rawValue: host) else {
//            print("Deeplink not found: \(host)")
//            return false
//        }
//        
//        print("IGHEDOSA delegate was called")
//        //mydeeplink?.deepLink(deeplink: deepLink)
//        print("deepLink = \(deepLink)")
//        //hand off to mainviewController
//        //StripeAccountOnboardingViewController.handleDeepLink(deepLink)
//        //handleDeepLink(deepLink)
//        stripeAccountOnboardingViewController.handleDeepLink(deepLink)
//        
//        return true
//    }
//  

//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        print("url \(url)")
//        print("url host :\(url.host!)")
//        print("url path :\(url.path)")
//        
//        let urlPath : String = (url.path as String?)!
//        let urlHost : String = (url.host as String?)!
//        let mainStoryboard: UIStoryboard = UIStoryboard(name:
//            "Main", bundle: nil)
//        
//        if (urlHost != "sprayapp.com") {
//            print("host is not correct")
//            return false
//        }
//        if(urlPath == "/inner") {
//            let innerPage: StripeOnboardingOKViewController = mainStoryboard.instantiateViewController(withIdentifier: "StripeOnboardingOKViewController" ) as! StripeOnboardingOKViewController
//            innerPage.lbldesc = "We made its"
//            self.window?.rootViewController = innerPage
//        } else if (urlPath == "/about") {
//            print("nOTHING HAPPENED")
//        }
//        self.window?.makeKeyAndVisible()
//        return true
//    }
      
}

