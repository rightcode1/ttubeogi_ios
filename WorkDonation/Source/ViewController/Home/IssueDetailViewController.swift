//
//  IssueDetailViewController.swift
//  FOAV
//
//  Created by hoon Kim on 06/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class IssueDetailViewController: UIViewController, UIGestureRecognizerDelegate {

 
    @IBOutlet var issueView: NSLayoutConstraint!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet var infoTV: UITextView!
    @IBOutlet var InfoView: UIView!
    
    var id = 0
    var imageOnOff = false
    var imageHeight: CGFloat = -590
  
    override func viewDidLoad() {
        super.viewDidLoad()
        getNoticeDetailInfo()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        newsImageView.contentMode = .scaleToFill
    }
  
    override func viewWillAppear(_ animated: Bool) {
      navigationController?.navigationBar.isHidden = false
    }
  
    override func viewDidAppear(_ animated: Bool) {
        getNoticeDetailInfo()
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func getNoticeDetailInfo() {
        ApiService.request(router: SettingApi.serviceNewsDetail, success: { (response: ApiResponse<ServiceNewsDetailResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                let url = URL(string: value.serviceNews.image ?? "")
                if url == nil {
                    self.issueView.constant = 0
                } else if url != nil {
                    // 현재 뷰 width에 맞게 이미지 높이 조정해주기
                    self.newsImageView.kf.setImage(with: url)
                    if let img = self.newsImageView.image {
                        let diff = (self.view.frame.width / img.size.width)
                        let h = img.size.height * diff
                        self.issueView.constant = h
                    }
                }
                self.newsDateLabel.text = String(value.serviceNews.createdAt.unicodeScalars.prefix(10))
                self.newsTitleLabel.text = value.serviceNews.title
                self.infoTV.text = value.serviceNews.content
                self.textViewFrame(textView: self.infoTV)
                
            }
            
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
        }
        
    }
    
    
}
