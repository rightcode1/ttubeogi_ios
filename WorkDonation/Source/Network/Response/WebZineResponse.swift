//
//  WebZineResponse.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/23.
//

import Foundation

struct WebZineListResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let list: [WebZineList]
}

struct WebZineList: Codable {
    let id: Int
    let name, link: String
    let sortCode: Int
}


struct WebZineDetailResponse: Codable {
    let code: Int
    let result: Bool
    let resultMsg: String
    let data: WebZineDetail?
}

struct WebZineDetail: Codable {
    let id: Int
    let name, link: String
    let sortCode: Int
    let webzineImages: [WebzineImage]
}

struct WebzineImage: Codable {
    let id: Int
    let image, date: String
}

