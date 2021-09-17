//
//  Payment.swift
//  spraytest
//
//  Created by Ighedosa, Dominic on 7/26/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct InitializePaymentModel: Model {
    let token: String?
    let profileId: Int64?
    let firstName: String?
    let lastName: String?
    let userName: String?
    let email: String?
    let phone: String?
    
}

struct InitializePaymentData: Model {
    let profileId: Int64?
    let clientToken: String?
//
//    let firstName: String?
//    let lastName: String?
//    let userName: String?
//    let email: String?
//    let phone: String?
//
}

struct AddPayment: Model {
    let paymentMethodToken: String?
    let isUpdate: Bool?
    let customName: String?
    let paymentType: Int64?
    let paymentDescription: String?
    let paymentExpiration: String?
    let currency: String
    let profileId: Int64?
}

struct AddPaymentType: Model {
    let nonce: String?
    let customName: String?
    let paymentType: Int64?
    let paymentDescription: String?
    let paymentExpiration: String?
    let profileId: Int64?
}

struct PaymentTypeData: Decodable  {
    let paymentMethodId: Int64?
    let profileId: Int64?
    let paymentType: Int64?
    let customName: String?
    let paymentDescription: String?
    let paymentExpiration: String?
    let defaultPaymentMethod: Bool?
    let currency: String?
    let success: Bool?
    let errorCode: String?
    let errorMessage: String?
}


struct PaymentTypeData2: Decodable  {
    let paymentMethodId: Int64?
    let profileId: Int64?
    let paymentType: Int64?
    let customName: String?
    let paymentDescription: String?
    let paymentExpiration: String?
    let defaultPaymentMethod: Bool?
    let currency: String?
    let paymentImage: String?
    
    
//    let success: Bool?
//    let errorCode: String?
//    let errorMessage: String?
}

