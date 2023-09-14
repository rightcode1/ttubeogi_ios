//
//  Environment.swift
//  InsideROO
//
//  Created by jason on 02/02/2019.
//  Copyright © 2019 Dong Seok Lee. All rights reserved.
//

import Foundation
import UIKit


var storeUpdateId: Int = 0
var updateDiff: String = "category"
var currentLocation: (Double, Double)?
var updateId: Int = 0
var FcmToken: String = ""
//
var charityId = 0
var newsDetailId = 0
var noticeDetailId = 0
var partnershipId = 0
var serviceNewsId = 0


struct ApiEnvironment {
    static let baseUrl = "http://3.35.83.59:8003"
    static let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as! String
    static let kakaoRESTKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_KEY") as! String
    //  static let serverGatewayStage = Bundle.main.object(forInfoDictionaryKey: "SERVER_GATEWAY_STAGE") as! String
}
