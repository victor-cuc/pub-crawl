//
//  LocationCell.swift
//  PubCrawl
//
//  Created by Victor Cuc on 28/04/2021.
//

import UIKit

class LocationCell: UITableViewCell {
  
  @IBOutlet weak var indexLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var priceLevelLabel: UILabel!
  @IBOutlet weak var ratingNumberLabel: UILabel!
  @IBOutlet weak var ratingStack: UIStackView!
  
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
}
