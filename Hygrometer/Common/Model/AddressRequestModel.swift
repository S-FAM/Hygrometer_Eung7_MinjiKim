//
//  AddressRequestModel.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/12.
//

/// - query : 검색을 원하는 질의어
/// - size : 한 페이지에 보여질 문서의 개수 (최소: 1, 최대: 30, 기본값: 10)
/// - page : 결과 페이지 번호 (최소: 1, 최대: 45, 기본값: 1)
struct AddressRequestModel: Codable {
  let query: String
  let size: Int
  let page: Int
}
