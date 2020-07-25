//
//  EventData.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/26/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct EventData: Model {
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


struct EventsOwned: Codable  {
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


struct EventsAttending: Codable  {
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

struct EventsInvited: Codable  {
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

struct EventResult: Codable {
    let eventsOwned: [EventsOwned]
    let eventsAttending: [EventsAttending]
    let eventsInvited: [EventsInvited]
}

struct EventList: Codable {
    let result: EventResult
    var id: Int64
    var exception: String?
    var status: Int64
    var isCanceled: Bool
    var isCompleted: Bool
    var isCompletedSuccessfully: Bool
    var creationOptions: Int64
    var asyncState: String?
    var isFaulted: Bool
    
//    init(result: EventResult, id: Int64, exception: String, status: Int64, isCanceled: Bool, isCompleted: Bool, isCompletedSuccessfully: Bool, creationOptions: Int64, asyncState: String, isFaulted: Bool) {
//        self.result = result
//        self.id = id
//        self.exception = exception
//        self.status = status
//        self.isCanceled = isCanceled
//        self.isCompleted = isCompleted
//        self.isCompletedSuccessfully = isCompletedSuccessfully
//        self.creationOptions = creationOptions
//        self.asyncState = asyncState
//        self.isFaulted = isFaulted
//    }
}



struct HomeScreenEventData {
   
    
//    init(homescreencategory: String,  homescreencategorydetails: [eventsOwned]){
//        self.homescreencategory = homescreencategory
//        self.homescreencategorydetails = homescreencategorydetails
    
//    var eventsOwned: [eventsOwned]
//    var eventsAttending: [eventsAttending]
//    var eventsInvited: [eventsInvited]
//    
//    init(eventsOwned: [eventsOwned], eventsAttending: [eventsAttending], eventsInvited: [eventsInvited]) {
//        self.eventsOwned  = eventsOwned
//        self.eventsAttending = eventsAttending
//        self.eventsInvited = eventsInvited
//    }
    
    
}


class BlogPost : Codable{
    var id : Int
    var day : Date
    var title : String
    var description : String

    init (id : Int, day : Date, title : String, description : String){
         self.id = id;
         self.day = day;
         self.title = title;
         self.description = description;
    }
}

//struct result: Codable {
//    
//    var eventsOwned: [eventsOwned]
//    let eventsAttending: [eventsAttending]
//    let eventsInvited: [eventsInvited]
//    var id: Int64
//    var exception: String?
//    var status: Int64
//    var isCanceled: Bool
//    var isCompleted: Bool
//    var isCompletedSuccessfully: Bool
//    var creationOptions: Int64
//    var asyncState: String?
//    var isFaulted: Bool
//}
//
//
struct MyeventsOwned: Codable  {
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
    
    init(eventId: Int64,
    ownerId: Int64,
    name: String,
    dateTime: String,
    address1: String,
    address2: String,
    city: String,
    zipCode: String,
    country: String,
    state: String,
    eventState: Int,
    eventCode: String,
    isActive: Bool){self.eventId = eventId;
        self.ownerId = ownerId;
        self.name = name;
        self.dateTime = dateTime;
        self.address1 = address1;
        self.address2 = address2;
        self.city = city;
        self.zipCode = zipCode;
        self.country = country;
        self.state = state;
        self.eventState = eventState;
        self.eventCode = eventCode;
        self.isActive = isActive
        
}
}
//
//
struct eventsAttending1: Codable  {
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
//
struct eventsInvited1: Codable  {
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
