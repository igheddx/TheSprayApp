//
//  Security.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/5/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct DeviceInfoId: Model {
    let deviceUniqueId: String
}

struct DeviceInfoData: Model {
    let deviceUniqueId: String?
    let success: Bool
    let errorCode: String?
    let errorMessage: String?
  
}
