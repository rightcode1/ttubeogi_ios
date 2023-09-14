//
//  UserApi.swift
//  damda
//
//  Created by hoonKim on 2020/11/18.
//

import Foundation
import Alamofire

struct RegistStepsCountRequest: Codable {
  let stepsCount: Int
  let date: String
}

enum UserApi: ApiRouter {
  
  case userInfo
  
  case logout
  
  case registStepsCount(param: RegistStepsCountRequest)
  
  case updateNickname(name:String,tel:Int,address1:String,address2:String,gender:String,age:String)
  
  case addressList(id:Int)
  
  case userWithdrawal
  
  case stepDetail(diff:String)
  
  case registRating(storeId: Int, rate: Double)
  
  var method: HTTPMethod{
    switch self{
      case
        .registStepsCount,
        .updateNickname,
        .registRating:
        return .post
      case
        .stepDetail,
        .userInfo,
        .addressList,
        .logout:
        return .get
      case .userWithdrawal:
        return .delete
    }
  }
  
  var path: String{
    switch self{
      
      case .userInfo : return "/user/info"
      case .logout : return "/user/logout"
      case .stepDetail: return "/stepCount/detail"
      case .registRating: return "/review/register"
      case .addressList: return "/address/list"
      case .registStepsCount : return "/step/register"
        
      case .updateNickname: return "/user/update"
      case .userWithdrawal: return "/user/withdrawal"
    }
  }
  //    var request = URLRequest(url: URL(string: usersDataPoint)!)
  //    request.addValue("Token \(tokenString)", forHTTPHeaderField: "Authorization")
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .userInfo:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
      case .logout:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
      
    case .addressList(let id):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["addressId": id])
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
        
      case .registRating(let storeId, let rate):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["storeId": storeId, "rate": rate])
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
      case .registStepsCount(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
        
    case .updateNickname(let name,let tel,let address1,let address2,let gender,let age):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["name": name,"tel": tel,"address1": address1,"address2": address2,"gender": gender,"age": age])
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
      case .userWithdrawal:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
      
    case .stepDetail(let diff):
      urlRequest = try URLEncoding.default.encode(urlRequest, with: ["diff": diff])
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
