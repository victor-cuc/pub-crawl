//
//  RouteModel.swift
//  PubCrawl
//
//  Created by Victor Cuc on 04/04/2021.
//

import Foundation
import CoreLocation

class Route: Hashable {
  
  let id = UUID().uuidString
  var name: String
  var likes: Int = 0
//  var locations: [Location] = []
  
  init(name: String) {
    self.name = name
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Route, rhs: Route) -> Bool {
    return lhs.id == rhs.id
  }
}
