//
//  WeatherViewModel.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/6/23.
//

import Foundation
import CoreLocation

class WeatherViewModel: NSObject {
    
    private var dataManager: DataManager!
    private var locationManager: CLLocationManager!
    
    
    private var weatherReport: WeatherReporterResponseModel? {
        didSet {
            print("Update view")
            self.notifyAndUpdateUI()
        }
    }
    
    var notifyAndUpdateUI: (() -> ()) = {}
    
    var searchedCity: String? {
        didSet {
            self.fetchWeatherReport()
        }
    }
    
    
    override init() {
        super.init()
        self.dataManager = DataManager()
        setupLocationManager()
        fetchWeatherReport()
    }
    
    private func fetchWeatherReport() {
        guard let searchedCity = searchedCity else { return }
        self.dataManager.fetchCityWeatherReport(city: searchedCity) { error, responseModel in
            if let responseModel = responseModel {
                dump(responseModel)
            } else if let error = error {
                dump(error)
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
}

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            dump(location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription) requesting user location")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
}
