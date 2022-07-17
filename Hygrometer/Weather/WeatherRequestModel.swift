//
//  WeatherRequestModel.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/07/12.
//

import Foundation
import CoreLocation

struct WeatherRequestModel: Codable {
    let lat: Double
    let lon: Double
}
