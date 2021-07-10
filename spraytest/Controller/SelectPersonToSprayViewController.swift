//
//  SelectPersonToSprayViewController.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 1/30/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit

class SelectPersonToSprayViewController: UIViewController {

    @IBOutlet weak var halfScreenView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var eventId: Int64 = 0
    var profileId: Int64 = 0
    var token: String = ""
    var eventOwnerProfileId: Int64 = 0
    var rsvpAttendees = [RSVPAttendees]()
    var rsvpAttendees2 = [RSVPAttendees]()
    var searching = false
    var receiverInfoDelegate: SprayReceiverDelegate?
    var encryptedAPIKey: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        //use to keep keyboard down
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = .clear
        createTheView()
        
        fetchRSVPAttendees(eventId: eventId)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.searchBarStyle = .minimal
        //searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 0
        //searchBar.barTintColor = UIColor.white
        searchBar.layer.masksToBounds = false
        tableView.separatorStyle = .none
        //tableView.layer.borderColor  = UIColor.lightGray.cgColor
       //        sprayCardView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
       //        sprayCardView.layer.shadowOpacity  = 1.0
       tableView.layer.masksToBounds = false
       //        sprayCardView.layer.cornerRadius = 2.0
               
       //        sprayCardView.layer.shadowColor = UIColor.lightGray.cgColor
       tableView.layer.borderWidth = 0
        
        halfScreenView.layer.borderColor  = UIColor.lightGray.cgColor
        halfScreenView.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        halfScreenView.layer.shadowOpacity  = 1.0
        halfScreenView.layer.masksToBounds = false
        halfScreenView.layer.cornerRadius = 8.0
        
        }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    private func createTheView() {

        let xCoord = self.view.bounds.width /// 2 - 50
        let yCoord = self.view.bounds.height /// 2 - 50

        let centeredView = UIView(frame: CGRect(x: xCoord, y: yCoord, width: self.view.bounds.width, height: self.view.bounds.height))
        centeredView.backgroundColor = .blue
        self.view.addSubview(centeredView)
    }
    

    @IBAction func dismissWindow(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
            
          }
    }
    
    func closeScreen(receiverProfileId: Int64, receiverName: String) {
        print("Close Screen Window")
        receiverInfoDelegate?.sendReceiverInfo(receiverProfileId: receiverProfileId, receivername: receiverName, eventId: eventId, profileId: profileId)
      
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
            
          }
    }
    func fetchRSVPAttendees(eventId: Int64) {
        print("eventId = \(eventId)")
        let request = Request(path: "/api/Event/attendees?eventId=\(eventId)", token: token, apiKey: encryptedAPIKey)
        Network.shared.send(request) { (result: Result<Data, Error>)  in
            switch result {
                case .success(let rsvpattendees):
                     let decoder = JSONDecoder()
                     do {
                        let attendeesJson: [RSVPAttendees] = try decoder.decode([RSVPAttendees].self, from: rsvpattendees)
                        for data in attendeesJson {
                            
                            //add rsp attendeese except the current profile
                            //you don't want to spray yourself
                            if data.profileId != self.profileId {
                                let dataOutPut = RSVPAttendees(profileId: data.profileId, firstName: data.firstName + " " + data.lastName, lastName: data.lastName, email: data.email, phone: data.phone, eventId: data.eventId, isAttending: data.isAttending)
                                self.rsvpAttendees.append(dataOutPut)
                            }
                            
                            //self.tableView.reloadData()
                        }
                        print("FETCHING DATA = \(self.rsvpAttendees)")
                        self.tableView.reloadData()
                    } catch {
                        print(error)
                    }
                   
                     print("rsvpattendees =\(self.rsvpAttendees)")
                case .failure(let error):
                    //self.textLabel.text = error.localizedDescription
                    print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
            }
        }
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

extension SelectPersonToSprayViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
            //searchActive = false
        self.searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //contact = contacts.filter({$0.name.prefix(searchText.count) == searchText})
        rsvpAttendees2 =  rsvpAttendees.filter({$0.firstName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        
        searching = true
        tableView.reloadData()
    }
    
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        rsvpAttendees.removeAll()
        rsvpAttendees2.removeAll()
        tableView.reloadData()
    }
    
    //hold this code for display data after selecting
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
//    {
//            //searchActive = false
//        self.searchBar.endEditing(true)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //contact = contacts.filter({$0.name.prefix(searchText.count) == searchText})
//        if searchBar.text == "" {
//            rsvpAttendees.removeAll()
//            rsvpAttendees2.removeAll()
//            fetchRSVPAttendees(eventId: eventId)
//            tableView.reloadData()
//        } else {
//            rsvpAttendees2 =  rsvpAttendees.filter({$0.firstName.lowercased().prefix(searchText.count) == searchText.lowercased()})
//        }
//
//        print("rsvpAttendees2 func searchbar = \(rsvpAttendees2)")
//
//
//        searching = true
//        tableView.reloadData()
//    }
//
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false
//        searchBar.text = ""
//        rsvpAttendees.removeAll()
//        rsvpAttendees2.removeAll()
//        fetchRSVPAttendees(eventId: eventId)
//        tableView.reloadData()
//    }
}

extension SelectPersonToSprayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
   
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  searching {
            return rsvpAttendees2.count
        } else {
           return rsvpAttendees.count
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell")! as! SelectPersonToSprayTableViewCell
         //let contactToDisplay = contact[indexPath.row]
        
        
        
        if searching {
            print("eventOwnerProfileId  search \(eventOwnerProfileId )")
            cell.receiverName.text = rsvpAttendees2[indexPath.row].firstName
            
           
            //cell.myProfileImage.image = UIImage(systemName: "person.crop.circle.fill")
            if rsvpAttendees2[indexPath.row].profileId == eventOwnerProfileId {
                cell.receiverName.font =  UIFont(name: "HelveticaNeue-Bold", size: 17)
                
                //cell.myProfileImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.red, renderingMode: .alwaysTemplate)
                cell.myProfileImage.image = cell.imageWith(name: rsvpAttendees2[indexPath.row].firstName, isEventOwner: true)
                
            } else {
                //cell.myProfileImage.image = UIImage(systemName: "person.crop.circle.fill")
                
                cell.myProfileImage.image = cell.imageWith(name: rsvpAttendees2[indexPath.row].firstName, isEventOwner: false)
            }
            
        } else {
            print("eventOwnerProfileId non search \(eventOwnerProfileId )")
            cell.receiverName.text = rsvpAttendees[indexPath.row].firstName
            
            if rsvpAttendees[indexPath.row].profileId == eventOwnerProfileId {
                cell.receiverName.font =  UIFont(name: "HelveticaNeue-Bold", size: 17)
                
     
                //cell.myProfileImage.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(UIColor(red: 155/250, green: 166/250, blue: 149/250, alpha: 1))
                cell.myProfileImage.image = cell.imageWith(name: rsvpAttendees[indexPath.row].firstName, isEventOwner: true)
                
                //withTintColor(UIColor.init(red: 155/250, green: 166/250, blue: 149/250, alpha: 1))
                //likeAction.image = UIImage(named: "Favourite_Selected")?.colored(in: .red)
              print("KEN Thomas - image")
            } else {
                //cell.myProfileImage.image = UIImage(systemName: "person.crop.circle.fill")
                cell.myProfileImage.image = cell.imageWith(name: rsvpAttendees[indexPath.row].firstName, isEventOwner: false)
            }
            
        }
       
        
        
        
        cell.layer.borderColor  = UIColor(red: 155/256, green: 166/256, blue: 149/256, alpha: 0.70).cgColor
    
       cell.layer.masksToBounds = false
       cell.layer.borderWidth = 0.25
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            closeScreen(receiverProfileId: rsvpAttendees2[indexPath.row].profileId, receiverName: rsvpAttendees2[indexPath.row].firstName)

        } else {
            closeScreen(receiverProfileId: rsvpAttendees[indexPath.row].profileId, receiverName: rsvpAttendees[indexPath.row].firstName)
        }
    }
    
}


extension UIImage {
    
    func paintOver(with color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { _ in
            color.set()
            self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderedImage
    }
}
