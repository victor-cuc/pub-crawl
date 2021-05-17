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
  
  enum ScreenState {
    case overview
    case inProgress(Location)
    case finished
  }
  
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var endButton: UIButton!
  @IBOutlet weak var previousButton: UIButton!
  
  var route: Route!
  var displayedMarkers: [GMSMarker] = []
  var displayedPolyline: GMSPolyline?
  var observation: NSKeyValueObservation?
  
  var previousScreenState: ScreenState?
  var screenState: ScreenState = .overview
  
  class func instantiateFromStoryboard() -> RouteMapViewController {
    let storyboard = UIStoryboard(name: "Maps", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "RouteMapViewController") as! RouteMapViewController
    
    return viewController
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureButtonsUI()
    
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
      self.configureCurrentState()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    fitMap(to: displayedMarkers.map( { $0.position }))
    configureCurrentState()
  }
  
  deinit {
    observation?.invalidate()
  }
  
  //MARK: - Configuration
  func configureCurrentState() {
    configureButtonAppearance()
    
    switch screenState {
    case .overview:
      getRouteOverviewDirections()
      break
    case .inProgress(let location):
      getRouteToLocation(location)
      break
    case .finished:
      getRouteOverviewDirections()
      break
    }
  }
  
  func configureButtonsUI() {
    previousButton.addDefaultShadow()
    previousButton.addRoundedCorners(radius: Constants.Appearance.defaultCornerRadius)
    endButton.addDefaultShadow()
    endButton.addRoundedCorners(radius: Constants.Appearance.defaultCornerRadius)
    nextButton.addDefaultShadow()
    nextButton.addRoundedCorners(radius: Constants.Appearance.defaultCornerRadius)
  }
  
  func configureButtonAppearance() {
    switch screenState {
    case .overview:
      previousButton.isHidden = true
      nextButton.setTitle("Start", for: .normal)
      break
    case .inProgress(let location):
      previousButton.isHidden = location === route.locations.first
      let title = location === route.locations.last ? "Finish" : "Next Location"
      nextButton.setTitle(title, for: .normal)
      break
    case .finished:
      previousButton.isHidden = true
      endButton.isHidden = true
      nextButton.setTitle("Continue", for: .normal)
      
      break
    }
  }
  
  func createMarkers() {
    
    let coordinates = route.locations.map { (location) -> CLLocationCoordinate2D in
      CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    for (index, location) in route.locations.enumerated() {
      let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      
      let markerView = MapMarkerView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
      markerView.numberLabel.text = String(index + 1)
      
      if index == 0 || index == coordinates.count - 1 {
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
  
  //MARK: - Directions
  func getRouteOverviewDirections() {
    let placeIDs = route.locations.map({ $0.placeID })
    
    GoogleDirectionsManager.shared.getDirections(myCoordinate: mapView.myLocation?.coordinate, waypoints: placeIDs) { [weak self] (polyline, error) in
      self?.displayedPolyline?.map = nil
      if error != nil {
        print(error!.localizedDescription)
      } else {
        self?.displayedPolyline = polyline
        self?.displayedPolyline?.map = self!.mapView
      }
    }
  }
  
  func getRouteToLocation(_ location: Location) {
    let myCoordinate = mapView.myLocation?.coordinate
    var previousLocation: Location?
    
    if myCoordinate == nil {
      guard case let .inProgress(_previousLocation) = previousScreenState else {
        getRouteOverviewDirections()
        return
      }
      previousLocation = _previousLocation
    }
    
    let waypoints = [previousLocation?.placeID, location.placeID].compactMap({ $0 })
    
    GoogleDirectionsManager.shared.getDirections(myCoordinate: myCoordinate, waypoints: waypoints) { [weak self] (polyline, error) in
      self?.displayedPolyline?.map = nil
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
  
  //MARK: - Actions
  @IBAction func endRouteButtonAction() {
    goToPostScreen()
  }
  
  @IBAction func nextButtonAction() {
    previousScreenState = screenState
    
    switch screenState {
    case .overview:
      if let firstLocation = route.locations.first {
        screenState = .inProgress(firstLocation)
      } else {
        screenState = .finished
      }
      
    case .inProgress(let location):
      if let nextLocation = route.nextLocation(for: location) {
        screenState = .inProgress(nextLocation)
      } else {
        screenState = .finished
      }
      
    case .finished:
      goToPostScreen()
      return
    }
    
    configureCurrentState()
  }
  
  @IBAction func previousButtonAction() {
    if case let .inProgress(location) = previousScreenState {
      screenState = previousScreenState!
      if let previousLocation = route.previousLocation(for: location) {
        previousScreenState = .inProgress(previousLocation)
      } else {
        previousScreenState = .overview
      }
      configureCurrentState()
    }
  }
  
  func goToPostScreen() {
    let createPostViewController = CreatePostViewController.instantiateFromStoryboard()
    createPostViewController.route = route
    self.navigationController?.pushViewController(createPostViewController, animated: true)
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
