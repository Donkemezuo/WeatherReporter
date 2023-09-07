//
//  WeatherReport.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation

struct WeatherResponseModel: Codable {
    var weather: [WeatherReport]
    var temperatureInfo: WeatherTemperatureDetails
    var additionalInfo: AdditionalInfo
    var cityName: String
    
    private enum CodingKeys: String, CodingKey {
        case temperatureInfo = "main"
        case additionalInfo = "sys"
        case weather
        case cityName = "name"
    }
}

struct WeatherReport: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct WeatherTemperatureDetails: Codable {
    private var temperature: Double
    private var feeling: Double
    private var maximum: Double
    private var minimum: Double
    private var humidity: Int
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feeling = "feels_like"
        case maximum = "temp_max"
        case minimum = "temp_min"
        case humidity
    }
    
    var feelsLike: String {
        return String(feeling) + "°"
    }
    
    var lowTemp: String {
        return String(minimum) + "°"
    }
    
    var highTemp: String {
        return String(maximum) + "°"
    }
    
    var currentTemp: String {
        return String(temperature) + "°"
    }
    
    var humidityString: String {
        return String(humidity) + "°"
    }
    
}

struct AdditionalInfo: Codable {
    var sunrise: Int
    var sunset: Int
}
