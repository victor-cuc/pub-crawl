//
//  RouteDetailTableViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 20/04/2021.
//

import UIKit

class RouteDetailTableViewController: UITableViewController {
  var route: Route
  
  required init?(coder: NSCoder) { fatalError("This should never be called") }
  
  init?(coder: NSCoder, route: Route) {
    self.route = route
    super.init(coder: coder)
  }
}
