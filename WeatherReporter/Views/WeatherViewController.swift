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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    private var viewModel:  WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        activityIndicatorView.startAnimating()
        configureDesign()
    }
    
    private func setupViewModel() {
        viewModel = WeatherViewModel()
        viewModel.notifyAndUpdateUI = { [weak self ] error in
            self?.removeActivityIndicator()
            if let error = error {
                self?.showAlert(title: "Unexpected error encountered", message: error.errorMessage)
            } else {
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.updateProperties()
        }
    }
    
    private func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    
    /// A function to update UI properties
    private func updateProperties() {
        let weatherConditionDetails = viewModel.weatherConditionDetails
        cityNameLabel.text = weatherConditionDetails.cityName
        lowLabel.text = weatherConditionDetails.lowTemperature
        highLabel.text = weatherConditionDetails.highTemperature
        currentTemperatureLabel.text = weatherConditionDetails.currentTemperature
        weatherDescriptionLabel.text = weatherConditionDetails.conditionDescription
        weatherImageView.image = weatherConditionDetails.conditionIcon
        feelsLikeLabel.text = weatherConditionDetails.feelsLike
        humidityLabel.text = weatherConditionDetails.humidity
    }
    
    /// A function to configure UI design
    private func configureDesign() {
        cityNameLabel.font = .systemFont(ofSize: 30, weight: .bold)
        lowLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        highLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        highLabel.textAlignment = .right
        weatherDescriptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        weatherDescriptionLabel.textAlignment = .left
        feelsLikeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        humidityLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        currentTemperatureLabel.font = .systemFont(ofSize: 60, weight: .bold)
        currentTemperatureLabel.textAlignment = .center
        feelsLikeLabel.textAlignment = .right
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
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
