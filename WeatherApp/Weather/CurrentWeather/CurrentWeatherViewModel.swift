//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Sreekumar K on 20/03/2022.
//  Copyright © 2022 Sreekumar. All rights reserved.
//

import SwiftUI
import Combine

class CurrentWeatherViewModel: ObservableObject {
  @Published var dataSource: CurrentWeatherRowViewModel?

  let city: String
  private let weatherFetcher: WeatherFetchable
  private var disposables = Set<AnyCancellable>()

  init(city: String, weatherFetcher: WeatherFetchable) {
    self.weatherFetcher = weatherFetcher
    self.city = city
  }

  func refresh() {
    weatherFetcher
      .currentWeatherForecast(forCity: city)
      .map(CurrentWeatherRowViewModel.init)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] value in
        guard let self = self else { return }
        switch value {
        case .failure:
          self.dataSource = nil
        case .finished:
          break
        }
      }, receiveValue: { [weak self] weather in
          guard let self = self else { return }
          self.dataSource = weather
      })
      .store(in: &disposables)
  }
}
