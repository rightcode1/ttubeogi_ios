//
//  UserWithdrawalViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/28.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser


class UserWithdrawalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  func kakaoOut() {
    KakaoSDKUser.UserApi.shared.unlink {(error) in
        if let error = error {
            print(error)
        }
        else {
            print("unlink() success.")
        }
    }
  }
    
  func withdrawal() {
    ApiService.request(router: UserApi.userWithdrawal, success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        DataHelper<Any>.clearAll()
        self.okActionAlert(message: "탈퇴되었습니다") {
          self.kakaoOut()
          self.moveToLogin()
        }
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }

  @IBAction func tapWithdrawal(_ sender: UIButton) {
    choiceAlert(message: "정말 회원탈퇴 하시겠습니까?") {
      self.withdrawal()
    }
  }

}
