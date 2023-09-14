//
//  StoreApi.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/27.
//

import Foundation
import Alamofire

enum StoreApi: ApiRouter {
  
  case storeList(param: StoreListRequest)
  case storeDetail(param: StoreDetailRequest)
  
  case homeYoutube
  
  var method: HTTPMethod{
    switch self{
      case .storeList,
           .storeDetail,
           .homeYoutube:
        return .get
    }
  }
  
  var path: String{
    switch self{
      case .storeList : return "/store/list"
      case .storeDetail : return "/store/detail"
        
      case .homeYoutube: return "/home/youtube"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .storeList(let param):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
      case .storeDetail(let param):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
        
      case .homeYoutube:
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
