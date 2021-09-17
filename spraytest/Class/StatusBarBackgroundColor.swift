//
//  StatusBarBackgroundColor.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 7/12/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit
class StatusBarBackgroundColor {
    
//    guard #available(iOS 13, *) else {
//        return
//    }
    
    func setBackground() {
        if #available(iOS 13.0, *) {
                   let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                    statusBar.backgroundColor = UIColor.init(red: 244/255, green: 209/255, blue: 96/255, alpha: 1.0)
                    UIApplication.shared.keyWindow?.addSubview(statusBar)
            print("NOAH I")
           
            //rgb(244, 209, 96)
        } else {
                
            print("NAYLA ESE")
//            var statusBarManager: UIView? {
//                  return  value(forKey: "statusBarManager") as? UIView
//            }
                UIApplication.shared.statusBarManager?.backgroundColor = UIColor.init(red: 237/255, green: 85/255, blue: 61/255, alpha: 1.0)
        }
    }

    
   
}
