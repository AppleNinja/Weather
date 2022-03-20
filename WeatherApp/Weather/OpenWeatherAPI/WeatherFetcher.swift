//
//  WeatherFetcher.swift
//  WeatherApp
//
//  Created by Sreekumar K on 20/03/2022.
//  Copyright © 2022 Sreekumar. All rights reserved.
//

import Foundation
import Combine

protocol WeatherFetchable {
  func weeklyWeatherForecast(
    forCity city: String
  ) -> AnyPublisher<WeeklyForecastResponse, WeatherError>

  func currentWeatherForecast(
    forCity city: String
  ) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherError>
}

class WeatherFetcher {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
}

// MARK: - WeatherFetchable
extension WeatherFetcher: WeatherFetchable {
  func weeklyWeatherForecast(
    forCity city: String
  ) -> AnyPublisher<WeeklyForecastResponse, WeatherError> {
    return forecast(with: makeWeeklyForecastComponents(withCity: city))
  }

  func currentWeatherForecast(
    forCity city: String
  ) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherError> {
    return forecast(with: makeCurrentDayForecastComponents(withCity: city))
  }

  private func forecast<T>(
    with components: URLComponents
  ) -> AnyPublisher<T, WeatherError> where T: Decodable {
    guard let url = components.url else {
      let error = WeatherError.network(description: "Couldn't create URL")
      return Fail(error: error).eraseToAnyPublisher()
    }
    return session.dataTaskPublisher(for: URLRequest(url: url))
      .mapError { error in
        .network(description: error.localizedDescription)
      }
      .flatMap(maxPublishers: .max(1)) { pair in
        decode(pair.data)
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - OpenWeatherMap API
private extension WeatherFetcher {
  struct OpenWeatherAPI {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5"
    static let key = "80d212e1069aaa90c03e8d1ab993d9ff"
  }
  
  func makeWeeklyForecastComponents(
    withCity city: String
  ) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/forecast"
    
    let units = SettingsManager.shared.temperatureScale
    components.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: units), //metric //"imperial"
      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
    ]
    
    return components
  }
  
  func makeCurrentDayForecastComponents(
    withCity city: String
  ) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/weather"
    
    let units = SettingsManager.shared.temperatureScale
    components.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: units),
      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
    ]
    
    return components
  }
}
