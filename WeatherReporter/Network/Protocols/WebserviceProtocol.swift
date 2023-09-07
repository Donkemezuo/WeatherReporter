//
//  WebserviceProtocol.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation
import UIKit

protocol WebserviceProtocol: AnyObject {
    func fetchCityWeatherReport(city: String, completionHandler: @escaping(QueryError?, WeatherResponseModel?) -> ())
    func fetchWeatherCondition(city: String, completionHandler: @escaping(QueryError?, WeatherConditionResponseModel?) -> ())
    func fetchWeatherConditionIcon(icon: String, completionHandler: @escaping(QueryError?, UIImage?) -> ())
}
