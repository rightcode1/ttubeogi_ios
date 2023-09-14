//
//  UIView+Extension.swift
//  albang
//
//  Created by hoon Kim on 27/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    func roundCorners(corners: UIRectCorner , radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView {
  
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable
  var borderColor: UIColor? {
    get {
      let color = UIColor.init(cgColor: layer.borderColor!)
      return color
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable
  var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOffset = CGSize(width: 0, height: 2)
      layer.shadowOpacity = 0.4
      layer.shadowRadius = newValue
    }
  }
}
