//
//  UserModel.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/26/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
import Contacts

struct UserModel: Model {
//    let token: String?
//    let profileId: Int64?
//    let firstName: String
//    let lastName: String
//    let userName: String?
//    let email: String?
    
    //let token: String?
       //let profileId: Int64?
   let firstName: String?
   var lastName: String = ""
   let username: String?
   let password: String?
   let email: String
   var phone: String = ""
    
}

struct ProfileModel: Codable {
    let  result: [UserModel]
    let id: Int
    let exception: String?
    let status: Int
    let isCanceled: Bool
    let isCompleted: Bool
    let isCompletedSuccessfully: Bool
    let creationOptions: Int
    let asyncState: String?
    let isFaulted: Bool
}

struct ContactStruct {
    let givenName: String
    let familyName: String
    let number: String
    let emailAddress: String
//    let email: String
   // let contact: CNContact
}

struct Contact {
    let name: String
    let phone: String
    let email: String
    let isRSVP: Bool
    let isInvited: Bool
    //let email: String
    // let contact: CNContact
    
}

struct Contact2 {
   // let name: String
    //let phone: String
    //let email: CNLabeledValue<NSCopying & NSSecureCoding>
     //let contact: CNContact
     let contact: CNContact
}


struct Attendees: Model {
    let profileId: Int64
    let eventId: Int64
    let isAttending: Bool
}


struct AddAttendees: Model {
    let profileId: Int64
    let eventId: Int64
    let eventAttendees: [Attendees]
    
}

struct SendInvite: Model {
    let profileId: Int64?
    let email: String?
    let phone: String?
    let eventCode: String
}
struct JoinEventData: Model {
    var joinList: [JoinEventFields]
}
struct JoinEvent: Model {
    var joinList: [JoinEventFields]
}

struct JoinEventFields: Model {
    let profileId: Int64?
    let email: String?
    let phone: String?
    let eventCode: String
}

struct SendEmail: Model {
    let toEmail: String?
    let toFirstName: String?
    let toLastName: String?
    let subject: String?
    let message: String?
    let ccList: [String]
}
