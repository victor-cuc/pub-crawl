//
//  FirebaseManager.swift
//  PubCrawl
//
//  Created by Victor Cuc on 16/04/2021.
//

import UIKit
import Firebase

class FirebaseManager {
  private static var ref: DatabaseReference! = Database.database().reference()
  private static var storeRef: StorageReference! = Storage.storage().reference()
  
  static func fetchAllRoutes(completion: @escaping ([Route]) -> Void) {
    var routes = [Route]()
    ref.child("routes").observe(.value, with: { (snapshot) in
      routes.removeAll()
      guard let routeDict = snapshot.value as? [String: Any] else { fatalError("Error getting/casting route dict") }
      
      for route in routeDict {
        let routeValues = route.value as? [String: Any] ?? [:]
        let route = Route(id: route.key, data: routeValues)
        let imageRef = storeRef.child("routeImages/\(route.id)/thumbnail.jpg")
        route.imageRef = imageRef
        
        routes.append(route)
      }
      routes.sort { $0.name < $1.name }
      completion(routes)
    })
  }
  
  static func getRoute(byID id: String, completion: @escaping (Route) -> Void) {
    ref.child("routes/\(id)").getData { (error, snapshot) in
      if let error = error {
        print("Error getting data \(error)")
      } else if snapshot.exists() {
        let routeData = snapshot.value as? [String: Any] ?? [:]
        let route = Route(id: id, data: routeData)
        let imageRef = storeRef.child("routeImages/\(route.id)/thumbnail.jpg")
        route.imageRef = imageRef
        
        completion(route)
      } else {
        print("No data available")
      }
    }
  }
  
  static func fetchAllPosts(completion: @escaping ([Post]) -> Void) {
    var posts = [Post]()
    ref.child("posts").observe(.value, with: { (snapshot) in
      posts.removeAll()
      guard let postDict = snapshot.value as? [String: Any] else { fatalError("Error getting/casting post dict") }
      
      for post in postDict {
        let postValues = post.value as? [String: Any] ?? [:]
        let post = Post(id: post.key, data: postValues)
        let imageRef1 = storeRef.child("postImages/\(post.id)/1.jpg")
        let imageRef2 = storeRef.child("postImages/\(post.id)/2.jpg")
        
        post.imageRefs.append(contentsOf: [imageRef1, imageRef2])
        
        posts.append(post)
      }
      completion(posts)
    })
  }
  
  static func getUser(byID id: String, completion: @escaping (User) -> Void) {
    ref.child("users/\(id)").getData { (error, snapshot) in
      if let error = error {
        print("Error getting data \(error)")
      } else if snapshot.exists() {
        let userData = snapshot.value as? [String: Any] ?? [:]
        let user = User(id: id, data: userData)
        let imageRef = storeRef.child("profilePictures/\(user.id)/profile.jpg")
        user.profilePictureRef = imageRef
        
        completion(user)
      } else {
        print("No data available")
      }
    }
  }
  
  static func toggleRouteStar(route: Route) {
    guard let currentUserID = Auth.auth().currentUser?.uid else { return }

    let newValue = route.isStarredByCurrentUser() ? nil : true
//    print("toggleRouteStar - \(currentUserID) - \(route.isStarredByCurrentUser()) - \(newValue)")
    let starUpdates = [
      "/routes/\(route.id)/starredBy/\(currentUserID)": newValue,
      "/users/\(currentUserID)/starred/\(route.id)": newValue
    ]
    ref.updateChildValues(starUpdates as [AnyHashable : Any])
  }
}
