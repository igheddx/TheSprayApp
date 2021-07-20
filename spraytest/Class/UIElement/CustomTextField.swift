//
//  CustomTextField.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 11/24/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField {
//    let textField: String? 
//    let validationflag: Bool
//    
//    init(textField: String, validationFlag: Bool) {
//        self.textField = textField
//        self.validationflag = validationFlag
//    }
//
  
    
    func borderForLabel(label: UILabel) {
        label.layer.cornerRadius = 6.0
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor(red: 112/256, green: 112/256, blue: 112/256, alpha: 1.0 ).cgColor
        label.layer.borderWidth = 1.0
        //label. borderStyle = .none
    }
    
    func noBorderForTextField(textField: UITextField, validationFlag: Bool) {
        //no error
    
        textField.layer.cornerRadius = 6.0
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 255/256, green: 255/256, blue: 255/256, alpha: 1.0 ).cgColor
        textField.layer.borderWidth = 0.0
        textField.borderStyle = .none
        
   }

    
    func borderForTextField(textField: UITextField, validationFlag: Bool) {
        //no error
        if validationFlag == false {
            
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 154/256, green: 154/256, blue: 154/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
            textField.borderStyle = .none
        //yes error
        } else {
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 209/256, green: 13/256, blue: 13/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
            textField.borderStyle = .none
        }
   }


    func activeBorderForTextField(textField: UITextField, isActive: Bool) {
        //no error
        if isActive == false {
            
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 154/256, green: 154/256, blue: 154/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
            textField.borderStyle = .none
        //yes error
        } else {
            textField.layer.cornerRadius = 6.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor(red: 162/256, green: 213/256, blue: 242/256, alpha: 1.0 ).cgColor
            textField.layer.borderWidth = 1.0
            textField.borderStyle = .none
            //rgb(162, 213, 242)
            //rgb(64, 168, 196)
        }
   }
    
}


//this textfiled enlarges the cursor
class CustomTextField2: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect = CGRect(x: rect.origin.x+2, y: 4, width: 1, height: 35)
        return rect
    }
}
