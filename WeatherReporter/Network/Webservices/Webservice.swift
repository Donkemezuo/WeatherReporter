//
//  Webservice.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation
import UIKit

// A web service class
class Webservice: WebserviceProtocol {
    
    private var urlSession: URLSession
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchCityWeatherReport(city: String,
                           completionHandler: @escaping (QueryError?, WeatherReporterResponseModel?) -> ()) {
        let endPoint = WeatherApiQueryEndPoint.cityWeatherReport(city: city).endPoint.replaceSpaceCharacters()
        WebserviceApiClient.fetchRemoteData(from: endPoint) { error, data in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                
                do {
                    let cityWeatherInfoResponse = try JSONDecoder().decode(WeatherReporterResponseModel.self, from: data)
                    completionHandler(nil, cityWeatherInfoResponse)
                } catch {
                    completionHandler(.jsonParse, nil)
                }
            }
        }
    }
    func fetchWeatherCondition(city: String, completionHandler: @escaping (QueryError?, WeatherConditionResponseModel?) -> ()) {
        let endPoint = WeatherApiQueryEndPoint.weatherCondition(city: city).endPoint.replaceSpaceCharacters()
        WebserviceApiClient.fetchRemoteData(from: endPoint) { error, data in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                
                do {
                    let weatherConditionResponse = try JSONDecoder().decode(WeatherConditionResponseModel.self, from: data)
                    completionHandler(nil, weatherConditionResponse)
                } catch {
                    completionHandler(.jsonParse, nil)
                }
            }
        }
    }
    
    func fetchWeatherConditionIcon(icon: String, completionHandler: @escaping (QueryError?, UIImage?) -> ()) {
        let endPoint = WeatherApiQueryEndPoint.weatherConditionIcon(icon: icon).endPoint
        WebserviceApiClient.fetchRemoteData(from: endPoint) { error, data in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                do {
                    let iconImage = UIImage(data: data)
                    completionHandler(nil, iconImage)
                } catch {
                    completionHandler(.jsonParse, nil)
                }
            }
        }
    }
}


final class WebserviceApiClient {
    
    static func fetchRemoteData(from endPoint: String, completionHandler: @escaping(QueryError?, Data?) -> ()) {
        guard let endPointURL = URL(string: endPoint) else { return }
        let urlRequest = URLRequest(url: endPointURL)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (responseData, response, error) in
            if let error = error {
                print("Error \(error.localizedDescription) encountered")
                completionHandler(.failedRequest(destination: endPoint), nil)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                      completionHandler(.badStatusCode(statusCode: String(statusCode)), nil)
                      return
                  }
            if let responseData = responseData {
                completionHandler(nil, responseData)
            }
        }
        dataTask.resume()
    }
}


enum WeatherApiQueryEndPoint {
    
    case cityWeatherReport(city: String)
    case weatherCondition(city: String)
    case weatherConditionIcon(icon: String)
    var endPoint: String {
        switch self {
        case .cityWeatherReport(let city):
            return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=1f1edc602d96a9f6d32d152a8bc67a51"
        case .weatherCondition(city: let city):
            return "https://samples.openweathermap.org/data/2.5/weather?q=\(city)&appid=1f1edc602d96a9f6d32d152a8bc67a51"
        case .weatherConditionIcon(icon: let icon):
            return "https://openweathermap.org/img/wn/\(icon)@2x.png"
        }
    }
}
