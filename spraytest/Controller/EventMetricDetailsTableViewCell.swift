//
//  EventMetricDetailsTableViewCell.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/6/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class EventMetricDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var metricsNumbersLabel: UILabel!
    @IBOutlet weak var metricNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
