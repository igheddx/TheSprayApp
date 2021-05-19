//
//  AddPaymentViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/24/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//
import BraintreeDropIn
import Braintree
import UIKit

class AddPaymentViewController: UIViewController {

    var token: String = ""
    var paymentClientToken: String?
    var eventName: String = ""
    var encryptedAPIKey: String = ""
       let clientToken = "CLIENT_TOKEN_FROM_SERVER"
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBAction func buttonPressed(_ sender: Any) {
        showDropIn(clientTokenOrTokenizationKey: paymentClientToken!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventNameLabel.text = eventName
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
 
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                let paymentOption = result.paymentOptionType
                let paymentMethod = result.paymentMethod
                let paymentIcon = result.paymentIcon
                let paymentDescription = result.paymentDescription
                
                print("paymentOption= \(paymentOption.rawValue)")
                print("paymentMethod! = \(paymentMethod!.nonce)")
                print("paymentIcon = \(paymentIcon)")
                print("paymentDescription = \(paymentDescription)")
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
