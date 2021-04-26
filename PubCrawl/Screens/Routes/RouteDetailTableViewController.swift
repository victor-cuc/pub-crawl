//
//  RouteDetailTableViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 20/04/2021.
//

import GooglePlaces
import UIKit

class RouteDetailTableViewController: UITableViewController {
  static let identifier = String(describing: RouteDetailTableViewController.self)
  
  private var route: Route!
  
  @IBOutlet weak var starCount: UILabel!
  @IBOutlet weak var starButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var roundedCornerContainer: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var locationCount: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var addLocationButton: UIButton!
  
  @IBAction func toggleStar() {
    FirebaseManager.toggleStar(forRoute: route) {
      self.starButton.isSelected = self.route.isStarredByCurrentUser()
      self.starCount.text = String(self.route.starredBy.count)
    }
  }
  
  @IBAction func startRoute() {
    navigationController?.pushViewController(MyLocationViewController.init(), animated: true)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  class func instantiateFromStoryboard(route: Route) -> RouteDetailTableViewController {
    let storyboard = UIStoryboard(name: "Routes", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "RouteDetailTableViewController") as! RouteDetailTableViewController
    viewController.route = route
    
    return viewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureDetailView()
  }
  
  func configureDetailView() {
    startButton.addDefaultShadow()
    startButton.addDefaultRoundedCorners()
    
    self.title = route.name
    nameLabel.text = route.name
    starCount.text = String(route.starredBy.count)
    starButton.isSelected = route.isStarredByCurrentUser()
    imageView.loadImageFromFirebase(reference: route.imageRef, placeholder: UIImage(named: "placeholderRouteThumbnail"))
    locationCount.text = String(route.locationIDs.count)
    
    roundedCornerContainer.addDefaultRoundedCorners(clipsToBounds: true)
  }
  
  @IBAction func showLocationSearch() {
    let locationSearchController = GMSAutocompleteViewController()
    locationSearchController.delegate = self
    
    let fields: GMSPlaceField = GMSPlaceField(rawValue:
                                                UInt(GMSPlaceField.name.rawValue) |
                                                UInt(GMSPlaceField.placeID.rawValue) |
                                                UInt(GMSPlaceField.coordinate.rawValue) |
                                                UInt(GMSPlaceField.rating.rawValue) |
                                                UInt(GMSPlaceField.priceLevel.rawValue))
    
    let filter = GMSAutocompleteFilter()
    filter.type = .establishment
    locationSearchController.autocompleteFilter = filter
    
    locationSearchController.placeFields = fields
    
    present(locationSearchController, animated: true)
  }
}

//MARK:- Google Maps Autocomplete ViewController Delegate
extension RouteDetailTableViewController: GMSAutocompleteViewControllerDelegate {
  func viewController(
    _ viewController: GMSAutocompleteViewController,
    didAutocompleteWith place: GMSPlace
  ) {
    let pickedPlace = Location(googlePlace: place)
    print(pickedPlace.coordinate)
    dismiss(animated: true, completion: nil)
  }

  func viewController(
    _ viewController: GMSAutocompleteViewController,
    didFailAutocompleteWithError error: Error
  ) {
    // TODO: Handle Error
    dismiss(animated: true, completion: nil)
    print("Error: ", error.localizedDescription)
  }

  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    navigationController?.dismiss(animated: true)
    dismiss(animated: true, completion: nil)
  }

  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
