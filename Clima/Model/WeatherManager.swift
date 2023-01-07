//
//  WeatherManager.swift
//  Clima
//
//  Created by Ogbemudia Terry Osayawe on 06.01.23.
//  Copyright © 2023 10GURU Software Solutions. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel) -> Void
    func didFailWithError(error: Error) -> Void
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let apiEndpoint = "https://api.openweathermap.org/data/2.5/weather?appid=daf7c5229d2cd26ca998f8b7d78537ce&unit=metric"
    
    func fetchWeatherInfo(cityName: String) {
        let urlString = "\(apiEndpoint)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(apiEndpoint)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) -> Void {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URL session
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //optional binding
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weatherModel: weather)
                    }
                }
            }
            // 4. start the task
            task.resume()
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let weatherDto = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(weatherDto: weatherDto)
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
