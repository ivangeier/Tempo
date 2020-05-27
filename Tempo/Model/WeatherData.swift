//
//  WeatherData.swift
//  Tempo
//
//  Created by Ivan Geier on 26/05/20.
//  Copyright © 2020 Ivan Geier. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let weather : [Weather]
    let main : Main
}

struct Weather : Codable {
    let id : Int
}

struct Main : Codable {
    let temp : Double
    let feels_like : Double
    let temp_min : Double
    let temp_max : Double
}
