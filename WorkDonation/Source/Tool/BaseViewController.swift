//
//  BaseViewController.swift
//  cheorwonHotPlace
//
//  Created by hoon Kim on 28/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    var disposeBag = DisposeBag()
    
    @IBInspectable var localizedText: String = "" {
      didSet {
        if localizedText.count > 0 {
          #if TARGET_INTERFACE_BUILDER
          var bundle = NSBundle(forClass: type(of: self))
          self.title = bundle.localizedStringForKey(self.localizedText, value:"", table: nil)
          #else
          self.title = NSLocalizedString(self.localizedText, comment:"");
          #endif
        }
      }
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
    

}
