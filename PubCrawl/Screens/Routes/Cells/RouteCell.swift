//
//  RouteCell.swift
//  PubCrawl
//
//  Created by Victor Cuc on 12/04/2021.
//

import UIKit

class RouteCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: RouteCell.self)
  
  @IBOutlet weak var roundedCornerContainer: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var starButton: UIButton!
  @IBOutlet weak var starCount: UILabel!
  @IBOutlet weak var locationCount: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    roundedCornerContainer.addDefaultRoundedCorners()
    self.addDefaultShadow()
    roundedCornerContainer.clipsToBounds = true
  }
  
  @IBAction func star() {
    print("Star button pressed")
  }
}
