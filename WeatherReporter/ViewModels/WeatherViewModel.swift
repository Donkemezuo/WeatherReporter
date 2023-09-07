//
//  WeatherViewModel.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/6/23.
//

import Foundation
import CoreLocation
import UIKit

/// A view Model class that handles the business logic of weather view controller
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
            guard oldValue != self.searchedCity else { return }
            self.cityTosearch = self.searchedCity ?? ( self.userCity ?? "New York")
            self.fetchWeatherReport()
            self.saveLastSearchedCity()
        }
    }
    
    private var userCity: String? {
        didSet {
            guard oldValue != self.userCity else { return }
            self.cityTosearch = self.searchedCity ?? ( self.userCity ?? "New York")
            self.fetchWeatherReport()
            self.saveLastSearchedCity()
        }
    }
    
    private var cityTosearch: String = ""
    
    override init() {
        super.init()
        self.apiService = Webservice()
        setupLocationManager()
        getCityNameFromUserLocation()
        cityTosearch = fetchLastSearchCity()
        fetchWeatherReport()
    }
    
    /// A function that fetches the weather report of the searched city
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
    
    /// A function to fetch the weather condition details of a given city
    /// - Parameter city: The city whose weather condition we are fetching
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
    
    /// A function to fetch the icon of a weather condition
    /// - Parameter icon: the icon string from the weather condition object
    private func fetchWeatherConditionIcon(icon: String) {
        apiService.fetchWeatherConditionIcon(icon: icon) { error, image in
            if let error = error {
                self.notifyAndUpdateUI(error)
            } else if let image = image {
                self.weatherConditionImage = image
            }
        }
    }
    
    /// A function to setup location services
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
    
    /// A function that performs revserse geocoding from user location to retrieve the name of the city
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
    
    /// A function to save the last searched location in user default
    func saveLastSearchedCity() {
        UserDefaults.standard.set(cityTosearch, forKey: "locationCity")
    }
    
    /// A function that retrieves the last searched location from user default
    /// - Returns: The last searched location and if there is no previous search, returns 'New York' as the default search
    func fetchLastSearchCity() -> String {
        let lastSearch = UserDefaults.standard.string(forKey: "locationCity")
        if let lastSearch = lastSearch {
            searchedCity = lastSearch
            return lastSearch
        }
        return  "New York"
    }
    
    /// A function that updates the weather condition detail object properties
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
