//
//  ViewController.swift
//  Weather
//
//  Created by Ruslan Fatkhulov on 23/06/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import UIKit
import CoreLocation

let keysForTableView = ["sunriseSunsetTime", "temperatureHighLow", "apparentTemperature", "precipProbability", "humidity", "windSpeed", "pressure", "cloudCover", "visibility"]
let mapForTableViewCellKey = ["sunriseSunsetTime": "Sunrise/Sunset","temperatureHighLow": "High/Low", "precipProbability": "Chance of precip", "humidity": "Humidity", "windSpeed" : "Wind", "apparentTemperature": "Feels like", "pressure": "Pressure", "cloudCover": "Cloud cover", "visibility": "Visibility"]
var mapForTableViewCellValue = [String: String]()
var arrayForCollectionViewCell = [(date: Date, icon: UIImage, temp: String)]()

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var apiWeatherManager: APIWeatherManager!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updateUI(weather: APIWeatherManager) {
        weather.getData { (json, error) in
            guard let json = json, error == nil else { return }
            let wm = WeatherModel(json: json)
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "EEEE"
            
            DispatchQueue.main.async {
                self.summaryLabel.text = wm.summaryString
                self.iconImage.image = wm.icon
                self.temperatureLabel.text = wm.temperatureString
                self.todayLabel.text = dateFormater.string(from: Date())
                
                dateFormater.dateFormat = "HH:mm"
                let today = wm.dailyData[0]
                mapForTableViewCellValue["precipProbability"] = wm.precipProbabilityString
                mapForTableViewCellValue["humidity"] = wm.humidityString
                mapForTableViewCellValue["windSpeed"] = wm.windSpeedString
                mapForTableViewCellValue["apparentTemperature"] = wm.appearentTemperatureString
                mapForTableViewCellValue["pressure"] = wm.pressureString
                mapForTableViewCellValue["cloudCover"] = wm.cloudCoverString
                mapForTableViewCellValue["visibility"] = wm.visibilityString
                mapForTableViewCellValue["temperatureHighLow"] = "\(lround(today.temperatureHigh))/\(lround(today.temperatureLow))"
                mapForTableViewCellValue["sunriseSunsetTime"] = "\(dateFormater.string(from: today.sunriseTime))/\(dateFormater.string(from: today.sunsetTime))"
                
                arrayForCollectionViewCell.removeAll()
                for i in wm.horlyData {
                    let t = "\(lround(i.temperature))"
                    let iconString = i.icon
                    let icon = IconManager(rawValue: iconString).image
                    arrayForCollectionViewCell.append((date: i.time, icon: icon, temp: t))
                }
                
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            if let city = placemarks?[0].locality {
                self.cityLabel.text = city
            }
        })
        
        apiWeatherManager = APIWeatherManager(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        updateUI(weather: apiWeatherManager)
        
        print("my locayion latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keysForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        let i = keysForTableView[indexPath.row]
        
        cell.keyLabel.text = mapForTableViewCellKey[i]
        cell.valueLabel.text = mapForTableViewCellValue[i]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayForCollectionViewCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH"
        
        cell.temperatureLabel.text = arrayForCollectionViewCell[indexPath.row].temp
        cell.timeLabel.text = dateFormater.string(from: arrayForCollectionViewCell[indexPath.row].date)
        cell.iconImage.image = arrayForCollectionViewCell[indexPath.row].icon
        
        return cell
    }
}
