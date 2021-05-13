//
//  PubCrawlTests.swift
//  PubCrawlTests
//
//  Created by Victor Cuc on 12/05/2021.
//

import XCTest
@testable import PubCrawl
import GooglePlaces

class PubCrawlTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testLocationInitWithGMSPlace() throws {
    
  }
  
  func testGoogleDirectionsURL() throws {
    
    // GIVEN
    let routeData: [String : Any] = [
      "createdAt": 1619619697.799052,
      "name": "hello"
    ]
    
    let location1Data: [String : Any] = [
      "placeID": "ChIJnbFn3z5-j4ARoqlFeSBuvFA",
      "name": "Loló",
      "address": "974 Valencia St, San Francisco, CA 94110, USA",
      "priceLevel": 2,
      "rating": 4.599999904632568,
      "latitude": 35.7573817,
      "longitude": -122.4213624
    ]
    
    let location2Data: [String : Any] = [
      "placeID": "ChIJ7UI8srLTlzMRFYviVAYtbxg",
      "name": "lolololo",
      "address": "4103 Buhay na Tubig St, Imus, Cavite, Philippines",
      "priceLevel": -1,
      "rating": 4.599999904632568,
      "latitude": 14.4087345,
      "longitude": 120.9543819
    ]
    
    let location3Data: [String : Any] = [
      "placeID": "ChIJV1FWhrQX2jERW2niVztAIj8",
      "name": "Lola's Cafe",
      "address": "5 Simon Rd, Singapore 545893",
      "priceLevel": -1,
      "rating": 4.300000190734863,
      "latitude": 1.3616352,
      "longitude": 103.8859561
    ]
    
    let location1 = Location(id: "-MZNqqe5L1Fu2kX0iDoN", data: location1Data)
    let location2 = Location(id: "-MZNquBdCL3DU479TBNk", data: location2Data)
    let location3 = Location(id: "-MZNqvsw_aLGe_wPvhmF", data: location3Data)
    let route = Route(id: "-MZNqpHX9rxuzDk9PJxO", data: routeData)
    route.locations = [location1, location2, location3]
    
    let expectedURLString = "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:ChIJnbFn3z5-j4ARoqlFeSBuvFA&destination=place_id:ChIJV1FWhrQX2jERW2niVztAIj8&mode=walking&waypoints=place_id:ChIJ7UI8srLTlzMRFYviVAYtbxg|&key=\(Constants.SDK.googleAPIKey)"
    guard let encoded = expectedURLString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
          let expectedURL = URL(string: encoded) else { return }
    
    // WHEN
    let url = GoogleDirectionsManager.makeDirectionsURL(forRoute: route)
    
    // THEN
    XCTAssertEqual(url, expectedURL)
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
