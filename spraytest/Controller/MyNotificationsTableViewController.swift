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
    
    @IBOutlet weak var cashRegisterSoundSwitch: UISwitch!
    
    @IBOutlet weak var coinDropSoundSwitch: UISwitch!
    
    @IBOutlet weak var alertMeWhenEventEndsSwitch: UISwitch!
    
    @IBOutlet weak var alertMeWhenGiftDepositedSwitch: UISwitch!
    @IBOutlet weak var alertMeWhenRSVPSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let defaults = UserDefaults.standard
        let isCashRegisterSound = defaults.bool(forKey: "isCashRegisterSound")
        if isCashRegisterSound == false {
            cashRegisterSoundSwitch.isOn = false
            //coinDropSoundSwitch.isOn = true
        } else {
            cashRegisterSoundSwitch.isOn = true
           // coinDropSoundSwitch.isOn = false
        }
        
        
        let isCoinDropSound = defaults.bool(forKey: "isCoinDropSound")
        if isCoinDropSound == false {
            coinDropSoundSwitch.isOn = false
            //cashRegisterSoundSwitch.isOn = true
        } else {
            coinDropSoundSwitch.isOn = true
            //cashRegisterSoundSwitch.isOn = false
        }
        
        
//        let isAlertMeWhenRSVP = defaults.bool(forKey: "isAlertMeWhenRSVP")
//        if isAlertMeWhenRSVP == false {
//            alertMeWhenRSVPSwitch.isOn = false
//        } else {
//            alertMeWhenRSVPSwitch.isOn = true
//        }
        
        
        //let useTouchID = defaults.bool(forKey: "UseTouchID")
        //let pi = defaults.double(forKey: "Pi")
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    
    @IBAction func cashRegisterSwitchSelected(_ sender: Any) {
        if ((sender as AnyObject).isOn == true) {
            defaults.set(true, forKey: "isCashRegisterSound")
            
            defaults.set(false, forKey: "isCoinDropSound")
            cashRegisterSoundSwitch.isOn = true
            coinDropSoundSwitch.isOn = false
        } else if ((sender as AnyObject).isOn == false) {
            defaults.set(false, forKey: "isCashRegisterSound")
            
            defaults.set(true, forKey: "isCoinDropSound")
            coinDropSoundSwitch.isOn = true
            cashRegisterSoundSwitch.isOn = false
        }
    }
    
    @IBAction func coinDropSwitchSelected(_ sender: Any) {
        if ((sender as AnyObject).isOn == true) {
            defaults.set(true, forKey: "isCoinDropSound")
            coinDropSoundSwitch.isOn = true
            
            defaults.set(false, forKey: "isCashRegisterSound")
            cashRegisterSoundSwitch.isOn = false
          
        } else if ((sender as AnyObject).isOn == false) {
            defaults.set(false, forKey: "isCoinDropSound")
            coinDropSoundSwitch.isOn = false
            
            defaults.set(true, forKey: "isCashRegisterSound")
            cashRegisterSoundSwitch.isOn = true
        }
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
