//
//  FirebaseManager.swift
//  PubCrawl
//
//  Created by Victor Cuc on 16/04/2021.
//

import Foundation
import Firebase

class FirebaseManager {
  private static var ref: DatabaseReference! = Database.database().reference()
  
  static func fetchAllRoutes(completion: @escaping ([Route]) -> Void) {
    var routes = [Route]()
    ref.child("routes").observe(.value, with: { (snapshot) in
      routes.removeAll()
      guard let routeDict = snapshot.value as? [String: Any] else { fatalError("Error getting/casting route dict") }
      for route in routeDict {
        let routeValues = route.value as? [String: Any] ?? [:]
        let route = Route(id: route.key, name: routeValues["name"] as? String ?? "Unnamed Route")
        routes.append(route)
      }
      completion(routes)
    })
  }
}
