//
//  SettingViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/23.
//

import UIKit
import KakaoSDKUser

class SettingViewController: BaseViewController {
  @IBOutlet var tapDonationHistory: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationTitleUI()
    initrx()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getUserInfo()
  }
  
  func getUserInfo() {
    ApiService.request(router: UserApi.userInfo, success: { (response: ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.callMSGDialog(message: value.resultMsg)
        }else {
          self.nameLabel.text = value.user.name
        }
      } else {
        if value.code >= 202 {
          self.callMSGDialog(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.callMSGDialog(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  func initrx(){
    tapDonationHistory.rx.gesture(.tap()).when(.recognized).subscribe(onNext: { [weak self] _ in
          guard let self = self else { return }
      
        let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "MyDonationListViewController") as! MyDonationListViewController
        self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
  }
  func kakaoOut() {
    KakaoSDKUser.UserApi.shared.logout {(error) in
        if let error = error {
            print(error)
        }
        else {
            print("logout() success.")
        }
    }
  }
  
  func logout() {
//    ApiService.request(router: UserApi.logout, success: { (response: ApiResponse<DefaultResponse>) in
//      guard let value = response.value else {
//        return
//      }
//      if value.result {
//
//      }
//
//    }) { (error) in
//      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
//    }
    DataHelper<String>.remove(forKey: .token)
    self.okActionAlert(message: "로그아웃되었습니다.") {
      self.kakaoOut()
      self.moveToLogin()
    }
  }

  @IBAction func tapLogout(_ sender: UIButton) {
    choiceAlert(message: "로그아웃 하시겠습니까?") {
      self.logout()
    }
  }
  @IBAction func tapProfile(_ sender: Any) {
    let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "update") as! UpdateNicknameViewController
    vc.diff = "수정"
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func tapUpdate(_ sender: UIButton) {
    if let url = URL(string: "https://apps.apple.com/kr/app/%ED%8F%AC%EC%95%84%EB%B8%8C/id1487589886"), UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
  
}
