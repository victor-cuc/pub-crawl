//
//  Post.swift
//  PubCrawl
//
//  Created by Victor Cuc on 13/04/2021.
//

import UIKit
import Firebase

class Post {
  let id: String
  var user: User!
  var text: String
  var route: Route!
  var imageRefs: [StorageReference] = []
  
  init(id: String, data: [String: Any]) {
    self.id = id
    text = data["text"] as? String ?? ""
    guard let routeID = data["route"] as? String else { return }
    FirebaseManager.getRoute(byID: routeID) { route in
      self.route = route
    }
    guard let userID = data["user"] as? String else { return }
    FirebaseManager.getUser(byID: userID) { user in
      self.user = user
    }
  }
}
