//
//  SprayModel.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 5/26/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation


struct SprayTransaction {
    var id: Int
    var eventId: Int64
    var senderId: Int64
    var receiverId: Int64
    var senderAmountRemaining: Int
    var receiverAmountReceived: Int
    var transactionDateTime: String
    var paymentType: Int
}


struct SenderSprayBalance {
    var id: Int
    var eventId: Int64
    var senderId: Int64
    var senderAmountRemaining: Int
    var isAutoReplenish: Int
    var transactionDateTime: String
    var paymentType: Int
}
