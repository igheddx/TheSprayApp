//
//  MainNavigationViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 9/17/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    //this method allow you to ask each controller for status bar style in navigation stack
    override var childForStatusBarStyle: UIViewController? {
           return self.topViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        UINavigationBar.appearance().barTintColor = UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)
//        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
//        //navigationController?.navigationBar.isHidden = false
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        //UINavigationBar.appearance().frame CGRect(x: 0, y: 0, width: 350, height: 0))
//        
//        //40,82,122
        
        
        UINavigationBar.appearance().barTintColor = .white
        //previous colore
        //UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1.0)]
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: ""), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "")
        

        
//        UINavigationBar.appearance().barTintColor = .white
//        //previous colore
//        //UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)
//        UINavigationBar.appearance().backgroundColor = .white
//        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)]
//        UINavigationBar.appearance().isTranslucent = false
//        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }

}
