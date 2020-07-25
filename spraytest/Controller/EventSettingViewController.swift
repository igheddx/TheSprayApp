//
//  EventSettingViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/22/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class EventSettingViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    
    var eventName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("my event name = \(eventName)")
       eventNameLabel?.text = eventName
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPaymentButtonPressed(_ sender: Any) {
        
        // self.performSegue(withIdentifier: "addPaymentVC", sender: nil)
        performSegue(withIdentifier: "addPaymentVC", sender: self)
                   // self.dismiss(animated: true, completion: nil)
        
        
//        let addPaymentVC = self.storyboard?.instantiateViewController(withIdentifier: "addPaymentVC") as! AddPaymentViewController
//                                 self.navigationController?.pushViewController(addPaymentVC , animated: true)
//                                
                                  //selectRSVPVC.eventName = theEventName
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //                           if(segue.identifier == "nextVC"){
        //                               let NextVC = segue.destination as! MenuTabViewController
        //                            NextVC.profileId = Int64(profileId!)
        //                            NextVC.token = token2pass
        //                          displayVC.token = token2pass
        //                          displayVC.userdata = userdata
        // }
        
    }

}
