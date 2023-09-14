//
//  SplashViewController.swift
//  KMS
//
//  Created by hoonKim on 2020/10/16.
//

import UIKit


class SplashViewController: UIViewController {
  
  var version: String? {
    guard let dictionary = Bundle.main.infoDictionary,
          let build = dictionary["CFBundleVersion"] as? String else {return nil}
    return build
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    visit()
    checkVersion()
  }
  
  func visit() {
    ApiService.request(router: VersionApi.visit, success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      print(value)
    }) { (error) in
    }
  }
  
  func checkVersion() {
    ApiService.request(router: VersionApi.version, success: {  (response: ApiResponse<VersionResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        let versionNumber: Int = Int(self.version!) ?? 0
        if versionNumber < value.versions.ios {
          self.performSegue(withIdentifier: "update", sender: nil)
        } else {
          if DataHelperTool.token == nil {
            self.moveToLogin()
          } else {
            self.goMain()
          }
          
          print("version : \(versionNumber)", value.versions.ios)
        }
      }
    }) { (error) in
      
    }
  }
  
  func goMain() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
}
