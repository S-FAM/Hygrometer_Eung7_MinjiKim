//
//  AddressResponseModel.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/12.
//

struct AddressResponseModel: Codable {
  let response: Response
}

struct Response: Codable {
  let result: Result
}

/// items: 응답결과 목록 Root
struct Result: Codable {
  let items: [Items]
}

/// id: 주소의 ID(행정구역코드), title: 행정구역명, point: 주소 좌표 Root
struct Items: Codable {
  let id, title: String
  let point: Point
}

/// x: x좌표, y: y좌표
struct Point: Codable {
  let x, y: String
}

extension Items {
  static let EMPTY = Items(id: "", title: "", point: Point(x: "", y: ""))
}
