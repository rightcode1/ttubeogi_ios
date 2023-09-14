//
//  UserResponse.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/17.
//

import Foundation

struct UserInfoResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let user: UserInfo
  let newBadge: NewBadge
}

struct NewBadge: Codable {
  let noticeId, newsId: Int
  
}

struct UserInfo: Codable {
  let id: Int
  let loginId, name, type, profile: String
  let createdAt,gender,address1,address2,age,tel: String
  let stepsCount, totalStepsCount: Int
}


struct StepDetailResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let data: stepDetail
}

struct stepDetail: Codable {
  let tree, co2,energy,km,stepsCount: Int
  
}

struct AddressListResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let list: [Adress]
}

struct Adress: Codable {
  let id: Int
  let name: String
  
}
