//
//  MenuNavigationController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 6/3/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class MenuNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* comment this out for now UINavigationBar.appearance().barTintColor = .white
        //previous colore
        //UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1.0)]
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: ""), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "") */
        
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 244/256, green: 209/256, blue: 96/256, alpha: 1.0)
            //UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .black //UIColor(red: 244/256, green: 209/256, blue: 96/256, alpha: 1.0)
            //UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0) //.black
        UINavigationBar.appearance().backgroundColor = UIColor(red: 244/256, green: 209/256, blue: 96/256, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().isTranslucent = false
        
        //R:64, G:78, B:85
        //R:31, G:35, B:49
//        /236,244,243
        //R:32, G:106, B:93
//        UINavigationBar.appearance().barTintColor = UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)
//        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
//
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//
        //UINavigationBar.layoutIfNeeded()
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()
    }
}
