//
//  RouteModel.swift
//  PubCrawl
//
//  Created by Victor Cuc on 04/04/2021.
//

import UIKit
import FirebaseStorage
import CoreLocation

class Route: Hashable {
  let id: String
  var name: String
  var starCount: Int
  var completedCount: Int
  var locationIDs: [String] = []
  var imageRef: StorageReference!
//  let id: String // String or other type?
//  var image: UIImage?
//  var name: String
//  var stars: Int
//  var timesCompleted: Int
  
  init(id: String, data: [String: Any]) {
    self.id = id
    name = data["name"] as? String ?? "No name"
    
    let starredBy = data["starredBy"] as? [String: Any] ?? [:]
    starCount = starredBy.count
    
    let completedBy = data["completedBy"] as? [String: Any] ?? [:]
    completedCount = completedBy.count
    
    let locations = data["locations"] as? [String: Any] ?? [:]
    for location in locations {
      self.locationIDs.append(location.key)
    }
    
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Route, rhs: Route) -> Bool {
    return lhs.id == rhs.id
  }
}
