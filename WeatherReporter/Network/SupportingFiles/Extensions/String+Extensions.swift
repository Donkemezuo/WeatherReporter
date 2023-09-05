//
//  String+Extensions.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation


extension String {
    func replaceSpaceCharacters() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
