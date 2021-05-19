//
//  ProfileData.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 4/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct ConnectedAccount: Model {
    let isAccountConnected: Bool
    let url: String?  //"https://connect.stripe.com/setup/s/DcNKKcRokEz3",
    let success: Bool
    let errorCode: String?
    let errorMessage: String?
}

struct MyProfile {
//    var firstName: String
//    var lastName: String
//    var email: String
//    var phone: String
    var token: String?
    var profileId: Int64
    var firstName: String
    var lastName: String
    var userName: String
    var email: String
    var phone: String
    var avatar: String?
    var paymentCustomerId: String?
    var paymentConnectedActId: String?
    var success: Bool
    var returnUrl: String
    var refreshUrl: String
    var hasValidPaymentMethod: Bool
    var defaultPaymentMethod: Int
    var defaultPaymentMethodCustomName: String?
    
}
struct RegisterPostModel: Codable {
   //var profileId: Int?
   var firstName: String
   var lastName: String
   var username: String
   var password: String?
   var email: String
   var phone: String?
   
}
       
struct RegisterResponseModel: Codable {
   var token: String?
   var profileId: Int64
   var firstName: String
   var lastName: String
   var userName: String
   //var password: String?
   var email: String
   //var phone: String?
   
}
