//
//  UserModel.swift
//  PubCrawl
//
//  Created by Victor Cuc on 04/04/2021.
//
//
import UIKit
import FirebaseStorage

class User {

  let id: String // UUID or String?
  let username: String
  var profilePictureRef: StorageReference?
  var level: Int
  var numberOfCompletedRoutes: Int
  var numberOfVisitedLocations: Int
  
  init(id: String, data: [String: Any]) {
    self.id = id
    username = data["username"] as! String
    let stats = data["stats"] as? [String: Any] ?? [:]
//    print(stats)
    level = stats["level"] as? Int ?? 0
    numberOfCompletedRoutes = stats["completedCount"] as? Int ?? 0
    numberOfVisitedLocations = stats["locationCount"] as? Int ?? 0
  }
}
