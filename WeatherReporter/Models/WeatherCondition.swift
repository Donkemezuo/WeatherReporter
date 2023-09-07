//
//  WeatherCondition.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/6/23.
//

import Foundation


struct WeatherConditionResponseModel: Codable {
    var weather: [WeatherCondition]
}

struct WeatherCondition: Codable {
    var icon: String
    var description: String
}

extension WeatherConditionResponseModel {
    var condition: WeatherCondition? {
        return weather.first
    }
}

