//
//  AppDelegate.swift
//  PubCrawl
//
//  Created by Victor Cuc on 04/04/2021.
//
import Firebase
import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey(Constants.SDK.googleAPIKey)
    GMSPlacesClient.provideAPIKey(Constants.SDK.googleAPIKey)
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    // Uncomment for automatic Sign Out every time app starts
//    do {
//      try Auth.auth().signOut()
//    } catch let signOutError as NSError {
//      print("Error signing out: \(signOutError)")
//    }
    
    let isUserLoggedIn = Auth.auth().currentUser != nil
    if isUserLoggedIn {
      let routesViewController = RoutesViewController.instantiateFromStoryboard()
      window?.rootViewController = routesViewController
    } else {
      let loginNavigationController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
      window?.rootViewController = loginNavigationController
    }
    
    window?.makeKeyAndVisible()
    
    IQKeyboardManager.shared.enable = true
    
    return true
  }
  
}

