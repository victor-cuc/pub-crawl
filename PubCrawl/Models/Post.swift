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
  var routeId: String!
  var imageRefs: [StorageReference] = []
  
  let storeRef = Storage.storage().reference()
  
  init(id: String, data: [String: Any]) {
    self.id = id
    text = data["text"] as? String ?? ""
    
    let imageRefsArray = data["imageRefs"] as? NSMutableArray ?? []
    for i in 0..<imageRefsArray.count {
      self.imageRefs.append(storeRef.child("postImages/\(id)/\(i).jpg"))
    }
//
    guard let routeId = data["route"] as? String else { return }
    self.routeId = routeId
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
