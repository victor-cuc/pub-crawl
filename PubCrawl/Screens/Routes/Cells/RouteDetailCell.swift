//
//  RouteDetailCell.swift
//  PubCrawl
//
//  Created by Victor Cuc on 20/04/2021.
//

import UIKit

class RouteDetailCell: UITableViewCell {
  static let reuseIdentifier = String(describing: RouteDetailCell.self)
  
//  var actionDelegate: RouteCellActionDelegate?

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationCount: UILabel!
  @IBOutlet weak var starCountLabel: UILabel!
  @IBOutlet weak var starButton: UIButton!
  @IBOutlet weak var roundedCornerContainer: UIView!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
//  @IBAction func toggleStar() {
//    FirebaseManager.toggleRouteStar(route: route)
//  }
}
