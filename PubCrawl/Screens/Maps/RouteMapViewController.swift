//
//  MyLocation.swift
//  PubCrawl
//
//  Created by Victor Cuc on 25/04/2021.
//

import GoogleMaps
import UIKit
import Alamofire
import SwiftyJSON

class RouteMapViewController: UIViewController {
  
  var route: Route!
  
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
    // MARK: Request for response from google
    if let url = GoogleDirectionsManager.makeDirectionsURL(forRoute: route) {
      AF.request(url).responseJSON { (response) in
        guard let data = response.data else {
          return
        }
        
        do {
          let jsonData = try JSON(data: data)
          let routes = jsonData["routes"].arrayValue
          
          for route in routes {
            let overview_polyline = route["overview_polyline"].dictionary
            let points = overview_polyline?["points"]?.string
            let path = GMSPath.init(fromEncodedPath: points ?? "")
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeColor = .systemBlue
            polyline.strokeWidth = 5
            polyline.map = self.mapView
          }
        }
        catch let error {
          print(error.localizedDescription)
        }
      }
    }
    
    
    mapView.delegate = self
    mapView.settings.compassButton = true
    mapView.settings.myLocationButton = true
    mapView.isMyLocationEnabled = true
    view = mapView
    
    createMarkers()
    
    // Listen to the myLocation property of GMSMapView.
    observation = mapView.observe(\.myLocation, options: [.new]) {
      [weak self] mapView, _ in
      self?.location = mapView.myLocation
    }
  }
  
  deinit {
    observation?.invalidate()
  }
  
  func createMarkers() {
    
    if route.locations != nil {
      let coordinates = route.locations.map { (location) -> CLLocationCoordinate2D in
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      }
      for i in 0..<coordinates.count {
        let coordinate = coordinates[i]
        
        let marker = GMSMarker(position: coordinate)
        marker.title = String(i+1)
        marker.iconView = MapMarkerView()
        marker.map = mapView
      }
    }
  }
}

extension RouteMapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
    let alert = UIAlertController(
      title: "Location Tapped",
      message: "Current location: <\(location.latitude), \(location.longitude)>",
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
