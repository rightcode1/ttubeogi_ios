//
//  AuthApi.swift
//  kospiKorea
//
//  Created by hoonKim on 2020/05/19.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

// 서버랑 통신하는 api 만드는 곳
enum AuthApi: ApiRouter {
  
  case certificationPhoneNumber(tel: String, diff: String)
  case checkExistId(loginId: String)
  case join(param: JoinRequest)
  case checkConfirm(tel: String, confirm: String)
  case login(loginId: String, name: String)
  case socailLogin(param: SocailLoginRequest)
  case findId(tel: String)
  case changePassword(param: ChangePasswordRequest)
  var method: HTTPMethod{
    switch self{
      
      case .certificationPhoneNumber,
           .checkExistId,
           .findId,
           .checkConfirm:
        return .get
      case .join,
           .login,
           .changePassword,
           .socailLogin:
        return .post
    }
  }
  
  var path: String{
    switch self{
      case .certificationPhoneNumber : return "/v1/auth/certificationNumberSMS"
      case .checkExistId : return "/v1/auth/existLoginId"
      case .join : return "/v1/auth/join"
      case .checkConfirm : return "/v1/auth/confirm"
      case .login : return "/auth/login"
      case .findId : return "/v1/auth/findLoginId"
      case .changePassword : return "/v1/auth/passwordChange"
        
      case .socailLogin: return "/v1/auth/social/login"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .certificationPhoneNumber (let tel, let diff) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["tel": tel, "diff": diff])
      case .checkExistId(let loginId) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["loginId": loginId])
      case .join(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
      case .checkConfirm(let tel, let confirm) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["tel": tel, "confirm": confirm])
      case .login(let loginId, let name) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["loginId": loginId, "name": name])
      case .findId(let tel):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["tel": tel])
      case .changePassword(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
      case .socailLogin(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
    }
    return urlRequest
  }
  
  #if DEBUG
  var fakeFile: String? {
    return nil
  }
  #endif
}
