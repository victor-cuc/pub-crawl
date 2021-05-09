//
//  FirebaseManager.swift
//  PubCrawl
//
//  Created by Victor Cuc on 16/04/2021.
//

import UIKit
import Firebase
import GooglePlaces

class FirebaseManager {
  private static var ref: DatabaseReference! = Database.database().reference()
  private static var storeRef: StorageReference! = Storage.storage().reference()
  
  // MARK:- Routes
  
  static func createNewDummyRoute(completion: @escaping (Route) -> Void) {
    let name = "Route\(Int.random(in: 1...100))"
    createNewRoute(name: name) { route in
      completion(route)
    }
  }
  
  static func createNewRoute(name: String, thumbnail: UIImage? = nil, completion: @escaping (Route) -> Void) {
    guard let key = ref.child("routes").childByAutoId().key else { return }
    let route = [
      "name": name,
      "createdAt": Date().timeIntervalSince1970
    ] as [String : Any]
    ref.child("routes").child(key).setValue(route)
    
    let imageRef = storeRef.child("routeImages/\(key)/thumbnail.jpg")
    
    if let thumbnail = thumbnail {
      guard let uploadData = thumbnail.jpegData(compressionQuality: 0.5) else { return }
      imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
        if error != nil {
          print(error?.localizedDescription)
        } else {
          completion(Route(id: key, data: route))
          //          storageRef.downloadURL(completion: { (url, error) in
          //
          //            print(url?.absoluteString)
          //            completion(url?.absoluteString)
          //          })
          
          //  completion((metadata?.downloadURL()?.absoluteString)!))
          // your uploaded photo url.
          
          
        }
      }
    }
    
  }
  
  static func getAllRoutes(completion: @escaping ([Route]) -> Void) {
    ref.child("routes").getData(completion: { (error, snapshot) in
      guard let routeDict = snapshot.value as? [String: Any] else { fatalError("Error getting/casting route dict") }
      
      var routes = [Route]()
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
  
  static func getRoutes(withIDs IDs: [String], completion: @escaping ([Route]) -> Void) {
    var routes: [Route] = []
    
    let queue = OperationQueue()
    let completionOperation = BlockOperation {
      completion(routes)
    }
    
    for id in IDs {
      let operation = BlockOperation {
        let lock = NSLock()
        lock.lock()
        getRoute(byID: id) { route in
          routes.append(route)
          lock.unlock()
        }
        lock.lock()
        return
      }
      
      completionOperation.addDependency(operation)
      queue.addOperation(operation)
    }
    
    queue.addOperation(completionOperation)
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
  
  static func toggleStar(forRoute route: Route, completion: (() -> Void)? = nil) {
    guard let currentUserID = Auth.auth().currentUser?.uid else { return }
    
    let newValue = !route.isStarredByCurrentUser()
    let starUpdates = [
      "/routes/\(route.id)/starredBy/\(currentUserID)": newValue ? true : nil,
      "/users/\(currentUserID)/starred/\(route.id)": newValue ? true : nil
    ]
    ref.updateChildValues(starUpdates as [AnyHashable : Any]) { (error, ref) in
      if error != nil {
        return
      }
      if newValue {
        route.starredBy.append(currentUserID)
      } else {
        route.starredBy.removeAll { (id) -> Bool in
          return id == currentUserID
        }
      }
      completion?()
    }
  }
  
  // MARK:- Posts
  
  static func createNewDummyPost(completion: @escaping (Post) -> Void) {
    let text = "post text: \(Int.random(in: 1...100))"
    let routeID = "r1"
    createNewPost(forRouteID: routeID, withText: text) { post in
      completion(post)
    }
  }
  
  static func createNewPost(forRouteID routeID: String, withText text: String, completion: @escaping (Post) -> Void) {
    let currentUserID = Auth.auth().currentUser!.uid
    guard let key = ref.child("posts").childByAutoId().key else { return }
    let post = [
      "route": routeID,
      "user": currentUserID,
      "text": text,
      "createdAt": Date().timeIntervalSince1970
    ] as [String : Any]
    ref.child("posts").child(key).setValue(post)
    completion(Post(id: key, data: post))
  }
  
  static func getAllPosts(completion: @escaping ([Post], Error?) -> Void) {
    ref.child("posts").getData(completion: { (error, snapshot) in
      if let error = error {
        completion([], error)
        return
      }
      
      guard let postDict = snapshot.value as? [String: Any] else { fatalError("Error getting/casting post dict") }
      
      var posts = [Post]()
      for post in postDict {
        let postValues = post.value as? [String: Any] ?? [:]
        let post = Post(id: post.key, data: postValues)
        
        posts.append(post)
      }
      
      let routeIDs = Set(posts.compactMap({$0.routeID}))
      self.getRoutes(withIDs: Array(routeIDs)) { (routes) in
        var routesDict = [String: Route]()
        routes.forEach({routesDict[$0.id] = $0})
        
        posts.forEach({$0.route = routesDict[$0.routeID]})
        
        let userIDs = Set(posts.compactMap({$0.userID}))
        self.getUsers(withIDs: Array(userIDs)) { (users) in
          var usersDict = [String: User]()
          users.forEach({usersDict[$0.id] = $0})
          
          posts.forEach({$0.user = usersDict[$0.userID]})
          posts.sort { $0.createdAt >= $1.createdAt }
          
          completion(posts, nil)
        }
      }
    })
  }
  
  //MARK:- Users
  
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
  
  static func getUsers(withIDs IDs: [String], completion: @escaping ([User]) -> Void) {
    var users: [User] = []
    
    let queue = OperationQueue()
    let completionOperation = BlockOperation {
      completion(users)
    }
    
    for id in IDs {
      let operation = BlockOperation {
        let lock = NSLock()
        lock.lock()
        getUser(byID: id) { user in
          users.append(user)
          lock.unlock()
        }
        lock.lock()
        return
      }
      
      completionOperation.addDependency(operation)
      queue.addOperation(operation)
    }
    
    queue.addOperation(completionOperation)
  }
  
  // MARK:- Locations
  
  static func createLocation(fromGMSPlace gmsPlace: GMSPlace, toRoute route: Route, completion: @escaping (Location) -> Void) {
    guard let key = ref.child("locations").childByAutoId().key else { return }
    
    guard let placeID = gmsPlace.placeID,
          let name = gmsPlace.name else { return }
    
    let latitude = gmsPlace.coordinate.latitude,
        longitude = gmsPlace.coordinate.longitude
    
    let address = gmsPlace.formattedAddress
    let priceLevel = gmsPlace.priceLevel.rawValue
    let rating = roundf(gmsPlace.rating * 10) / 10.0
    
    let locationData = [
      "placeID": placeID,
      "name": name,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "priceLevel": priceLevel,
      "rating": rating
    ] as [String : Any?]
    
    let createdLocation = Location(id: key, data: locationData as [String : Any])
    let newLocationIDsArray = route.locationIDs + [key]
    
    let updates = [
      "locations/\(key)": locationData,
      "routes/\(route.id)/locations/": newLocationIDsArray
    ] as [String : Any?]
    
    ref.updateChildValues(updates as [AnyHashable : Any]) { (error, reference) in
      if error != nil {
        return
      }
      route.locationIDs = newLocationIDsArray
      print(createdLocation)
      
      completion(createdLocation)
    }
  }
  
  static func getLocations(forRoute route: Route, completion: @escaping ([Location]) -> Void) {
    ref.child("routes").child(route.id).child("locations").getData { (error, data) in
      guard let locationIDs = data.value as? [String] else { return }
      print(locationIDs)
      
      var locations: [(index: Int, location: Location)] = []
      
      let queue = OperationQueue()
      let completionOperation = BlockOperation {
        let sortedLocations = locations.sorted { (value1, value2) -> Bool in
          return value1.index < value2.index
        }
        completion(sortedLocations.compactMap({ $0.location }))
      }
      
      for (index, id) in locationIDs.enumerated() {
        let operation = BlockOperation {
          let lock = NSLock()
          lock.lock()
          getLocation(byID: id) { location in
            locations.append( (index, location) )
            lock.unlock()
          }
          lock.lock()
          return
        }
        
        completionOperation.addDependency(operation)
        queue.addOperation(operation)
      }
      
      queue.addOperation(completionOperation)
    }
  }
  
  static func getLocation(byID id: String, completion: @escaping (Location) -> Void) {
    ref.child("locations/\(id)").getData { (error, snapshot) in
      if let error = error {
        print("Error getting data \(error)")
      } else if snapshot.exists() {
        let locationData = snapshot.value as? [String: Any] ?? [:]
        let location = Location(id: id, data: locationData)
        
        completion(location)
      } else {
        print("No data available")
      }
    }
  }
}
