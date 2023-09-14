//
//  NoticeResponse.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/06/09.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct NoticeListResponse: Codable {
  let status: Int
  let result: Bool
  let message: String
  let list: [Notice]?
}

//struct NoticeDetailResponse: Codable {
//  let status: Int
//  let result: Bool
//  let message: String
//  let data: Notice?
//}

struct Notice: Codable {
  let id: Int
  let title, createdAt: String
  let content: String?
}


