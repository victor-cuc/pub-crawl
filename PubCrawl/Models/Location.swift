//
//  Location.swift
//  PubCrawl
//
//  Created by Victor Cuc on 15/04/2021.
//

import Foundation
import GooglePlaces

class Location: Hashable {
  var placeID: String
  var name: String
  var coordinate: CLLocationCoordinate2D
  var priceLevel: Int? // from 0 to 4
  var rating: Float? // from 1.0 to 5.0
  
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
  init(googlePlace: GMSPlace) {
    self.placeID = googlePlace.placeID!
    self.name = googlePlace.name!
    self.coordinate = googlePlace.coordinate
    self.priceLevel = googlePlace.priceLevel.rawValue
    self.rating = googlePlace.rating
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(placeID)
  }
  
  static func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.placeID == rhs.placeID
  }
}
