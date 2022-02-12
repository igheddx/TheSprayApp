//
//  UserData.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/26/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct OnboardingUrl: Codable {
    let redirectUrl: String?
}
struct UserData: Model {
    let token: String?
    let profileId: Int64?
    let firstName: String?
    var lastName: String?
    let userName: String?
    let email: String?
    
    
//    var result: String {
//        return "token: \(String(describing: token)), profileId: \(String(describing: profileId)), firstName: \(firstName), lastName: \(lastName), userName: \(String(describing: userName)), email: \(String(describing: email)) "}

}

struct ProfileData: Codable {
    
    var  result: [UserData]
    var id: Int
    var exception: String?
    var status: Int
    var isCanceled: Bool
    var isCompleted: Bool
    var isCompletedSuccessfully: Bool
    var creationOptions: Int
    var asyncState: String?
    var isFaulted: Bool
    
}

struct ProfileData2: Model {
    
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
    var returnUrl: String?
    var refreshUrl: String?
    //var success: Bool
    //var isFaulted: Bool
    var hasValidPaymentMethod: Bool
    var defaultPaymentMethod: Int
    var defaultPaymentMethodCustomName: String?
    var isDuplicate: Bool
    
}
