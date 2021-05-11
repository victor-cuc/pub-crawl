//
//  File.swift
//  PubCrawl
//
//  Created by Victor Cuc on 29/04/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

class GoogleDirectionsManager {
  
  static func makeDirectionsURL(forRoute route: Route) -> URL? {
    guard let origin = route.locations.first?.placeID,
          let destination = route.locations.last?.placeID else {
      return nil
    }
    
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:\(origin)&destination=place_id:\(destination)&mode=walking\(getWaypointsString(forRoute: route))&key=\(Constants.SDK.googleAPIKey)"
    
    guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
          let url = URL(string: encoded) else { return nil }
    
    return url
  }
  
  private static func getWaypointsString(forRoute route: Route) -> String {
    var placeIDs: String = ""
    
    let locationCount = route.locations.count
    if locationCount > 2 {
      placeIDs.append("&waypoints=") // add 'optimize:true|' for waypoint optimisation
      for i in 1..<locationCount-1 {
        let placeID = route.locations[i].placeID
        placeIDs.append("place_id:\(placeID)|")
      }
    }
    
    return placeIDs
  }
  
  static func getTimeEstimate(forRoute route: Route, completion: @escaping (Int) -> Void) {
    if let url = makeDirectionsURL(forRoute: route) {
      AF.request(url).responseJSON { (response) in
        guard let data = response.data else {
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
          completion(timeEstimate)
        }
        catch let error {
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
