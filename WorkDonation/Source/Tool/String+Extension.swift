//
//  String+Extension.swift
//  FOAV
//
//  Created by hoon Kim on 16/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

extension String {
  
  func contains(find: String) -> Bool {
    return self.range(of: find) != nil
  }
  func containsIgnoringCase(find: String) -> Bool {
    return self.range(of: find, options: .caseInsensitive) != nil
  }
  func isPhone() -> Bool {
    let regex = "^01([0|1|6|7|8|9]?)([0-9]{3,4})([0-9]{4})$"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
  }
  
  func isIdValidate() -> Bool {
    // 영문 + 숫자 5 ~ 20 자리
    let regex = "^[a-zA-Z0-9]{5,20}$"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
  }
  
  func isPasswordValidate() -> Bool {
    // 영문 + 특수문자 + 숫자 8 ~ 13 자리
    let regex = "^(?=.*[a-zA])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,13})"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
  }
  
  var stringToDate:Date {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: self)!
  }
}

extension Int {
  func formattedProductPrice() -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    guard let formattedCount = formatter.string(from: self as NSNumber) else {
      return nil
    }
    return formattedCount
  }
}
