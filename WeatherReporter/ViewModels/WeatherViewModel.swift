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
    
    
     var weatherReport: WeatherReporterResponseModel? {
        didSet {
            print("Update UI")
            self.notifyAndUpdateUI()
        }
    }
    
    var weatherCondition: WeatherCondition?
    var weatherConditionImage: UIImage?
    var notifyAndUpdateUI: (() -> ()) = {}
    
    var searchedCity: String? {
        didSet {
            print("Searched text = ", searchedCity ?? "")
            guard oldValue != self.searchedCity else { return }
            self.fetchWeatherReport()
            self.saveLastSearchedCity()
        }
    }
    
    var userCity: String? {
        didSet {
            guard oldValue != self.userCity else { return }
            self.cityTosearch = self.userCity ?? "New York"
            self.fetchWeatherReport()
            self.saveLastSearchedCity()
        }
    }
    
    var cityTosearch: String = ""
    
    
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
                self.fetchWeatherCondition(weatherReport: responseModel)
            } else if let error = error {
                dump(error)
            }
        }
    }
    
    private func fetchWeatherCondition(weatherReport: WeatherReporterResponseModel) {
        apiService.fetchWeatherCondition(city: weatherReport.cityName) { error, responseModel in
            if let responseModel = responseModel {
                self.weatherReport = weatherReport
                self.fetchWeatherConditionIcon(weatherCondition: responseModel)
            } else if let error = error {
                dump(error)
            }
        }
    }
    
    private func fetchWeatherConditionIcon(weatherCondition: WeatherConditionResponseModel) {
        apiService.fetchWeatherConditionIcon(icon: weatherCondition.condition?.icon ?? "") { error, image in
            if let error = error {
                dump(error)
            } else if let image = image {
                self.weatherConditionImage = image
                self.weatherCondition = weatherCondition.condition
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
