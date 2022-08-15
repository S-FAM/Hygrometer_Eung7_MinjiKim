//
//  AddressResponseModel.swift
//  Hygrometer
//
//  Created by 김민지 on 2022/07/12.
//

struct AddressResponseModel: Codable {
    let documents: [Document]
    let meta: Meta
}

struct Document: Codable {
    let address: Address
    let addressName, addressType: String
    let x, y: String

    enum CodingKeys: String, CodingKey {
        case address
        case addressName = "address_name"
        case addressType = "address_type"
        case x, y
    }
}

struct Address: Codable {
    let addressName, bCode, hCode, mainAddressNo: String
    let mountainYn, region1DepthName, region2DepthName, region3DepthHName: String
    let region3DepthName, subAddressNo, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case bCode = "b_code"
        case hCode = "h_code"
        case mainAddressNo = "main_address_no"
        case mountainYn = "mountain_yn"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthHName = "region_3depth_h_name"
        case region3DepthName = "region_3depth_name"
        case subAddressNo = "sub_address_no"
        case x, y
    }
}

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
