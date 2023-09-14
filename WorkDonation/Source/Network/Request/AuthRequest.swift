//
//  AuthRequest.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/05/22.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct ChangePasswordRequest: Codable {
  let tel: String
  let loginId: String
  let password: String
}

enum joinType: String, Codable {
  case 일반
  case 사장
}

struct JoinRequest: Codable {
  let loginId, password, name: String
  let tel: String
  let boss: String?
  let businessNumber: String?
  let role: joinType
}

struct SocailLoginRequest: Codable {
  let loginId: String
  let password: String
  let provider: String
  let name: String
  let image: String?
  let email: String?
}
