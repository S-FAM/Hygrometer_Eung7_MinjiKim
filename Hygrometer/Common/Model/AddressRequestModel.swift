//
//  AddressRequestModel.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/12.
//

struct AddressRequestModel: Codable {
  let key, query, request, type, category: String
  let page: Int
}

