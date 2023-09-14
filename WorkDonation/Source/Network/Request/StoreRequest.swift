//
//  StoreRequest.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/27.
//

import Foundation

struct StoreListRequest: Codable {
  let latitude: String?
  let longitude: String?
  let category: String?
  let delivery: String?
  let search: String?
  
  init(
    latitude: String? = nil,
    longitude: String? = nil,
    category: String? = nil,
    delivery: String? = nil,
    search: String? = nil
  ) {
    self.latitude = latitude
    self.longitude = longitude
    self.category = category
    self.delivery = delivery
    self.search = search
  }
}

struct StoreDetailRequest: Codable {
  let storeId: Int
  let latitude: String?
  let longitude: String?
}
