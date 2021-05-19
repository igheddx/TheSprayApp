//
//  EventMetricDetailsViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 12/5/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit

struct EventStatsDetail: Model {
    var eventId: Int64
    var numInvitees: Int
    var numAttendees: Int
    var numSprayTransactions: Int
    var totalAmountGifted: Int
    var success: Bool
    var errorCode: String?
    var errorMessage: String?
}
struct EventsStatsTableData {
    var metricNum: String
    var metricName: String
}

class EventMetricDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var paymentClientToken: String?
    var eventTypeIcon: String?
    var eventId: Int64 = 0
    var ownerId: Int64 = 0
    var profileId: Int64 = 0
    var token: String = ""
    var encryptedAPIKey: String = ""
    var eventsstatstabledata = [EventsStatsTableData]()
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventCodeLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
  
    
    //    @IBOutlet weak var numberOfInviteesLabel: UILabel!
//    @IBOutlet weak var inviteesDescLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "Event Metrics"
   
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        eventNameLabel.text = eventName
        eventDateTimeLabel.text = eventDateTime
        //eventCodeLabel.text = eventCode
        eventImage.image = UIImage(named: eventTypeIcon!)
        getEventDetailMetrics()
        // Do any additional setup after loading the view.
    }
    
    func getEventDetailMetrics() {
      
        let request = Request(path: "/api/Event/stats/\(eventId)", token: token, apiKey: encryptedAPIKey)
               
        Network.shared.send(request) { [self] (result: Result<EventStatsDetail, Error>)  in
            switch result {
            case .success(let eventStats):
                
                let numAttendees = eventStats.numAttendees
                let numInvitees = eventStats.numInvitees
                let totalAmountGifted = eventStats.totalAmountGifted
                let numSprayTransactions = eventStats.numSprayTransactions
                
                
                let data1 = EventsStatsTableData(metricNum: String(numAttendees), metricName: "Attendees")
                let data2 = EventsStatsTableData(metricNum: String(numInvitees), metricName: "Invited")
                let data3 = EventsStatsTableData(metricNum: String("$\(totalAmountGifted)"), metricName: "Gifted")
                
                let data4 = EventsStatsTableData(metricNum: String(numSprayTransactions), metricName: "Spray Transactions")
                
                eventsstatstabledata.append(data1)
                eventsstatstabledata.append(data2)
                eventsstatstabledata.append(data3)
                eventsstatstabledata.append(data4)
            //                self.numberOfInviteesLabel.text = String(eventStats.numInvitees)
//                self.inviteesDescLabel.text = "Invitees"
                //
                //"numInvitees": 5,
//                    "numAttendees": 3,
//                    "numSprayTransactions": 4,
//                    "totalAmountGifted": 1136,
//                    "success": true,
//                    "errorCode": null,
//                    "errorMessage": null
                tableView.reloadData()
            case .failure(let error):
                    print(" DOMINIC IGHEDOSA ERROR 2 \(error.localizedDescription)")
            }
        }
            

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsstatstabledata.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cell)
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventMetricDetailsTableViewCell") as! EventMetricDetailsTableViewCell
        
        cell.metricsNumbersLabel.text = String(eventsstatstabledata[indexPath.row].metricNum)
        cell.metricNameLabel.text = eventsstatstabledata[indexPath.row].metricName
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
