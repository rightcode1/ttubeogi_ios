//
//  LoginViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/02.
//

import UIKit
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

class LoginViewController: BaseViewController {
  @IBOutlet var appleLoginView: UIView!
  
  @IBOutlet var ivLogo: UIImageView!
  
  var testModeCount = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 13.0, *) {
      appleLoginView.isHidden = false
    }else {
      appleLoginView.isHidden = true
    }
    
    ivLogo.rx.gesture(.tap()).when(.recognized).subscribe(onNext: { [weak self] _ in
          guard let self = self else { return }
      if testModeCount < 5 {
        testModeCount += 1
        showToast(message: "개발자 모드로 로그인 \(testModeCount) / 5")
        return
      }
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
  }
  
  func moveToMain() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
  func login(loginId: String, name: String) {
    ApiService.request(router: AuthApi.login(loginId: loginId, name: name), success: { (response: ApiResponse<LoginResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.callMSGDialog(message: value.resultMsg)
        }else {
          DataHelper.set("bearer \(value.token ?? "")", forKey: .token)
          let dateFormmater = DateFormatter()
          dateFormmater.dateFormat = "yyyy.MM.dd"
          DataHelper.set(dateFormmater.string(from: Date()), forKey: .joinDate)
          print("!!!")
          ApiService.request(router: NotificationApi.registNotificationToken(notificationToken: FcmToken), success: { (response: ApiResponse<DefaultResponse>) in
          }) { (error) in
          }
          if value.register {
            let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "update") as! UpdateNicknameViewController
            vc.diff = "가입"
            self.navigationController?.pushViewController(vc, animated: true)
            
          }else{
            self.moveToMain()
          }
        }
      } else {
        if value.code >= 202 {
          self.callMSGDialog(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.dismissHUD()
      self.callMSGDialog(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  func setUserInfo(token: String) {
    KakaoSDKUser.UserApi.shared.me() { [self](user, error) in
      if let error = error {
        print("!!\(error)")
      }
      else {
        print("me() success.")
        //do something
        _ = user
        
        let id = "\(user?.id ?? 0)"
        
        let name = "\(user?.kakaoAccount?.legalName ?? "")"
        
        self.login(loginId: id, name: name)
      }
    }
  }
  
  @objc
  @available(iOS 13.0, *)
  func handleLogInWithAppleID() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
  
  @IBAction func tapKakaoLogin(_ sender: UIButton) {
    if (KakaoSDKUser.UserApi.isKakaoTalkLoginAvailable()) {
      // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
      KakaoSDKUser.UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
        if let error = error {
          // 예외 처리 (로그인 취소 등)
          print("!!!\(error)")
          KakaoSDKUser.UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
              print("!!!\(error)")
            }
            else {
              print("loginWithKakaoAccount() success.")
              //do something
              _ = oauthToken
              self.setUserInfo(token: oauthToken?.accessToken ?? "")
            }
          }
        }
        else {
          print("loginWithKakaoTalk() success.")
          // do something
          _ = oauthToken
          // 액세스토큰
          self.setUserInfo(token: oauthToken?.accessToken ?? "")
        }
      }
    } else {
      KakaoSDKUser.UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
        if let error = error {
          print("!!!\(error)")
        }
        else {
          print("loginWithKakaoAccount() success.")
          //do something
          _ = oauthToken
          self.setUserInfo(token: oauthToken?.accessToken ?? "")
        }
      }
    }
  }
  
  @IBAction func tapAppleLogin(_ sender: UIButton) {
    if #available(iOS 13.0, *) {
      handleLogInWithAppleID()
    }
  }
  
}
// MARK: - 애플 로그인
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  
  @available(iOS 13.0, *)
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
      
      var name = credential.fullName?.familyName ?? ""
      name += credential.fullName?.givenName ?? ""
      self.login(loginId: credential.user, name: name)
      
    } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
      print(passwordCredential.user)
      print(passwordCredential.password)
    }
  }
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print(error.localizedDescription)
  }
}
