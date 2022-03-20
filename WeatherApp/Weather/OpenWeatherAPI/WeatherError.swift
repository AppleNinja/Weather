//
//  WeatherError.swift
//  WeatherApp
//
//  Created by Sreekumar K on 20/03/2022.
//  Copyright © 2022 Sreekumar. All rights reserved.
//


import Foundation

enum WeatherError: Error {
  case parsing(description: String)
  case network(description: String)
}
