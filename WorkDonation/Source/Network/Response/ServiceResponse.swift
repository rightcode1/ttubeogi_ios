//
//  ServiceResponse.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/04.
//

import Foundation
struct ServiceNewsResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let serviceNewsList: [ListRows]
}

struct ListRows: Codable {
  let id: Int
  let sortCode: Int
  let link: String
  let thumbnail: String
  let title: String
}
