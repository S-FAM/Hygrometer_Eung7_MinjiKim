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
  let page: Page
  let result: Result
}

/// total: 전체 페이지 수, current: 현재 페이지 번호, size: 페이지 당 반환되는 결과 건수
struct Page: Codable {
  let total, current, size: String
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
