//
//  WebZineApi.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/23.
//

import Foundation
import Alamofire

enum WebZineApi: ApiRouter {
  
  case webZineList
  case webZineDetail(id: Int)
  
  var method: HTTPMethod{
    switch self{
      case .webZineList,
           .webZineDetail:
        return .get
    }
  }
  
  var path: String{
    switch self{
      case .webZineList : return "/webzine/list"
      case .webZineDetail: return "/webzine/detail"
    }
  } 
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .webZineList:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
      case .webZineDetail(let id):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["id": id])
    }
    return urlRequest
  }
  
  #if DEBUG
  var fakeFile: String? {
    return nil
  }
  #endif
}
