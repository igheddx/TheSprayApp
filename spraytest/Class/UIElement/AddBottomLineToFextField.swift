//
//  AddBottomLineToFextField.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 6/7/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
////
//
//import Foundation
//
//class addBottomLineToTextField {
//    
//    let textField: String?
//    
//    init(textField: String) {
//        self.textField = textField
//    }
//    
//    func addBottomLineToTextField(textField: UITextField) {
//        
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
//        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
//        //red: 48/255, green: 173/255, blue: 99/255, apha: 1).cgColor
//        textField.borderStyle = .none
//        
//        textField.layer.addSublayer(bottomLine)
//        
//        //        let border = CALayer()
//        //          let borderWidth = CGFloat(1.0)
//        //          border.borderColor = UIColor.white.cgColor
//        //          border.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.size.width, height: 2)
//        //          border.borderWidth = borderWidth
//        //          textField.layer.addSublayer(border)
//        //          textField.layer.masksToBounds = true
//    }
//
//}
