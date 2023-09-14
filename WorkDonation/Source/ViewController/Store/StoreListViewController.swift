//
//  StoreListViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/17.
//

import UIKit

class StoreListViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var tableView: UITableView!
  
  var storeList: [StoreList] = []
  
  let cellIdentifier = "StoreListCell"
  
  var selectCategoryList: [String] = ["전체", "숙박&음식", "서비스업", "패션&잡화", "미용&뷰티", "의료업", "기타"]
  
  var selectCategory: String = "전체"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationTitleUI()
    tableView.delegate = self
    tableView.dataSource = self
    registerXib()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getStoreList(category: selectCategory)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "detail", let vc = segue.destination as? StoreDetailViewController, let id = sender as? Int {
      vc.storeId = id
    }
  }
  
  private func registerXib() {
    let nibName = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
  }
  
  func getStoreList(category: String?, onlyDelivery: String? = nil) {
    self.showHUD()
    let param = StoreListRequest(
      latitude: String(currentLocation?.0 ?? 0.0),
      longitude: String(currentLocation?.1 ?? 0.0),
      category: category,
      delivery: onlyDelivery,
      search: nil
    )
    ApiService.request(router: StoreApi.storeList(param: param), success: { (response: ApiResponse<StoreListResponse>) in
      guard let value = response.value else {
        return
      }
      
      if value.result {
        if value.code >= 202 {
          self.dismissHUD()
          self.callMSGDialog(message: value.resultMsg)
        } else {
          self.storeList = value.storeList
          self.tableView.reloadData()
          self.dismissHUD()
        }
      } else {
        if value.code >= 202 {
          self.dismissHUD()
          self.callMSGDialog(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.dismissHUD()
      self.callMSGDialog(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
}
// MARK: - TableView
extension StoreListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return storeList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StoreListCell
    cell.initWithStoreList(storeList[indexPath.row])
    cell.selectionStyle = .none
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dict = storeList[indexPath.row]
    performSegue(withIdentifier: "detail", sender: dict.id)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 105
  }
  
}

extension StoreListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return selectCategoryList.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = UICollectionViewCell()
    
    let dict = selectCategoryList[indexPath.row]
    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
    let categoryLabel = cell.viewWithTag(1) as! UILabel
    let selectedView = cell.viewWithTag(2)
    categoryLabel.text = dict
    
    if dict == selectCategory {
      selectedView?.backgroundColor = #colorLiteral(red: 0.8042817712, green: 0.1436723173, blue: 0.3958616853, alpha: 1)
    } else {
      selectedView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let dict = selectCategoryList[indexPath.row]
    selectCategory = dict
    self.collectionView.reloadData()
    getStoreList(category: selectCategory)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
  let text = selectCategoryList[indexPath.row]
    let width = self.estimatedFram(text: text, font: UIFont.systemFont(ofSize: 15)).width
    return CGSize(width: width + 25, height: 40)
    
  }
  
  func estimatedFram(text: String, font: UIFont) -> CGRect {
    let size = CGSize(width: 100, height: 25)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
  }
  
}
