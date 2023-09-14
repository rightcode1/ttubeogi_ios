     //
//  RatingPopupViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/28.
//

import UIKit
import Cosmos

class RatingPopupViewController: UIViewController {
  @IBOutlet var ratingLabel: UILabel!
  @IBOutlet var ratingView: CosmosView!
  
  var storeId: Int!
  
  var rating = 1.0 {
    didSet {
      ratingView.rating = rating
      ratingLabel.text = String(rating)
    }
  }
  

    override func viewDidLoad() {
        super.viewDidLoad()

      ratingView.settings.fillMode = .half
      ratingView.settings.disablePanGestures = true
      ratingView.didFinishTouchingCosmos = { rating in
        self.rating = rating
      }
      ratingView.didTouchCosmos = { rating in
        self.rating = rating
      }
    }
    
  func registReview() {
    self.showHUD()
    ApiService.request(router: UserApi.registRating(storeId: storeId, rate: rating), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.dismissHUD()
          self.callMSGDialog(message: value.resultMsg)
        }else {
          self.dismissHUD()
          self.callOkActionMSGDialog(message: "별점이 등록되었습니다.") {
            self.backPress()
          }
        }
      } else {
        self.dismissHUD()
        self.callMSGDialog(message: value.resultMsg)
      }
    }) { (error) in
      self.dismissHUD()
      self.callMSGDialog(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  @IBAction func tapRegistReview(_ sender: UIButton) {
    registReview()
  }

}
