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
        
        UINavigationBar.appearance().barTintColor = .white
        //previous colore
        //UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1.0)]
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
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
