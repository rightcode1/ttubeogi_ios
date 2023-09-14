//
//  VersionResponse.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/05/19.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct VersionResponse: Codable {
  let code: Int
  let result: Bool
  let resultMsg: String
  let versions: Version
}

struct Version: Codable {
  let ios: Int
  let android: Int
}
