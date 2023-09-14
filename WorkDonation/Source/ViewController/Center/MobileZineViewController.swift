//
//  MobileZineViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/26.
//

import UIKit

class MobileZineViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var imageViewHeight: NSLayoutConstraint!
  
  var id: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getWebzineDetail()
    
  }
  
  func notExist() {
    self.okActionAlert(message: "모바일진이 존재하지 않습니다.") {
      self.backPress()
    }
  }
  
  func figureOutHeight(urlString: String, height: NSLayoutConstraint) {
    if let url = URL(string: urlString) {
      if let data = try? Data(contentsOf: url) {
        if let img = UIImage(data: data) {
          print("img: \(img)")
          let diff = (self.view.frame.width / img.size.width)
          print("diff: \(diff)")
          print("viewWidth: \(self.view.frame.width)")
          let h = img.size.height * diff
          height.constant = h
        }
      }
    }
  }
  
  func initWithWebzineDetail(_ data: WebZineDetail) {
    if data.webzineImages.count > 0 {
      figureOutHeight(urlString: data.webzineImages.first?.image ?? "", height: imageViewHeight)
      imageView.kf.setImage(with: URL(string: data.webzineImages.first?.image ?? ""))
    } else {
      notExist()
    }
    
  }
  
  func getWebzineDetail() {
    ApiService.request(router: WebZineApi.webZineDetail(id: id ?? 0), success: { (response: ApiResponse<WebZineDetailResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.data != nil {
          self.initWithWebzineDetail(value.data!)
        } else {
          self.notExist()
        }
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  @IBAction func previus(_ sender: UIButton) {
    doAlert(message: "이전달 모바일진이 존재하지 않습니다.")
  }
  @IBAction func next(_ sender: UIButton) {
    doAlert(message: "다음달 모바일진이 존재하지 않습니다.")
  }
}
