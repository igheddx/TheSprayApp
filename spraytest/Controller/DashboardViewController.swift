//
//  DashboardViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/27/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Charts
import UIKit

struct MyEventsForDashboard {
    let eventId: Int64
    let eventName: String
    let eventDateTime: String
    let eventCode: String
    let eventTypeId: Int
}
class DashboardViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {
       
        

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var thePieChart: PieChartView!
    @IBOutlet weak var searchBar: UISearchBar!
    //var pieChart = PieChartView()
    
    var amountGifted = PieChartDataEntry(value: 0)
    var amountReceived = PieChartDataEntry(value: 0)
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    var searching = false
    //var pieChartEntries = [PieChartDataEntry]()
    //var pieChart = PieChartView()
    
    internal enum AttendeeType {
        case gifter
        case receiver
    }
    
//        @IBOutlet weak var eventImage: UIImageView!
//        @IBOutlet weak var eventCodeLabel: UILabel!
//        @IBOutlet weak var eventDateLabel: UILabel!
//        @IBOutlet weak var eventNameLabel: UILabel!
//        @IBOutlet weak var eventIdLabel: UILabel!
//        @IBOutlet weak var profileIdLabel: UILabel!
//
//        @IBOutlet weak var amountGiftedLabel: UILabel!
//
//        @IBOutlet weak var amountReceivedLabel: UILabel!
    var eventId: Int64?
    var profileId: Int64?
    var token: String = ""
    var eventName: String?
    var eventCode: String?
    var eventDate: String?
    //var eventTypeIcon: String?
    var paymentClientToken: String?
    var ownerId: Int64?
    var eventtypeData: [EventTypeData] = []
    
    var giftReceived: Int = 0
    var giftGiven: Int = 0
    var eventmetricsspraydetails: [EventMetricsSprayDetails] = []
    var eventmetricsspraydetails2: [EventMetricsSprayDetails] = []
    var eventmetricsspraydetails3: [EventMetricsSprayDetails] = []
    
    var myeventsfordashboard = [MyEventsForDashboard]()
    var myeventsfordashboard2 = [MyEventsForDashboard]()
    let eventTypeIcon = EventTypeIcon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        thePieChart.delegate = self
       
        //pieChart.delegate = self
        
//            eventNameLabel.text = eventName
//            eventDateLabel.text = eventDate
//            eventCodeLabel.text = eventCode
//            eventImage.image = UIImage(named: eventTypeIcon!)
       // eventIdLabel.text = String(describing: eventId)
        //profileIdLabel.text = String(describing: profileId)
        
        getMyEvents()
        //getMyEventStats()
        
        //displayChart2()
        //setupPieChart()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            
        
    }
    
    func getMyEvents(){
       
       
        
        let request = Request(path: "/api/Event/myevents?profileid=\(profileId!)", token: token)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
                
            case .success(let event):
                let decoder = JSONDecoder()
                do {
                    let eventjson = try decoder.decode(EventListModel.self, from: event)
                    for i in eventjson.result.eventsOwned {
                        //if i.isActive == true {
                        let eventId = i.eventId// eventjson[i].result.eventsOwned[i].eventId
                        //let ownerId = i.ownerId //eventjson[i].result.eventsOwned[i].ownerId
                        let name = i.name //eventjson[i].result.eventsOwned[i].name
                        let dateTime = i.dateTime //eventjson[i].result.eventsOwned[i].dateTime
                        //let address1 = i.address1 //eventjson[i].result.eventsOwned[i].address1
                        //let address2 = i.address2 //eventjson[i].result.eventsOwned[i].address2
                        //let city = i.city //eventjson[i].result.eventsOwned[i].city
                        //let zipCode = i.zipCode //eventjson[i].result.eventsOwned[i].zipCode
                        //let country = i.country //eventjson[i].result.eventsOwned[i].country
                        //let state = i.state //eventjson[i].result.eventsOwned[i].state
                        //let eventState = i.eventState //eventjson[i].result.eventsOwned[i].eventState
                        let eventCode = i.eventCode //eventjson[i].result.eventsOwned[i].eventCode
                        //let isActive = i.isActive //eventjson[i].result.eventsOwned[i].isActive
                        let eventType = i.eventType
                     

                        let data1 = MyEventsForDashboard(eventId: eventId, eventName: name, eventDateTime: dateTime, eventCode: eventCode, eventTypeId: eventType!)
                        self.myeventsfordashboard.append(data1)
                        print(self.myeventsfordashboard)
                 
                        //}
                    }
                    self.tableView.reloadData()
                } catch {
                    
                    // do print(error)
                }
                    
                //self.parse(json: event)
                
            case .failure(let error):
                
                print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")

            }
        }
    }
    
    func setupPieChart() {
        thePieChart.chartDescription?.enabled = false
        thePieChart.drawHoleEnabled = true
        thePieChart.rotationAngle = 0
        thePieChart.rotationEnabled = true
        thePieChart.isUserInteractionEnabled = true
       // thePieChart.legend.entries.
        
        //pieView.legend.enabled = false
        
        let l = thePieChart.legend
        //l.horizontalAlignment = .left
        //l.verticalAlignment = .bottom
        //l.orientation = .vertical
        //l.xEntrySpace = 10
        //l.yEntrySpace = 0
        l.font = UIFont(name: "HelveticaNeue-Bold", size: 11)!
        l.textColor = UIColor.black
        //yourInstanceChart.legend.textColor = UIColor.white
        
        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: 100.0, label: "$100"))
        entries.append(PieChartDataEntry(value: 30.0, label: "$30"))
//        entries.append(PieChartDataEntry(value: 20.0, label: "Soft Drink"))
//        entries.append(PieChartDataEntry(value: 10.0, label: "Water"))
//        entries.append(PieChartDataEntry(value: 40.0, label: "Home Meals"))
        
        let dataSet = PieChartDataSet(entries: entries, label: "Gifted")
        
        //let colors = [UIColor(red: CGFloat(190/255), green: CGFloat(219/255), blue: CGFloat(187/255), alpha: 1), UIColor(red: CGFloat(141/255), green: CGFloat(181/255), blue: CGFloat(150/255), alpha: 1)]
        
        //let c1 = UIColor(red: CGFloat(190/255), green: CGFloat(219/255), blue: CGFloat(187/255), alpha: 1) //NSUIColor(hex: 0x3A015C)
        //let c2 = UIColor(red: CGFloat(141/255), green: CGFloat(181/255), blue: CGFloat(150/255), alpha: 1) //NSUIColor(hex: 0x4F0147)
//        let c3 = NSUIColor(hex: 0x35012C)
//        let c4 = NSUIColor(hex: 0x290025)
//        let c5 = NSUIColor(hex: 0x11001C)
    
        //dataSet.colors = colors
        var  colors: [UIColor] = []
             colors.append(UIColor(red: 190/255, green: 219/255, blue: 187/255, alpha: 1))
             colors.append(UIColor(red: 141/255, green: 181/255, blue: 150/255, alpha: 1))
             //colors.append(UIColor.black)
            //UIColor(red: CGFloat(190/255), green: CGFloat(219/255), blue: CGFloat(187/255), alpha: 1)
        //pieChartDataSet.colors = colors
        dataSet.colors = colors //ChartColorTemplates.colorful()
        dataSet.drawValuesEnabled = false
        
        thePieChart.data = PieChartData(dataSet: dataSet)
    }
    func displayChart2() {
        
        var pieChartEntries = [PieChartDataEntry]()
        //for x in 0..<10 {
        let value1 = "$200 Amount Gifted"
        let value2 =    "$150 Amount Received"
        pieChartEntries.append(PieChartDataEntry(value: 200, label: value1))
        pieChartEntries.append(PieChartDataEntry(value: 100, label: value2))


//                pieChartEntries.append(ChartDataEntry(x: Double(200), y: Double(0)))
//                pieChartEntries.append(ChartDataEntry(x: Double(50), y: Double(0)))
//
        //}
        let pieChartSet = PieChartDataSet(entries: pieChartEntries, label: "Dominic" )
        
       
        let pieChartData = PieChartData(dataSet: pieChartSet)
        pieChartSet.colors = ChartColorTemplates.joyful()

        
        thePieChart.data = pieChartData
    }
    func displayChart(gifted: Double, received: Double) {
        
        thePieChart.chartDescription?.text = ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1.0
        formatter.currencySymbol = "$"
        
        amountGifted.value = gifted
        amountGifted.label = ""
        //amountGifted.label = UIFont(name: "HelveticaNeue-Bold", size: 11)!
        
        
        amountReceived.value = received
        amountReceived.label = ""
//
        numberOfDownloadsDataEntries = [amountGifted, amountReceived]
        
        let l = thePieChart.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.xEntrySpace = 10
        l.yEntrySpace = 0
        l.font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        
        //LegendEntry
        let formSize =  CGFloat.nan

        let legendEntry1 = LegendEntry(label: "Gifted \(gifted)", form: .default, formSize: formSize, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor(red: 141/255, green: 181/255, blue: 150/255, alpha: 1))  //set formSize, formLizeWidth, and formLineDashLengths to .nan to use default
        let legendEntry2 = LegendEntry(label: "Received \(received)", form: .default, formSize: formSize, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: UIColor(red: 190/255, green: 219/255, blue: 187/255, alpha: 1))
        let customLegendEntries = [legendEntry1, legendEntry2]
        l.setCustom(entries: customLegendEntries)
        //l.orientation = .horizontal
        //l.textColor = UIColor.white
        //l.font = myFonts.openSansRegular.of(size: 6)
        
        //l.font = Typography.robotoRegular14
        //l.font = self.isPhone ? Typography.robotoRegular14 : Typography.robotoRegular18
        
        let chartDataSet = PieChartDataSet(entries: numberOfDownloadsDataEntries, label: "")
        chartDataSet.entryLabelFont = UIFont(name: "HelveticaNeue", size: 12)!
        let chartData = PieChartData(dataSet: chartDataSet)
        chartData
            .setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chartData.setValueFont(UIFont(name: "HelveticaNeue", size: 12)!)
        chartData.setValueTextColor(.black)
        //let colors = [UIColor(named: .red), UIColor(named: .blue)]
        var  colors: [UIColor] = []
             colors.append(UIColor(red: 190/255, green: 219/255, blue: 187/255, alpha: 1))
             colors.append(UIColor(red: 141/255, green: 181/255, blue: 150/255, alpha: 1))
        
        chartDataSet.colors = colors // ChartColorTemplates.material()
        
        
        
        thePieChart.data = chartData
        
        /* reference to your data
        PieData data = new PieData(labels, dataSet);

         this increases the values text size
        data.setValueTextSize(40f); // <- here
        
         This will align label text to top right corner */
          
//
//          self.pieChartView.entryLabelFont = Typography.robotoRegular14
//          self.pieChartView.drawHoleEnabled = false
//          self.pieChartView.drawEntryLabelsEnabled = false
//          self.pieChartView.notifyDataSetChanged()
        
//        pieChartView.data = pieChartData
//            pieChartView.centerText = "Amount Spent"
//            pieChartView.chartDescription?.text = ""
//            pieChartView.usePercentValuesEnabled = true
//            pieChartView.legend.horizontalAlignment = .center
//            pieChartView.drawEntryLabelsEnabled = false
//            pieChartView.holeRadiusPercent = 0.55
//            pieChartView.highlightPerTapEnabled = false
//            pieChartView.animate(yAxisDuration: 2.0, easingOption: .easeInBack)
        
        //        pieChart.frame = CGRect(x: 134, y:370, width: self.view.frame.size.width, height: self.view.frame.size.width)
//        pieChart.center = view.center
//
//        view.addSubview(pieChart)
//
//
//
//        pieChartEntries.append(PieChartDataEntry(value: amount1, label: "Total Received", data: AttendeeType.receiver as AnyObject?))
//        pieChartEntries.append(PieChartDataEntry(value: amount2, label: "Total Gifted", data: AttendeeType.gifter as AnyObject?))
//
//        let pieChartSet = PieChartDataSet(entries: pieChartEntries )
//
//
//
//        let pieChartData = PieChartData(dataSet: pieChartSet)
//        pieChartSet.colors = ChartColorTemplates.material() //joyful()
//
//        pieChart.data = pieChartData
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected")
        // Extract the SliceType from the selected value
        //highlight.x
        if let dataSet = thePieChart.data?.dataSets[ highlight.dataSetIndex] {

                let sliceIndex: Int = dataSet.entryIndex( entry: entry)
            if sliceIndex == 1 {
                getSenderSprayDetails(isForSearch: false)
            } else {
                getReceiverSprayDetails(isForSearch: false)
            }
            print( "Selected slice index: \(sliceIndex.description)")
            //sliceIndex
            
            }
    }
    
    func getMyEventStats() {
      
        
        let request = Request(path: "/api/Event/profilestats/\(profileId)/\(eventId)", token: token)
        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
        case .success(let eventStatsData):
        let decoder = JSONDecoder()
            do {
                let eventStatsJson: EventStatsData = try decoder.decode(EventStatsData.self, from: eventStatsData)
                
               self.displayChart(gifted: Double(eventStatsJson.totalAmountGifted), received: Double(eventStatsJson.totalAmountReceived))

            } catch {
                print(error)
            }
            
            //load data for search/ delete existing
            eventmetricsspraydetails2.removeAll()
            getSenderSprayDetails(isForSearch: true)
            getReceiverSprayDetails(isForSearch: true)
       
            //hold for now
            //getReceiverSprayDetails()
        case .failure(let error):
            print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
        }
    }
    }
    
    func getReceiverSprayDetails(isForSearch: Bool) {
      
        //clear object data
        eventmetricsspraydetails.removeAll()
        
        let request = Request(path: "/api/SprayTransaction/sendertotal/\(profileId)/\(eventId)", token: token)

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
        case .success(let sprayData):
        let decoder = JSONDecoder()
            do {
                let sprayDetailJson: sEventMetricsSprayData  = try decoder.decode(sEventMetricsSprayData.self, from: sprayData)
                
                for sprayData in  sprayDetailJson.recipientList {
                    switch isForSearch {
                    case true:
                        let data1 = EventMetricsSprayDetails(lastName: sprayData.lastName, firstName: sprayData.firstName, totalAmount: sprayData.totalAmount, recordType: "Receiver")
                        
                        eventmetricsspraydetails2.append(data1)
                    case false:
                        let data1 = EventMetricsSprayDetails(lastName: sprayData.lastName, firstName: sprayData.firstName, totalAmount: sprayData.totalAmount, recordType: "Receiver")
                        
                        eventmetricsspraydetails.append(data1)
                    default:
                        break
                    }
                 
                    
                }
                
                
            } catch {
                print(error)
            }
            
            tableView.reloadData()
      
        case .failure(let error):
            print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
        }
    }
    }
    
    func getSenderSprayDetails(isForSearch: Bool) {
      
        eventmetricsspraydetails.removeAll()
        let request = Request(path: "/api/SprayTransaction/recipienttotal/\(profileId)/\(eventId)", token: token)

        Network.shared.send(request) { [self] (result: Result<Data, Error>)  in
        switch result {
        case .success(let sprayData):
        let decoder = JSONDecoder()
            do {
                let sprayDetailJson: rEventMetricsSprayData  = try decoder.decode(rEventMetricsSprayData.self, from: sprayData)
                
                for sprayData in  sprayDetailJson.senderList {
                    
                    switch isForSearch {
                    case true:
                        
                        let data1 = EventMetricsSprayDetails(lastName: sprayData.lastName, firstName: sprayData.firstName, totalAmount: sprayData.totalAmount, recordType: "Sender")
                        eventmetricsspraydetails2.append(data1)
                    case false:
                        let data1 = EventMetricsSprayDetails(lastName: sprayData.lastName, firstName: sprayData.firstName, totalAmount: sprayData.totalAmount, recordType: "Sender")
                        eventmetricsspraydetails.append(data1)
                    default:
                        break
                    }
                    
                    
                    
                }
            } catch {
                print(error)
            }
            
            tableView.reloadData()
      
        case .failure(let error):
            print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
        }
    }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      1
   
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
           return myeventsfordashboard2.count
        } else {
           return myeventsfordashboard.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.accessoryType = .disclosureIndicator
        if searching {
            cell.textLabel?.text = myeventsfordashboard2[indexPath.row].eventName
            //\(eventmetricsspraydetails3[indexPath.row].lastName)"
            cell.detailTextLabel?.text = myeventsfordashboard2[indexPath.row].eventDateTime
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            
        } else {
            cell.textLabel?.text = myeventsfordashboard[indexPath.row].eventName
            //\(eventmetricsspraydetails3[indexPath.row].lastName)"
            cell.detailTextLabel?.text = myeventsfordashboard[indexPath.row].eventDateTime
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        }
//            cell.textLabel?.text = rsvpAttendees[indexPath.row].firstName
//            cell.detailTextLabel?.text = rsvpAttendees[indexPath.row].lastName
//            attendeeNameSelected = rsvpAttendees[indexPath.row].firstName
//            giftReceiverId = rsvpAttendees[indexPath.row].profileId
        //}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEventMetriDetails", sender: self)
        
     
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

extension  DashboardViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //contact = contacts.filter({$0.name.prefix(searchText.count) == searchText})
        //if searchText == "" {
          print("searchText \(searchText)")
       // } else {
        myeventsfordashboard2 =  myeventsfordashboard.filter({$0.eventName.lowercased().prefix(searchText.count) == searchText.lowercased()})
            
        //}
        print("myeventsfordashboard2 \(myeventsfordashboard2)")
        
       // contacts = contacts.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
//            //= //countryNameARr.fitler({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
//        contact = contacts.filter {
//            (service: ContactStruct) -> Bool in
////        let index = find(value: "Eddie", in: contacts)
////        print(index)
////            return
////            co
////            if let name = service.givenName.lowercased().prefix(searchText.count) == searchText.lowercased()
////            return false
//        }
//
        
        //*** this is good
    
        
        searching = true
        tableView.reloadData()
    }
    
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        myeventsfordashboard2.removeAll()
        tableView.reloadData()
        
        //reload data
//        getSenderSprayDetails(isForSearch: true)
//        getReceiverSprayDetails(isForSearch: true)
    }
}

extension DashboardViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventMetriDetails" { //create event view controller
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let NextVC = segue.destination as! EventMetricDetailsViewController
                if searching {
                    NextVC.profileId = profileId!
                    NextVC.token = token
                    NextVC.eventId = myeventsfordashboard2[indexPath.row].eventId// rsvpAttendees2[indexPath.row].firstName //contact[indexPath.row].name
                    NextVC.eventName = myeventsfordashboard2[indexPath.row].eventName
                    NextVC.eventCode = myeventsfordashboard2[indexPath.row].eventCode
                    NextVC.eventDateTime = myeventsfordashboard2[indexPath.row].eventDateTime
                    NextVC.paymentClientToken = paymentClientToken
                    NextVC.eventTypeIcon = eventTypeIcon.getEventTypeIcon(eventTypeId: myeventsfordashboard2[indexPath.row].eventTypeId)
                    
                } else {
                    NextVC.profileId = profileId!
                    NextVC.token = token
                    NextVC.eventId = myeventsfordashboard[indexPath.row].eventId// rsvpAttendees2[indexPath.row].firstName //contact[indexPath.row].name
                    NextVC.eventName = myeventsfordashboard[indexPath.row].eventName
                    NextVC.eventCode = myeventsfordashboard[indexPath.row].eventCode
                    NextVC.eventDateTime = myeventsfordashboard[indexPath.row].eventDateTime
                    NextVC.paymentClientToken = paymentClientToken
                    NextVC.eventTypeIcon = eventTypeIcon.getEventTypeIcon(eventTypeId: myeventsfordashboard[indexPath.row].eventTypeId)
                }
            }
        }
          
                    
//                        print("BALANCE AT SEGUE 1 = \(balance)")
//                        NextVC.incomingGiftReceiverName =   rsvpAttendees2[indexPath.row].firstName //contact[indexPath.row].name
//                        NextVC.eventName = eventName
//                        NextVC.eventDateTime = eventDateTime
//                        NextVC.eventCode = eventCode
//                        NextVC.paymentClientToken = paymentClientToken!
//                        NextVC.eventTypeIcon = eventTypeIcon
//                        //nextVC.paymentClientToken  =  paymentClientToken
//                        NextVC.gifterBalance = balance
//                        NextVC.sprayDelegate = self
//                        NextVC.eventId = eventId!
//                        NextVC.profileId = profileId!
//                        NextVC.giftReceiverId = rsvpAttendees2[indexPath.row].profileId
//                        NextVC.gifterTotalTransAmount = gifterTotalTransAmount
//                        NextVC.token = token
//                        NextVC.isAutoReplenishFlag = isAutoReplenishFlag
//                        NextVC.autoReplenishAmount = autoReplenishAmount
//                        NextVC.notificationAmount = notificationAmount
//                        NextVC.sprayIncrementAmt = sprayIncrementAmt
//                        NextVC.currencyImageSide1 = currencyImageSide1
//                        NextVC.currencyImageSide2 = currencyImageSide2
//                        NextVC.paymentMethod = paymentMethod
                        
                        
               

                //if let indexPath = self.tableVi
//                if let indexPath = self.tableView.indexPathForSelectedRow {
//                    //let menulist = menulists[indexPath.row]
//                    let itemselect = menulists[indexPath.row]
//
//                    print(itemselect.title)
//                    if itemselect.title == "Add Event" {
//                        let NextVC = segue.destination as! CreateEventViewController
//                        NextVC.createEventTitle = itemselect.title
//                    } else {
//                        print("Do nothing")
//                    }
           

//            } else if(segue.identifier == "backToHome") {
////                      let NextVC = segue.destination as! LoginViewController
////                      NextVC.logout  = true
//
//                        if let  NextVC = segue.destination as? MainNavigationViewController,
//                        let targetController =  NextVC.topViewController as? LoginViewController  {
//                        //targetController.data = "hello from ReceiveVC !"
//                            //NextVC.logout  = true
//                        }
//
//            } else if(segue.identifier == "toAddBankAccountVC")  { //add bank account
//
//            } else if(segue.identifier == "toNotificationVC")  { //notification view controller
//
//            } else if(segue.identifier == "toSettingsVC")  { //setting view controller
//
//            }
    
    }
}
