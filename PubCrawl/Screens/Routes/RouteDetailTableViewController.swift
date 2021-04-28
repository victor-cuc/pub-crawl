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

  class func instantiateFromStoryboard(route: Route) -> RouteDetailTableViewController {
    let storyboard = UIStoryboard(name: "Routes", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "RouteDetailTableViewController") as! RouteDetailTableViewController
    viewController.route = route
    
    return viewController
  }
  
  private var route: Route!
  var dataSource: UITableViewDiffableDataSource<Int, Location>!
  
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

  override func viewDidLoad() {
    super.viewDidLoad()
    
    route.fetchLocations() {
      self.updateDataSource()
    }
    
    self.configureDetailView()
    self.configureDataSource()
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
    newSnapshot.appendItems(route.locations!)
    
    dataSource.apply(newSnapshot, animatingDifferences: true)
  }
}
