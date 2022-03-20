//
//  WeeklyWeatherBuilder.swift
//  WeatherApp
//
//  Created by Sreekumar K on 20/03/2022.
//  Copyright © 2022 Sreekumar. All rights reserved.
//

import SwiftUI

enum WeeklyWeatherBuilder {
  static func makeCurrentWeatherView(
    withCity city: String,
    weatherFetcher: WeatherFetchable
  ) -> some View {
    let viewModel = CurrentWeatherViewModel(
      city: city,
      weatherFetcher: weatherFetcher)
    return CurrentWeatherView(viewModel: viewModel)
  }
}
