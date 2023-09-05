//
//  WeatherReport.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation

struct WeatherReporter: Codable {
    var coordinates: CityCoordinates
    var weather: [WeatherReport]
    var temperatureInfo: WeatherTemperatureDetails
    var windInfo: WindInfo
    var additionalInfo: AdditionalInfo
    
    private enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case temperatureInfo = "main"
        case windInfo = "wind"
        case additionalInfo = "sys"
        case weather
    }
    
}

struct CityCoordinates: Codable {
    var long: Double
    var lat: Double
    private enum CodingKeys: String, CodingKey {
        case long = "lon"
        case lat
    }
}

struct WeatherReport: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct WeatherTemperatureDetails: Codable {
    var temperature: Double
    var feeling: Double
    var maximum: Double
    var minimum: Double
    var pressure: Int
    var humidity: Int
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feeling = "feels_like"
        case maximum = "temp_max"
        case minimum = "temp_min"
        case pressure
        case humidity
    }
}

struct WindInfo: Codable {
    var speed: Double
    var degree: Double
    
    private enum CodingKeys: String, CodingKey {
        case degree = "deg"
        case speed
    }
}

struct AdditionalInfo: Codable {
    var sunrise: String
    var sunset: String
}
