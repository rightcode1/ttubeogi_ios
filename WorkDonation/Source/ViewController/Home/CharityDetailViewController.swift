//
//  CharityDetailViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/27.
//

import UIKit
import Kingfisher
import YoutubePlayer_in_WKWebView
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class CharityDetailViewController: UIViewController, UIGestureRecognizerDelegate  {
  @IBOutlet var thumbnailImageView: UIImageView!
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var dDayLabel: UILabel!
  
  @IBOutlet var presentSavePointLabel: UILabel!
  @IBOutlet var purposePointLabel: UILabel!
  
  @IBOutlet var presentCountingLabel: CountingLabel!
  @IBOutlet var progressView: UIProgressView!
  @IBOutlet var purposeLabel: UILabel!
  
  
  @IBOutlet var youtubeBackView: UIView!
  @IBOutlet var youtubeView: WKYTPlayerView!
  
  @IBOutlet var companyNameLabel: UILabel!
  
  @IBOutlet var companyImageView: UIImageView!
  @IBOutlet var compnayImageViewHeight: NSLayoutConstraint!
  
  @IBOutlet var companyImageView2: UIImageView!
  @IBOutlet var compnayImageViewHeight2: NSLayoutConstraint!
  
  @IBOutlet var companyImageView3: UIImageView!
  @IBOutlet var compnayImageViewHeight3: NSLayoutConstraint!
  
  @IBOutlet var contentLabel: UILabel!
  @IBOutlet var charityNameLabel: UILabel!
  @IBOutlet var peopleCountLabel: UILabel!
  @IBOutlet var charityContentLabel: UILabel!
  @IBOutlet var needThingsLabel: UILabel!
  
  @IBOutlet var personLabel: UILabel!
  @IBOutlet var totalLabel: UILabel!
  @IBOutlet var donateButton: UIButton!
  var detailData : Charity?
  let dateFormatter = DateFormatter()
  let currentCalendar = NSCalendar.current
  var count = 0.0
  var total = 0.0
  var donationCompany = ""
  var url2:URL?
  var videoId = ""
  var donationId: Int = 0
  var diff: String?
  var status: Bool = false
  var link: String?
  var donationResult: DonationResponse.Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    thumbnatilImageViewWithBlur()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    charityDetail()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
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
  
  func thumbnatilImageViewWithBlur() {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = thumbnailImageView.bounds
    blurEffectView.alpha = 0.5
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    thumbnailImageView.addSubview(blurEffectView)
  }
  
  func initWithCharityDetail(_ data: Charity) {
    self.donationId = data.id
    self.detailData = data
    
    self.videoId = data.code ?? ""
    
    if self.videoId != "" {
      youtubeBackView.isHidden = false
      let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "autoplay": 1, "modestbranding": 0]
      self.youtubeView.load(withVideoId: self.videoId, playerVars: playvarsDic)
    } else {
      youtubeBackView.isHidden = true
    }
    // 두 데이트 타입의 -D 구하는법 D-day구하는법
    // 스트링을 데이트 타입으로 변환시키는 방법
    let date1: Date = self.dateFormatter.date(from: data.startDate)!
    let date2: Date = self.dateFormatter.date(from: data.endDate)!
    let diffInDays = Calendar.current.dateComponents([.day], from: date1, to: date2)
    print("diffInDays : \(diffInDays)")
    
    self.presentSavePointLabel.text = "\(data.currentPrice.formattedProductPrice() ?? "")원"
    self.purposePointLabel.text = "\(data.goalPrice.formattedProductPrice() ?? "")원"
    self.total = Double(data.goal)
    self.count = Double(data.current)
    self.personLabel.text = "\(data.count.formattedProductPrice() ?? "0")명"
    self.totalLabel.text = "현재 \((data.total ?? 0).formattedProductPrice() ?? "0")걸음을 누적 기부중입니다."
    self.presentCountingLabel.count(fromValue: 0, to: Float(self.count), withDuration: 0.4,  andAnimationType: .EaseIn, andCounterType: .Int)
    UIView.animate(withDuration: 0.5) {
      // 프로그레스바는 맥시멈 값이 무조건 1.0 이기때문에
      // 백분율을 구하듯이 100을 곱해주지 않아도 된다 .
      let progress:Float = Float(self.count / self.total)
      
      self.progressView.setProgress(Float(progress), animated: true)
    }
    self.purposeLabel.text = "\(data.goal.formattedProductPrice() ?? "")원"
    
    dateLabel.text = "\(data.startDate)~\(data.endDate)"
    dDayLabel.text = data.dDay

//    dDayLabel.text = (diffInDays.day ?? 0) > 0 ? "마감" : "D-\(diffInDays.day ?? 0)"
    if !data.active {
      donateButton.backgroundColor = .lightGray
      donateButton.isEnabled = false
    }
    
    if !self.status {
      donateButton.backgroundColor = .lightGray
      donateButton.isEnabled = false
    }
    let url = URL(string: "\(data.thumbnail ?? "")")
    self.url2 = URL(string: "\(data.image ?? "")")
    
    if url != nil {
      self.thumbnailImageView.kf.setImage(with: url)
    }
    
    if self.url2 != nil {
      self.companyImageView.kf.setImage(with: self.url2)
      self.figureOutHeight(urlString: "\(data.image ?? "")", height: compnayImageViewHeight)
    } else {
      compnayImageViewHeight.constant = 0
    }
    
    if let url3 = URL(string: "\(data.image1 ?? "")") {
      self.companyImageView2.isHidden = false
      self.companyImageView2.kf.setImage(with: url3)
      self.figureOutHeight(urlString: "\(data.image1 ?? "")", height: compnayImageViewHeight2)
    } else {
      self.companyImageView2.isHidden = true
      compnayImageViewHeight2.constant = 0
    }
    
    if let url4 = URL(string: "\(data.image2 ?? "")") {
      self.companyImageView3.isHidden = false
      self.companyImageView3.kf.setImage(with: url4)
      self.figureOutHeight(urlString: "\(data.image2 ?? "")", height: compnayImageViewHeight3)
    } else {
      self.companyImageView3.isHidden = true
      compnayImageViewHeight3.constant = 0
    }
    
    titleLabel.text = data.title
    contentLabel.text = data.content
    charityNameLabel.text = data.group
    companyNameLabel.text = data.companyName
    peopleCountLabel.text = "\(data.userCount)명"
    charityContentLabel.text = data.serviceContent
    needThingsLabel.text = data.serviceItems
  }
  
  func charityDetail() {
    DispatchQueue.main.async {
      self.dateFormatter.dateFormat = "yyyy.MM.dd"
      self.dateFormatter.timeZone = NSTimeZone(name:"UTC") as TimeZone?
      let param = CharityDetailRequest(
        charityId: charityId
      )
      ApiService.request(router: DonationApi.charityDetail(param: param), success: { (response: ApiResponse<CharityDetailResponse>) in
        guard let value = response.value else {
          return
        }
        if value.result {
          if value.code == 202 {
            self.doAlert(message: value.resultMsg)
          } else {
            self.initWithCharityDetail(value.charity)
          }
        }
      }) { (error) in
        self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
      }
    }
  }
  func donation() {
    ApiService.request(router: DonationApi.donation(charityId: donationId ), success: { (response: ApiResponse<DonationResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.okActionAlert(message: value.resultMsg) {
          }
        } else {
          self.donationResult = value.data
          let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "finishDonation") as! FinishDonationViewController
          vc.diff = self.diff
          vc.donationId = self.donationId
          vc.donationCompany = self.donationCompany
          vc.donationResult = self.donationResult
          vc.modalPresentationStyle = .fullScreen
          self.present(vc, animated: true, completion: nil)
          }
        }
    }) { (error) in
      self.okActionAlert(message: "알수없는 오류 입니다.\n다시 시도해주세요.") {
      }
    }
  }
  
  @IBAction func donationBtn(_ sender: UIButton) {
    donation()
    
//    //    if let url = URL(string: "https://foav.co.kr/prepare/index.php") {
//    //      UIApplication.shared.open(url, options: [:])
//    //    }
//    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "donationPopup") as! DonationPopupViewController
//    vc.diff = "걸음"
//    vc.donationId = donationId
//    vc.donationCompany = donationCompany
//    vc.modalPresentationStyle = .overCurrentContext
//    vc.modalTransitionStyle = .crossDissolve
//
//    self.present(vc, animated: true, completion: nil)
  }
  
  @IBAction func backBtn(_ sender: Any) {
    // 네비게이션을 이용한 이전화면으로 돌아가기
    self.navigationController!.popViewController(animated: true)
  }
  @IBAction func shareButton(_ sender: Any) {
    kakaoShare(data: detailData!)
  }
  func kakaoShare(data: Charity) {
    var feedTemplate: FeedTemplate?
      let link = Link(webUrl: URL(string:"https://developers.kakao.com"),
                      mobileWebUrl: URL(string:"https://developers.kakao.com"),
                      androidExecutionParams: ["schemeData_store": "\(data.id)"],
                      iosExecutionParams: ["storeId": "\(data.id)"])
      
      let appLink = Link(androidExecutionParams: ["schemeData_store": "\(data.id)"],
                         iosExecutionParams: ["storeId": "\(data.id)"])
      let button2 = Button(title: "앱으로 보기", link: appLink)
    let content = Content(title: data.title,
                          imageUrl: URL(string: (data.thumbnail ?? ""))!,
                          description: data.company,
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
