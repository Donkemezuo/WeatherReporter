//
//  WebserviceProtocol.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation

protocol WebserviceProtocol: AnyObject {
    func cityWeatherReport(city: String, completionHandler: @escaping(QueryError?, WeatherReporterResponseModel?) -> ())
}
