//
//  Location.swift
//  PubCrawl
//
//  Created by Victor Cuc on 15/04/2021.
//

import Foundation

class Location: Hashable {
  
  let id = UUID().uuidString
  var name: String
  
  init(name: String) {
    self.name = name
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.id == rhs.id
  }
}
