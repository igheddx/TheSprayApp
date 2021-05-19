//
//  SelectPersonToSprayTableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/1/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class SelectPersonToSprayTableViewCell: UITableViewCell {
    
    var myImage: String = ""
    var myName: String = ""
    var encryptedAPIKey: String = ""
    @IBOutlet weak var myProfileImage: UIImageView!
    @IBOutlet weak var receiverName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        myProfileImage.image = UIImage(named: "femaleprofile")
//        receiverName.text = myName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
