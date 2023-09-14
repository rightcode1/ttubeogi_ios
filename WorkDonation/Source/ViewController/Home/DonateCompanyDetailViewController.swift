//
//  DonateCompanyDetailViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/25.
//

import UIKit
import Kingfisher
import YoutubePlayer_in_WKWebView

class DonateCompanyDetailViewController: UIViewController {
  
  @IBOutlet var contentLabel: UILabel!
  
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var imageViewHeight: NSLayoutConstraint!
  
  @IBOutlet var linkView: UIView!
  @IBOutlet var youtubeBackView: UIView!
  @IBOutlet var youtubeView: WKYTPlayerView!
  
  var link: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getCompanyDetail()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = false
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
  
  func initWithCompanyDetail(_ data: CompanyDetail) {
    contentLabel.text = data.content
    
    figureOutHeight(urlString: data.image ?? "", height: imageViewHeight)
    thumbnailImageView.kf.setImage(with: URL(string: data.image ?? ""))
    
    link = data.link
    
    linkView.isHidden = data.link == nil || data.link == ""
    youtubeBackView.isHidden = data.youtube == nil || data.youtube == ""
    
    if let videoId = data.youtube {
      let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "autoplay": 1, "modestbranding": 0]
      youtubeView.load(withVideoId: videoId, playerVars: playvarsDic)
    }
    
    self.dismissHUD()
  }
  
  func getCompanyDetail() {
    self.showHUD()
    ApiService.request(router: DonationApi.companyDetail, success: { (response: ApiResponse<CompanyDetailResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.initWithCompanyDetail(value.company)
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
    
  }
  
  
  @IBAction func tapLink(_ sender: UIButton) {
    if let url = URL(string: link ?? "") {
      UIApplication.shared.open(url, options: [:])
    }
  }
  
}
