//
//  WeatherModel.swift
//  Tempo
//
//  Created by Ivan Geier on 26/05/20.
//  Copyright © 2020 Ivan Geier. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let maxTemperatura: Double
    let minTemperature: Double
    
    var conditionName: String {
        switch conditionID {
        case 200...299:
            return "cloud.bolt"
        case 300...399:
            return "cloud.drizzle"
        case 500...599:
            return "cloud.rain"
        case 600...699:
            return "cloud.snow"
        case 700...799:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...899:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
}
