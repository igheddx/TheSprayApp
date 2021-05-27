//
//  Navigation.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/25/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class BackButtonOnNavBar<T: UIViewController> {
    let currentVC: UIViewController? = nil
    
    let screenSize: CGRect = UIScreen.main.bounds
   public func a () {
        print("Dominic Ighedosa")
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 35, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
        let image = UIImage(named: "closeicon")!.withRenderingMode(.alwaysOriginal)
        let doneItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(done))
           navItem.leftBarButtonItem = doneItem
           navBar.setItems([navItem], animated: false)
        currentVC?.view.addSubview(navBar)
        //self.view.addSubview(navBar)
    }
   
    @objc func done() {
        print("Done was clicked")
//        let loginVC =  instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
//        let window = UIApplication.shared.windows.first
//
//        // Embed loginVC in Navigation Controller and assign the Navigation Controller as windows root
//        let nav = UINavigationController(rootViewController: loginVC!)
//        window?.rootViewController = nav
//
//       self.navigationController?.popToRootViewController(animated: true)
    }
}

//func showAsPopUp<T: UIViewController>(currentVC: UIViewController,currentVCname: String, popupStoryboardID: String, popUpVC: T.type) {
//    let popOverVC = UIStoryboard(name: currentVCname, bundle: nil).instantiateViewController(withIdentifier: popupStoryboardID) as! T
//    currentVC.addChildViewController(popOverVC)
//}
