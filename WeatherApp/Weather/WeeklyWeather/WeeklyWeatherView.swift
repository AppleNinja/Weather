//
//  WeeklyWeatherView.swift
//  WeatherApp
//
//  Created by Sreekumar K on 20/03/2022.
//  Copyright © 2022 Sreekumar. All rights reserved.
//

import SwiftUI

struct WeeklyWeatherView: View {
  @ObservedObject var viewModel: WeeklyWeatherViewModel
  @State private var showingSheet = false
  @ObservedObject
      var weatherSettings = WeatherSettings()
  
  init(viewModel: WeeklyWeatherViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    
    NavigationView {
      List {
        searchField

        if viewModel.dataSource.isEmpty {
          emptySection
        } else {
          cityHourlyWeatherSection
          forecastSection
        }
      }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Weather ⛅️")
        .toolbar {
                            Button("⚙️") {
                                print("Settings tapped!")
                              viewModel.city = ""
                              showingSheet.toggle()
                            }
                            .sheet(isPresented: $showingSheet) {
                              SheetView(weatherSettings: weatherSettings)
                          }
                        }
    }
  }
}

struct SheetView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject
      var weatherSettings: WeatherSettings
  
  var body: some View {
      NavigationView {
 
          Form {
              Section(header: Text("Weather Settings")) {
                  Picker("Scale", selection: $weatherSettings.chosenScale, content: {
                      ForEach(WeatherSettings.Scale.allCases, id: \.self) { scale in
                          Text("\(scale.rawValue)")
                      }
                  })
                  .pickerStyle(SegmentedPickerStyle())
              }
          }
          .navigationBarTitle("Settings")
                        .navigationBarItems(trailing: Button("Dismiss", action: {
                          SettingsManager.shared.temperatureScale = weatherSettings.chosenScale.scaleValue
                            self.presentationMode.wrappedValue.dismiss()
                        }))
        Button("Press to dismiss") {
          
          self.presentationMode.wrappedValue.dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
      }
  }
}

struct WeatherScale {
    @ObservedObject
    var weatherSettings: WeatherSettings
    
    func symbol() -> String {
        switch weatherSettings.chosenScale {
        case .Centigrade:
            return "C"
        case .Fahrenheit:
            return "F"
        }
    }
  
  func scale() -> String {
      switch weatherSettings.chosenScale {
      case .Centigrade:
          return "metric"
      case .Fahrenheit:
          return "imperial"
      }
  }
}

class WeatherSettings: ObservableObject {
    enum Scale: String, CaseIterable {
        case Centigrade, Fahrenheit
      
      var scaleValue : String {
        switch self {
        case .Centigrade:
          return "metric"
        case .Fahrenheit:
          return "imperial"
        }
      }
    }
    
    @Published
  var chosenScale = Scale.Centigrade
}

private extension WeeklyWeatherView {
  var searchField: some View {
    HStack(alignment: .center) {
      TextField("Enter your City", text: $viewModel.city)
    }
  }

  var forecastSection: some View {
    Section {
      ForEach(viewModel.dataSource, content: DailyWeatherRow.init(viewModel:))
    }
  }

  var cityHourlyWeatherSection: some View {
    Section {
      NavigationLink(destination: viewModel.currentWeatherView) {
        VStack(alignment: .leading) {
          Text(viewModel.city)
          Text("Weather today")
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
    }
  }

  var emptySection: some View {
    Section {
      Text("No results")
        .foregroundColor(.gray)
    }
  }
}
