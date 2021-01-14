//
//  File.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 8/8/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

//this is used to take a user back to sprayViewcontroler with data
protocol SprayTransactionDelegate {
    func sprayGifterBalance(balance: Int)
    func sprayReceiverBalance(balance: Int)
    func sprayReceiverId(receiverId: Int64)
    func sprayEventSettingRefresh(isEventSettingRefresh: Bool)
    
    func processSprayTransaction(eventId: Int, senderId: Int, receiverId: Int, senderAmountRemaining: Int, receiverBalanceAfterSpray: Int, isAutoReplenish: Bool, paymentMethod: Int)
}

protocol RefreshScreenDelegate {
    func refreshScreen(isRefreshScreen: Bool)
}

protocol SideSelectionDelegate {
    func didTapChoice(name: String)
}
//this is used to take a user back to HomeViewControler from the EventSettingView Controller
protocol EventSettingBackToHomeDelegate {
    func refreshData(isShowScreen: Bool)
}


protocol MyCustomCellDelegator {
    func callSegueFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool, eventId: Int64, profileId: Int64, ownerId: Int64,  token: String, paymentClientToken: String, screenIdentifier: String, isAttendingEventId: Int64, eventTypeIcon: String)
}


protocol MyInvitationCustomCellDelegate {
    func callEventSettingFromCell(eventName: String, eventDateTime: String, eventCode: String, isActiveFlag: Bool, eventId: Int64, profileId: Int64, ownerId: Int64, token: String, paymentClientToken: String, screenIdentifier: String, eventTypeIcon: String)
}

protocol MyEventsCustomCellDelegate {
    func callInviteFriendsFromCell(eventName: String,
                                   eventDateTime: String,
                                   eventCode: String,
                                   isActiveFlag: Bool,
                                   eventId: Int64,
                                   profileId: Int64,
                                   ownerId: Int64,
                                   token: String,
                                   paymentClientToken: String,
                                   screenIdentifier: String,
                                   eventTypeIcon: String,
                                   address1: String,
                                   address2: String,
                                   city: String,
                                   state: String,
                                   zipCode: String,
                                   country: String,
                                   eventState: Int,
                                   eventType: Int
                                   
    
    )
    
    
    
    //let eventId = x.eventId// eventjson[i].result.eventsOwned[i].eventId
    //let ownerId = x.ownerId //eventjson[i].result.eventsOwned[i].ownerId
    //let name = x.name //eventjson[i].result.eventsOwned[i].name
    //let dateTime = x.dateTime //eventjson[i].result.eventsOwned[i].dateTime
//    let address1 = x.address1 //eventjson[i].result.eventsOwned[i].address1
//    let address2 = x.address2 //eventjson[i].result.eventsOwned[i].address2
//    let city = x.city //eventjson[i].result.eventsOwned[i].city
//    let zipCode = x.zipCode //eventjson[i].result.eventsOwned[i].zipCode
//    let country = x.country //eventjson[i].result.eventsOwned[i].country
//    let state = x.state //eventjson[i].result.eventsOwned[i].state
//    let eventState = x.eventState //eventjson[i].result.eventsOwned[i].eventState
//    //let eventCode = x.eventCode //eventjson[i].result.eventsOwned[i].eventCode
//    let isActive = x.isActive //eventjson[i].result.eventsOwned[i].isActive
//    let eventType = x.eventType
}


protocol GetClearEventDataDelegate {
    func getClearEventData()
}

protocol FromEditEventToHomeDelegate {
    func refreshScreen(isRefreshScreen: Bool)
}


