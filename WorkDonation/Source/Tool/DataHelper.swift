//
//  DataHelper.swift
//  OPenPal
//
//  Created by jason on 11/10/2018.
//  Copyright © 2018 WePlanet. All rights reserved.
//

import Foundation
import FirebaseMessaging

class DataHelper<T> {
  
  enum DataKeys: String {
    case token = "token"
    case nickname = "nickname"
    case myLocation = "myLocation"
    case serachKeyword = "serachKeyword"
    case area = "area"
    case dong = "dong"
    case isOnlyDelivery = "isOnlyDelivery"
    case isOnlyEvent = "isOnlyEvent"
    
    case stepsCountDate = "stepsCountDate"
    case stepsCountCalculateDate = "stepsCountCalculateDate"
    case stepCountingStatus = "stepCountingStatus"
    
    case joinDate = "joinDate"
  }
  
  class func value(forKey key: DataKeys) -> T? {
    if let data = UserDefaults.standard.value(forKey: key.rawValue) as? T {
      return data
    }else {
      return nil
    }
  }
  
  class func set(_ value:T, forKey key: DataKeys){
    UserDefaults.standard.set(value, forKey : key.rawValue)
  }
  
  class func remove(forKey key: DataKeys) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
  
  class func clearAll(){
    UserDefaults.standard.dictionaryRepresentation().keys.forEach{ key in
      UserDefaults.standard.removeObject(forKey: key.description)
    }
  }
}

class DataHelperTool {
  static var token: String? {
    guard let token = DataHelper<String>.value(forKey: .token) else { return nil }
    return token
  }
  
  static var serachKeyword: String? {
    guard let serachKeyword = DataHelper<String>.value(forKey: .serachKeyword) else { return nil }
    return serachKeyword
  }
  
  static var area: String? {
    guard let area = DataHelper<String>.value(forKey: .area) else { return nil }
    return area
  }
  
  static var dong: String? {
    guard let dong = DataHelper<String>.value(forKey: .dong) else { return nil }
    return dong
  }
  
  static var myLocation: String? {
    guard let myLocation = DataHelper<String>.value(forKey: .myLocation) else { return nil }
    return myLocation
  }
  
  static var isOnlyDelivery: String? {
    guard let isOnlyDelivery = DataHelper<String>.value(forKey: .isOnlyDelivery) else { return nil }
    return isOnlyDelivery
  }
  
  static var isOnlyEvent: String? {
    guard let isOnlyEvent = DataHelper<String>.value(forKey: .isOnlyEvent) else { return nil }
    return isOnlyEvent
  }
  
  static var stepsCountDate: String? {
    guard let stepsCountDate = DataHelper<String>.value(forKey: .stepsCountDate) else { return nil }
    return stepsCountDate
  }
  
  static var stepCountingStatus: Bool? {
    guard let stepCountingStatus = DataHelper<Bool>.value(forKey: .stepCountingStatus) else { return nil }
    return stepCountingStatus
  }
  
  static var stepsCountCalculateDate: String? {
    guard let stepsCountCalculateDate = DataHelper<String>.value(forKey: .stepsCountCalculateDate) else { return nil }
    return stepsCountCalculateDate
  }
  
  static var joinDate: String? {
    guard let joinDate = DataHelper<String>.value(forKey: .joinDate) else { return nil }
    return joinDate
  }
  static var nickname: String? {
    guard let nickname = DataHelper<String>.value(forKey: .nickname) else { return nil }
    return nickname
  }

}
