//
//  UIViewController+Extension.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/7/23.
//

import Foundation
import UIKit


extension UIViewController {
    
    /// A UIViewController extension function to display alert in any UIViewController class
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: message on alert
    func showAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
            alertController.addAction(okAction)
           
           if let popOverPresentationController = alertController.popoverPresentationController {
                      popOverPresentationController.sourceView = self.view
                      popOverPresentationController.sourceRect = CGRect(x: 1.0, y: 1.0, width: self.view.bounds.width, height: self.view.bounds.height)
                  }
            self.present(alertController, animated: true, completion: nil)
        }
     }
}
