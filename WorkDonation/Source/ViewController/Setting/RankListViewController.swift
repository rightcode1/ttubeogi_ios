//
//  RankListViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/25.
//

import UIKit

class RankListViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var monthLb: UILabel!
  @IBOutlet var isMyView: UIStackView!
  
  @IBOutlet var myRanking: UILabel!
  @IBOutlet var myNickName: UILabel!
  @IBOutlet var myArea: UILabel!
  @IBOutlet var myTotal: UILabel!
  
  let monthFormatter = DateFormatter()
  let yearFormatter = DateFormatter()
  
  let date = Date()
  var year = ""
  var month = ""
  var rankList: [CharityRankList] = []
  
  var myId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    todayForm()
    
    monthLb.text = "\(year)년\(month)월"
    getRankList()
    
  }
  func todayForm() {
      monthFormatter.dateFormat = "MM"
      yearFormatter.dateFormat = "yyyy"
      month = monthFormatter.string(from: date)
      year = yearFormatter.string(from: date)
  }
  
  func getRankList() {
    ApiService.request(router: DonationApi.charityRank(date:"\(year)-\(month)"), success: { (response: ApiResponse<CharityRankResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.isMyView.isHidden = true
          for count in 0 ..< value.list.count{
            if value.list[count].user.name == DataHelperTool.nickname{
              self.isMyView.isHidden = false
              self.myRanking.text = "\(value.list[count].rank)"
              self.myNickName.text = value.list[count].user.name
              self.myArea.text = value.list[count].user.address2
              self.myTotal.text = Int(value.list[count].sumCount)?.formattedProductPrice()
            }
          }
          self.tableView.layoutTableHeaderView()
          self.rankList = value.list
          self.tableView.reloadData()
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  @IBAction func previousMonth(_ sender: UIButton) {
      month = "\(Int(month)! - 1)"
      if Int(month)! == 0 {
          month = "\(12)"
          year = "\(Int(year)! - 1)"
      }
      if Int(month)! < 10 {
          month = "0" + month
      }
      getRankList()
      monthLb.text = "\(year)년\(month)월"
  }
  @IBAction func nextMonthBtn(_ sender: UIButton) {
      month = "\(Int(month)! + 1)"
      if Int(month)! > 12 {
          month = "\(01)"
          year = "\(Int(year)! + 1)"
      }
      if Int(month)! < 10 || Int(month) == 1 {
          month = "0" + month
      }
      getRankList()
      monthLb.text = "\(year)년\(month)월"
  }
  
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension RankListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rankList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
    let dict = rankList[indexPath.row]
    (cell.viewWithTag(1) as! UILabel).text = "\(dict.rank)"
    (cell.viewWithTag(3) as! UILabel).text = dict.user.name
    (cell.viewWithTag(2) as! UILabel).text = Int(dict.sumCount)?.formattedProductPrice()
    (cell.viewWithTag(5) as! UILabel).text = "\(dict.user.address2 ?? "")"
    
    
    if indexPath.row == 0{
      (cell.viewWithTag(4) as! UIImageView).isHidden = false
      (cell.viewWithTag(1) as! UILabel).isHidden = true
      (cell.viewWithTag(4) as! UIImageView).image = UIImage(named: "medal1")
    }else if indexPath.row == 1 {
      (cell.viewWithTag(4) as! UIImageView).isHidden = false
      (cell.viewWithTag(1) as! UILabel).isHidden = true
      (cell.viewWithTag(4) as! UIImageView).image = UIImage(named: "medal2")
    }else if indexPath.row == 2 {
      (cell.viewWithTag(4) as! UIImageView).isHidden = false
      (cell.viewWithTag(1) as! UILabel).isHidden = true
      (cell.viewWithTag(4) as! UIImageView).image = UIImage(named: "medal3")
    }else{
      (cell.viewWithTag(4) as! UIImageView).isHidden = true
      (cell.viewWithTag(1) as! UILabel).isHidden = false
    }
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48
  }
  
}
