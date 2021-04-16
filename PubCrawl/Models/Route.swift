//
//  RouteModel.swift
//  PubCrawl
//
//  Created by Victor Cuc on 04/04/2021.
//

import UIKit
import CoreLocation

class Route: Hashable {
  let id: String
  var name: String
  var stars: Int = 0
//  let id: String // String or other type?
//  var image: UIImage?
//  var name: String
//  var locations: [CLLocation]
//  var stars: Int
//  var timesCompleted: Int
  
  init(id: String, name: String) {
    self.id = id
    self.name = name
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Route, rhs: Route) -> Bool {
    return lhs.id == rhs.id
  }
}
