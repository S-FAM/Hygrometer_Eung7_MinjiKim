//
//  WeatherServices.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/07/12.
//

import Foundation
import Alamofire

class WeatherServiceManager {
  func load(requestModel: WeatherRequestModel, completion: @escaping (Int) -> Void) {
    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    let parameters: [String: Any] = [
      "appid": weatherAPIKEY,
      "lat": requestModel.lat,
      "lon": requestModel.lon
    ]

    AF
      .request(url, parameters: parameters)
      .responseDecodable(of: WeatherResponseModel.self) { response in
        switch response.result {
        case .success(let responseModel):
          DispatchQueue.main.async {
            completion(responseModel.main.humidity)
          }
          return
        case .failure(let error):
          print(error.localizedDescription)
          return
        }
      }
      .resume()
  }
}
