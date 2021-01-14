//
//  MetricsModel.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 11/28/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
struct EventMetricsSprayDetails: Decodable {
    let eventId: Int64?
    let senderId: Int64?
    let totalAmountGifted: Int
    let recipientList: [RecipientListFields]
    let success: Bool
    let errorCode: String
    let errorMessage: String
    
}
//struct JoinEvent: Model {
//    var joinList: [JoinEventFields]
//}

struct RecipientListFields:  Codable {
    let eventId: Int64?
    let profileId: Int64?
    let lastName: String
    let firstName: String
    let totalAmount: Int
    let success: Bool
    let errorCode: String
    let errorMessage: String
}

