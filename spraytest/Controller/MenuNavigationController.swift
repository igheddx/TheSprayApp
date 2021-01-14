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
        //R:64, G:78, B:85
        //R:31, G:35, B:49
//        /236,244,243
        //R:32, G:106, B:93
        UINavigationBar.appearance().barTintColor = UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        //UINavigationBar.layoutIfNeeded()
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()
    }
}
