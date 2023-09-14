//
//  AuthResponse.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/05/25.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation



struct LoginResponse: Codable {
  let code: Int
  let result: Bool
  let register: Bool
  let resultMsg: String
  let token: String?
}

struct FindIdResponse: Codable {
  let status: Int
  let result: Bool
  let message: String
  let data: FindId?
}

struct FindId: Codable {
  let loginId: String
}
