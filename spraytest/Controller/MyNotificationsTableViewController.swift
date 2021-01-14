//
//  MyNotificationsTableViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 10/18/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import UIKit

class MyNotificationsTableViewController: UITableViewController {
   
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var alertMeWhenEventEndsSwitch: UISwitch!
    @IBOutlet weak var alertMeWhenGiftDepositedSwitch: UISwitch!
    @IBOutlet weak var alertMeWhenRSVPSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let defaults = UserDefaults.standard
        let isAlertMeWhenEventEnds = defaults.bool(forKey: "isAlertMeWhenEventEnds")
        if isAlertMeWhenEventEnds == false {
            alertMeWhenEventEndsSwitch.isOn = false
        } else {
            alertMeWhenEventEndsSwitch.isOn = true
        }
        
        
        let isAlertMeWhenGiftDeposited = defaults.bool(forKey: "isAlertMeWhenGiftDeposited")
        if isAlertMeWhenGiftDeposited == false {
            alertMeWhenGiftDepositedSwitch.isOn = false
        } else {
            alertMeWhenGiftDepositedSwitch.isOn = true
        }
        
        
        let isAlertMeWhenRSVP = defaults.bool(forKey: "isAlertMeWhenRSVP")
        if isAlertMeWhenRSVP == false {
            alertMeWhenRSVPSwitch.isOn = false
        } else {
            alertMeWhenRSVPSwitch.isOn = true
        }
        
        
        //let useTouchID = defaults.bool(forKey: "UseTouchID")
        //let pi = defaults.double(forKey: "Pi")
    }
    @IBAction func alertMeWhenEventEndsSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            defaults.set(true, forKey: "isAlertMeWhenEventEnds")
        } else if (sender.isOn == false) {
            defaults.set(false, forKey: "isAlertMeWhenEventEnds")
        }
    }
    

    
    @IBAction func alertMeWhenGiftDepositedSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            defaults.set(true, forKey: "isAlertMeWhenGiftDeposited")
        } else if (sender.isOn == false) {
            defaults.set(false, forKey: "isAlertMeWhenGiftDeposited")
        }
    }

    @IBAction func alertMeWhenRSVPSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            defaults.set(true, forKey: "isAlertMeWhenRSVP")
        } else if (sender.isOn == false) {
            defaults.set(false, forKey: "isAlertMeWhenRSVP")
        }
    }

}
