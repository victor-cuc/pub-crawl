//
//  EditRouteViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 20/04/2021.
//

import GooglePlaces
import UIKit

class EditRouteViewController: UITableViewController {
  static let identifier = String(describing: EditRouteViewController.self)
  
  class func instantiateFromStoryboard(route: Route) -> EditRouteViewController {
    let storyboard = UIStoryboard(name: "Routes", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "EditRouteViewController") as! EditRouteViewController
    viewController.route = route
    
    return viewController
  }

  private var route: Route!
  var dataSource: UITableViewDiffableDataSource<Int, Location>!
  let rectangularBounds = GMSPlaceRectangularLocationOption(CLLocationCoordinate2D(latitude: 46.814222, longitude: 23.711550), CLLocationCoordinate2D(latitude: 46.709125, longitude: 23.530400))
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var roundedCornerContainer: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var addLocationButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = editButtonItem

    addLocationButton.addDefaultShadow()
    addLocationButton.addFullRoundedCorners()
    
    route.fetchLocations() { return }
    
    self.configureDetailView()
    self.configureDataSource()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.setEditing(true, animated: true)
  }
  
  func configureDetailView() {
    
    self.title = route.name
    nameLabel.text = route.name
    imageView.loadImageFromFirebase(reference: route.imageRef, placeholder: UIImage(named: "placeholderRouteThumbnail"))
    
    roundedCornerContainer.addDefaultRoundedCorners(clipsToBounds: true)
  }
  
  // MARK:- Data Source
  func configureDataSource() {
    typealias LocationDataSource = UITableViewDiffableDataSource<Int, Location>
    
    dataSource = LocationDataSource(tableView: tableView) {
      (tableView: UITableView, indexPath: IndexPath, location: Location) -> UITableViewCell? in
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else {
        fatalError("Could not create LocationCell")
      }
      
      cell.indexLabel.text = String(indexPath.item + 1)
      cell.nameLabel.text = location.name
      cell.addressLabel.text = location.address ?? ""
      
      return cell
    }
  }
  
  func updateDataSource() {
    var newSnapshot = NSDiffableDataSourceSnapshot<Int, Location>()
    
    newSnapshot.appendSections([0])
    newSnapshot.appendItems(route.locations)
    
    dataSource.apply(newSnapshot, animatingDifferences: true)
  }
  
  //MARK:- Editing
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    .delete
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      guard let location = dataSource.itemIdentifier(for: indexPath) else { return }
      print("should delete location\(location.name)")
    }
  }
  
  //MARK:- Location Search
  @IBAction func showLocationSearch() {
    let locationSearchController = GMSAutocompleteViewController()
    locationSearchController.delegate = self
    
    let fields: GMSPlaceField = GMSPlaceField(rawValue:
                                                UInt(GMSPlaceField.name.rawValue) |
                                                UInt(GMSPlaceField.placeID.rawValue) |
                                                UInt(GMSPlaceField.coordinate.rawValue) |
                                                UInt(GMSPlaceField.rating.rawValue) |
                                                UInt(GMSPlaceField.priceLevel.rawValue) |
                                                UInt(GMSPlaceField.formattedAddress.rawValue))
    
    let filter = GMSAutocompleteFilter()
    filter.type = .establishment
    locationSearchController.autocompleteFilter = filter
    
    filter.locationBias = rectangularBounds
    
    locationSearchController.placeFields = fields
    
    present(locationSearchController, animated: true)
  }
}

//MARK:- Google Maps Autocomplete ViewController Delegate
extension EditRouteViewController: GMSAutocompleteViewControllerDelegate {
  func viewController(
    _ viewController: GMSAutocompleteViewController,
    didAutocompleteWith place: GMSPlace
  ) {
    FirebaseManager.createLocation(fromGMSPlace: place, toRoute: route) { (location) in
      print(location)
      self.route.fetchLocations {
        self.updateDataSource()
      }
      self.dismiss(animated: true, completion: nil)
    }
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
  
  // MARK:- Actions
  @IBAction func cancelAction() {
    self.navigationController?.popViewController(animated: true)
    FirebaseManager.deleteRoute(route) { (error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        print("Deleted route: \(self.route.name)")
      }
    }
  }
}


