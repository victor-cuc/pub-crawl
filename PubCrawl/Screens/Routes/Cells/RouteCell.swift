//
//  RouteCell.swift
//  PubCrawl
//
//  Created by Victor Cuc on 12/04/2021.
//

import UIKit

protocol RouteCellActionDelegate {
  func toggleStarAction(cell: RouteCell)
}

class RouteCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: RouteCell.self)
  
  var actionDelegate: RouteCellActionDelegate?
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var roundedCornerContainer: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var starButton: UIButton!
  @IBOutlet weak var starCount: UILabel!
  @IBOutlet weak var locationCount: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    roundedCornerContainer.addDefaultRoundedCorners(clipsToBounds: true)
    self.addDefaultShadow()
    self.clipsToBounds = false
  }
  
  @IBAction func toggleStar() {
    actionDelegate?.toggleStarAction(cell: self)
  }
}
