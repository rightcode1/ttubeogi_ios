//
//  ViewcontrollerExtention.swift
//  FOAV
//
//  Created by hoon Kim on 02/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//
import Foundation
import UIKit
import JGProgressHUD
import PopupDialog
import RxSwift
import RxGesture
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import RangeSeekSlider

extension UIViewController {
  var progressHUD: JGProgressHUD {
    let hud = JGProgressHUD(style: .dark)
    return hud
  }
  
  
  func showHUD(){
    self.progressHUD.show(in: self.view, animated: true)
    self.view.isUserInteractionEnabled = false
  }
  
  func dismissHUD(){
    JGProgressHUD.allProgressHUDs(in: self.view).forEach{ hud in
      hud.dismiss(animated: true)
    }
    self.view.isUserInteractionEnabled = true
  }
  
  func callMSGDialog(title: String? = "",message: String, buttonTitle: String? = nil) {
    
    let custom = PopupDialog(
      title: title,
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: true,
      panGestureDismissal: false,
      hideStatusBar: false,
      completion: nil
    )
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    let button = DefaultButton(title: buttonTitle ?? "확인") {
      
    }
    button.titleColor = .black
    button.buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    custom.addButton(button)
    self.present(custom, animated: true, completion: nil)
  }
  
  func callOkActionMSGDialog(title: String? = "", message: String, okAction: @escaping () -> Void) {
    let custom = PopupDialog(
      title: title,
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: false,
      panGestureDismissal: false,
      hideStatusBar: false,
      completion: nil
    )
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    let button = DefaultButton(title: "확인") {
      okAction()
    }
    button.titleColor = .black
    button.buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    custom.addButton(button)
    self.present(custom, animated: true, completion: nil)
  }
  
  func callYesNoMSGDialog(title: String? = "",yesButtonTitle: String? = nil, noButtonTitle: String? = nil, message: String, okAction: @escaping () -> Void) {
    let custom = PopupDialog(
      title: title,
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: false,
      panGestureDismissal: false,
      hideStatusBar: false,
      completion: nil
    )
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    
    let noButton = DefaultButton(title: (noButtonTitle == nil ? "취소" : noButtonTitle)!) {}
    let yesButton = DefaultButton(title: (yesButtonTitle == nil ? "확인" : yesButtonTitle)!) {
      okAction()
    }
    
    noButton.titleColor = .black
    noButton.buttonColor = .white
    custom.addButton(noButton)
    
    
    yesButton.titleColor = .black
    yesButton.buttonColor = .white
    custom.addButton(yesButton)
    
    self.present(custom, animated: true, completion: nil)
  }
  
  // "네" "아니오" 선택할 수 있는 얼럿 함수
  func choiceAlert(message: String, okAction: @escaping () -> Void) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let noAction = UIAlertAction(title: "아니요", style: UIAlertAction.Style.cancel)
    let yesAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default) { (action) in
      okAction()
    }
    alert.addAction(noAction)
    alert.addAction(yesAction)
    self.present(alert, animated: true, completion: nil)
  }
  // 확인버튼 누르면 액션 이벤트하는 얼럿
  func okActionAlert(message: String, okAction: @escaping () -> Void) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let yesAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) {
      (action) in
      okAction()
    }
    alert.addAction(yesAction)
    self.present(alert, animated: true, completion: nil)
  }
  // 확인 버튼만 있는 얼럿 함수
  func doAlert(message: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let yesAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
    alert.addAction(yesAction)
    self.present(alert, animated: true, completion: nil)
  }
  // 토스트 함수
  func showToast(message : String, seconds: Double = 2.0) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.view.backgroundColor = UIColor.black
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15
    
    self.present(alert, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
      alert.dismiss(animated: true)
    }
  }
  
  func presentFromLeft(controller: UIViewController) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromLeft
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    view.window?.layer.add(transition, forKey: kCATransition)
    present(controller, animated: false, completion: nil)
  }
  
  @IBAction func dismissFromRight() {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromRight
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    view.window?.layer.add(transition, forKey: nil)
    dismiss(animated: false, completion: nil)
  }
  
  // 네비게이션 바 타이틀 UI 넣어주는 함수
  func navigationTitleUI() {
    let logoView = UIView(frame: CGRect(x: 0, y: 0, width: 80 , height: 25))
    
    let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 80 , height: 25))
    logo.contentMode = .scaleAspectFit
    let image = #imageLiteral(resourceName: "icon")
    logo.image = image
    logoView.addSubview(logo)
    self.navigationItem.titleView = logoView

    
    
    
    let rightbtn = UIButton(frame: CGRect(x: 0, y: 0, width: 75 , height: 26))
    let rightlogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 75 , height: 26))
    rightlogo.contentMode = .scaleAspectFit
    let rightimage = #imageLiteral(resourceName: "share")
    rightlogo.image = rightimage
    rightbtn.addSubview(rightlogo)
    rightbtn.addTarget(self, action: #selector(tapkakao), for: .touchUpInside)

    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbtn)
  }
  
  @objc func tapkakao() {
    kakaoShare()
  }
  
  func insertComma(textField: UITextField) {
    if textField.text!.count == 4 {
      var text = textField.text!.components(separatedBy: ",").joined()
      text.insert(",", at: text.index(text.startIndex, offsetBy: 1))
      textField.text = text
    }
    if textField.text!.count >= 6 {
      var text = textField.text!.components(separatedBy: ",").joined()
      text.insert(",", at: text.index(text.startIndex, offsetBy: 2))
      textField.text = text
    }
    if textField.text!.count >= 7 {
      var text = textField.text!.components(separatedBy: ",").joined()
      text.insert(",", at: text.index(text.startIndex, offsetBy: 3))
      textField.text = text
    }
    if textField.text!.count >= 8 {
      var text = textField.text!.components(separatedBy: ",").joined()
      text.insert(",", at: text.index(text.startIndex, offsetBy: 1))
      text.insert(",", at: text.index(text.startIndex, offsetBy: 5))
      textField.text = text
    }
    if textField.text!.count <= 4 {
      let text = textField.text!.components(separatedBy: ",").joined()
      textField.text = text
    }
  }
  // 다이나믹 텍스트뷰 ( 텍스트의 길이의 따라 텍스트뷰 크기 조정)
  func textViewFrame(textView: UITextView) {
    let size = CGSize(width: textView.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    textView.constraints.forEach { (constraint) in
      if constraint.firstAttribute == .height {
        if textView.text.count >= 1000 && textView.text.count <= 2000 {
          constraint.constant = estimatedSize.height + CGFloat(100)
          print("textView.text.count 1 : \(textView.text.count)")
        } else if textView.text.count >= 2000 && textView.text.count <= 3000 {
          print("textView.text.count 2 : \(textView.text.count)")
          constraint.constant = estimatedSize.height + CGFloat(125)
        } else if textView.text.count >= 3000 && textView.text.count <= 4000 {
          print("textView.text.count 3 : \(textView.text.count)")
          constraint.constant = estimatedSize.height + CGFloat(150)
        } else if textView.text.count >= 4000 && textView.text.count <= 5000 {
          print("textView.text.count 4 : \(textView.text.count)")
          constraint.constant = estimatedSize.height + CGFloat(200)
        } else if textView.text.count >= 5000 && textView.text.count <= 6000 {
          print("textView.text.count 4 : \(textView.text.count)")
          constraint.constant = estimatedSize.height + CGFloat(225)
        } else if textView.text.count >= 6000 {
          print("textView.text.count 4 : \(textView.text.count)")
          constraint.constant = estimatedSize.height + CGFloat(250)
        } else if textView.text.count >= 500 && textView.text.count <= 1000 {
          print("textView.text.count 0 : \(textView.text.count)")
          constraint.constant = estimatedSize.height + CGFloat(80)
        } else if textView.text.count >= 250 && textView.text.count <= 500 {
          print("textView.text.count 0 : \(textView.text.count)")
          constraint.constant = estimatedSize.height + CGFloat(50)
        } else {
          print("textView.text.count 0 : \(textView.text.count)")
          constraint.constant = estimatedSize.height + CGFloat(50)
        }
      }
    }
  }
  // , 추가해주는 함수
  func changeString(string: String) -> String {
    var str = string
    if string != "" {
      switch str.count {
      case 0:
        str = ""
      case 5:
        str.components(separatedBy: [","]).joined()
        str.insert(",", at: str.index(str.startIndex, offsetBy: 1))
      case 6:
        str.components(separatedBy: [","]).joined()
        str.insert(",", at: str.index(str.startIndex, offsetBy: 2))
      case 7:
        str.components(separatedBy: [","]).joined()
        str.insert(",", at: str.index(str.startIndex, offsetBy: 3))
      case 8:
        str.components(separatedBy: [","]).joined()
        str.insert(",", at: str.index(str.startIndex, offsetBy: 1))
        str.insert(",", at: str.index(str.startIndex, offsetBy: 5))
      case 9:
        str.components(separatedBy: [","]).joined()
        str.insert(",", at: str.index(str.startIndex, offsetBy: 2))
        str.insert(",", at: str.index(str.startIndex, offsetBy: 6))
      default:
        break
      }
      return str
    } else {
      return str
    }
  }
  
  func shadow(view: UIView, radius: CGFloat?, offset: CGSize) {
    view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    view.layer.cornerRadius = radius ?? 0
    view.layer.shadowOpacity = 1
    view.layer.shadowOffset = offset
    view.layer.shadowRadius = 4
  }
  
  func moveToLogin() {
    let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "login")
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
  
  
  @IBAction func backPress(){
    if let navigationController = navigationController{
      if let rootViewController = navigationController.viewControllers.first, rootViewController.isEqual(self){
        dismiss(animated: true, completion: nil)
      }else{
        navigationController.popViewController(animated: true)
      }
    }else{
      dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func moveToHome(animated: Bool) {
    let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: animated, completion: nil)
  }
  
  func kakaoShare() {
    let link = Link(webUrl: URL(string:"https://developers.kakao.com"),
                    mobileWebUrl: URL(string:"https://developers.kakao.com"),
                    androidExecutionParams: ["schemeData_store": "0"],
                    iosExecutionParams: ["storeId": "0"])
    
    let appLink = Link(androidExecutionParams: ["schemeData_store": "0"],
                       iosExecutionParams: ["storeId": "0"])
    let button2 = Button(title: "앱으로 보기", link: appLink)
    let content = Content(title: "뚜벅이",
                          imageUrl: URL(string: "https://foav-backend-images.s3.ap-northeast-2.amazonaws.com/ttubeogi-new.jpeg")!,
                          description: "자원봉사자 활성화를 지원하는 경상북도 자원봉사 걸음걸이 기부앱",
                          link: link)
    
    //메시지 템플릿 encode
    ShareApi.shared.shareDefault(templatable: FeedTemplate(content: content, buttons: [button2])) {(sharingResult, error) in
      if let error = error {
        print(error)
      }
      else {
        print("shareDefault() success.")
        
        if let sharingResult = sharingResult {
          UIApplication.shared.open(sharingResult.url,
                                    options: [:], completionHandler: nil)
        }
      }
    }
  }
}

