//
//  EventModel.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/26/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct EventModel: Model {
    let ownerId: Int64
    let name: String
    let dateTime: String
    let address1: String
    let address2: String
    let city: String
    let zipCode: String
    let country: String
    let state: String
    let eventId: Int64?
    let isActive: Bool?
    let eventState: Int64?
}

struct EventModelEdit: Model {
    let ownerId: Int64
    let name: String?
    let dateTime: String?
    let address1: String?
    let address2: String?
    let city: String?
     let zipCode: String?
     let country: String?
   
    let state: String?
    let eventId: Int64
    let isActive: Bool
    let eventState: Int64
}
struct EventModelEditData: Model {
    let eventId: Int64
    let ownerId: Int64
    let name: String?
    let dateTime: String?
    let address1: String?
    let address2: String?
    let city: String?
    let zipCode: String?
    let country: String?
    let state: String?
    let eventState: Int64
    let eventCode: String?
    let isActive: Bool
    let success: Bool
    let data: [String]?
    let errorCode: String?
    let errorMessage: String?
    let status: Bool
    
}

struct EventsOwnedModel:  Decodable {
    var eventId: Int64
    var ownerId: Int64
    var name: String
    var dateTime: String
    var address1: String
    var address2: String
    var city: String
    var zipCode: String
    var country: String
    var state: String
    var eventState: Int
    var eventCode: String
    var isActive: Bool
}


struct EventsAttendingModel:  Decodable {
    var eventId: Int64
    var ownerId: Int64
    var name: String?
    var dateTime: String?
    var address1: String?
    var address2: String?
    var city: String?
    var zipCode: String?
    var country: String?
    var state: String?
    var eventState: Int
    var eventCode: String?
    var isActive: Bool
}

struct EventsInvitedModel: Decodable  {
    var eventId: Int64
       var ownerId: Int64
       var name: String?
       var dateTime: String?
       var address1: String?
       var address2: String?
       var city: String?
       var zipCode: String?
       var country: String?
       var state: String?
       var eventState: Int
       var eventCode: String?
       var isActive: Bool
}

struct EventResultModel: Decodable {
    var eventsOwned: [EventsOwnedModel]
    var eventsAttending: [EventsAttendingModel]
    var eventsInvited: [EventsInvitedModel]
}

struct EventListModel:  Decodable {
var result: EventResultModel
    
//    var eventsOwned: [EventsOwnedModel]
//    var eventsAttending: [EventsAttendingModel]
//    var eventsInvited: [EventsInvitedModel]
//
    var id: Int64
    var exception: String?
    var status: Int64
    var isCanceled: Bool
    var isCompleted: Bool
    var isCompletedSuccessfully: Bool
    var creationOptions: Int64
    var asyncState: String?
    var isFaulted: Bool
}

struct EventProperty {
    var eventId: Int64
    var ownerId: Int64
    var name: String?
    var dateTime: String?
    var address1: String?
    var address2: String?
    var city: String?
    var zipCode: String?
    var country: String?
    var state: String?
    var eventState: Int
    var eventCode: String?
    var isActive: Bool
    var isAttending: Bool?
    var dataCategory: String?
}
struct HomeScreenEventDataModel {
    var eventCategory: String?
    var eventProperty: [EventProperty]
    
    init?(eventCategory: String, eventProperty: [EventProperty]){
        self.eventCategory = eventCategory
        self.eventProperty = eventProperty
    }
    
    
    
}
public protocol LosslessStringConvertible: CustomStringConvertible {
  init? (_ description: String)
}

struct isAttendingModel {
    let profileId: Int64
    let eventId: Int64
    let category: String
   
}


struct isAttendingData {
    let profileId: Int64
    let eventId: Int64
    let isAttending: Bool
    let category: String
}
