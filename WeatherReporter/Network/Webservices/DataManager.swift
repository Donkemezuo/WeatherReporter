//
//  DataManager.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation

class DataManager {
    private let webservice = Webservice()
    
    func fetchCityWeatherReport(city: String, completionHandler: @escaping(QueryError?, WeatherReporterResponseModel?) -> ()) {
        webservice.cityWeatherReport(city: city) { error, responseModel in
            completionHandler(error, responseModel)
        }
    }
}
