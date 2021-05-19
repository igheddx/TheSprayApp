//
//  SceneDelegate.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 4/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
//    let stripeAccountOnboardingViewController = StripeAccountOnboardingViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //comment out 3/8 - not using
//        guard let _ = (scene as? UIWindowScene) else { return }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                guard let rootVC = storyboard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {
//                    print("ViewController not found")
//                    return
//                }
//                let rootNC = UINavigationController(rootViewController: rootVC)
//                self.window?.rootViewController = rootNC
//                self.window?.makeKeyAndVisible()
    }

//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//            if let url = URLContexts.first?.url {
//                print(url)
//                let urlStr = url.absoluteString //1
//                // Parse the custom URL as per your requirement.
//                let component = urlStr.components(separatedBy: "=") // 2
//                if component.count > 1, let appId = component.last { // 3
//                    print("appId = \(appId)")
//
//                    switch appId {
//                    case "onboardingok":
//                        window?.rootViewController = stripeAccountOnboardingViewController
//
//                        stripeAccountOnboardingViewController.handleDeepLink("onboardingok")
////                        let nextVC = storyboard?.instantiateViewController(withIdentifier: "StripeOnboardingOKViewController") as! StripeOnboardingOKViewController
////
////                            let topViewController = self.window?.rootViewController as? HomeNavigationViewController
////                            let currentVC = topViewController?.topViewController as? StripeOnboardingOKViewController
//                            print("i am onboarding ok")
////                        self.navigationController?.pushViewController(nextVC , animated: true)
//                    case "onboardingnotok":
////                        let topViewController = self.window?.rootViewController as? HomeNavigationViewController
////                        let currentVC = topViewController?.topViewController as? StripeOnboardingNotOKViewController
//                        print("nothing")
////                        let nextVC = storyboard?.instantiateViewController(withIdentifier: "StripeOnboardingNotOKViewController") as! StripeOnboardingNotOKViewController
//
//                    default:
//                        print("do nothing")
//                    }
//
////                    if appId == "onboardingok" {
////                        let topViewController = self.window?.rootViewController as? UINavigationController
////                        let currentVC = topViewController?.topViewController as? StripeOnboardingOKViewController
////                        //currentVC!.textforlbl = "Application Id : " + appId
////                    }
//
//                }
//            }
//        }
  
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

   func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            print("url = \(url)")
            let urlString = url.absoluteString
            print("urlString = \(urlString)")
            let component = urlString.components(separatedBy: "=")
            print(component)
            if component.count > 1, let status = component.last {
                print(status)
                if status == "complete" {
                    navigateToVC(vc: "complete")
                } else if status == "failed" {
                    navigateToVC(vc: "failed")
                }
                
            }
            
            //let url = "https://projectxclientapp.azurewebsites.net/stripe/Index?profileid=105&status=success&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjEwNSIsIm5iZiI6MTYxNjM1MjA2NCwiZXhwIjoxNjE2MzYyODY0LCJpYXQiOjE2MTYzNTIwNjR9.flvvgMc8HznlVaspZ¿qmOh9a6Cf3x-NaRhvH2k79aVI--"
           // let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            //"https://projectxclientapp.azurewebsites.net/stripe/Index?profileid=105&status=success&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjEwNSIsIm5iZiI6MTYxNjM1MjA2NCwiZXhwIjoxNjE2MzYyODY0LCJpYXQiOjE2MTYzNTIwNjR9.flvvgMc8HznlVaspZ¿qmOh9a6Cf3x-NaRhvH2k79aVI--"
            let urlStr = String(urlString) //"https://connect.stripe.com/setup/s/rj3P9V1UW0Ns"
            let index = urlStr.lastIndex(of: "/") ?? urlStr.endIndex
            let indexNoSpace = urlString.index(after: index)
            let range = indexNoSpace..<urlStr.endIndex

            let newURL = urlStr[range]
            print(newURL)
            
            
            let queryItems = URLComponents(string: "https://sprayapp.com/?\(newURL)")?.queryItems

            print("queryItems \(queryItems)")
            let profileid = queryItems?.filter({$0.name == "profileid"}).first
            let status = queryItems?.filter({$0.name == "status"}).first
            let  token = queryItems?.filter({$0.name == "token"}).first
            //let token = queryItems?.filter({$0.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) == "token"}).first

            print(profileid?.value)
            
            print(status?.value)
            print(token?.value)
            
            //if status == "complete" {
            launchVC(onboardingMessage: (status?.value)!, profileId: (profileid?.value)!, token: (token?.value)!)
            //navigateToVC(vc: (status?.value)!)
            //} else if status == "failed" {
                //navigateToVC(vc: "failed")
            //}
        }
    }
    func launchVC(onboardingMessage: String, profileId: String, token: String){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        //if onboardingMessage == "success" {
            print("calling stripeOnboardingOK")
            guard  let nextVC = storyBoard.instantiateViewController(identifier: "MenuTabViewController") as? MenuTabViewController
            else  {return}
            let navVC = self.window?.rootViewController as?  MainNavigationViewController
            nextVC.profileId = Int64(profileId)!
            nextVC.token = token
            nextVC.paymentClientToken = ""
            nextVC.myProfileData = []
            nextVC.stripeOnboardingMessage = onboardingMessage
            navVC?.pushViewController(nextVC, animated: true)
            
//            let NextVC = segue.destination as! MenuTabViewController
//            NextVC.profileId = Int64(profileId!)
//            NextVC.token = token2pass
//            NextVC.paymentClientToken = paymentClientToken
//            NextVC.myProfileData = myprofiledata
       // }
          
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            nextVC.profileId = profileId
//            nextVC.token = token
//            nextVC.eventType =  theEventType
//            nextVC.eventOwnerId = theOwnerId
//
//           self.navigationController?.pushViewController(nextVC , animated: true)
//            dismiss(animated: true, completion: nil)
            

    }
    func navigateToVC(vc: String) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if vc == "success" {
            print("calling stripeOnboardingOK")
            guard  let nextVC = storyBoard.instantiateViewController(identifier: "StripeOnboardingOKViewController") as? StripeOnboardingOKViewController
            else  {return}
            let navVC = self.window?.rootViewController as? MainNavigationViewController
            nextVC.lbldesc = "onboarding was successful - StripeOnboardingOKViewController"
            navVC?.pushViewController(nextVC, animated: true)
            
            //self.navigationController?.pushViewController(nextVC , animated: true)
            
        } else if vc == "failed" {
            guard  let nextVC = storyBoard.instantiateViewController(identifier: "StripeOnboardingNotOKViewController") as? StripeOnboardingNotOKViewController
            else  {return}
            let navVC = self.window?.rootViewController as? MainNavigationViewController
            nextVC.lbldesc = "onboarding was not successful - StripeOnboardingNotOKViewController"
            navVC?.pushViewController(nextVC, animated: true)
        }
        
    }
    

}

