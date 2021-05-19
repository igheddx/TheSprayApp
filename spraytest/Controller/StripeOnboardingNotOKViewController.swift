//
//  StripeOnboardingNotOKViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 3/6/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class StripeOnboardingNotOKViewController: UIViewController {

    @IBOutlet weak var displaylbl: UILabel!
    var lbldesc: String = ""
    var encryptedAPIKey: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        print("I AM HERE")
        displaylbl?.text = lbldesc
        // Do any additional setup after loading the view.
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
