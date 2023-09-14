//
//  HomeViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/04.
//

import UIKit
import CoreLocation
import HealthKit
import RxSwift
import RxGesture

class HomeViewController: UIViewController {
  @IBOutlet weak var mainServiceNewsCollectionView: UICollectionView!
  @IBOutlet weak var bottomEventCollectionView: UICollectionView!
  
  @IBOutlet var backgroundImageView: UIImageView!
  
  @IBOutlet var shadowView: UIView!
  @IBOutlet var todayStepsCountLabel: UILabel!
  
  @IBOutlet var calLabel: UILabel!
  @IBOutlet var totalStepsCountLabel: UILabel!
  
  @IBOutlet var treeLabel: UILabel!
  @IBOutlet var co2Label: UILabel!
  @IBOutlet var stepBackView: UIView!
  
  let notificationCenter = NotificationCenter.default
  
  let manager = CLLocationManager()
  var serviceNews = [ListRows]()
  var activeCharity = [CharityListV2]()
  let dateFormatter = DateFormatter()
  let date = Date()
  var status: Bool = false
  
  var companyList: [CompanyList] = []
  
  var healthStore = HKHealthStore()
  
  var lastContentOffset: CGFloat = 0
  
  var registStepsCount: Int?
  
  var timer: Timer?
  var companyListCount: Int = 0
  var counter = 0
  var showCounter = 0
  
  let infiniteCount: Int = 999
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationTitleUI()
      
    shadowView.layer.masksToBounds = false
    stepBackView.layer.masksToBounds = false
    shadow(view: stepBackView, radius: 10, offset: CGSize(width: 0, height: 2))
    shadow(view: shadowView, radius: 50, offset: CGSize(width: 0, height: 2))
    
    notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(backgroundMovedToApp), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setMyLocation()
    getServiceNewsList()
    getCompanyList()
    
    if (appIsAuthorized()) {
      displaySteps()
      displayCalories()
    } // end if
    else {
      // Don't have permission, yet
      handlePermissions()
    }
    stepDetail()
    initStepsCount()
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    invalidateTimer()
  }
  
  @objc func appMovedToBackground() {
    print("App moved to background!")
  }
  
  @objc func backgroundMovedToApp() {
    print("Background moved to app!")
    if (appIsAuthorized()) {
      displaySteps()
      displayCalories()
    } // end if
    else {
      // Don't have permission, yet
      handlePermissions()
    }
    stepDetail()
    initStepsCount()
  }
  
  func updateStepsCount() {
    ApiService.request(router: UserApi.userInfo, success: { (response:  ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        DataHelper.set(value.user.name, forKey: .nickname)
        self.totalStepsCountLabel.text = "\(value.user.stepsCount.formattedProductPrice() ?? "")"
      }
      else {
        if !value.result {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
  }
  
  func registStepsCount(stepsCount: Int, date: String) {
    let param = RegistStepsCountRequest(
      stepsCount: stepsCount,
      date: date
    )
    ApiService.request(router: UserApi.registStepsCount(param: param), success: { (response:  ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      
      self.updateStepsCount()
    }) { (error) in
    }
  }
  
  func stepDetail() {
    ApiService.request(router: UserApi.stepDetail(diff: "all"), success: { (response:  ApiResponse<StepDetailResponse>) in
      guard let value = response.value else {
        return
      }
      
      self.co2Label.text = "\(value.data.co2)"
      self.treeLabel.text = "\(value.data.tree)"
      self.updateStepsCount()
    }) { (error) in
    }
  }
  
  func appIsAuthorized() -> Bool {
    if (self.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) == .sharingAuthorized) && (self.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!) == .sharingAuthorized) {
      return true
    }
    else {
      return false
    }
  }
  
  func authorize(completion: @escaping (Bool, Error?) -> Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HKError.noError as? Error)
      return
    }
    guard
      let step = HKObjectType.quantityType(forIdentifier: .stepCount) else {
      completion(false, HKError.noError as? Error)
      return
    }
    guard
      let calories = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
      completion(false, HKError.noError as? Error)
      return
    }
    
    let reading: Set<HKObjectType> = [step, calories]
    HKHealthStore().requestAuthorization(toShare: nil, read: reading, completion: completion)
  }
  
  func handlePermissions() {
    // Access Step Count
    let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ]
    
    let burnedCalories: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)! ]
    
    // Check Authorization
    healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
      if (bool) {
        // Authorization Successful
        self.displaySteps()
      } // end if
    } // end of checking authorization
    
    healthStore.requestAuthorization(toShare: burnedCalories, read: burnedCalories) { (bool, error) in
      if (bool) {
        self.displayCalories()
      } else {
        
      }
    }
    
  } // end of func handlePermissions
  
  
  func displayCalories() {
    getBurnedEnergy{ (result) in
      DispatchQueue.main.async {
        let calories = String(Int(result))
        // Did not retrieve proper step count
        if (calories == "-1") {
          // If we do not have permissions
          if (!self.appIsAuthorized()) {
            self.authorize { (bool, error) in
              if bool {
                print("get burned calories : success")
              } else {
                print("fali")
              }
            }
          } // end if
          // Else, no data to show
          else {
            self.calLabel.text = "0"
          } // end else
          return
        } // end if
        self.calLabel.text = "\(Int(calories)?.formattedProductPrice() ?? "")"
        print("calories : \(Int(calories)?.formattedProductPrice() ?? "")")
      }
    }
  }
  
  func displaySteps() {
    getSteps { (result) in
      DispatchQueue.main.async {
        let stepCount = String(Int(result))
        // Did not retrieve proper step count
        if (stepCount == "-1") {
          // If we do not have permissions
          if (!self.appIsAuthorized()) {
            self.authorize { (bool, error) in
              if bool {
                print("getStepsCount : success")
              } else {
                print("fali")
              }
            }
          } // end if
          // Else, no data to show
          else {
            self.todayStepsCountLabel.text = "0"
          } // end else
          return
        } // end if
        self.registStepsCount = Int(stepCount) ?? nil
        self.todayStepsCountLabel.text = "\(Int(stepCount)?.formattedProductPrice() ?? "")"
        self.updateStepsCount()
        print("steps count : \(Int(stepCount)?.formattedProductPrice() ?? "")")
      }
    }
    
  } // end of func displaySteps
  
  func getSteps(completion: @escaping (Double) -> Void) {
    let calendar = NSCalendar.current
    let interval = NSDateComponents()
    interval.day = 1
    
    var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
    anchorComponents.hour = 0
    let anchorDate = calendar.date(from: anchorComponents)
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    // Define 1-day intervals starting from 0:00
    let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepsQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
    
    // Set the results handler
    stepsQuery.initialResultsHandler = {query, results, error in
      let endDate = NSDate()
      let startDate = calendar.date(byAdding: .day, value: 0, to: endDate as Date, wrappingComponents: false)
      if let myResults = results{
        myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
          if let quantity = statistics.sumQuantity(){
            let date = statistics.startDate
            let steps = quantity.doubleValue(for: HKUnit.count())
            
            
            print("today \(date): steps = \(steps)")
            //NOTE: If you are going to update the UI do it in the main thread
            DispatchQueue.main.async {
              completion(steps)
            }
            
          }
        } //end block
      } //end if let
    }
    healthStore.execute(stepsQuery)
  }
  
  func registStepsCountOfWeaks() {
    
    let calendar = NSCalendar.current
    let interval = NSDateComponents()
    interval.day = 1
    
    var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
    anchorComponents.hour = 0
    let anchorDate = calendar.date(from: anchorComponents)
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    // Define 1-day intervals starting from 0:00
    let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepsQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
    
    // Set the results handler
    stepsQuery.initialResultsHandler = {query, results, error in
      let endDate = NSDate()
      let startDate = calendar.date(byAdding: .day, value: -7, to: endDate as Date, wrappingComponents: false)
      if let myResults = results{
        myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
          if let quantity = statistics.sumQuantity() {
            DispatchQueue.global().sync {
              let date = statistics.startDate
              let steps = quantity.doubleValue(for: HKUnit.count())
              
              self.dateFormatter.dateFormat = "yyyy-MM-dd"
              
              let todayDateString = self.dateFormatter.string(from: Date())
              let registDateString = self.dateFormatter.string(from: calendar.date(byAdding: .hour, value: 9, to: date)!)
              
              //              print("@@@@@@@@@@@@@\n\n\n\n")
              //              print("\(date): steps = \(steps), registIndex: \(registIndex)")
              //              print("today: \(todayDateString), registDate: \(registDateString), isBefore :\(todayDateString >= registDateString) ")
              
              if todayDateString >= registDateString  {
                self.registStepsCount(stepsCount: Int(steps), date: registDateString)
              }
            }
            
            //NOTE: If you are going to update the UI do it in the main thread
            DispatchQueue.main.async {
              //update UI components
            }
            
          }
        } //end block
      } //end if let
    }
    healthStore.execute(stepsQuery)
  }
  
  func initStepsCount() {
    //    if DataHelperTool.joinDate != nil {
    //      let joinDate = DataHelperTool.joinDate!.stringToDate
    //      let interval = Date().timeIntervalSince(joinDate)
    //      let days = Int(interval / 86400)
    //
    //      if days > 6 {
    //        registStepsCountOfWeaks()
    //      }
    //    } else {
    registStepsCountOfWeaks()
    //    }
  }
  
  func getBurnedEnergy(completion: @escaping (Double) -> Void) {
    
    let calendar = NSCalendar.current
    let interval = NSDateComponents()
    interval.day = 1
    
    var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
    anchorComponents.hour = 0
    let anchorDate = calendar.date(from: anchorComponents)
    let caloriesQuantityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    // Define 1-day intervals starting from 0:00
    let caloriesQuery = HKStatisticsCollectionQuery(quantityType: caloriesQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
    
    // Set the results handler
    caloriesQuery.initialResultsHandler = {query, results, error in
      let endDate = NSDate()
      let startDate = calendar.date(byAdding: .day, value: 0, to: endDate as Date, wrappingComponents: false)
      if let myResults = results{
        myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
          if let quantity = statistics.sumQuantity(){
            let date = statistics.startDate
            let calories = quantity.doubleValue(for: HKUnit.kilocalorie())
            print("today \(date): calories = \(calories)")
            //NOTE: If you are going to update the UI do it in the main thread
            DispatchQueue.main.async {
              completion(calories)
            }
            
          }
        } //end block
      } //end if let
    }
    healthStore.execute(caloriesQuery)
  }
  
  // 주요소식 불러오는 함수
  func getServiceNewsList() {
    ApiService.request(router: SettingApi.serviceNews, success: { (response: ApiResponse<ServiceNewsResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.serviceNews = value.serviceNewsList
        self.mainServiceNewsCollectionView.reloadData()
        print("_____\(self.serviceNews)")
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  // 기부단체 불러오는 함수
  func charityList() {
    let param = CharityListRequest(diff: "all")
    ApiService.request(router: DonationApi.charityList(param: param), success: { (response: ApiResponse<CharityListV2Response>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code == 202 {
          self.doAlert(message: value.resultMsg)
        } else {
          self.activeCharity = value.charityList ?? []
          self.bottomEventCollectionView.reloadData()
        }
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
  }
  
  private func visibleCellIndexPath() -> IndexPath {
    return bottomEventCollectionView.indexPathsForVisibleItems[0]
  }
  
  private func invalidateTimer() {
    timer?.invalidate()
  }
  
  private func activateTimer() {
    timer = Timer.scheduledTimer(timeInterval: 3,
                                 target: self,
                                 selector: #selector(timerCallBack),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  @objc func timerCallBack() {
    var item = visibleCellIndexPath().item
    if item == companyList.count * infiniteCount {
      bottomEventCollectionView.scrollToItem(at: IndexPath(item: companyList.count * 2 - 1, section: 0),
                                             at: .centeredHorizontally,
                                             animated: false)
      item = companyList.count * (2 - 1)
    }
    
    item += 1
    bottomEventCollectionView.scrollToItem(at: IndexPath(item: item, section: 0),
                                           at: .centeredHorizontally,
                                           animated: true)
    //    let unitCount: Int = item % companyList.count
    //    pageControl.currentPage = unitCount
  }
  
  func getCompanyList() {
    ApiService.request(router: DonationApi.companyList, success: { (response: ApiResponse<CompanyListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code == 202 {
          self.doAlert(message: value.resultMsg)
        } else {
          self.companyList.removeAll()
          
          self.companyList = value.companyList
          
          self.companyListCount = value.companyList.count
          self.bottomEventCollectionView.reloadData()
          
          self.bottomEventCollectionView.scrollToItem(at: IndexPath(item: self.companyListCount, section: 0),
                                                      at: .centeredHorizontally,
                                                      animated: false)
          self.activateTimer()
        }
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
  }
  
  func setMyLocation() {
    if DataHelperTool.myLocation == nil {
      manager.delegate = self
      manager.desiredAccuracy = kCLLocationAccuracyBest
      let status = CLLocationManager.authorizationStatus()
      if status == .notDetermined {
        manager.requestWhenInUseAuthorization()
      }else if status == .restricted || status == .denied {
        self.callYesNoMSGDialog(message: "위치 정보 사용 동의가 필요합니다\n설정창으로 이동하시겠습니까?") {
          UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
        }
      }else {
        manager.startUpdatingLocation()
      }
    } else {
      
    }
    print("setArea: \(DataHelperTool.myLocation ?? "전체전체")")
  }
  
  func openUrl(_ url: String?,_ index:Int) {
    if url == nil{
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "issueVC") as! IssueDetailViewController
        serviceNewsId = self.serviceNews[index].id
        self.navigationController?.pushViewController(vc, animated: true)
    }else{
      if let url = URL(string: url!) {
        print("url: \(url)")
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
    }
  }
  
  @IBAction func tapCharityList(_ sender: UIButton) {
    let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "charityList") as! CharityListViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func tapRankList(_ sender: UIButton) {
    let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "rankList") as! RankListViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //    self.lastContentOffset = scrollView.contentOffset.x
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.isEqual(bottomEventCollectionView), scrollView.isDragging {
      //      self.lastContentOffset = scrollView.contentOffset.x
      //      backgroundImageView.alpha = (-(self.lastContentOffset) + 150) * 0.01
      //      print("self.lastContentOffset : \(self.lastContentOffset)")
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView.isEqual(bottomEventCollectionView), scrollView.isDragging {
      invalidateTimer()
      
      var item = visibleCellIndexPath().item
      if item == companyList.count * (infiniteCount) {
        item = companyList.count * 2
      } else if item == 1 {
        item = companyList.count + 1
      }
      
      bottomEventCollectionView.scrollToItem(at: IndexPath(item: item, section: 0),
                                  at: .centeredHorizontally,
                                  animated: false)
      
      activateTimer()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView == mainServiceNewsCollectionView {
      if self.serviceNews.count != 0 {
        return self.serviceNews.count
      } else {
        return 0
      }
    }
    else if collectionView == bottomEventCollectionView {
      return companyList.count * infiniteCount
    }
    else {
      return 4
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // mainCollection TagNum - image: 5 , label: 6
    // donationCollection TagNum - image: 7, titleLabel: 8 , contentLabel: 9
    
    if collectionView == mainServiceNewsCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainServiceListCell", for: indexPath)
      
      if let imageView = cell.viewWithTag(5) as? UIImageView {
        let url = URL(string: serviceNews[indexPath.row].thumbnail ?? "")
        imageView.kf.setImage(with: url!)
        imageView.layer.cornerRadius = 10
      }
      if let labelText = cell.viewWithTag(6) as? UILabel {
        labelText.text = serviceNews[indexPath.row].title
      }
      return cell
    }
    else if collectionView == bottomEventCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donationListCell", for: indexPath)
      
      if let imageView = cell.viewWithTag(1) as? UIImageView {
        //        \(ApiEnvironment.baseUrl)/img/
        let url = URL(string: "\(companyList[indexPath.item % companyListCount].thumbnail ?? "")")
        imageView.kf.setImage(with: url)
      }
      return cell
    }
    else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainServiceListCell", for: indexPath)
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == mainServiceNewsCollectionView {
      openUrl(self.serviceNews[indexPath.row].link,indexPath.row)
    }
    else if collectionView == bottomEventCollectionView {
      companyId = companyList[indexPath.item % companyListCount].id
      performSegue(withIdentifier: "companyDetail", sender: nil)
    }
    
  }
  
}
// 콜렉션 뷰 활용 할 땐 꼭 필요함
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if collectionView == bottomEventCollectionView {
      let size = bottomEventCollectionView.frame.size
      return CGSize(width: size.width, height: 100)
    } else if collectionView == mainServiceNewsCollectionView {
      return CGSize(width: CGFloat(160), height: CGFloat(185))
    } else {
      return CGSize(width: CGFloat(0), height: CGFloat(0))
    }
    
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}

// MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .restricted || status == .denied {
      
    } else {
      manager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //위치가 업데이트될때마다
    if let location = manager.location {
      print("latitude :" + String(location.coordinate.latitude) + " / longitude :" + String(location.coordinate.longitude))
      currentLocation = (location.coordinate.latitude, location.coordinate.longitude)
      manager.stopUpdatingLocation()
      
      let geoCoder = CLGeocoder()
      geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
        if let error = error {
          NSLog("\(error)")
          return
        }
        if DataHelperTool.myLocation == nil {
          guard let placemark = placemarks?.first else { return }
          //          self.addressLabel.text = "\(placemark.administrativeArea ?? "")" + " " + "\(placemark.locality ?? "")"
          //          " + " " + "\(placemark.name ?? "")
        } else {
          //          self.addressLabel.text = DataHelperTool.myLocation ?? ""
        }
      }
      
    }
  }
}
