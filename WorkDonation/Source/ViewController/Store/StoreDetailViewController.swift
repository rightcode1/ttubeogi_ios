//
//  StoreDetailViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2020/12/27.
//

import UIKit
import Kingfisher

class StoreDetailViewController: UIViewController {
  @IBOutlet var mapView: MTMapView!
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var telLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var reviewCountLabel: UILabel!
  
  @IBOutlet var webSiteInfoView: UIView!
  @IBOutlet weak var webSiteLabel: UILabel!
  @IBOutlet weak var storeInfoLabel: UILabel!
  
  @IBOutlet weak var imageStackView: UIStackView!
  
  @IBOutlet var ratingButton: UIButton!
  
  var storeId: Int?
  var moveUrl = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    shadow(view: ratingButton, radius: 5, offset: CGSize(width: 0, height: 1))
    getStoreDetail()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "rate", let vc = segue.destination as? RatingPopupViewController {
      vc.storeId = storeId
    }
  }
  
  func initWithDetailData(_ data: StoreDetail) {
    if data.images.count > 0 {
      thumbnailImageView.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/\(data.images[0])"))
    } else {
      thumbnailImageView.image = #imageLiteral(resourceName: "blankImage")
    }
    
    if (data.images.count) > 0 {
      for i in 0..<data.images.count {
        if i != 0 {
          KingfisherManager.shared.retrieveImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/\(data.images[i])")!) { result in
            switch result {
              case .success(let value):
                let image = value.image.resizeToWidth(newWidth: self.view.frame.width - 40)
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
                
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = image
                self.imageStackView.addArrangedSubview(imageView)
              case .failure:
                break
            }
          }
        }
      }
    }
    
    titleLabel.text = data.name
    addressLabel.text = data.address
    telLabel.text = data.tel
    distanceLabel.text = data.distance
    ratingLabel.text = "\(data.averageRate)"
    //    reviewCountLabel.text = "리뷰 \(data.reviews.count)개"
    storeInfoLabel.text = data.content
    
    if data.url == nil {
      webSiteInfoView.isHidden = true
    } else {
      webSiteLabel.text = data.url ?? ""
      moveUrl = data.url ?? ""
      
      if moveUrl != "" {
        let first = moveUrl[moveUrl.startIndex]
        if first == "w" || first == "W" {
          moveUrl = "http://" + moveUrl
        }
      }
    }
    
    let poiItem = MTMapPOIItem()
    
    poiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(data.latitude)!, longitude: Double(data.longitude)!))
    poiItem.itemName = data.name
    poiItem.markerType = .customImage
    poiItem.customImage =  #imageLiteral(resourceName: "marker").resizeToWidth(newWidth: 17)
    poiItem.showAnimationType = .springFromGround
    poiItem.tag = 1
    poiItem.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)
    let customCalloutBalloonViewCompany:UIView = .init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    poiItem.customCalloutBalloonView = customCalloutBalloonViewCompany
    self.mapView.add(poiItem)
    
    let initialPointGeo = MTMapPointGeo(latitude: Double(data.latitude)!,
                                        longitude: Double(data.longitude)!)
    self.mapView.setMapCenter(MTMapPoint(geoCoord: initialPointGeo), animated: true)
  }
  
  
  func getStoreDetail() {
    let param = StoreDetailRequest(
      storeId: storeId ?? 0,
      latitude: String(currentLocation?.0 ?? 0.0),
      longitude: String(currentLocation?.1 ?? 0.0)
    )
    ApiService.request(router: StoreApi.storeDetail(param: param), success: { (response: ApiResponse<StoreDetailResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.callMSGDialog(message: value.resultMsg)
        } else {
          self.initWithDetailData(value.store)
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
  
  
  
  @IBAction func moveToWebBtn(_ sender: UIButton) {
    if let url = URL(string: moveUrl) {
      UIApplication.shared.open(url, options: [:])
    }
  }
}
