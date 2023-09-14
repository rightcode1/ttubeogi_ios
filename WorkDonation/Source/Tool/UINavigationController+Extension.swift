//
//  UINavigationController+Extension.swift
//  dontWorry
//
//  Created by hoonKim on 2020/06/24.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
  func pushViewControllerFromLeft(controller: UIViewController) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromLeft
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    view.window?.layer.add(transition, forKey: kCATransition)
    pushViewController(controller, animated: false)
  }
  
  func popViewControllerToLeft() {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromRight
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    view.window?.layer.add(transition, forKey: kCATransition)
    popViewController(animated: false)
  }
}
