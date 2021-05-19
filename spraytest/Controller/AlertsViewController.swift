//
//  AlertsViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/6/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileId: Int64 = 0
    var token: String = ""
    var encryptedAPIKey: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Alerts"
       
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
       
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func getAlerts() {
        ///api/Alert/myalerts/{profileid}
        let request = Request(path: "/api/Alerts/myalerts/\(profileId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
            case .success( _):
                    break
                     //print("rsvpattendees =\(self.rsvpAttendees)")
                case .failure(let error):
                    //self.textLabel.text = error.localizedDescription
                    print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlertsTableViewCell
        
        
        return cell
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
