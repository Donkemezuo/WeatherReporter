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
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var searchContainerView: UIVisualEffectView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    private var viewModel:  WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel = WeatherViewModel()
        viewModel.notifyAndUpdateUI = { [weak self] in
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.updateProperties()
        }
    }
    
    
    private func updateProperties() {
        guard let responseModel = viewModel.weatherReport else { return }
        guard let weatherCondition = viewModel.weatherCondition else { return  }
        
        cityNameLabel.text = responseModel.cityName
        lowLabel.text = responseModel.lowTemp
        highLabel.text = responseModel.highTemp
        currentTemperatureLabel.text = responseModel.currentTemp
        weatherDescriptionLabel.text = weatherCondition.description
        weatherImageView.image = viewModel.weatherConditionImage
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchContainerView.isHidden.toggle()
    }
    @IBAction func cancelSearchPressed(_ sender: UIButton) {
        viewModel.searchedCity = nil
        searchContainerView.isHidden.toggle()
    }
    
    @IBAction func seeWeatherPressed(_ sender: UIButton) {
        viewModel.searchedCity = citySearchBar.text
        searchContainerView.isHidden.toggle()
    }
    
}
