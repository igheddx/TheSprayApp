//
//  SelectPersonToSpray2TableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/22/22.
//  Copyright © 2022 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class SelectPersonToSpray2TableViewCell: UITableViewCell {

    var myImage: String = ""
    var myName: String = ""
    var encryptedAPIKey: String = ""
//    @IBOutlet weak var myProfileImage: UIImageView!
//    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var myProfileImage: UIImageView!
    
    @IBOutlet weak var receiverName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        myProfileImage.image = UIImage(named: "femaleprofile")
//        receiverName.text = myName
        
        //print("MY LABEL = \(name)")
        myProfileImage.layer.borderWidth = 1
        myProfileImage.layer.masksToBounds = false
         //UIColor.black.cgColor
        myProfileImage.layer.cornerRadius = myProfileImage.frame.height/2
        myProfileImage.clipsToBounds = true
        
        
       
    }

    //public func configure
    public func imageWith(name: String?, isEventOwner: Bool) -> UIImage? {
        
        
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.layer.cornerRadius = nameLabel.frame.height/2
        nameLabel.textAlignment = .center
        if isEventOwner == true {
            nameLabel.backgroundColor = UIColor(red: 249/256, green: 132/256, blue: 4/256, alpha: 1.0)
            myProfileImage.layer.borderColor = UIColor(red: 249/256, green: 132/256, blue: 4/256, alpha: 1.0).cgColor

        } else {
            nameLabel.backgroundColor = UIColor(red: 30/256, green: 174/256, blue: 152/256, alpha: 1.0)
            myProfileImage.layer.borderColor = UIColor(red: 30/256, green: 174/256, blue: 152/256, alpha: 1.0).cgColor
        }
        
            //.lightGray
        //rgb(30, 174, 152)
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                    
                }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first {
                    initials += String(lastLetter).capitalized
                }
            }
        } else {
           return nil
        }
        
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
