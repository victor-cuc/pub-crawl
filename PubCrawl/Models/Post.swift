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
    
    guard let routeId = data["route"] as? String else { return }
    self.routeId = routeId

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
