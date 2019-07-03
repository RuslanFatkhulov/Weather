//
//  NetworkManager.swift
//  Weather
//
//  Created by Ruslan Fatkhulov on 23/06/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import Foundation

class APIWeatherManager {
    
    private let baseURL = "https://api.darksky.net"
    var latitude: Double
    var longitude: Double
    
    var path: String {
        var dictionary: NSDictionary?
        if let bmpath = Bundle.main.path(forResource: "keys", ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: bmpath)
        }
        let apiKey = dictionary?.value(forKeyPath: "apiKey")
        return "/forecast/\(apiKey!)/\(latitude),\(longitude)?units=si"
    }
    
    var request: URLRequest {
        let baseURL = URL(string: self.baseURL)
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
    
    func getData(completition: @escaping (WeatherJSONModel?, Error?) -> ()) {
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            if let error = error {completition(nil, error); return }
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(WeatherJSONModel.self, from: data)
                completition(result, nil)
            } catch {
                completition(nil, error)
            }
        }.resume()
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
