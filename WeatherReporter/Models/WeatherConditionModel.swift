//
//  WeatherConditionModel.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/7/23.
//

import Foundation
import UIKit

struct WeatherConditionModel {
    
    var lowTemperature: String
    var highTemperature: String
    var currentTemperature: String
    var sunriseTime: String
    var sunsetTime: String
    var conditionIcon: UIImage?
    var conditionDescription: String
    var humidity: String
    var feelsLike: String
    var cityName: String
    
    init(
        lowTemperature: String = "",
         highTemperature: String = "",
         currentTemperature: String = "",
         sunriseTime: String = "",
         sunsetTime: String = "",
         conditionIcon: UIImage? = nil,
         conditionDescription: String = "",
         humidity: String = "",
         feelsLike: String = "",
         cityName: String = ""
         
    ) {
        self.lowTemperature = lowTemperature
        self.highTemperature = highTemperature
        self.currentTemperature = currentTemperature
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
        self.conditionIcon = conditionIcon
        self.conditionDescription = conditionDescription
        self.humidity = humidity
        self.feelsLike = feelsLike
        self.cityName = cityName
    }
}
