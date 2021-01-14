////
////  Post.swift
////  spraytest
////
////  Created by Ighedosa, Dominic on 4/11/20.
////  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
////
//
//import Foundation
//
//
//class Post: Codable {
//    let userID, id: Int
//    let title, body: String
//
//    enum CodingKeys: String, CodingKey {
//        case userID = "userId"
//        case id, title, body
//    }
//
//    init(userID: Int, id: Int, title: String, body: String) {
//        self.userID = userID
//        self.id = id
//        self.title = title
//        self.body = body
//    }
//}
//
//
//
//
// if homescreeneventdata[indexPath.section].eventCategory == "My Events" {
//                     let cell = tableView.dequeueReusableCell(withIdentifier: MyEventsTableViewCell.identifier, for: indexPath) as! MyEventsTableViewCell
//                    if homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dataCategory! == "owned" {
//                           print("my invitation")
//                          //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
//
//
//                    let eventNameCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//                    let eventAddressCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + "\n" + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2! + "\n" + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + "\n" + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//                    let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!)
//
//       //                let dateString = "2020-07-20T00:00:00"
//       //                let dateFormatter = DateFormatter()
//       //                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
//       //                dateFormatter.locale = Locale.init(identifier: "en_GB")
//       //                let dateres = dateFormatter.date(from: dateString)
//       //                print("DATE FORMAT \(dateres!)")
//       //
//
//
//
//                         //let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +
//                         //homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//                    let eventCityStateZipCountryCellData = ""
//                    let eventCodeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!
//                    let eventImageCellData = "birthdayicon1"
//                    let eventIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId
//                    let profileIdData = profileId!
//                    let ownerIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].ownerId
//                    let tokenData = token
//                    let paymentClientTokenData = paymentClientToken!
//
//                        cell.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData,  eventCode: eventCodeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)
//
//                        cell.myEventsCustomCellDelegate = self
//                        cell.layer.borderColor = UIColor.gray.cgColor
//                        cell.layer.borderWidth = 3.0
//                        cell.accessoryType = .disclosureIndicator
//
//
//       //            print("i am here \(homescreeneventdata[indexPath.section].eventCategory)")
//       //            let lbl  = UILabel(frame: CGRect(x: 47, y: 229, width: 262, height: 21))
//       //            lbl.backgroundColor = UIColor.white
//       //            lbl.textColor = UIColor.black
//       //            lbl.textAlignment = NSTextAlignment.center
//       //            lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
//       //
//       //
//       //            lbl.text = "Invite Friends"
//       //            lbl.tag = indexPath.row
//       //            cell.contentView.addSubview(lbl)
//       //
//       //
//       //
//       //            let inviteIconImage = UIImage(named:"addusericon1")!
//       //
//       //            let button = UIButton(frame: CGRect(x: 316, y: 224, width: 55, height: 31))
//       //
//       //            button.backgroundColor = UIColor.white
//       //
//       //            button.tag =  indexPath.row
//       //
//       //            button.setTitle("invite", for: .normal)
//       //
//       //            //button.setTitle("Invite", forState: .Normal)
//       //
//       //            button.setImage(inviteIconImage, for: .normal)
//       //
//       //            //button.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
//       //
//       //            button.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
//       //
//       //            cell.contentView.addSubview(button)
//       //
//                //self.view.addSubview(button)
//                cell.layer.cornerRadius = 4.0
//                cell.layer.borderWidth = 1.0
//                cell.layer.borderColor  = UIColor.clear.cgColor
//                          cell.layer.masksToBounds = false
//                          cell.layer.shadowColor = UIColor.gray.cgColor
//                          cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//                          cell.layer.shadowRadius = 4.0
//                          cell.layer.shadowOpacity  = 1.0
//                          cell.layer.masksToBounds = false
//                          cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//
//
//                    return cell
//                   }
//                } else if homescreeneventdata[indexPath.section].eventCategory == "My RSVP" {
//              let cell2 = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier, for: indexPath) as! TableViewCell3
//            //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
//
//            let eventNameCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//            let eventAddressCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2!
//            //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
//             let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!)
//
//
//            let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +
//            homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//
//            let eventCodeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!
//            let eventImageCellData = "birthdayicon1"
//            let eventIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId
//            let profileIdData = profileId!
//            let ownerIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].ownerId
//            let tokenData = token
//            let paymentClientTokenData = paymentClientToken!
//
//            cell2.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)
//
//            cell2.customCellDelegate = self
//
//            cell2.layer.borderColor = UIColor.gray.cgColor
//
//            cell2.layer.borderWidth = 3.0
//
//            cell2.layer.cornerRadius = 4.0
//                   cell2.layer.borderWidth = 1.0
//                   cell2.layer.borderColor  = UIColor.clear.cgColor
//                   cell2.layer.masksToBounds = false
//                   cell2.layer.shadowColor = UIColor.gray.cgColor
//                   cell2.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//                   cell2.layer.shadowRadius = 4.0
//                   cell2.layer.shadowOpacity  = 1.0
//                   cell2.layer.masksToBounds = false
//                   cell2.layer.shadowPath = UIBezierPath(roundedRect: cell2.bounds, cornerRadius: cell2.contentView.layer.cornerRadius).cgPath
//
//              return cell2
//
//        } else if  homescreeneventdata[indexPath.section].eventCategory == "My Invitations" {
//                  let cell3 = tableView.dequeueReusableCell(withIdentifier: MyInvitationsTableViewCell.identifier, for: indexPath) as! MyInvitationsTableViewCell
//            print("my invitation")
//            //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
//            for eventidattending in eventIdsattendingmodel {
//                //print("eventidattending = \(eventidattending)")
//                //print("eventId = \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId)")
//                if eventidattending != homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId {
//                    let eventNameCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//                    let eventAddressCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2!
//                    //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
//                     let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!)
//
//                     let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +
//                    homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//
//                    let eventCodeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!
//                    let eventImageCellData = "birthdayicon1"
//                    let eventIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId
//                    let profileIdData = profileId!
//                     let ownerIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].ownerId
//                    let tokenData = token
//                    let paymentClientTokenData = paymentClientToken!
//
//                    cell3.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)
//
//                     cell3.myInvitationCustomCellDelegate = self
//
//                    cell3.layer.borderColor = UIColor.gray.cgColor
//                    cell3.layer.borderWidth = 3.0
//
//
//                     cell3.layer.cornerRadius = 4.0
//                            cell3.layer.borderWidth = 1.0
//                            cell3.layer.borderColor  = UIColor.clear.cgColor
//                            cell3.layer.masksToBounds = false
//                            cell3.layer.shadowColor = UIColor.gray.cgColor
//                            cell3.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//                            cell3.layer.shadowRadius = 4.0
//                            cell3.layer.shadowOpacity  = 1.0
//                            cell3.layer.masksToBounds = false
//                            cell3.layer.shadowPath = UIBezierPath(roundedRect: cell3.bounds, cornerRadius: cell3.contentView.layer.cornerRadius).cgPath
//
//
//                     return cell3
//                }
//
//            }
//        }
//    }
//
        
        
       // return cell
        
             //cell2.eventName.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//            cell.eventNameLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//
//          cell.eventAddressLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2!
//
//          cell.eventCityStateZipCountryLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +
//
//              homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//
//
//          cell.eventDateTimeLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
//          cell.eventCodeLabel.text = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!
//          cell.eventImage.image = UIImage(named: "birthdayicon1")

          
          
          
          
        
        //cell.layer.borderColor = UIColor.gray.cgColor
        //cell.layer.borderWidth = 3.0
        //return cell
    
        
    


//if  homescreeneventdata[indexPath.section].eventCategory == "My Invitations" {
//               let cell3 = tableView.dequeueReusableCell(withIdentifier: MyInvitationsTableViewCell.identifier, for: indexPath) as! MyInvitationsTableViewCell
//       
//               print("my invitation")
//               //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
//               for eventidattending in eventIdsattendingmodel {
//                   //print("eventidattending = \(eventidattending)")
//                   //print("eventId = \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId)")
//                   if eventidattending != homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId {
//                       let eventNameCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//                       let eventAddressCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2!
//                       //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
//                       let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!)
//                    
//                       let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +
//                           homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//                   
//                       let eventCodeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!
//                       let eventImageCellData = "birthdayicon1"
//                       let eventIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId
//                       let profileIdData = profileId!
//                       let ownerIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].ownerId
//                       let tokenData = token
//                       let paymentClientTokenData = paymentClientToken!
//                   
//                       cell3.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)
//                   
//                       cell3.myInvitationCustomCellDelegate = self
//
//                       cell3.layer.borderColor = UIColor.gray.cgColor
//                       cell3.layer.borderWidth = 3.0
//                   
//                   
//                       cell3.layer.cornerRadius = 4.0
//                       cell3.layer.borderWidth = 1.0
//                       cell3.layer.borderColor  = UIColor.clear.cgColor
//                       cell3.layer.masksToBounds = false
//                       cell3.layer.shadowColor = UIColor.gray.cgColor
//                       cell3.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//                       cell3.layer.shadowRadius = 4.0
//                       cell3.layer.shadowOpacity  = 1.0
//                       cell3.layer.masksToBounds = false
//                       cell3.layer.shadowPath = UIBezierPath(roundedRect: cell3.bounds, cornerRadius: cell3.contentView.layer.cornerRadius).cgPath
//                    
//                       return cell3
//                      
//                       }
//                   }
//               }
//          
//           }
//     



//8/18/2020

//if(indexPath.row == 0) {
//         
//    let cell = tableView.dequeueReusableCell(withIdentifier: MyEventsTableViewCell.identifier, for: indexPath) as! MyEventsTableViewCell
//    if homescreeneventdata[indexPath.section].eventCategory == "My Events" {
//        
//        if homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dataCategory! == "owned" {
//               print("my invitation")
//              //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
//
//
//        let eventNameCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//        let eventAddressCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + "\n" + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2! + "\n" + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + "\n" + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//        let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!)
//
//
//        let eventCityStateZipCountryCellData = ""
//        let eventCodeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!
//        let eventImageCellData = "birthdayicon1"
//        let eventIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId
//        let profileIdData = profileId!
//        let ownerIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].ownerId
//        let tokenData = token
//        let paymentClientTokenData = paymentClientToken!
//
//            cell.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)
//
//            cell.myEventsCustomCellDelegate = self
//            cell.layer.borderColor = UIColor.gray.cgColor
//            cell.layer.borderWidth = 3.0
//            cell.accessoryType = .disclosureIndicator
//
//
//    cell.layer.cornerRadius = 4.0
//    cell.layer.borderWidth = 1.0
//    cell.layer.borderColor  = UIColor.clear.cgColor
//              cell.layer.masksToBounds = false
//              cell.layer.shadowColor = UIColor.gray.cgColor
//              cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//              cell.layer.shadowRadius = 4.0
//              cell.layer.shadowOpacity  = 1.0
//              cell.layer.masksToBounds = false
//              cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//         
//        
//
//     }
// }
//         
//          return cell
//     } else if indexPath.row == 1 {
//             let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier, for: indexPath) as! TableViewCell3
//     if homescreeneventdata[indexPath.section].eventCategory == "My RSVP" {
//                 
//                 //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
//
//                 let eventNameCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//                 let eventAddressCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2!
//                 //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
//                  let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!)
//
//
//                 let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +
//                 homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//
//                 let eventCodeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!
//                 let eventImageCellData = "birthdayicon1"
//                 let eventIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId
//                 let profileIdData = profileId!
//                 let ownerIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].ownerId
//                 let tokenData = token
//                 let paymentClientTokenData = paymentClientToken!
//
//                 cell.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)
//
//                 cell.customCellDelegate = self
//                 //cell.myInvitationCustomCellDelegate = self
//                 cell.layer.borderColor = UIColor.gray.cgColor
//
//                 cell.layer.borderWidth = 3.0
//
//                 cell.layer.cornerRadius = 4.0
//                        cell.layer.borderWidth = 1.0
//                        cell.layer.borderColor  = UIColor.clear.cgColor
//                        cell.layer.masksToBounds = false
//                        cell.layer.shadowColor = UIColor.gray.cgColor
//                        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//                        cell.layer.shadowRadius = 4.0
//                        cell.layer.shadowOpacity  = 1.0
//                        cell.layer.masksToBounds = false
//                        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//             
//     }
//         return cell
//     } else if indexPath.row == 2 {
//         let cell = tableView.dequeueReusableCell(withIdentifier: MyInvitationsTableViewCell.identifier, for: indexPath) as! MyInvitationsTableViewCell
//         if  homescreeneventdata[indexPath.section].eventCategory == "My Invitations" {
//         
//                 print("my invitation")
//                  //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell3.identifier) as! TableViewCell3
//                 for eventidattending in eventIdsattendingmodel {
//                     //print("eventidattending = \(eventidattending)")
//                     //print("eventId = \(homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId)")
//                     if eventidattending != homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId {
//                         let eventNameCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].name!
//                         let eventAddressCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address1! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].address2!
//                         //let eventDateTimeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!
//                          let eventDateTimeCellData = convertDateFormatter(date: homescreeneventdata[indexPath.section].eventProperty[indexPath.row].dateTime!)
//
//                          let eventCityStateZipCountryCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].city! + ", " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].state! + " " + homescreeneventdata[indexPath.section].eventProperty[indexPath.row].zipCode! + " " +
//                         homescreeneventdata[indexPath.section].eventProperty[indexPath.row].country!
//
//                         let eventCodeCellData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventCode!
//                         let eventImageCellData = "birthdayicon1"
//                         let eventIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].eventId
//                         let profileIdData = profileId!
//                          let ownerIdData = homescreeneventdata[indexPath.section].eventProperty[indexPath.row].ownerId
//                         let tokenData = token
//                         let paymentClientTokenData = paymentClientToken!
//
//                         cell.configure(with: eventNameCellData, eventAddress: eventAddressCellData, eventDateTime: eventDateTimeCellData, eventCityStateZipCountry: eventCityStateZipCountryCellData, eventCode: eventCodeCellData, imageName: eventImageCellData, eventId: eventIdData, profileId: profileIdData, ownerId: ownerIdData, token: tokenData!, paymentClientToken: paymentClientTokenData)
//
//                          cell.myInvitationCustomCellDelegate = self
//
//                         cell.layer.borderColor = UIColor.gray.cgColor
//                         cell.layer.borderWidth = 3.0
//
//
//                          cell.layer.cornerRadius = 4.0
//                                 cell.layer.borderWidth = 1.0
//                                 cell.layer.borderColor  = UIColor.clear.cgColor
//                                 cell.layer.masksToBounds = false
//                                 cell.layer.shadowColor = UIColor.gray.cgColor
//                                 cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//                                 cell.layer.shadowRadius = 4.0
//                                 cell.layer.shadowOpacity  = 1.0
//                                 cell.layer.masksToBounds = false
//                                 cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//
//
//                        
//                     }
//             }
//     }
//        return cell
//     }
//     
//     return 
