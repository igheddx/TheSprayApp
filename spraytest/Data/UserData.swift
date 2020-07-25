//
//  UserData.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/26/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation


struct UserData: Model {
    let token: String?
    let profileId: Int64?
    let firstName: String?
    let lastName: String?
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
