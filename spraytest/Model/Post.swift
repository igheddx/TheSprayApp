//
//  Post.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 4/11/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation


class Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }

    init(userID: Int, id: Int, title: String, body: String) {
        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
    }
}
