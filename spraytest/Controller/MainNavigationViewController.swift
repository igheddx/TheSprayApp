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
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(red: 35/256, green: 9/256, blue: 98/256, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = UIColor(red: 35/256, green: 9/256, blue: 98/256, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "hairlinebackground"), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

}
