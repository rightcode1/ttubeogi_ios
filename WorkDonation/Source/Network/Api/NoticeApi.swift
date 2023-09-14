//
//  NoticeApi.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/05/19.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire


enum NoticeApi: ApiRouter {
  
  case noticeList(diff: String)
  case noticeDetail(id: Int)
  
  var method: HTTPMethod{
    switch self{
    case .noticeList,
         .noticeDetail:
      return .get
    }
  }
  
  var path: String{
    switch self{
      
    case .noticeList : return "/v1/board/list"
    case .noticeDetail : return "/v1/board/detail"
      
    }
  }
  //    var request = URLRequest(url: URL(string: usersDataPoint)!)
  //    request.addValue("Token \(tokenString)", forHTTPHeaderField: "Authorization")
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
    case .noticeList(let diff):
      urlRequest = try URLEncoding.default.encode(urlRequest, with: ["diff" : diff])
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .noticeDetail(let id) :
      urlRequest = try URLEncoding.default.encode(urlRequest, with: ["id" : id])
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

