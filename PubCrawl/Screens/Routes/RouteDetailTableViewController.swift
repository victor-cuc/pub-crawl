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
    
    self.title = route.name
    nameLabel.text = route.name
  }
}
