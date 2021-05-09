//
//  Location.swift
//  PubCrawl
//
//  Created by Victor Cuc on 15/04/2021.
//

import Foundation
import GooglePlaces

class Location: Hashable, Codable {
  var id: String = UUID().uuidString
  var placeID: String
  var name: String
  var address: String?
  var latitude: Double
  var longitude: Double
  var priceLevel: Int? // from 0 to 4
  var rating: Float? // from 1.0 to 5.0
  
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  /**
   Initializez Location object - requires a **GMSPlace** with _placeID_ and _name_, optionally _priceLevel_ and _rating_
   - parameters:
      - googlePlace: GMSPlace
        - **required:**
          - *name*
          - *placeID*
          - *coordinate*
        - optional
          - *priceLevel*
          - *rating*
 */
  init(id: String, googlePlace: GMSPlace) {
    self.id = id
    self.placeID = googlePlace.placeID!
    self.name = googlePlace.name!
    self.address = googlePlace.formattedAddress
    self.latitude = Double(googlePlace.coordinate.latitude)
    self.longitude = Double(googlePlace.coordinate.longitude)
    self.priceLevel = googlePlace.priceLevel.rawValue
    self.rating = googlePlace.rating
  }
  
  init(id: String, data: [String:Any]) {
    self.id = id
    placeID = data["placeID"] as! String
    name = data["name"] as! String
    address = data["address"] as? String
    latitude = data["latitude"] as! Double
    longitude = data["longitude"] as! Double
    priceLevel = data["priceLevel"] as! Int
    
    if let ratingData = data["rating"] as? Float {
      rating = roundf(ratingData * 10) / 10.0
    }
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(placeID)
  }
  
  static func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.placeID == rhs.placeID
  }
}
