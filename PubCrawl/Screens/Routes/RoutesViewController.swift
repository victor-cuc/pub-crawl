//
//  RoutesViewControlle.swift
//  PubCrawl
//
//  Created by Victor Cuc on 09/04/2021.
//

import UIKit
import FirebaseAuth

class RoutesViewController: UITableViewController {
  
  class func instantiateFromStoryboard() -> RoutesViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "RoutesViewController") as! RoutesViewController
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let user = Auth.auth().currentUser {
      print("Viewing routes for user: \(user)")
    }
  }
}
