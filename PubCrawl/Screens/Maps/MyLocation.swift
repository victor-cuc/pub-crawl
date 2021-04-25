//
//  MyLocation.swift
//  PubCrawl
//
//  Created by Victor Cuc on 25/04/2021.
//

import GoogleMaps
import UIKit

class MyLocationViewController: UIViewController {
  
  lazy var mapView: GMSMapView = {
    let camera = GMSCameraPosition(latitude: -33.868, longitude: 151.2086, zoom: 1)
    return GMSMapView(frame: .zero, camera: camera)
  }()

  var observation: NSKeyValueObservation?
  var location: CLLocation? {
    didSet {
      guard oldValue == nil, let firstLocation = location else { return }
      mapView.camera = GMSCameraPosition(target: firstLocation.coordinate, zoom: 14)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.delegate = self
    mapView.settings.compassButton = true
    mapView.settings.myLocationButton = true
    mapView.isMyLocationEnabled = true
    view = mapView

    // Listen to the myLocation property of GMSMapView.
    observation = mapView.observe(\.myLocation, options: [.new]) {
      [weak self] mapView, _ in
      self?.location = mapView.myLocation
    }
  }

  deinit {
    observation?.invalidate()
  }
}

extension MyLocationViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
    let alert = UIAlertController(
      title: "Location Tapped",
      message: "Current location: <\(location.latitude), \(location.longitude)>",
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
