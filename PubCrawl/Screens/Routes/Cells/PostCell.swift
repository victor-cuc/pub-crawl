//
//  PostCell.swift
//  PubCrawl
//
//  Created by Victor Cuc on 18/04/2021.
//

import UIKit

class PostCell: UITableViewCell {
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var postTextLabel: UILabel!
  @IBOutlet weak var postImageView1: UIImageView!
  @IBOutlet weak var postImageView2: UIImageView!
  
  @IBOutlet weak var routeImageView: UIImageView!
  @IBOutlet weak var routeRoundedCornerContainer: UIView!
  @IBOutlet weak var routeNameLabel: UILabel!
  @IBOutlet weak var routeStarButton: UIButton!
  @IBOutlet weak var routeStarCount: UILabel!
  @IBOutlet weak var routeLocationCount: UILabel!
}
