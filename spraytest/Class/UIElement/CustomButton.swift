//
//  CustomButton.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 10/19/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class SelectPaymentButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
//    layer.borderColor = UIColor(red: 169/256, green: 169/256, blue: 169/256, alpha: 1.0 ).cgColor
//    layer.borderWidth = 1.0
//    layer.cornerRadius = 3.0
        
        setTitleColor(UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0), for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 1.0
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        //layer.borderWidth = 1
        layer.borderColor =  UIColor(red: 169/256, green: 169/256, blue: 169/256, alpha: 1.0 ).cgColor //UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0).cgColor
        //138,196,208
        
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
class EventUIView: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
    //layer.borderColor  = UIColor.lightGray.cgColor
    layer.shadowOffset = CGSize(width: 1, height: 1.0)
    layer.shadowOpacity  = 0.5
    layer.masksToBounds = false
    layer.cornerRadius = 3.0
    backgroundColor = UIColor(red: 244/256, green: 209/256, blue: 96/256, alpha: 1.0)
        //244209,96
    }
}
class RSVPYesBtn: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 0.5 * self.bounds.size.width
        //self.frame.height / 2
        //backgroundColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        clipsToBounds = true
        layer.borderColor = UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor
        //tintColor = UIColor.white
        //myButton.setTitle("Connect With Facebook", for: .normal)
        
        
        setTitleColor(UIColor.black, for: .normal)
        backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 255/256, alpha: 1.0)
        layer.borderWidth = 2.0
        
        self.frame = CGRect.init(x: 132, y: 205, width: 100, height: 100)
        //myAvatar.backgroundColor = UIColor.black
        self.contentMode =  UIView.ContentMode.scaleToFill// ScaleToFill
        
        
//
//        setTitleColor(UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0), for: .normal)
//        //layer.cornerRadius = 6
//        //backgroundColor = UIColor.red
//        layer.borderWidth = 1.0
//        //borderColor = UIColor.black
//
//        //layer.cornerRadius = 10
//        //layer.masksToBounds = true
//        //layer.borderWidth = 1
//        layer.borderColor = UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor
//        //old UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0).cgColor
//
//        //61, 126, 166 – Hcolor
//        backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 255/256, alpha: 1.0)
//        layer.cornerRadius = 4
//        layer.shadowColor = UIColor.white.cgColor
//        layer.shadowOffset = CGSize(width: 2, height: 2)
//        layer.shadowRadius = 1
//        layer.shadowOpacity = 0.5
//        layer.masksToBounds = true
    }
}

class RSVPNoBtn: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 0.5 * self.bounds.size.width
        //self.frame.height / 2
        //backgroundColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        clipsToBounds = true
        layer.borderColor =  UIColor(red: 178/256, green: 9/256, blue: 18/256, alpha: 1.0).cgColor
        //tintColor = UIColor.white
        //myButton.setTitle("Connect With Facebook", for: .normal)
        
        
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 255/256, alpha: 1.0)
        layer.borderWidth = 2.0
        
        self.frame = CGRect.init(x: 132, y: 390, width: 100, height: 100)
        //myAvatar.backgroundColor = UIColor.black
        self.contentMode =  UIView.ContentMode.scaleToFill// ScaleToFill
//        setTitleColor(UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0), for: .normal)
//        //layer.cornerRadius = 6
//        //backgroundColor = UIColor.red
//        layer.borderWidth = 1.0
//        //borderColor = UIColor.black
//
//        //layer.cornerRadius = 10
//        //layer.masksToBounds = true
//        //layer.borderWidth = 1
//        layer.borderColor =  UIColor(red: 178/256, green: 9/256, blue: 18/256, alpha: 1.0).cgColor
//
//        //61, 126, 166 – Hcolor
//
//        layer.cornerRadius = 4
//        layer.shadowColor = UIColor.white.cgColor
//        layer.shadowOffset = CGSize(width: 2, height: 2)
//        layer.shadowRadius = 1
//        layer.shadowOpacity = 0.5
//        layer.masksToBounds = true
    }
}

class MainActionBtn : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        //setTitleColor(UIColor.white, for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
//        layer.borderWidth = 0.5
//        //borderColor = UIColor.black
//40
//        //layer.cornerRadius = 10
//        //layer.masksToBounds = true
//
//        //61, 126, 166 – Hcolor
//        backgroundColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
//        layer.cornerRadius = 4
//        layer.shadowColor = UIColor.white.cgColor
//        layer.shadowOffset = CGSize(width: 2, height: 2)
//        layer.shadowRadius = 1
//        layer.shadowOpacity = 0.5
//        layer.masksToBounds = true
        
        
        
        layer.cornerRadius = self.frame.height / 2
        backgroundColor = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)
            //UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        clipsToBounds = true
        tintColor = UIColor.white
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        

        
        
    }
}
class Switch1 : UISwitch{
    override func awakeFromNib() {
        super.awakeFromNib()
            self.onTintColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        self.tintColor = .lightGray
        
    }
}

class PayoutBtn : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.frame.height / 2
        backgroundColor = UIColor(red: 235/256, green: 94/256, blue: 11/256, alpha: 1.0)
        clipsToBounds = true
        tintColor = UIColor.white
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)

    }
}

class SecondaryActionBtn : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.frame.height / 2
        backgroundColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        clipsToBounds = true
        tintColor = UIColor.white
        //myButton.setTitle("Connect With Facebook", for: .normal)
        
        
        setTitleColor(UIColor.white, for: .normal)

    }
}

class CircularImage: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        frame = CGRect.init(x: 8, y: 41, width: 90, height: 90)
        //myAvatar.backgroundColor = UIColor.black
        contentMode =  UIView.ContentMode.scaleToFill// ScaleToFill
        layoutIfNeeded()
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.lightGray.cgColor //UIColor(red: 154/256, green: 211/256, blue: 188/256, alpha: 1.0).cgColor //UIColor.black.cgColor
        layer.cornerRadius = frame.height/2
       clipsToBounds = true
    }
}
class CircleActionBtn : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 0.5 * self.bounds.size.width
        //self.frame.height / 2
        backgroundColor = UIColor(red: 40/256, green: 82/256, blue: 122/256, alpha: 1.0) //UIColor(red: 251/256, green: 238/256, blue: 172/256, alpha: 1.0)
        //251, 238, 172
        clipsToBounds = true
        //tintColor = UIColor.white
        //myButton.setTitle("Connect With Facebook", for: .normal)
        
        
        setTitleColor(UIColor.white, for: .normal)
//        //layer.cornerRadius = 6
//        //backgroundColor = UIColor.red
//        layer.borderWidth = 0.5
//        //borderColor = UIColor.black
//
//        //layer.cornerRadius = 10
//        //layer.masksToBounds = true
//
//        //61, 126, 166 – Hcolor
//        backgroundColor = UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
//        layer.cornerRadius = 4
//        layer.shadowColor = UIColor.white.cgColor
//        layer.shadowOffset = CGSize(width: 2, height: 2)
//        layer.shadowRadius = 5
//        layer.shadowOpacity = 0.5
//        layer.masksToBounds = true
    }
}

class NoNActiveActionButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0), for: .normal)
        //layer.cornerRadius = 6
        //backgroundColor = UIColor.red
        layer.borderWidth = 1.0
        //borderColor = UIColor.black
        
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        //layer.borderWidth = 1
        layer.borderColor =  UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0).cgColor
        //138,196,208
        
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
class ActiveActionButton: UIButton {
    
}
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
        backgroundColor = UIColor(red: 138/256, green: 196/256, blue: 208/256, alpha: 1.0)
            //UIColor(red: 61/256, green: 126/256, blue: 166/256, alpha: 1.0)
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
    
    


    var activityIndicator: UIActivityIndicatorView!

    let activityIndicatorColor: UIColor = .white

    func loadIndicator(_ shouldShow: Bool) {
        if shouldShow {
            if (activityIndicator == nil) {
                activityIndicator = createActivityIndicator()
            }
            self.isEnabled = false
            self.alpha = 0.7
            showSpinning()
        } else {
            activityIndicator.stopAnimating()
            self.isEnabled = true
            self.alpha = 1.0
        }
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        positionActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func positionActivityIndicatorInButton() {
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .trailing,
                                                   multiplier: 1, constant: 16)
        self.addConstraint(trailingConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }


}

class GoSpray : UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
//        setTitleColor(UIColor.white, for: .normal)
//        //layer.cornerRadius = 6
//        //backgroundColor = UIColor.red
//        layer.borderWidth = 0.5
//        //borderColor = UIColor.black
//        
//        //layer.cornerRadius = 10
//        //layer.masksToBounds = true
//        
//        //61, 126, 166 – Hcolor
//        backgroundColor = UIColor(red: 141/256, green: 181/256, blue: 150/256, alpha: 1.0)
//        layer.cornerRadius = 4
//        layer.shadowColor = UIColor.white.cgColor
//        layer.shadowOffset = CGSize(width: 2, height: 2)
//        layer.shadowRadius = 5
//        layer.shadowOpacity = 0.5
//        layer.masksToBounds = true
        
        layer.cornerRadius = self.frame.height / 2
        backgroundColor = UIColor(red: 235/256, green: 94/256, blue: 11/256, alpha: 1.0)
        clipsToBounds = true
        tintColor = UIColor.white
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
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
