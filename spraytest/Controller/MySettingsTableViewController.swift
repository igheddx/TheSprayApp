//
//  MySettingsTableViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 10/18/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class MySettingsTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var keepGiftBalanceSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keepGiftBalance = defaults.bool(forKey: "keepGiftBalance")
        if keepGiftBalance == false {
            keepGiftBalanceSwitch.isOn = false
        } else {
            keepGiftBalanceSwitch.isOn = true
        }
    }
    
    @IBAction func keepGiftBalanceSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            defaults.set(true, forKey: "keepGiftBalance")
        } else if (sender.isOn == false) {
            defaults.set(false, forKey: "keepGiftBalance")
        }
    }
    
}
