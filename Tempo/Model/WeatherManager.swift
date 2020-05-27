//
//  WheaterManager.swift
//  Tempo
//
//  Created by Ivan Geier on 26/05/20.
//  Copyright © 2020 Ivan Geier. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    
    func weatherUpDate(_ weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&lang=pt_br&APPID="
    let weatherAPI = "YOUR_API_HERE"
    
    //prepare URL to online request
    func findCityWheater (cityName: String) {
        
        let URL = "\(weatherURL)\(weatherAPI)&q=\(cityName)"
        print(URL)
        performRequest(with: URL)
        
    }
    
    func findWeatherByCordnates (latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let URL = "\(weatherURL)\(weatherAPI)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: URL)
        
    }
    
    
    //MARK: -  Perform URL request
    
    func performRequest (with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                    print("Error performing request! \(error!)")
                    return
                    
                } else {
                    
                    if let safeData = data {
                        
                        if let weather = self.parseJSON(with: safeData) {
                            
                            self.delegate?.weatherUpDate(self, weather: weather)
                        }
                        
                    }
                }
                
            }
            task.resume()
        }
    }
    
    
    //MARK: -  Decode JSON data and delegate to View Controller
    
    func parseJSON (with weatherData: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let feels = decodedData.main.feels_like
            let min = decodedData.main.temp_min
            let max = decodedData.main.temp_max
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, feelsLike: feels, maxTemperatura: max, minTemperature: min)
            return weather
            
        } catch {
            
            return nil
        }
    }
}
