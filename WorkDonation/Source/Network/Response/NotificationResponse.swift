//
//  NotificationResponse.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/06/10.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

struct NotificationDetailResponse: Codable {
  let status: Int
  let result: Bool
  let message: String
  let data: Notification?
  
  struct Notification: Codable {
    let notificationToken: String
    let active: Bool
  }
}
