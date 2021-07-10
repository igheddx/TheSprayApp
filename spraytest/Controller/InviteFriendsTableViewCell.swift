//
//  InviteFriendsTableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 6/25/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class InviteFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarInitial: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    var name: String =  ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //avatarInitial.image = imageWith(name: name)
        
        print("MY LABEL = \(name)")
        avatarInitial.layer.borderWidth = 1
        avatarInitial.layer.masksToBounds = false
        avatarInitial.layer.borderColor = UIColor(red: 30/256, green: 174/256, blue: 152/256, alpha: 1.0).cgColor //UIColor.black.cgColor
        avatarInitial.layer.cornerRadius = avatarInitial.frame.height/2
        avatarInitial.clipsToBounds = true
        
        
       
    }
    
    //public func configure
    public func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.layer.cornerRadius = nameLabel.frame.height/2
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor(red: 30/256, green: 174/256, blue: 152/256, alpha: 1.0)
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
