//
//  StoreResponse.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/17.
//

import Foundation

struct StoreListResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let storeList: [StoreList]
}

struct StoreList: Codable {
    let id: Int
    let name, address: String
    let category: String
    let tel, managerTel: String
    let averageRate: Double
    let distance: String
    let discount: String?
    let image: String?
    let longitude, latitude: String
    let createdAt: String
    let active: Bool
    let reviews: [ReviewCount]
}

struct ReviewCount: Codable {
  let id: Int
}

enum Category: String, Codable {
    case 미용뷰티 = "미용&뷰티"
    case 서비스업 = "서비스업"
    case 숙박음식 = "숙박&음식"
    case 의료업 = "의료업"
    case 패션잡화 = "패션&잡화"
}


struct StoreDetailResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let store: StoreDetail
}

struct StoreDetail: Codable {
    let id: Int
    let name, address: String
    let addressDetail: String?
    let category, tel, managerTel: String
    let url: String?
    let content, distance: String
    let mainNumber, discount: String?
    let isDeliveryService, isAreaVoucher: Bool
    let images: [String]
    let longitude, latitude: String
    let averageRate: Double
    let createdAt: String
    let storeManager: String?
//    let reviews: []
}

struct HomeYoutubeResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let data: HomeYoutube?
}

struct HomeYoutube: Codable {
    let url: String
}
