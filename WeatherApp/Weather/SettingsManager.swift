//
//  SettingsManager.swift
//  WeatherApp
//
//  Created by Sreekumar K on 20/03/2022.
//  Copyright © 2022 Sreekumar. All rights reserved.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()

    let userDefaults = UserDefaults.standard
    struct Keys {
        static let temperatureScale = "temperatureScale"
    }
    
  var temperatureScale: String {
      get {
          return userDefaults.string(forKey: Keys.temperatureScale) ?? "metric"
      }
      set(value) {
          userDefaults.set(value, forKey: Keys.temperatureScale)
      }
    }

}
