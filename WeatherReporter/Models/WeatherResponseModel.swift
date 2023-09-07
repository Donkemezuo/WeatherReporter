//
//  WeatherReport.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation

struct WeatherResponseModel: Codable {
    var coordinates: CityCoordinates
    var weather: [WeatherReport]
    var temperatureInfo: WeatherTemperatureDetails
    var windInfo: WindInfo
    var additionalInfo: AdditionalInfo
    var cityName: String
    
    private enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case temperatureInfo = "main"
        case windInfo = "wind"
        case additionalInfo = "sys"
        case weather
        case cityName = "name"
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
    private var temperature: Double
    private var feeling: Double
    private var maximum: Double
    private var minimum: Double
    private var pressure: Int
    private var humidity: Int
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feeling = "feels_like"
        case maximum = "temp_max"
        case minimum = "temp_min"
        case pressure
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

struct WindInfo: Codable {
    var speed: Double
    var degree: Double
    
    private enum CodingKeys: String, CodingKey {
        case degree = "deg"
        case speed
    }
}

struct AdditionalInfo: Codable {
    var sunrise: Int
    var sunset: Int
}
