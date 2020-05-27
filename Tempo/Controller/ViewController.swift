//
//  ViewController.swift
//  Tempo
//
//  Created by Ivan Geier on 26/05/20.
//  Copyright © 2020 Ivan Geier. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    //search Stack
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    //information Stack
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    
    
    var weatherManager = WeatherManager()
    var coreLocation = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        coreLocation.delegate = self
        coreLocation.requestWhenInUseAuthorization()
        
        styleTextFiel(searchTextField)
        coreLocation.requestLocation()
        
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        
        coreLocation.requestLocation()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    
    
    //MARK: -  TextField Style Method
    
    func styleTextFiel(_ texteField: UITextField) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: texteField.frame.height, width: texteField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        
        texteField.borderStyle = .none
        texteField.layer.addSublayer(bottomLine)
        
    }
}

//MARK: -  Weather Manager Delegate

extension ViewController: WeatherManagerDelegate {
    
    func weatherUpDate(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            
            self.iconImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = String(format: "%.1f", weather.temperature)
            self.minLabel.text = String(format: "%.1f", weather.minTemperature)
            self.maxLabel.text = String(format: "%.1f", weather.maxTemperatura)
            
        }
    }
}

//MARK: -  Core Location Delegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = coreLocation.location {
            
            coreLocation.stopUpdatingLocation()
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            weatherManager.findWeatherByCordnates(latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
    }
    
}

//MARK: -  TextField Delegate (search Button)

extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextField.endEditing(true)
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if var city = searchTextField.text {
            
            if city.last == " " {
                
                city.removeLast()
            }
            
            city = city.replacingOccurrences(of: " ", with: "%20")
            weatherManager.findCityWheater(cityName: city)
            searchTextField.resignFirstResponder()
            
        }
        
        searchTextField.text = ""
    }
}
