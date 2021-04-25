//
//  RouteDetailTableViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 20/04/2021.
//

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
}
