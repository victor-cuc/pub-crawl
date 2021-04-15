//
//  RouteDataSource.swift
//  PubCrawl
//
//  Created by Victor Cuc on 13/04/2021.
//

import Foundation

class DataSource {
  
  static var dummyData: [Route] {
    var routes: [Route] = []
    for i in 1...20 {
      routes.append(Route(name: "RouSDFGHJKXFVGHJKJ HVJND Jte\(i)"))
    }
    return routes
  }
}
