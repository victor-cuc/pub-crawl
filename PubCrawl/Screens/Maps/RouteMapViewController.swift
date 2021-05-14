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
  
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var endButton: UIButton!
  @IBOutlet weak var previousButton: UIButton!
  
  var route: Route!
  var observation: NSKeyValueObservation?
  var location: CLLocation? {
    didSet {
      guard oldValue == nil, let firstLocation = location else { return }
      mapView.camera = GMSCameraPosition(target: firstLocation.coordinate, zoom: 14)
    }
  }
  
  class func instantiateFromStoryboard() -> RouteMapViewController {
    let storyboard = UIStoryboard(name: "Maps", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "RouteMapViewController") as! RouteMapViewController
    
    return viewController
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    
    configureButtons()
    
    mapView.delegate = self
    mapView.settings.compassButton = true
    mapView.settings.myLocationButton = true
    mapView.isMyLocationEnabled = true
    mapView.padding = UIEdgeInsets (top: 0, left: 0, bottom: 98, right: 0)
        
    createMarkers()
    
    // Listen to the myLocation property of GMSMapView.
    observation = mapView.observe(\.myLocation, options: [.new]) {
      [weak self] mapView, _ in
      self?.location = mapView.myLocation
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  deinit {
    observation?.invalidate()
  }
  
  @IBAction func endRoute() {
    let createPostViewController = CreatePostViewController.instantiateFromStoryboard()
    createPostViewController.route = route
    var viewControllers = self.navigationController?.viewControllers
    viewControllers?.removeLast()
    viewControllers?.append(createPostViewController)
    self.navigationController?.setViewControllers(viewControllers!, animated: true)
  }
  
  func configureButtons() {
    previousButton.addDefaultShadow()
    previousButton.addRoundedCorners(radius: Constants.Appearance.defaultCornerRadius)
    endButton.addDefaultShadow()
    endButton.addRoundedCorners(radius: Constants.Appearance.defaultCornerRadius)
    nextButton.addDefaultShadow()
    nextButton.addRoundedCorners(radius: Constants.Appearance.defaultCornerRadius)
  }
  
  func createMarkers() {
    
    if route.locations != nil {
      let coordinates = route.locations.map { (location) -> CLLocationCoordinate2D in
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      }
      for i in 0..<coordinates.count {
        let location = route.locations[i]
        let coordinate = coordinates[i]
        
        let markerView = MapMarkerView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        markerView.numberLabel.text = String(i + 1)
        
        if i == 0 || i == coordinates.count - 1 {
          markerView.invertColors()
        }
        
        let marker = GMSMarker(position: coordinate)
        marker.title = location.name
        marker.snippet = location.address
        marker.iconView = markerView
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
