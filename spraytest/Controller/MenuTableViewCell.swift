//
//  MenuTableViewCell.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItemLabel: UILabel!
    
    func setMenuList(menuitem: MenuList){
        
        menuItemLabel.text = menuitem.title
    
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
