////
////  Spraying.swift
////  spraytest
////
////  Created by Ighedosa, Dominic on 8/6/20.
////  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
////
//
//import Foundation
//
//
//
//
//struct Mydata {
//    var balance: Int
//    var eventId: Int64
//    var profileId: Int64
//}
//
//var mydata = [Mydata]()
//
//let data1 = Mydata(balance: 20, eventId: 5, profileId: 45)
//let data2 = Mydata(balance: 30, eventId: 2, profileId: 31)
//
//mydata.append(data1)
//mydata.append(data2)
//
//class SprayBalance {
//    var balance: Int = 0
//    var profileId: Int64?
//    var eventId: Int64?
//    var token: String?
//
//    init(profileId: Int64, eventId: Int64, token: String) {
//          self.profileId = profileId
//          self.eventId = eventId
//          self.token = token
//
//      }
//
//    var balancefromPreference = SprayBalanceFromPreference(profileId: profileId!, eventId: eventId!, token: token!)
//    var balancefromDb = SprayBalanceFromLocalDb()
//  
//  
//    func getBalance(eventId: Int64, profileId: Int64) -> Int {
//        
//        for i in data3.balancedata {
//            if i.eventId == eventId {
//                if i.balance > 0 {
//                    let sprayBalance = i.balance
//                    return sprayBalance
//                } else {
//                    let sprayBalance = balancefromPreference.balancefromPreference
//                    return sprayBalance
//                }
//            }
//        }
//        
//        balance = balance + balancefromPreference.balancefromPreference
//        
//        return balance
//    }
//    
//}
//
//class SprayBalanceFromPreference {
//    var balance: Int = 0
//    var profileId: Int64?
//    var eventId: Int64?
//    var token: String?
//
//    init(profileId: Int64, eventId: Int64, token: String) {
//        self.profileId = profileId
//        self.eventId = eventId
//        self.token = token
//
//    }
//    var balancefromPreference: Int = 100
//    func getData() -> [EventPreferenceData] {
//    let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId!)", token: token!)
//    
//    Network.shared.send(request) { (result: Result<Data, Error>)  in
//    switch result {
//    case .success(let eventPreferenceData):
//        //self.parse(json: event)
//        let decoder = JSONDecoder()
//        do {
//                let eventPreferenceJson: [EventPreferenceData] = try decoder.decode([EventPreferenceData].self, from: eventPreferenceData)
//                for eventPrefData in eventPreferenceJson {
//                    self.balance = eventPrefData.maxSprayAmount
//    
//                print("BALANCE = \(self.balance)")
//            }
//    
//            } catch {
//                print(error)
//            }
//    case .failure(let error):
//            print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
//        }
//    }
//}
//    
//class SprayBalanceFromLocalDb {
//    var balancefromDb: Int = 100
//    var balancedata: [Mydata] = mydata
//    
//}
//
//
//
////class Balance {
////
////    var balance: Int = 0
////    var profileId: Int64?
////    var eventId: Int64?
////    var token: String?
////
////    init(profileId: Int64, eventId: Int64, token: String) {
////        self.profileId = profileId
////        self.eventId = eventId
////        self.token = token
////
////    }
////
////    func getEventPreference2() {
////         let request = Request(path: "/api/Event/prefs/\(profileId!)/\(eventId!)", token: token!)
////
////         Network.shared.send(request) { (result: Result<Data, Error>)  in
////            switch result {
////            case .success(let eventPreferenceData):
////            //self.parse(json: event)
////            let decoder = JSONDecoder()
////                do {
////                        let eventPreferenceJson: [EventPreferenceData] = try decoder.decode([EventPreferenceData].self, from: eventPreferenceData)
////                        for eventPrefData in eventPreferenceJson {
//////                                            print("paymentmethodId = \(paymenttypedata.paymentMethodId!)")
//////                                            print("customName = \(paymenttypedata.customName!)")
//////                                            print("paymenttype = \(paymenttypedata.paymentType!)")
////
////                        self.balance = eventPrefData.maxSprayAmount
////
////                        print("BALANCE = \(self.balance)")
////
////                    }
////
////                } catch {
////                    print(error)
////                }
////
////             case .failure(let error):
////                 print(" DOMINIC IGHEDOSA ERROR \(error.localizedDescription)")
////             }
////        }
////    }
////
////
////
////}
////
//
