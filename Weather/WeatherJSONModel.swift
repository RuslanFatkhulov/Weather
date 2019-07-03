//
//  WeatherJSONModel.swift
//  Weather
//
//  Created by Ruslan Fatkhulov on 23/06/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import Foundation

struct WeatherJSONModel: Decodable {
    
    struct Currently: Decodable {
        let time: Date
        let summary: String
        let icon: String
        let precipProbability: Double
        let temperature: Double
        let apparentTemperature: Double
        let humidity: Double
        let pressure: Double
        let windSpeed: Double
        let cloudCover: Double
        let visibility: Double
    }
    
    struct Hourly: Decodable {
        struct Data: Decodable {
            let time: Date
            let icon: String
            let precipProbability: Double
            let temperature: Double
        }
        let data: [Data]
    }
    
    struct Daily: Decodable {
        struct Data: Decodable {
            let icon: String
            let time: Date
            let temperatureHigh: Double
            let temperatureLow: Double
            let sunriseTime: Date
            let sunsetTime: Date
        }
        let data: [Data]
    }
    
    let currently: Currently
    let hourly: Hourly
    let daily: Daily
}
