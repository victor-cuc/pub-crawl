//
//  RouteModel.swift
//  PubCrawl
//
//  Created by Victor Cuc on 04/04/2021.
//

import UIKit
import Firebase
import GooglePlaces

class Route: Hashable {
  let id: String
  var name: String
  var starredBy: [String]
  var completedBy: [String]
  var locations: [Location]!
  var locationIDs: [String] = []
  var imageRef: StorageReference!
  var createdAt: Date
//  let id: String // String or other type?
//  var image: UIImage?
//  var name: String
//  var stars: Int
//  var timesCompleted: Int
    
  init(id: String, data: [String: Any]) {
    self.id = id
    name = data["name"] as? String ?? "No name"
    
    let starredByData = data["starredBy"] as? [String: Any] ?? [:]
    starredBy = Array(starredByData.keys)
    
    let completedByData = data["completedBy"] as? [String: Any] ?? [:]
    completedBy = Array(completedByData.keys)
    
    let locations = data["locations"] as? [String: Any] ?? [:]
    for location in locations {
      self.locationIDs.append(location.key)
    }
    
    guard let interval = data["createdAt"] as? Double else { fatalError("error casting date") }
    self.createdAt = Date(timeIntervalSince1970: interval)
  }
  
  func isStarredByCurrentUser() -> Bool {
    guard let currentUserID = Auth.auth().currentUser?.uid else { return false }
    return starredBy.contains(currentUserID)
  }
  
  func fetchLocations(completion: @escaping () -> Void) {
    FirebaseManager.getLocations(forRoute: self) { (locations) in
      self.locations = locations
      completion()
    }
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Route, rhs: Route) -> Bool {
    return lhs.id == rhs.id
  }
}
