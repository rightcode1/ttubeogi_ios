//
//  CenterTabViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/23.
//

import UIKit
import DropDown
import YoutubePlayer_in_WKWebView

class CenterTabViewController: BaseViewController {
  
  @IBOutlet var webzineDropDownView: UIView!
  @IBOutlet var webzineDropDownTextField: UITextField!
  
  @IBOutlet var youtubeBackView: UIView!
  @IBOutlet var youtubeView: WKYTPlayerView!
  
  let webzineDropDown = DropDown()
  
  var webzineList: [WebZineList] = []
  
  var webzineCenterStringArray: [String] = []
  
  var mobileUrl: String?
  
  var centerUrl: String?
  
  var selectedId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationTitleUI()
    setDropDown()
    bindInput()
    getWebzineList()
    getYoutubeUrl()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "mobile", let vc = segue.destination as? MobileZineViewController {
      vc.id = selectedId
    }
  }
  
  func setDropDown() {
    webzineDropDown.anchorView = webzineDropDownView
    webzineDropDown.backgroundColor = .white
    webzineDropDown.direction = .bottom
    webzineDropDown.selectionAction = { [weak self] (index: Int, item: String) in
      guard let self = self else { return }
      self.webzineDropDownTextField.text = item
      
      self.mobileUrl = self.webzineList[index].link
      self.centerUrl = self.webzineList[index].name
      self.selectedId = self.webzineList[index].id
    }
  }
  
  func initWithWebZineList(_ list: [WebZineList]) {
    DispatchQueue.global().async {
      self.webzineList.removeAll()
      self.webzineCenterStringArray.removeAll()
      
      self.webzineList = list
      
      self.webzineCenterStringArray = list.map{ $0.name }
      
      DispatchQueue.main.async {
        self.webzineDropDown.dataSource = self.webzineCenterStringArray
        self.webzineDropDownTextField.text = self.webzineList.first?.name
        self.mobileUrl = self.webzineList.first?.link
        self.selectedId = self.webzineList.first?.id
      }
    }
    
  }
  
  func openUrl(_ url: String?) {
    if let url = URL(string: url!) {
      print("url: \(url)")
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
  }
  
  func getWebzineList() {
    ApiService.request(router: WebZineApi.webZineList, success: { (response: ApiResponse<WebZineListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.initWithWebZineList(value.list)
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  func getYoutubeUrl() {
    ApiService.request(router: StoreApi.homeYoutube, success: { (response: ApiResponse<HomeYoutubeResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.youtubeBackView.isHidden = value.data?.url == nil
        if let videoId = value.data?.url {
          let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "autoplay": 1, "modestbranding": 0]
          self.youtubeView.load(withVideoId: videoId, playerVars: playvarsDic)
        }
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  func bindInput() {
    webzineDropDownView.rx.gesture(.tap()).when(.recognized).subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      
      self.webzineDropDown.show()
    }).disposed(by: disposeBag)
  }
  
  @IBAction func tapMobile(_ sender: UIButton) {
    
  }
  
  @IBAction func tapCenterHome(_ sender: UIButton) {
    openUrl(mobileUrl)
  }
  
  @IBAction func tapYoutube1(_ sender: UIButton) {
    openUrl("https://www.youtube.com/channel/UC3-odWx_2h247Oo-zathHCw/featured")
  }
  
  @IBAction func tapYoutube2(_ sender: UIButton) {
    openUrl("https://www.youtube.com/channel/UClUMxNBoKujXtXtzdqhq9sg")
  }
  
  
  @IBAction func tapClick(_ sender: UIButton) {
    switch sender.tag {
      case 1:
        openUrl("https://www.gbvt1365.kr/contents/main/")
      case 2:
        openUrl("https://www.1365.go.kr/")
      case 3:
        openUrl("www.gbvt1365.kr")
      default:
        print(1)
    }
  }
  
  
}
