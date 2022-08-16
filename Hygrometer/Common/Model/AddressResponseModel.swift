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

/// - address : 지번 주소 상세 정보, 아래 Address 참고
/// - addressName : 전체 지번 주소 또는 전체 도로명 주소, 입력에 따라 결정됨
/// - addressType : addressName의 값의 타입, 다음 중 하나: REGION(지명) / ROAD(도로명) / REGION_ADDR(지번 주소) / ROAD_ADDR(도로명 주소)
/// - x, y : X(경도), Y(위도) 좌표 값 
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

/// - addressName : 전체 지번 주소
/// - bCode : 법정 코드
/// - hCode : 행정 코드
/// - mainAddressNo : 지번 주번지
/// - mountainYn : 산 여부, Y 또는 N
/// - region1DepthName : 지역 1 Depth, 시도 단위
/// - region2DepthName : 지역 2 Depth, 구 단위
/// - region3DepthHName :  지역 3 Depth, 행정동 명칭
/// - region3DepthName :  지역 3 Depth, 동 단위
/// - subAddressNo : 지번 부번지, 없을 경우 빈 문자열("") 반환
/// - x, y : X(경도), Y(위도) 좌표 값
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

/// - isEnd : 현재 페이지가 마지막 페이지인지 여부 (값이 false면 다음 요청 시 page 값을 증가시켜 다음 페이지 요청 가능)
/// - pageableCount : totalCount 중 노출 가능 문서 수 (최대: 45)
/// - totalCount : 검색어에 검색된 문서 수
struct Meta: Codable {
  let isEnd: Bool
  let pageableCount, totalCount: Int
  
  enum CodingKeys: String, CodingKey {
    case isEnd = "is_end"
    case pageableCount = "pageable_count"
    case totalCount = "total_count"
  }
}
