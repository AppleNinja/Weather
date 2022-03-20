//
//  DailyWeatherRow.swift
//  WeatherApp
//
//  Created by Sreekumar K on 20/03/2022.
//  Copyright © 2022 Sreekumar. All rights reserved.
//

import SwiftUI

struct DailyWeatherRow: View {
  private let viewModel: DailyWeatherRowViewModel
  
  init(viewModel: DailyWeatherRowViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack {
      VStack {
        Text("\(viewModel.day)")
        Text("\(viewModel.month)")
      }
      
      VStack(alignment: .leading) {
        Text("\(viewModel.title)")
          .font(.body)
        Text("\(viewModel.fullDescription)")
          .font(.footnote)
      }
        .padding(.leading, 8)

      Spacer()

      Text("\(viewModel.temperature)°")
        .font(.title)
    }
  }
}
