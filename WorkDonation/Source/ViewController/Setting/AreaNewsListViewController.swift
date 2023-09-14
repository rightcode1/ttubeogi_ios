//
//  AreaNewsListViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/27.
//

import UIKit

class AreaNewsListViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  
  let cellIdentifier = "noticeTableViewCell"
  
  var serviceNews = [ListRows]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    registerXib()
    
    getServiceNewsList()
    
  }
  
  private func registerXib() {
    let nibName = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
  }
  
  // 주요소식 불러오는 함수
  func getServiceNewsList() {
    ApiService.request(router: SettingApi.serviceMainNewsList, success: { (response: ApiResponse<SettingServiceNewsResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.serviceNews = value.serviceNewsList.rows
        self.tableView.reloadData()
        print("_____\(self.serviceNews)")
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
}
extension AreaNewsListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return serviceNews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! noticeTableViewCell
    cell.noticeDateLabel.text = String(serviceNews[indexPath.row].createdAt!.unicodeScalars.prefix(10))
    cell.noticeTitleLabel.text = serviceNews[indexPath.row].title
    cell.separatorInset = UIEdgeInsets.zero
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "issueVC") as! IssueDetailViewController
    serviceNewsId = self.serviceNews[indexPath.row].id
    self.navigationController?.pushViewController(vc, animated: true)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  
}


