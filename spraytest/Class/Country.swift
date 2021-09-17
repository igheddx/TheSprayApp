//
//  Country.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 7/30/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct CountryData {
    
    func getCurrencyCode(regionCode: String) -> String {
        var currencyCode: String = ""
        switch regionCode {
        case "US":
            currencyCode = "usd"
        case "NG":
            currencyCode = "ngn"
        default:
            break
        }
        
        return currencyCode
    }
    
    func getCurrencyCodeWithCountryName(country: String) -> String {
        var currencyCode: String = ""
        switch country {
        case "United States":
            currencyCode = "usd"
        case "Nigeria":
            currencyCode = "ngn"
        default:
            break
        }
        
        return currencyCode
    }
    
    func getCountryNameWithCurrencyCode(currencyCode: String) -> String {
        var country: String = ""
        switch currencyCode {
        case "usd":
            country = "United States"
        case "ngn":
            country = "Nigeria"
        default:
            break
        }
        
        return country
    }
    
    func getDefaultAvailableCredit(currencyCode: String) -> Int {
        var defaultAvailableCreditAmt: Int = 0
        switch currencyCode {
        case "usd":
            defaultAvailableCreditAmt = 15
        case "ngn":
            defaultAvailableCreditAmt = 1000
        default:
            break
        }
        
        return defaultAvailableCreditAmt
    }
    
}
