//
//  EventModel.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/26/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct EventCloseModel: Model {
    let profileId: Int64
    let eventId: Int64
}

struct EventCloseResult: Model {
    let isClosed: Bool
}
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
    let eventType: Int?
    let isRsvprequired: Bool
    let isSingleReceiver: Bool
    let isForBusiness: Bool
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
    let eventType: Int?
    let isRsvprequired: Bool
    let isSingleReceiver: Bool
    let isForBusiness: Bool
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

struct EventDataReturned: Decodable {
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
    let eventType: Int?
    let success: Bool
    let errorCode: String?
    let errorMessage: String?

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
    var eventType: Int?
    var isRsvprequired: Bool?
    var isSingleReceiver: Bool?
    var isForBusiness: Bool?
    var defaultEventPaymentMethod: Int?
    var defaultEventPaymentCustomName: String?
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
    var eventType: Int?
    var isRsvprequired: Bool?
    var isSingleReceiver: Bool?
    var isForBusiness: Bool?
    var defaultEventPaymentMethod: Int?
    var defaultEventPaymentCustomName: String?
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
    var eventType: Int?
    var isRsvprequired: Bool?
    var isSingleReceiver: Bool?
    var isForBusiness: Bool?
    var defaultEventPaymentMethod: Int?
    var defaultEventPaymentCustomName: String?
}

struct EventIdAttending: Decodable  {
    var eventId: Int64
}

struct EventResultModel: Decodable {
    var eventsOwned: [EventsOwnedModel]
    var eventsAttending: [EventsAttendingModel]
    var eventsInvited: [EventsInvitedModel]
    var eventIdsAttending: [Int]
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
    var eventType: Int?
    var isRsvprequired: Bool
    var isSingleReceiver: Bool
    var isForBusiness: Bool
    var defaultEventPaymentMethod: Int?
    var defaultEventPaymentCustomName: String?
    var isAttending: Bool?
    var dataCategory: String?
    var hasPaymentMethod: Bool
    var outstandingTransferAmt1: String
    var pendingPayoutAmt1: String
    var totalGiftedAmt1: String
    var totalReceivedAmt1: String
    var currency1: String
    var paymentCustomerId1: String
    var paymentConnectedActId1: String
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

struct EventPreference: Model {
    var eventId: Int64
    var profileId: Int64
    var paymentMethod: Int
    var maxSprayAmount: Int
    var replenishAmount: Int
    var notificationAmount: Int
    var isAutoReplenish: Bool
    var currency: String
}

struct EventPreferenceData:  Model {
    var eventId: Int64
    var profileId: Int64
    var paymentMethod: Int
    var maxSprayAmount: Int
    var replenishAmount: Int
    var notificationAmount: Int
    var isAutoReplenish: Bool
    var createDate: String
    var modifiedDate: String
    var success: Bool
    var errorCode: String?
    var errorMessage: String?
}

struct EventPreferenceData2:  Model {
    var eventId: Int64
    var profileId: Int64
    var paymentMethod: Int
    var maxSprayAmount: Int
    var replenishAmount: Int
    var notificationAmount: Int
    var isAutoReplenish: Bool
    var createDate: String
    var modifiedDate: String
    var paymentMethodDetails: paymentMethodDetails
//    var defaultEventPaymentMethod: Int
//    var defaultEventPaymentCustomName: String
    var success: Bool
    var errorCode: String?
    var errorMessage: String?
}

struct SprayTransactionModel: Model {
    let eventId: Int64
    let senderId: Int64
    let recipientId: Int64
    let amount: Int
    let success: Bool
    let errorCode: String
    let errorMessage: String
}

struct GifterTransactionTotal: Model {
    let eventId: Int64
    let profileId: Int64
    let totalAmountAllTransactions: Int
    let numUniqueTransactions: Int
    let success: Bool
    let errorCode: String?
    let errorMessage: String?
}
struct paymentMethodDetails:  Model {
    var paymentMethodId: Int
    var profileId: Int64
    var paymentType: Int
    var customName: String!
    var paymentDescription: String!
    var paymentExpiration: String!
    var defaultPaymentMethod: Bool
    var success: Bool
    var errorCode: String?
    var errorMessage: String?
}
struct EventStatsData:  Decodable {
    var eventId: Int64
    var profileId: Int64
    var totalAmountReceived: Int
    var totalAmountGifted: Int
    var success: Bool
    var errorCode: String?
    var errorMessage: String?
    
}

struct EventTypeData {
    var id: Int
    var eventTypeName: String
    init(id:Int,eventTypeName:String){
        self.id = id
        self.eventTypeName = eventTypeName
    }
}

struct EventTypeIcon {

    func getEventTypeIcon(eventTypeId: Int) -> String {
        var eventTypeIconName: String = ""
        switch eventTypeId {
        case 1:
            eventTypeIconName = "birthdayicon1" //bithday
            return eventTypeIconName
        case 2:
            eventTypeIconName = "generalpartyicon" //anniversary
            return eventTypeIconName
        case 7:
            eventTypeIconName = "entertainer" //street entertainer
            return eventTypeIconName
        case 3:
            eventTypeIconName = "weddingicon" //wedding
            return eventTypeIconName
        case 4:
            eventTypeIconName = "babyshowericon" //baby shower
            return eventTypeIconName
        case 5:
            eventTypeIconName = "graduationicon" //graduation
            return eventTypeIconName
        case 6:
            eventTypeIconName = "graduationicon" //naming ceremony
            return eventTypeIconName
       
        case 8:
            eventTypeIconName = "generalpartyicon" //family reunion
            return eventTypeIconName
        case 9:
            eventTypeIconName = "concerticon" //concert
            return eventTypeIconName
        case 10:
            eventTypeIconName = "generalpartyicon" //general party
            return eventTypeIconName
        case 11:
            eventTypeIconName = "waiter" //waiter
            return eventTypeIconName
        case 12:
            eventTypeIconName = "bandicon" //band
            return eventTypeIconName
        case 13:
            eventTypeIconName = "thanksgivingicon" //band
            return eventTypeIconName
        case 14:
            eventTypeIconName = "waiter" //band
            return eventTypeIconName
        case 15:
            eventTypeIconName = "entertainer" //band
            return eventTypeIconName
        default:
            eventTypeIconName = "generalpartyicon"
            return eventTypeIconName
            
        }
    }
    
}

  
struct CloseEvent: Model {
    let profileId: Int64
    let eventId: Int64
}
