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
  var displayedMarkers: [GMSMarker] = []
  var displayedPolyline: GMSPolyline?
  var observation: NSKeyValueObservation?
  
  class func instantiateFromStoryboard() -> RouteMapViewController {
    let storyboard = UIStoryboard(name: "Maps", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "RouteMapViewController") as! RouteMapViewController
    
    return viewController
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureButtons()
    
    mapView.delegate = self
    mapView.settings.compassButton = true
    mapView.settings.myLocationButton = true
    mapView.isMyLocationEnabled = true
    mapView.padding = UIEdgeInsets (top: 0, left: 0, bottom: 98, right: 0)
        
    createMarkers()
    // Listen to the myLocation property of GMSMapView.
    observation = mapView.observe(\.myLocation, options: [.new]) { [weak self] mapView, _ in
      guard let self = self else {
        return
      }
      
      self.fitMap(to: self.displayedMarkers.map({ $0.position }))
      self.getRouteOverviewDirections()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    fitMap(to: displayedMarkers.map( { $0.position }))
    getRouteOverviewDirections()
  }
  
  deinit {
    observation?.invalidate()
  }
  
  @IBAction func endRoute() {
    let createPostViewController = CreatePostViewController.instantiateFromStoryboard()
    createPostViewController.route = route
    self.navigationController?.pushViewController(createPostViewController, animated: true)
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
        
        displayedMarkers.append(marker)
      }
    }
  }
  
  //MARK: - Directions
  func getRouteOverviewDirections() {
    let placeIDs = route.locations.map({ $0.placeID })
    
    GoogleDirectionsManager.shared.getDirections(myCoordinate: mapView.myLocation?.coordinate, waypoints: placeIDs) { [weak self] (polyline, error) in
      if error != nil {
        print(error!.localizedDescription)
      } else {
        self?.displayedPolyline = polyline
        self?.displayedPolyline?.map = self!.mapView
      }
    }
  }
  
  //MARK: - Helpers
  func fitMap(to coordinates: [CLLocationCoordinate2D], animated: Bool = true) {
    var bounds = GMSCoordinateBounds()
    
    for coordinate in coordinates {
      bounds = bounds.includingCoordinate(coordinate)
    }
    
    if let myCoordinate = mapView.myLocation?.coordinate {
      bounds = bounds.includingCoordinate(myCoordinate)
    }
    
    let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 40.0)
    if animated {
      mapView.animate(with: cameraUpdate)
    } else {
      mapView.moveCamera(cameraUpdate)
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
