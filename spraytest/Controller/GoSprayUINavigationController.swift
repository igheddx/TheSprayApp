//
//  GoSprayUINavigationController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 3/21/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class GoSprayUINavigationController: UINavigationController {

    //this method allow you to ask each controller for status bar style in navigation stack
    override var childForStatusBarStyle: UIViewController? {
           return self.topViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = .yellow// UIColor(red: 155/256, green: 166/256, blue: 149/256, alpha: 1.0) //.white
        //previous colore
        //UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = .yellow //UIColor(red: 155/256, green: 166/256, blue: 149/256, alpha: 1.0) //.white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1.0)]
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: ""), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
