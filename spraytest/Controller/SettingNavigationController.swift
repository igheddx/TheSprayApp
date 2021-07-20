//
//  SettingNavigationController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/23/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class SettingNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*UINavigationBar.appearance().barTintColor = .white
        //previous colore
        //UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1.0)]
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: ""), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "")*/
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 244/256, green: 209/256, blue: 96/256, alpha: 1.0)
            //UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .black //UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)//UIColor(red: 244/256, green: 209/256, blue: 96/256, alpha: 1.0)
             //.black
        UINavigationBar.appearance().backgroundColor = UIColor(red: 244/256, green: 209/256, blue: 96/256, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().isTranslucent = false
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
