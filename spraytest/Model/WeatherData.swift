//
//  WeatherData.swift
//  spray
//
//  Created by Ighedosa, Dominic on 4/10/20.
//  Copyright © 2020 Ighedosa, Dominic. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
