//
//  ViewController.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import UIKit

class ViewController: UIViewController {
    
    let dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemYellow
        fetchData()
    }

    private func fetchData() {
        dataManager.fetchCityWeatherReport(city: "Wichita") { error, responseData in
            if let error = error {
                print(error)
            } else if let responseData = responseData {
                dump(responseData)
            }
        }
    }

}

