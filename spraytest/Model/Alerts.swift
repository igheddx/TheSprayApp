//
//  Alerts.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 4/27/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct AlertModel: Model {
    //let alertId: Int64
    let alertType: Int64
    let alertText: String
    let alertName: String
    let entityLink: Int64
    let isViewed: Bool
    let isActive: Bool
    let profileId: Int64
}

struct AlertModel2 {
    let alertId: Int64
    let alertType: Int64
    let alertText: String
    let alertName: String
    let entityLink: Int64
    let entityLinkObj: EntityObjData
    let isViewed: Bool
    let isActive: Bool
    let createdDate: String
    let modifiedDate: String
    let success: Bool
    let errorCode: Int?
    let errorMessage: String?
}
struct AlertData {
    let result: [AlertModel2]
    let id: Int
    let exception: String
    let status: Int
    let isCanceled: Bool
    let isCompleted: Bool
    let isCompletedSuccessfully: Bool
    let creationOptions: Int
    let asyncState: Int
    let isFaulted: Bool
}

struct EntityObjData {
    let result: Int?
    let id: Int?
    let exception: Int?
    let status:Int
    let isCanceled: Bool
    let isCompleted: Bool
    let isCompletedSuccessfully: Bool
    let creationOptions: Int
    let asyncState: Int?
    let isFaulted: Bool
}

