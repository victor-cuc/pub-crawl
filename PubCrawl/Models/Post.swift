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
  var createdAt: Date!
  var text: String
  var route: Route!
  var routeID: String!
  var userID: String!
  var imageRefs: [StorageReference] = []
  
  let storeRef = Storage.storage().reference()
  
  init(id: String, data: [String: Any]) {
    self.id = id
    text = data["text"] as? String ?? ""
    print(text)
    
    guard let interval = data["createdAt"] as? Double else { return }
    self.createdAt = Date(timeIntervalSince1970: interval)
    
    guard let routeID = data["route"] as? String else { return }
    self.routeID = routeID
    
    guard let userID = data["user"] as? String else { return }
    self.userID = userID

    let imageRefsArray = data["imageRefs"] as? [String] ?? []
    for imageRef in imageRefsArray {
      imageRefs.append(storeRef.child(imageRef))
    }
  }
}

extension Post: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Post, rhs: Post) -> Bool {
    return lhs.id == rhs.id
  }
}
