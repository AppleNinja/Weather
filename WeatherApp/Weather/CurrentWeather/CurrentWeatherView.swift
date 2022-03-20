//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Sreekumar K on 20/03/2022.
//  Copyright © 2022 Sreekumar. All rights reserved.
//

import SwiftUI

struct CurrentWeatherView: View {
  @ObservedObject var viewModel: CurrentWeatherViewModel
  @State private var showingProfile = false

  init(viewModel: CurrentWeatherViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    List(content: content)
      .onAppear(perform: viewModel.refresh)
      .navigationBarTitle(viewModel.city)
      .listStyle(GroupedListStyle())
  }
}

private extension CurrentWeatherView {
  func content() -> some View {
    if let viewModel = viewModel.dataSource {
      return AnyView(details(for: viewModel))
    } else {
      return AnyView(loading)
    }
  }

  func details(for viewModel: CurrentWeatherRowViewModel) -> some View {
    CurrentWeatherRow(viewModel: viewModel)
  }

  var loading: some View {
    Text("Loading \(viewModel.city)'s weather...")
      .foregroundColor(.gray)
  }
}
