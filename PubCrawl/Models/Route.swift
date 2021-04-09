//
//  RouteModel.swift
//  PubCrawl
//
//  Created by Victor Cuc on 04/04/2021.
//

import Foundation
import CoreLocation

class Route {
  
  let name: String
  let locations: Set<CLLocation> = []
  
  init(name: String) {
    self.name = name
  }
}

extension Route: Hashable, Identifiable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Route: Equatable {
  static func == (lhs: Route, rhs: Route) -> Bool {
    lhs === rhs
  }
}
