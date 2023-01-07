//
//  WeatherData.swift
//  Clima
//
//  Created by Ogbemudia Terry Osayawe on 06.01.23.
//  Copyright © 2023 10GURU Software Solutions. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let id: Int
    let name: String
    let coord: Cordinates
    let main: Main
    let weather: [Weather]
    let base: String
    let visibility: Int
    let wind: Wind
    let clouds: Cloud
    let dt: Int64
    let sys: Sys
    let timezone: Int
    let cod: Int
    
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Cordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Cloud: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int64
    let sunset: Int64
}

