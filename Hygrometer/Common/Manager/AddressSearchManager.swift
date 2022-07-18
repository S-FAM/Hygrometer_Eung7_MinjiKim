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
    completionHandler: @escaping ([Items]) -> Void
  ) {
    guard let url = URL(string: "http://api.vworld.kr/req/search?") else { return }

    let parameters = AddressRequestModel(
      key: AddressSearchAPI.key,
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
          completionHandler(result.response.result.items)
        case .failure(let error):
          print(error)
        }
      }
      .resume()
  }
}
