//
//  IconManager.swift
//  Weather
//
//  Created by Ruslan Fatkhulov on 23/06/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import UIKit

enum IconManager: String {
    
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"
    case Fog = "fog"
    case Cloudy = "cloudy"
    case PartlyCloudyDay = "partly-cloudy-day"
    case PartlyCloudyNight = "partly-cloudy-night"
    case UnpredictedIcon = "unpredicted-icon"
    
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
    
    init(rawValue: String) {
        switch rawValue {
        case "clear-day": self = .ClearDay
        case "clear-night": self = .ClearNight
        case "rain": self = .Rain
        case "snow": self = .Snow
        case "sleet": self = .Sleet
        case "wind": self = .Wind
        case "fog": self = .Fog
        case "cloudy": self = .Cloudy
        case "partly-cloudy-day": self = .PartlyCloudyDay
        case "partly-cloudy-night": self = .PartlyCloudyNight
        default: self = .UnpredictedIcon
        }
    }
}


