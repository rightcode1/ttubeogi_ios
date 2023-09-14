//
//  MyDonationListViewController.swift
//  FOAV
//
//  Created by hoon Kim on 13/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class MyDonationListViewController: UIViewController {

    @IBOutlet var myDonationTableView: UITableView!
    @IBOutlet var monthLb: UILabel!
    @IBOutlet var nothingView: UIView!
    
  @IBOutlet var distanceLabel: UILabel!
  @IBOutlet var co2Shadow: UIView!
  @IBOutlet var co2Label: UILabel!
  @IBOutlet var energyLabel: UILabel!
  @IBOutlet var walkLabel: UILabel!
  
  let monthFormatter = DateFormatter()
        let yearFormatter = DateFormatter()
        let date = Date()
        var year = ""
        var month = ""
        
        var donationList = [CharityHistoryList]()
        let cellIdentifier = "DonationListCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        myDonationTableView.delegate = self
        myDonationTableView.dataSource = self
        todayForm()
      stepDetail()
      co2Shadow.layer.masksToBounds = false
      shadow(view: co2Shadow, radius: 10, offset: CGSize(width: 0, height: 2))
//         Do any additional setup after loading the view.
        monthLb.text = "\(year)년\(month)월"
        (serviceList(todayDate: year + "-" + month))
    }
//    override func viewWillAppear(_ animated: Bool) {
//        todayForm()
//        (serviceList(todayDate: year + "-" + month))
//    }
    func todayForm() {
        monthFormatter.dateFormat = "MM"
        yearFormatter.dateFormat = "yyyy"
        month = monthFormatter.string(from: date)
        year = yearFormatter.string(from: date)
    }
  
  
  func stepDetail() {
    ApiService.request(router: UserApi.stepDetail(diff: "id"), success: { (response:  ApiResponse<StepDetailResponse>) in
      guard let value = response.value else {
        return
      }
      self.co2Label.text = "\(value.data.co2)"
      self.energyLabel.text = "\(value.data.energy)"
      self.walkLabel.text = value.data.stepsCount.formattedProductPrice()
      self.distanceLabel.text = "\(value.data.km)"
    }) { (error) in
    }
  }
  
    func serviceList(todayDate: String) {
        ApiService.request(router: DonationApi.charityHistory(date: todayDate), success: { (response: ApiResponse<CharityHistoryListResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.donationList = value.list
                if self.donationList.count == 0 {
                    self.view.bringSubviewToFront(self.nothingView)
                } else {
                    self.view.bringSubviewToFront(self.myDonationTableView)
                }
                self.myDonationTableView.reloadData()
            }
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
        }
    }
    private func registerXib() {
        let nibName = UINib(nibName: "DonationListCell", bundle: nil)
        myDonationTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
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
        (serviceList(todayDate: year + "-" + "\(month)"))
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
        (serviceList(todayDate: year + "-" + "\(month)"))
        monthLb.text = "\(year)년\(month)월"
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }

}
extension MyDonationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myDonationTableView.dequeueReusableCell(withIdentifier: "DonationListCell", for: indexPath) as! DonationListCell
        cell.companyLb.text = donationList[indexPath.row].company
        cell.dateLb.text = donationList[indexPath.row].createdAt
      let diff: String = donationList[indexPath.row].diff
        cell.payTypeLb.text = "\(diff)기부"
      cell.payLb.text = "\(donationList[indexPath.row].count.formattedProductPrice() ?? "")\(donationList[indexPath.row].diff)"
        cell.titleLb.text = donationList[indexPath.row].title
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
       
}


    


