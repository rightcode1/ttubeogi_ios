//
//  VersionApi.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/05/19.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

enum VersionApi: ApiRouter {
  
  case version
  case visit
  
  var method: HTTPMethod{
    switch self{
      case .version,
           .visit:
        return .get
    }
  }
  
  var path: String{
    switch self{
      case .version : return "/version"
      case .visit : return "/visitors"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .version:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
      case .visit:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
    }
    return urlRequest
  }
  
  #if DEBUG
  var fakeFile: String? {
    return nil
  }
  #endif
}
