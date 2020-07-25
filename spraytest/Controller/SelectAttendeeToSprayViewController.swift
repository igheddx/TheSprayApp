//
//  SelectAttendeeToSprayViewController.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/16/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import UIKit
import Contacts


class SelectAttendeeToSprayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventCodeLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var message: String = ""
    var eventName: String = ""
    var eventDateTime: String = ""
    var eventCode: String = ""
    var profileId: Int64?
    var eventId: Int64?
    var token: String = ""
    
    var attendeeNameSelected: String = ""
    var attendeePhoneSelected: String = ""
    
    
    var contactStore = CNContactStore()
    var service = [CNContactStore]()
    var contacts = [Contact]()
    var contact = [Contact]()
    
    //@IBOutlet weak var messageLabel: UILabel!
    
    var searchCountry = [String]()
    var searching = false
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.allowsMultipleSelectionDuringEditing = true self.navigationItem.rightBarButtonItem = editButtonItem
        tableView.allowsMultipleSelection = true
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Authorize")
            }
        }
        contact.removeAll()
        contacts.removeAll()
       
        fetchContacts()
       
       
        
        eventNameLabel?.text = eventName
        eventDateTimeLabel?.text = eventDateTime
        eventCodeLabel?.text = eventCode
        
        //messageLabel?.text = message
        //print(messageLabel.text!)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func fetchContacts() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        
        var x: Int = 0
        do {
            x = x + 1
            try contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
                let name = contact.givenName
                let familynName = contact.familyName
                let number = contact.phoneNumbers.first?.value.stringValue
            
                let contactToAppend = Contact(name: name + " " + familynName, phone: number!)
            //print("CONCAT = \(contactToAppend)")
                //let contactToAppend2 = Contact(name: name + " " + familynName + " " + number!)
                //self.contact.append(contactToAppend2)
                self.contacts.append(contactToAppend)
                //print(self.contacts)
        
            })
        } catch let err {
            print("failed to enumerate contacts", err)
        }
        
    
       // tableView.reloadData()
        
        print(contacts)
    }
    
    struct Invitees {
        var name: String
       var phone: String
        var sentInvite: Bool
    }
    
    var invitees = [Invitees]()



    @objc func saveClicked(){
        var i: Int = 0
        var email: String = ""
        for invite in invitees {
            
            email = String("me555\(i)mail.com")
            
            print("the invite = \(invite.name)")
            let Invite = SendInvite(profileId: nil, email: email, phone: invite.phone, eventCode: eventCode)
            
            let request = PostRequest(path: "/api/Event/joinevent", model: Invite, token: token)
        
            
            Network.shared.send(request) { (result: Result<Data, Error>)  in
                switch result {
                case .success( _): break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            print(Invite)
            i=i+1
        }
        if invitees.count == i {
            print("Update is complete")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
      1
   
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return contact.count
        } else {
            return contacts.count
        }
        
       }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
       
       
        //let contactToDisplay = contact[indexPath.row]
       
        if searching {
            cell.textLabel?.text = contact[indexPath.row].name
            cell.detailTextLabel?.text = contact[indexPath.row].phone
            attendeeNameSelected = contact[indexPath.row].name
               } else {
            cell.textLabel?.text = contacts[indexPath.row].name
            attendeeNameSelected = contacts[indexPath.row].name
            cell.detailTextLabel?.text = contacts[indexPath.row].phone
             //contactToDisplay.givenName + "  " + contactToDisplay.familyName
                   //cell.detailTextLabel?.text = contactToDisplay.number
               }
//        let switchView = UISwitch(frame: .zero)
//        switchView.setOn(false, animated: true)
//        switchView.tag = indexPath.row
//        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
//
//        cell.accessoryView = switchView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToSpray", sender: self)
              self.dismiss(animated: true, completion: nil)
//         if searching {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
////            myItemsArray[indexPath.row].isChecked  = false
////            myItemsArray[indexPath.row].name = contacts[indexPath.row].name
//            print(" Remove = \(contact[indexPath.row].name) --- Index = \([indexPath.row]) ")
//            //myItemsArray = Items(isChecked: true, name: contacts[indexPath.row].name)
//            //let inviteeRecord = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, sentInvite: true)
//             self.invitees[indexPath.row] = Invitees(name: contact[indexPath.row].name, phone: contact[indexPath.row].phone, sentInvite: false)
//            //invitees.append(inviteeRecord)
//           // invitees.remove(at: indexPath.row)
//
//        }else {
//             tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//            let inviteeRecord = Invitees(name: contact[indexPath.row].name, phone: contact[indexPath.row].phone, sentInvite: true)
//            invitees.append(inviteeRecord)
//             print(" Add = \(contact[indexPath.row].name) --- Index = \([indexPath.row]) ")
//
//            //myItemsArray[indexPath.row - 1].isChecked  = true
//            //myItemsArray[indexPath.row - 1].name = contacts[indexPath.row].name
//
//        }
//         } else {
//             if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
//                        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
//            //            myItemsArray[indexPath.row].isChecked  = false
//            //            myItemsArray[indexPath.row].name = contacts[indexPath.row].name
//                        print(" Remove = \(contacts[indexPath.row].name) --- Index = \([indexPath.row]) ")
//                self.invitees[indexPath.row] = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, sentInvite: false)
//                        //myItemsArray = Items(isChecked: true, name: contacts[indexPath.row].name)
//                        //let inviteeRecord = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, sentInvite: true)
//                        //invitees.append(inviteeRecord)
//                       // invitees.remove(at: indexPath.row)
//                print("my invitees object SENT INVITES = FALSE = \(invitees)")
//
//                    }else {
//                         tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//                        let inviteeRecord = Invitees(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, sentInvite: true)
//                        print(" Add = \(contacts[indexPath.row].name) --- Index = \([indexPath.row]) ")
//                        invitees.append(inviteeRecord)
//                        //myItemsArray[indexPath.row - 1].isChecked  = true
//                        //myItemsArray[indexPath.row - 1].name = contacts[indexPath.row].name
//
//                 print("my invitees object SENT INVITES = FALSE = \(invitees)")
//                    }
            
       // }
            
       // print("printing invities object = \(invitees)")
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
        
    }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
   func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    // return getfooterView()
//        if searching {
//             return getfooterView()
//        } else {
//            return nil
//        }
       
//        guard section == 0 else { return nil }
//
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0))
//        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 44.0))
//        // here is what you should add:
//        doneButton.center = footerView.center
//
//        doneButton.setTitle("Send Invites", for: .normal)
//        doneButton.backgroundColor = .lightGray
//        doneButton.layer.cornerRadius = 10.0
//       // doneButton. shadow = true
//        doneButton.addTarget(self, action: #selector(hello(sender:)), for: .touchUpInside)
//        footerView.addSubview(doneButton)
//         contentView.addSubview(doneButton)
//        return footerView
        return nil
    }
    
    func getfooterView() -> UIView
    {
        let Header = UIView(frame: CGRect(x: 0, y: 0, width: Double(self.tableView.frame.size.width), height: 45))
       Header.backgroundColor = UIColor(named: "#2AF8AC")
       
        
        
       // let Header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0))
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 44.0))
        //button.frame = CGRect(x: 0, y: 0, width: Header.frame.size.width , height: Header.frame.size.height)
        button.backgroundColor = .gray
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(saveClicked), for: UIControl.Event.touchUpInside)

        Header.addSubview(button)
       Header.bringSubviewToFront(button)
        return Header
    }
    
    @objc func SubmitAction()  {
    print("Hello");
        let selectedRows = self.tableView.indexPathsForSelectedRows
        if selectedRows != nil {
            for var selectionIndex in selectedRows! {
                while selectionIndex.item >= contacts.count {
                    selectionIndex.item -= 1
                    print("Dominic IGhedoas")
                }
                //tableView(tableView, commit: .delete, forRowAt: selectionIndex)
            }
        }

    }
    
    
    @objc func switchChanged(_ sender: UISwitch!) {
        print("attendee name selected  = =\(attendeeNameSelected)")
        print("table row swith changed \(sender.tag)")
        print("the swith is \(sender.isOn ? "ON" : "OFF")")
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
                
                if segue.identifier == "goToSpray" {
                    //if let indexPath = self.tableVi
                    if let indexPath = self.tableView.indexPathForSelectedRow {
                        let NextVC = segue.destination as! SprayViewController
                        if searching {
                            NextVC.incomingGiftReceiverName =   contact[indexPath.row].name
                        } else {
                            NextVC.incomingGiftReceiverName =   contacts[indexPath.row].name
                        }
                         
                        NextVC.gifterBalance = 10
                    }
                    
                    
                    //MARK: send this values back to the LoginViewController
                    
                   
                    //NextVC.gifterBalance = 10
                    //NextVC.passwordStored = passwordTextField.text!
                    
                   
                }
                

                }

}

extension SelectAttendeeToSprayViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        contact = contacts.filter({$0.name.prefix(searchText.count) == searchText})
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
        contact.removeAll()
        contacts.removeAll()
        tableView.reloadData()
    }
}
