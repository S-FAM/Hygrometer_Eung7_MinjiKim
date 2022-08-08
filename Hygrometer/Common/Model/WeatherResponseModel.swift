//
//  WeatherResponseModel.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/07/12.
//

import Foundation

struct WeatherResponseModel: Decodable {
  let main: Main
}

// MARK: - Main
struct Main: Decodable {
  let humidity: Int
}
