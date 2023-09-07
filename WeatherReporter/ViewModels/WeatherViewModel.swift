//
//  WeatherViewModel.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/6/23.
//

import Foundation
import CoreLocation
import UIKit

class WeatherViewModel: NSObject {
    
    private var apiService: Webservice!
    private var locationManager: CLLocationManager!
    
    var weatherConditionDetails = WeatherConditionModel() {
        didSet {
            self.notifyAndUpdateUI(nil)
        }
    }
    
    
     private var weatherReport: WeatherResponseModel? {
        didSet {
            self.updateWeatherConditionDetails()
        }
    }
    
   private var weatherCondition: WeatherCondition? {
        didSet {
            self.updateWeatherConditionDetails()
        }
    }
    
    private var weatherConditionImage: UIImage? {
        didSet {
            self.updateWeatherConditionDetails()
        }
    }
    
    var notifyAndUpdateUI: ((QueryError?) -> ()) = {_ in }
    
    var searchedCity: String? {
        didSet {
            print("Searched text = ", searchedCity ?? "")
            guard oldValue != self.searchedCity else { return }
            self.fetchWeatherReport()
            self.saveLastSearchedCity()
        }
    }
    
    private var userCity: String? {
        didSet {
            guard oldValue != self.userCity else { return }
            self.cityTosearch = self.userCity ?? "New York"
            self.fetchWeatherReport()
            self.saveLastSearchedCity()
        }
    }
    
    private var cityTosearch: String = "New York"
    
    
    override init() {
        super.init()
        self.apiService = Webservice()
        setupLocationManager()
        getCityNameFromUserLocation()
        cityTosearch = fetchLastSearchCity()
        fetchWeatherReport()
    }
    
    private func fetchWeatherReport() {
        apiService.fetchCityWeatherReport(city: cityTosearch) { error, responseModel in
            if let responseModel = responseModel {
                self.weatherReport = responseModel
                self.fetchWeatherCondition(city: responseModel.cityName)
            } else if let error = error {
                self.notifyAndUpdateUI(error)
            }
        }
    }
    
    private func fetchWeatherCondition(city: String) {
        apiService.fetchWeatherCondition(city: city) { error, responseModel in
            if let responseModel = responseModel {
                self.weatherCondition = responseModel.condition
                guard let icon = responseModel.condition?.icon else { return }
                self.fetchWeatherConditionIcon(icon: icon)
            } else if let error = error {
                self.notifyAndUpdateUI(error)
            }
        }
    }
    
    private func fetchWeatherConditionIcon(icon: String) {
        apiService.fetchWeatherConditionIcon(icon: icon) { error, image in
            if let error = error {
                self.notifyAndUpdateUI(error)
            } else if let image = image {
                self.weatherConditionImage = image
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        if CLLocationManager.locationServicesEnabled() {
            
            guard CLLocationManager().authorizationStatus == .restricted ||
                    CLLocationManager().authorizationStatus == .notDetermined else { return }
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func getCityNameFromUserLocation() {
        guard let location = locationManager.location else { return }
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Error = ", error.localizedDescription)
            } else if let placemark = placemarks?.first {
                self?.userCity = placemark.locality
            }
        }
    }
    
    func saveLastSearchedCity() {
        var city = "New York"
        if let searchedCity = searchedCity {
            city = searchedCity
        } else if let userCity = userCity {
            city = userCity
        }
        UserDefaults.standard.set(city, forKey: "locationCity")
    }
    
    func fetchLastSearchCity() -> String {
        return UserDefaults.standard.string(forKey: "locationCity") ?? "New York"
    }
    
    private func updateWeatherConditionDetails() {
        
        if let weatherReport = weatherReport {
            weatherConditionDetails.cityName = weatherReport.cityName
            weatherConditionDetails.feelsLike = weatherReport.temperatureInfo.feelsLike
            weatherConditionDetails.currentTemperature = weatherReport.temperatureInfo.currentTemp
            weatherConditionDetails.highTemperature = weatherReport.temperatureInfo.highTemp
            weatherConditionDetails.lowTemperature = weatherReport.temperatureInfo.lowTemp
            weatherConditionDetails.humidity = weatherReport.temperatureInfo.humidityString
        }
        
        if let weatherCondition = weatherCondition {
            weatherConditionDetails.conditionDescription = weatherCondition.description
        }
        
        if let weatherConditionImage = weatherConditionImage {
            weatherConditionDetails.conditionIcon = weatherConditionImage
        }
        
    }
    
}

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription) requesting user location")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        getCityNameFromUserLocation()
    }
}
