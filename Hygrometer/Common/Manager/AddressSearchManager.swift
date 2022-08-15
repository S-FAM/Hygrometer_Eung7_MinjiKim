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
    guard let url = URL(string: "https://dapi.kakao.com/v2/local/search/address.json?") else { return }
    
    let headers: HTTPHeaders = ["Authorization": "KakaoAK f4d5918e1b10aa97287ba17425e51451"]
    
    let parameters = AddressRequestModel(
      query: keyword,
      size: 20,
      page: startPage
    )

    AF
      .request(url, method: .get, parameters: parameters, headers: headers)
      .responseDecodable(of: AddressResponseModel.self) { response in
        switch response.result {
        case .success(let result):
          let locations = result.documents.map {
            return Location(lat: $0.x, lon: $0.y, location: $0.addressName)
          }
          completionHandler(locations)
        case .failure(let error):
          print(error.localizedDescription)
          completionHandler([])
        }
      }
      .resume()
  }
}
