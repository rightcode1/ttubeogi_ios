//
//  NotificationApi.swift
//  Bartender
//
//  Created by hoonKim on 2020/10/12.
//  Copyright © 2020 rightCode.hoonKim. All rights reserved.
//

import Foundation
import Alamofire


enum NotificationApi: ApiRouter {
  
  case registNotificationToken(notificationToken: String)
  case switchNotification(notificationToken: String, active: String)
  
  case notificationDetail(notificationToken: String)
  
  var method: HTTPMethod{
    switch self{
      case .registNotificationToken:
        return .post
      
      case .notificationDetail:
        return .get
      
      case .switchNotification:
        return .put
      
    }
  }
  
  var path: String{
    switch self{
      case .registNotificationToken : return "/v1/notification/register"
      case .switchNotification : return "/v1/notification/update"
      case .notificationDetail : return "/v1/notification/detail"
    }
  }
  //    var request = URLRequest(url: URL(string: usersDataPoint)!)
  //    request.addValue("Token \(tokenString)", forHTTPHeaderField: "Authorization")
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .registNotificationToken(let notificationToken):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["notificationToken" : notificationToken])
      //            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .notificationDetail(let notificationToken):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["notificationToken" : notificationToken])
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
      case .switchNotification(let notificationToken, let active):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["notificationToken" : notificationToken, "active" : active])
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    }
    return urlRequest
  }
  
  #if DEBUG
  var fakeFile: String? {
    return nil
  }
  #endif
}

