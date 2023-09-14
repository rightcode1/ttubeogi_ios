//
//  CharityListViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/25.
//

import UIKit

class CharityListViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  
  
  @IBOutlet var selectView1: UIView!
  @IBOutlet var selectView2: UIView!
  
  let cellIdentifier: String = "CharityListCell"
  
  var charityList: [CharityListV2] = []
  
  let date = Date()
  
  let dateFormatter = DateFormatter()
  
  var isActive: Bool = true
  
  var status: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    registerXib()
    
    
    getCharityList()
  }
  
  private func registerXib() {
    let nibName = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
  }
  
  // 기부단체 불러오는 함수
  
  
  func getCharityList() {
    let param = CharityListRequest(diff: "all")
    ApiService.request(router: DonationApi.charityList(param: param), success: { (response: ApiResponse<CharityListV2Response>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code == 202 {
          self.doAlert(message: value.resultMsg)
        } else {
          self.charityList = value.charityList ?? []
          self.tableView.reloadData()
        }
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
  }
  
  @IBAction func tapGetNormalList(_ sender: UIButton) {
    selectView1.isHidden = false
    selectView2.isHidden = true
    isActive = true
    tableView.reloadData()
  }
  
  @IBAction func tapGetEndList(_ sender: UIButton) {
    selectView1.isHidden = true
    selectView2.isHidden = false
    isActive = false
    tableView.reloadData()
  }
  
}

extension CharityListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return charityList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CharityListCell
    
    cell.initWithCharityList(charityList[indexPath.row])
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dict = charityList[indexPath.row]
    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "charityDetail") as! CharityDetailViewController
    dateFormatter.dateFormat = "yyyy.MM.dd"
    let today = dateFormatter.string(from: date)
    if Int(today.components(separatedBy: ".").joined())! < Int(dict.startDate.components(separatedBy: ".").joined())! ||
        Int(today.components(separatedBy: ".").joined())! > Int(dict.endDate.components(separatedBy: ".").joined())! {
      status = false
    } else {
      status = true
    }
    charityId = dict.id
    vc.status = status
    self.navigationController?.pushViewController(vc, animated: true)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let dict = charityList[indexPath.row]
    
    dateFormatter.dateFormat = "yyyy.MM.dd"
    let today = dateFormatter.string(from: date)
    
    if isActive {
      if !dict.active {
        if Int(today.components(separatedBy: ".").joined())! <= Int(dict.startDate.components(separatedBy: ".").joined())! {
          return 192
        } else if  Int(today.components(separatedBy: ".").joined())! > Int(dict.endDate.components(separatedBy: ".").joined())! {
          return 0
        } else {
          return 0
        }
      } else if dict.active {
        if Int(today.components(separatedBy: ".").joined())! <= Int(dict.startDate.components(separatedBy: ".").joined())! {
          return 192
        } else if Int(today.components(separatedBy: ".").joined())! > Int(dict.startDate.components(separatedBy: ".").joined())! &&
                    Int(today.components(separatedBy: ".").joined())! <= Int(dict.endDate.components(separatedBy: ".").joined())! {
          return 192
        } else if  Int(today.components(separatedBy: ".").joined())! > Int(dict.endDate.components(separatedBy: ".").joined())! {
          return 0
        } else {
          return 0
        }
      } else {
        return 0
      }
    } else {
      if !dict.active {
        if Int(today.components(separatedBy: ".").joined())! < Int(dict.startDate.components(separatedBy: ".").joined())! {
          return 0
        }else if  Int(today.components(separatedBy: ".").joined())! > Int(dict.endDate.components(separatedBy: ".").joined())! {
          return 192
        } else {
          return 192
        }
      } else if dict.active {
        if Int(today.components(separatedBy: ".").joined())! <= Int(dict.startDate.components(separatedBy: ".").joined())! {
          return 0
        }else if  Int(today.components(separatedBy: ".").joined())! > Int(dict.endDate.components(separatedBy: ".").joined())! {
          return 192
        } else {
          return 0
        }
      } else {
        return 0
      }
    }
  }
  
  
}
