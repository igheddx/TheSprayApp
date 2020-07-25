//
//  ProfileData.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 4/29/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
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
