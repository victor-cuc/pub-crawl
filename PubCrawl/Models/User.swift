//
//  UserModel.swift
//  PubCrawl
//
//  Created by Victor Cuc on 04/04/2021.
//

import Foundation

class User {
  
  // let id: UUID
  let firstName: String
  let lastName: String
  let email: String
  var savedRoutes: Set<Route> = []
  var completedRoutes: Set<Route> = []
  
  init(
    firstName: String,
    lastName: String,
    email: String
  ) {
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
  }
}
