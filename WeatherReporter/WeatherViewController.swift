//
//  ViewController.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var temperatureBar: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    private var viewModel:  WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        updateUI()
    }
    
    private func setupViewModel() {
        self.viewModel = WeatherViewModel()
        viewModel.searchedCity = "Miami"
    }
    
    private func updateUI() {
        viewModel.notifyAndUpdateUI = {
            print("Notified of a successful data fetch operation")
        }
    }
}
