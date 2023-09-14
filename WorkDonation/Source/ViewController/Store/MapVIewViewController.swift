//
//  MapVIewViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/28.
//

import UIKit

class MapVIewViewController: UIViewController, MTMapViewDelegate {

  var mapView: MTMapView?
  
    override func viewDidLoad() {
        super.viewDidLoad()

      mapView = MTMapView(frame: self.view.bounds)
      if let mapView = mapView {
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
      }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
