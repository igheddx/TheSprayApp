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
            textField.layer.borderColor = UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1.0 ).cgColor
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

        
    
}
