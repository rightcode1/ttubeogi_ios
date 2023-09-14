//
//  InquiryApi.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/05/19.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

enum InquiryApi: ApiRouter {
  
  case inquiry(param: InquiryRequest)
  
  var method: HTTPMethod{
    switch self{
      case
      .inquiry:
        return .post
    }
  }
  
  var path: String{
    switch self{
      
      case .inquiry : return "/v1/inquiry/register"
      
    }
  }
  //    var request = URLRequest(url: URL(string: usersDataPoint)!)
  //    request.addValue("Token \(tokenString)", forHTTPHeaderField: "Authorization")
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      
      case .inquiry(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
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

