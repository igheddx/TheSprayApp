//
//  Metrics.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 11/28/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation
struct sEventMetricsSprayData: Decodable {
    let eventId: Int64?
    let senderId: Int64?
    let totalAmountGifted: Int
    let recipientList: [GeneralFields]
    let success: Bool
    var errorCode: String?
    var errorMessage: String?
    
}

struct rEventMetricsSprayData: Decodable {
    let eventId: Int64?
    let recipientId: Int64?
    let totalAmountReceived: Int
    let senderList: [GeneralFields]
    let success: Bool
    var errorCode: String?
    var errorMessage: String?
    
}
struct GeneralFields:  Codable {
    let eventId: Int64?
    let profileId: Int64?
    let lastName: String
    let firstName: String
    let totalAmount: Int
    let success: Bool
    var errorCode: String?
    var errorMessage: String?
}

struct EventMetricsSprayDetails  {
    let lastName: String
    let firstName: String
    let totalAmount: Int
    let recordType: String
    
}


