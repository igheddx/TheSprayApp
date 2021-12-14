//
//  HomeNavigationViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 6/6/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class HomeNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(red: 35/256, green: 9/256, blue: 98/256, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = UIColor(red: 35/256, green: 9/256, blue: 98/256, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barStyle = .black
        //UINavigationBar.appearance().setBackgroundImage(UIImage(named: "hairlinebackground"), for: .any, barMetrics: .default)
        //UINavigationBar.appearance().shadowImage = UIImage()
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: ""), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage(named: "")
//        
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

extension UINavigationController {

//    override open var preferredStatusBarStyle: UIStatusBarStyle {
//       return .lightContent
//    }
    var isHiddenHairline: Bool {
        get {
            guard let hairline = findHairlineImageViewUnder(navigationBar) else { return true }
            print("I WILL HIDE HAIRLINE - \( hairline.isHidden)")
            return hairline.isHidden
            
        }
        set {
            if let hairline = findHairlineImageViewUnder(navigationBar) {
                print("I WILL NOT HIDE HAIRLINE - \(newValue)")
                hairline.isHidden = newValue
            }
        }
    }

    private func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }

        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }

        return nil
    }
}

