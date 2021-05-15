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
  @IBOutlet weak var timeEstimate: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var timeEstimateActivityIndicator: UIActivityIndicatorView!

  
  @IBAction func toggleStar() {
    FirebaseManager.toggleStar(forRoute: route) {
      self.starButton.isSelected = self.route.isStarredByCurrentUser()
      self.starCount.text = String(self.route.starredBy.count)
    }
  }
  
  @IBAction func startRoute() {
    let routeMapViewController = RouteMapViewController.instantiateFromStoryboard()
    routeMapViewController.route = route
    navigationController?.pushViewController(routeMapViewController, animated: true)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func viewDidLoad() {
    print("viewDidLoad DetailView")
    super.viewDidLoad()
    
    loadData()
    
    configureDetailView()
    configureDataSource()
  }
  
  func loadData() {
    route.fetchLocations() { [weak self] in
      self?.updateDataSource()
      self?.loadTimeEstimate()
      self?.toggleStartButton(enabled: !(self?.route.locations.isEmpty == true))
    }
  }
  
  func loadTimeEstimate() {
    self.timeEstimateActivityIndicator.isHidden = false
    self.timeEstimateActivityIndicator.startAnimating()
    self.timeEstimate.text = "Loading..."
    GoogleDirectionsManager.getTimeEstimate(forRoute: route) { [weak self] (directionsEstimate, error) in
      self?.timeEstimateActivityIndicator.isHidden = true
      self?.timeEstimateActivityIndicator.stopAnimating()
      guard let self = self else { return }
      guard let directionsEstimate = directionsEstimate else { return }
      let timeEstimateInSeconds = directionsEstimate + 10 * 60 * self.route.locations.count // 10 mins per location
      let timeEstimateHMS = timeEstimateInSeconds.secondsToHoursMinutesSeconds()
      let formattedTime = "\(timeEstimateHMS.0) hours, \(timeEstimateHMS.1) minutes"
      self.timeEstimate.text = formattedTime
    }
  }
  
  func configureDetailView() {
    startButton.addDefaultShadow()
    startButton.addDefaultRoundedCorners()
    
    
    self.title = route.name
    nameLabel.text = route.name
    starCount.text = String(route.starredBy.count)
    starButton.isSelected = route.isStarredByCurrentUser()
    toggleStartButton(enabled: !route.locations.isEmpty)
    imageView.loadImageFromFirebase(reference: route.imageRef, placeholder: UIImage(named: "placeholderRouteThumbnail"))
    locationCount.text = String(route.locationIDs.count)
    timeEstimateActivityIndicator.isHidden = true
    
    roundedCornerContainer.addDefaultRoundedCorners(clipsToBounds: true)
  }
  
  func toggleStartButton(enabled: Bool) {
    startButton.backgroundColor = !enabled ? startButton.backgroundColor?.withAlphaComponent(0.6) : startButton.backgroundColor?.withAlphaComponent(1)
    startButton.isEnabled = enabled
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
      
      if location.rating != nil {
        cell.ratingNumberLabel.text = String(location.rating!)
      } else {
        cell.ratingStack.isHidden = true
      }
      
//      guard location.priceLevel != nil else {
//        cell.priceLevelLabel.isHidden = true
//        return cell
//      }
      if location.priceLevel != nil && location.priceLevel != -1 {
        let attributedText = NSMutableAttributedString(attributedString: cell.priceLevelLabel.attributedText!)
        let range = NSRange(location: location.priceLevel!, length: attributedText.length - location.priceLevel!)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.secondaryLabel, range: range)
        cell.priceLevelLabel.attributedText = attributedText
      } else {
        cell.priceLevelLabel.isHidden = true
      }
      
      return cell
    }
  }
  
  func updateDataSource() {
    var newSnapshot = NSDiffableDataSourceSnapshot<Int, Location>()
    
    newSnapshot.appendSections([0])
    newSnapshot.appendItems(route.locations)
    
    dataSource.apply(newSnapshot, animatingDifferences: true)
  }
}
