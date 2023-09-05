//
//  String+Extensions.swift
//  WeatherReporter
//
//  Created by Raymond Donkemezuo on 9/5/23.
//

import Foundation


extension String {
    /// This method is added to replace white spaces in the endpoint string with a %20.
    /// This is because with a white space, converting a string into a URL fails.
    /// The reason for handling this case explicitly is that when user search cities like ''New York'', the application still works.
    func replaceSpaceCharacters() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
