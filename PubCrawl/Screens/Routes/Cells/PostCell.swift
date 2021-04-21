//
//  PostCell.swift
//  PubCrawl
//
//  Created by Victor Cuc on 18/04/2021.
//

import UIKit

class PostCell: UITableViewCell {
  
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var profilePicture: UIImageView!
  @IBOutlet weak var postTextLabel: UILabel!
  @IBOutlet weak var postImageView1: UIImageView!
  @IBOutlet weak var postImageView2: UIImageView!
  
  @IBOutlet weak var routeImageView: UIImageView!
  @IBOutlet weak var routeRoundedCornerContainer: UIView!
  @IBOutlet weak var routeNameLabel: UILabel!
  @IBOutlet weak var routeStarButton: UIButton!
  @IBOutlet weak var routeStarCount: UILabel!
  @IBOutlet weak var routeLocationCount: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    routeRoundedCornerContainer.addDefaultRoundedCorners(clipsToBounds: true)
    
    containerView.addDefaultRoundedCorners()
    containerView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = CGColor(gray: 0.5, alpha: 0.3)
  }
}
