//
//  DonationApi.swift
//  FOAV
//
//  Created by hoon Kim on 13/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

var companyId: Int = 0


enum DonationApi: ApiRouter {
  case donationList(param: DonationListRequest)
  case charityList(param: CharityListRequest)
  case charityDetail(param: CharityDetailRequest)
  case paymentDonation(param: PaymentDonationRequest)
  case payCheck(param: PayCheckRequest)
  case charityHistory(date: String)
  
  case charityRank(date: String)
  
  case donation(charityId: Int)
  
  case companyList
  case companyDetail
  
  
  var method: HTTPMethod{
    switch self{
    case .charityList,
        .charityDetail,
        .donationList,
        .charityHistory,
        .charityRank,
        .companyList,
        .companyDetail:
      return .get
    case .paymentDonation,
        .payCheck,
        .donation:
      return .post
    }
  }
  
  var path: String {
    switch self {
      
    case .charityList : return "/charity/list"
    case .charityDetail : return "/charity/detail"
    case .charityRank : return "charityHistory/rank"
    case .donationList : return "/donation/user/list"
    case .paymentDonation : return "/donation/buyInfo"
    case .payCheck : return "/donation/buyCheck"
      
    case .charityHistory : return "/charityHistory/list"
    case .donation : return "/charityHistory/register"
      
    case .companyList: return "/company/mainList"
    case .companyDetail: return "company/\(companyId)"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    switch self {
    case .charityList(let param) :
      urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .charityDetail(let param) :
      urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .donationList(let param) :
      urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .paymentDonation(let param) :
      urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .payCheck(let param) :
      urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .charityRank(let date):
      urlRequest = try URLEncoding.default.encode(urlRequest, with: ["date" : date])
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .donation(let chrityId):
      urlRequest = try URLEncoding.default.encode(urlRequest, with: ["charityId" : chrityId])
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .charityHistory(let date):
      urlRequest = try URLEncoding.default.encode(urlRequest, with: ["date" : date])
      urlRequest.addValue(DataHelperTool.token ?? "", forHTTPHeaderField: "Authorization")
    case .companyList:
      urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
      
    case .companyDetail:
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

