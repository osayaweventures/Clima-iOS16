//
//  ViewController.swift
//  Clima
//
//  Created by Ogbemudia Terry Osayawe on 06.01.23.
//  Copyright © 2023 10GURU Software Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
   
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
       
        searchField.delegate = self //set handler
        weatherManager.delegate = self
        locationManager.delegate = self
        
        if let openWeatherApiKey = Bundle.main.infoDictionary?["OPEN_WEATHER_API_KEY"] as? String {
            weatherManager.apiKey = openWeatherApiKey
        }
        
        locationManager.requestLocation()
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
        print(searchField.text ?? "empty")
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}


//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        print(textField.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //use search term
        if let city = searchField.text {
            weatherManager.fetchWeatherInfo(cityName: city)
        }
        
        // reset textField
        searchField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        
        textField.placeholder = "Type something"
        
        return false
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel) -> Void {
        
        DispatchQueue.main.async { [self] in
            temperatureLabel.text = weatherModel.temperatureString
            cityLabel.text = weatherModel.cityName
            conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeatherInfo(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
