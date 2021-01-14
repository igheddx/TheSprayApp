//
//  User.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

//
//  User.swift
//  Network
//
//  Created by Peter Livesey on 7/7/19.
//  Copyright © 2019 PeterLivesey. All rights reserved.
//
import Foundation
import UIKit

class MenuList {
    var title: String
    init(title: String) {
        self.title = title
    }
}

class Video {
    var image: String
    var title: String
    
    init(image: String, title: String) {
        self.image = image
        self.title = title
    }
}
struct User: Model {
//    let id: Int
//    let name: String
//    let username: String
//    let email: String
    
    let token: String?
    let profileId: Int64?
    let firstName: String
    let lastName: String
    let userName: String
    let password: String?
    let email: String
    let phone: String?
    
}




struct profile: Model {
    let firstName: String
    let lastName: String
}

struct AuthenticateUser: Model {
    let username: String
    let password: String
}

struct RSVPAttendees: Decodable {
    let profileId: Int64
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let eventId: Int64
    let isAttending: Bool
}

struct InvitedGuest: Decodable {
    
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
    let profileId: Int64?
}


