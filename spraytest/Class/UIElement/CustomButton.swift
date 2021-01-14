//
//  CustomButton.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 10/19/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit
class MyCustomButton : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.white, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 0.5
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        
        //61, 126, 166 – Hcolor
        backgroundColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}

class GoSpray : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.white, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 0.5
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        
        //61, 126, 166 – Hcolor
        backgroundColor = UIColor(red: 141/256, green: 181/256, blue: 150/256, alpha: 1.0)
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}
class GoSpraySecondary : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.black, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 0.5
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        //layer.borderWidth = 1
        layer.borderColor = UIColor(red: 141/256, green: 181/256, blue: 150/256, alpha: 1.0).cgColor
        
        //61, 126, 166 – Hcolor
        backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 255/256, alpha: 1.0)
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}


class MyCustomButtonRed : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.white, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 0.5
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        
        //61, 126, 166 – Hcolor
        backgroundColor = UIColor(red: 177/256, green: 23/256, blue: 23/256, alpha: 1.0)
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}


class MyCustomButton2 : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.black, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 0.5
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        //layer.borderWidth = 1
        layer.borderColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0).cgColor
        
        //61, 126, 166 – Hcolor
        backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 255/256, alpha: 1.0)
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}
class MyCustomButtonOld : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.black, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 0.5
        //layer.borderColor = UIColor(red: 191/256, green: 220/256, blue: 174/256, alpha: 1.0)
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        
        //61, 126, 166 – Hcolor
        //R:191, G:220, B:174
        //layer.borderColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0).cgColor
        
       // UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0) //UIColor.white.cgColor
        backgroundColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        
       //backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 255/256, alpha: 1.0)
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}

class MyCustomButton3 : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.white, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 0.5
        
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        
        //61, 126, 166 – Hcolor
        //R:191, G:220, B:174
        backgroundColor = UIColor(red: 129/256, green: 178/256, blue: 20/256, alpha: 1.0)
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}
