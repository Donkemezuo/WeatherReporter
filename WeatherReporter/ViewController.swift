//
//  ViewController.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let dataManager = DataManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemYellow
        fetchData()
        registerDelegates()
        fetchDefaultCity()
    }

    private func fetchData() {
        dataManager.fetchCityWeatherReport(city: "New York") { error, responseData in
            if let error = error {
                print(error)
            } else if let responseData = responseData {
                dump(responseData)
            }
        }
    }
    
    private func registerDelegates() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    private func fetchDefaultCity() {
        switch CLLocationManager().authorizationStatus {
        case .notDetermined:
            locationManager.requestLocation()
            print("Not determined")
        case .restricted, .denied:
            print(" fetch searched city instead")
        case .authorizedAlways, .authorizedWhenInUse:
            print("fetch user city")
    @unknown default:
        print("Got here instead")
    }
    }
}


extension ViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            dump(location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription) requesting user location")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(manager.location)
    }
    
    
    
    
}
