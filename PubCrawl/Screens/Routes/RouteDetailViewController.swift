//
//  RouteDetailViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 19/04/2021.
//

import UIKit

class RouteDetailViewController: UIViewController {
  static let identifier = String(describing: RouteDetailViewController.self)
  
  private let route: Route
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var roundedCornerContainer: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var starButton: UIButton!
  @IBOutlet weak var starCount: UILabel!
  @IBOutlet weak var locationCount: UILabel!
  
  init?(coder: NSCoder, route: Route) {
    self.route = route
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
