//
//  File.swift
//  PubCrawl
//
//  Created by Victor Cuc on 29/04/2021.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation
import GoogleMaps

class GoogleDirectionsManager {
  
  static let shared = GoogleDirectionsManager()
  
  private func makeDirectionsURL(myCoordinate: CLLocationCoordinate2D?, placeIDs: [String]) -> URL? {
    guard placeIDs.count >= 2 || ( placeIDs.count >= 1 && myCoordinate != nil ) else {
      return nil
    }
    
    var waypoints = placeIDs
    waypoints.removeLast()
    
    let origin = placeIDs.first!
    let destination = placeIDs.last!
    
    var originString = "place_id:\(origin)"
    
    if let coordinate = myCoordinate {
      originString = "\(coordinate.latitude),\(coordinate.longitude)"
    } else {
      waypoints.removeFirst()
    }
    
    let destinationString = "place_id:\(destination)"
    
    let waypointsString = getWaypointsString(placeIDs: waypoints)
    
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originString)&destination=\(destinationString)&mode=walking&waypoints=\(waypointsString)&key=\(Constants.SDK.googleAPIKey)"
    
    guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
          let url = URL(string: encoded) else { return nil }
    
    return url
  }
  
  func getDirections(myCoordinate: CLLocationCoordinate2D?, waypoints: [String], completion: @escaping (GMSPolyline?, Error?) -> Void) {
    if let url = self.makeDirectionsURL(myCoordinate: myCoordinate, placeIDs: waypoints) {
      AF.request(url).responseJSON { (response) in
        guard response.error == nil else {
          completion(nil, response.error)
          return
        }
        
        guard let data = response.data else {
          completion(nil, nil)
          return
        }
        
        do {
          let jsonData = try JSON(data: data)
          let routes = jsonData["routes"].arrayValue
          
          for route in routes {
            let overview_polyline = route["overview_polyline"].dictionary
            let points = overview_polyline?["points"]?.string
            let path = GMSPath.init(fromEncodedPath: points ?? "")
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeColor = .systemBlue
            polyline.strokeWidth = 5
            completion(polyline, nil)
          }
        }
        catch let error {
          completion(nil, error)
        }
      }
    }
  }
  
  private func getWaypointsString(placeIDs: [String]) -> String {
    var placeIDsString: String = "" // add 'optimize:true|' for waypoint optimisation
    for item in placeIDs {
      if !placeIDsString.isEmpty {
        placeIDsString.append("|")
      }
      
      placeIDsString.append("place_id:\(item)")
    }
    
    return placeIDsString
  }
  
  func getTimeEstimate(placeIDs: [String], completion: @escaping (Int?, Error?) -> Void) {
    if let url = makeDirectionsURL(myCoordinate: nil, placeIDs: placeIDs) {
      AF.request(url).responseJSON { (response) in
        guard let data = response.data else {
          completion(nil, response.error)
          return
        }
        
        do {
          var timeEstimate = 0
          let jsonData = try JSON(data: data)
          let routes = jsonData["routes"].arrayValue
          for route in routes {
            let legs = route["legs"].arrayValue
            for leg in legs {
              guard let legDuration = leg["duration"]["value"].int else { continue }
              timeEstimate += legDuration
            }
          }
          print(timeEstimate)
          completion(timeEstimate, nil)
        }
        catch let error {
          completion(nil, error)
          print(error.localizedDescription)
        }
      }
    }
  }
}


extension Int {
  func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
    return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
  }
}
