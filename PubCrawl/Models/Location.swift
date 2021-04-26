//
//  Location.swift
//  PubCrawl
//
//  Created by Victor Cuc on 15/04/2021.
//

import Foundation

class Location: Hashable {
  var placeID: String
  var name: String
  var priceLevel: Int? // from 0 to 4
  var rating: Float? // from 1.0 to 5.0
  
  init(
    placeID: String,
    name: String,
    priceLevel: Int?,
    rating: Float?
  ) {
    self.placeID = placeID
    self.name = name
    self.priceLevel = priceLevel
    self.rating = rating
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(placeID)
  }
  
  static func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.placeID == rhs.placeID
  }
}
