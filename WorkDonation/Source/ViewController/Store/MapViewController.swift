//
//  MapViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/27.
//

import UIKit
import CoreLocation

var latitude = ""
var longitude = ""

class MapViewController: UIViewController {
  @IBOutlet var addressLb: UILabel!
  @IBOutlet var mapView: MTMapView!{
    didSet{
      mapView.delegate = self
    }
  }
  @IBOutlet var centerMakerImageView: UIImageView!
  @IBOutlet var infoView: UIView!
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var telLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var reviewCountLabel: UILabel!
  
  let locManager = CLLocationManager()
  var location = CLLocation()
  
  var storeList: [StoreList] = []
  
  var selectStoreId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationTitleUI()
    
    let infoViewTap = UITapGestureRecognizer(target: self, action: #selector(infoViewTapped(_:)))
    infoView.addGestureRecognizer(infoViewTap)

    let status = CLLocationManager.authorizationStatus()
    if status == .notDetermined {
      DispatchQueue.main.async {
        self.locManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
              CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
          self.locManager.startUpdatingLocation()
          self.location = self.locManager.location!
          longitude = "\(self.location.coordinate.longitude)"
          latitude = "\(self.location.coordinate.latitude)"
        }
      }
    } else if status == .restricted || status == .denied {
      self.callYesNoMSGDialog(message: "위치 정보 사용 동의가 필요합니다\n설정창으로 이동하시겠습니까?") {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
      }
    } else {
      DispatchQueue.main.async {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
              CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
          self.locManager.startUpdatingLocation()
          self.location = self.locManager.location!
          //                        DispatchQueue.global().sync {
          longitude = "\(self.location.coordinate.longitude)"
          latitude = "\(self.location.coordinate.latitude)"
          //                        }
          self.setUI()
          
        }
      }
      
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let initialPointGeo = MTMapPointGeo(latitude: currentLocation?.0 ?? 0.0,
                                        longitude: currentLocation?.1 ?? 0.0)
    self.mapView.setMapCenter(MTMapPoint(geoCoord: initialPointGeo), animated: true)
    self.infoView.frame = CGRect(x: 0, y: self.mapView.frame.maxY, width: self.view.frame.width, height: 95)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "detail", let vc = segue.destination as? StoreDetailViewController, let id = sender as? Int {
      vc.storeId = id
    }
  }
  
  // 위도경도로 주소 가져오는 함수
  func coordinateToAddress(lati: String, long: String) {
    guard let a = Double(lati) else { return }
    guard let b = Double(long) else { return }
    let findLocation = CLLocation(latitude: a, longitude: b)
    
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(findLocation) { (placemarks, error) -> Void in
      if error != nil {
        print("\(String(describing: error))")
        return
      }
      guard let placemark = placemarks!.first,
            let addrList = placemark.addressDictionary else {
        return
      }
      let address = addrList["Street"]
      let city = addrList["City"]
      let state = addrList["State"]
      
      let finalAddress = "\(state ?? "서울특별시") \(city ?? "강남구") \(address ?? "봉은사로")"
      self.addressLb.text = finalAddress
    }
  }
  
  func initWithStoreList(_ list: StoreList) {
    selectStoreId = list.id
    if list.image == nil {
      thumbnailImageView.image = #imageLiteral(resourceName: "blankImage")
    } else {
      thumbnailImageView.kf.setImage(with: URL(string: list.image ?? ""))
    }
    titleLabel.text = list.name
    addressLabel.text = list.address
    telLabel.text = list.tel
    distanceLabel.text = list.distance
    ratingLabel.text = "\(list.averageRate)"
    reviewCountLabel.text = "리뷰 \(list.reviews.count)개"
  }
  
  func setUI() {
    mapView.removeAllCircles()
    let initialPointGeo = MTMapPointGeo(latitude: Double(latitude) ?? 0,
                                        longitude: Double(longitude) ?? 0 )
    
    self.getStoreList(category: "전체")
    self.coordinateToAddress(lati: latitude, long: longitude)
    let circle = MTMapCircle()
    
    circle.circleCenterPoint = MTMapPoint(geoCoord: initialPointGeo)
    circle.circleLineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.09808433219)
    circle.circleFillColor = #colorLiteral(red: 0.1489442587, green: 0.4468096495, blue: 0.6807867885, alpha: 0.3973137842)
    circle.tag = 1234
    circle.circleRadius = 100
    mapView.addCircle(circle)
    self.mapView.setMapCenter(MTMapPoint(geoCoord: initialPointGeo), animated: true)
    self.mapView.currentLocationTrackingMode = .onWithoutHeading
    self.mapView.showCurrentLocationMarker = true
    
  }
  
  func getStoreList(category: String?, onlyDelivery: String? = nil) {
    let param = StoreListRequest(
      latitude: latitude,
      longitude: longitude,
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
          self.callMSGDialog(message: value.resultMsg)
        }else {
          print("in???????????????????")
          DispatchQueue.global().sync {
            self.mapView.removeAllPOIItems()
            
            self.storeList = value.storeList
            var poiItems = [MTMapPOIItem]()
            for (index, list) in value.storeList.enumerated() {
              let pointItme = MTMapPOIItem()
              pointItme.itemName = list.name
              pointItme.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(list.latitude)!, longitude: Double(list.longitude)!))
              pointItme.markerType = MTMapPOIItemMarkerType.customImage
              
              pointItme.customImage = #imageLiteral(resourceName: "marker").resizeToWidth(newWidth: 17)
              
              pointItme.tag = index
              poiItems.append(pointItme)
            }
            
            self.mapView.addPOIItems(poiItems)
          }
          
          DispatchQueue.main.async {
            self.mapView.reloadInputViews()
          }
        }
      } else {
        if value.code >= 202 {
          self.callMSGDialog(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.callMSGDialog(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  @objc
  func infoViewTapped(_ sender: UITapGestureRecognizer) {
    let vc = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "storeDetailVC") as! StoreDetailViewController
    vc.storeId = selectStoreId
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}
// MARK: - MTMapViewDelegate

extension MapViewController: MTMapViewDelegate {
  
  func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
    let dict = storeList[poiItem.tag]
    self.initWithStoreList(dict)
    // 뷰의 위치가 변하면서 애니메이션 주는 법
    UIView.animate(withDuration: 0.2) {
      self.infoView.frame = CGRect(x: 0, y: self.mapView.frame.maxY - 95, width: self.view.frame.width, height: 95)
      self.view.layoutIfNeeded()
      self.infoView.isHidden = false
    }
    return true
    
  }
  
  
  func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
    UIView.animate(withDuration: 0.2) {
    self.infoView.frame = CGRect(x: 0, y: mapView.frame.maxY, width: self.view.frame.width, height: 95)
    self.infoView.isHidden = true
      
    }
  }
  
  func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
    let dict = storeList[poiItem.tag]
    performSegue(withIdentifier: "detail", sender: dict.id)
  }
  
  func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
    let currentLocationPointGeo = location.mapPointGeo()
    print("\(currentLocationPointGeo.latitude)")
    print("\(currentLocationPointGeo.longitude)")
    print("\(accuracy)")
  }
}
