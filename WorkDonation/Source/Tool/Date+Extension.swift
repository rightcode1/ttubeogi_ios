//
//  Date+Extension.swift
//  FOAV
//
//  Created by hoon Kim on 13/11/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
