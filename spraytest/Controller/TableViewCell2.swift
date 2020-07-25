//
//  TableViewCell2.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/21/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {
      @IBOutlet weak var eventNameLabel: UILabel!
       
       @IBOutlet weak var eventAddressLabel: UILabel!
       @IBOutlet weak var eventDateTimeLabel: UILabel!
       @IBOutlet weak var eventCityStateZipCountryLabel: UILabel!

       @IBOutlet weak var eventCodeLabel: UILabel!
       
       @IBOutlet weak var eventImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
