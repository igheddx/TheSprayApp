//
//  Menu2TableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 2/19/22.
//  Copyright © 2022 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class Menu2TableViewCell: UITableViewCell {

    //var customCellDelegate: MyCustomCellDelegator?
    static let identifier = "Menu2TableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "Menu2TableViewCell", bundle: nil)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
