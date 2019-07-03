//
//  WeatherManager.swift
//  Weather
//
//  Created by Ruslan Fatkhulov on 23/06/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import UIKit

struct WeatherModel {
    
    let time: Date
    let summary: String
    let icon: UIImage
    let precipProbability: Double
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let cloudCover: Double
    let visibility: Double
    let horlyData: [WeatherJSONModel.Hourly.Data]
    let dailyData: [WeatherJSONModel.Daily.Data]
    
    var timeString: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        return dateFormater.string(from: time)
    }
    var summaryString: String {
        return "\(summary)"
    }
    var precipProbabilityString: String {
        return "\(lround(precipProbability)) %"
    }
    var temperatureString: String {
        return "\(lround(temperature))˚C"
    }
    var appearentTemperatureString: String {
        return "\(lround(apparentTemperature))˚C"
    }
    var humidityString: String {
        return "\(lround(humidity * 100)) %"
    }
    var pressureString: String {
        return "\(lround(pressure * 0.750062)) mm Hg"
    }
    var windSpeedString: String {
        return "\(lround(windSpeed)) m/s"
    }
    var cloudCoverString: String {
        return "\(Int(cloudCover * 100)) %"
    }
    var visibilityString: String {
        return "\(lround(visibility)) km"
    }
}

extension WeatherModel {
    
    init(json: WeatherJSONModel) {
        
        self.time = json.currently.time
        self.summary = json.currently.summary
        self.precipProbability = json.currently.precipProbability
        self.temperature = json.currently.temperature
        self.apparentTemperature = json.currently.apparentTemperature
        self.humidity = json.currently.humidity
        self.pressure = json.currently.pressure
        self.windSpeed = json.currently.windSpeed
        self.cloudCover = json.currently.cloudCover
        self.visibility = json.currently.visibility
        self.horlyData = json.hourly.data
        self.dailyData = json.daily.data
        
        let curIconString = json.currently.icon
        let curIcon = IconManager(rawValue: curIconString).image
        self.icon = curIcon
    }
}


