//
//  AddressSearchManager.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/12.
//

import Alamofire
import Foundation

struct AddressSearchManager {
  func request(
    from keyword: String,
    startPage: Int,
    completionHandler: @escaping ([Location]) -> Void
  ) {
    guard let url = URL(string: "http://api.vworld.kr/req/search?") else { return }

    let parameters = AddressRequestModel(
      key: searchAPIKEY,
      query: keyword,
      request: "search",
      type: "district",
      category: "L4",
      page: startPage
    )

    AF
      .request(url, method: .get, parameters: parameters)
      .responseDecodable(of: AddressResponseModel.self) { response in
        switch response.result {
        case .success(let result):
          let locations = result.response.result.items.map { return Location(id: $0.id, lat: $0.point.x, lon: $0.point.y, location: $0.title, bookmark: false) }
          completionHandler(locations)
        case .failure(let error):
          print(error)
        }
      }
      .resume()
  }
}
