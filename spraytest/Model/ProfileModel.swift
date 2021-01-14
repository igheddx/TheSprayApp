//
//  ProfileModel.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
struct ProfileModel2: Codable {
   //var profileId: Int?
   var firstName: String
   var lastName: String
   var username: String
   var password: String?
   var email: String
   var phone: String?
           
}
       
struct ProfilResponseModel: Codable {
    var token: String?
    var profileId: Int64
    var firstName: String
    var lastName: String
    var userName: String
    //var password: String?
    var email: String
    //var phone: String?
}

struct ProfileAvatar: Model {
    var token: String?
    var profileId: Int64
    var firstName: String?
    var lastName: String?
    var userName: String?
    var email: String?
    var phone: String?
    var avatar: String?
    var success: Bool?
}
