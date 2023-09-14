//
//  CompanyResponse.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/25.
//

import Foundation

struct CompanyListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let companyList: [CompanyList]
}

struct CompanyList: Codable {
  let id, sortCode: Int
  let thumbnail: String?
  let title: String
}

struct CompanyDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let company: CompanyDetail
}

struct CompanyDetail: Codable {
  let id: Int
  let title, content: String
  let sortCode: Int
  let thumbnail, image, link, youtube: String?
  let createdAt: String
}

