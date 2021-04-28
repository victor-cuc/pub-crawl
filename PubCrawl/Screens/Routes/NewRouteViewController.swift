//
//  NewRouteViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 28/04/2021.
//

import UIKit

class NewRouteViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
//  @IBAction weak var roundedButtonContainer: UIView!
//  @IBAction weak var nextButton: UIButton!
  
  class func instantiateFromStoryboard() -> NewRouteViewController {
    let storyboard = UIStoryboard(name: "Routes", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "NewRouteViewController") as! NewRouteViewController
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func nextStep() {
    FirebaseManager.createNewRoute(name: nameTextField.text ?? "No name") { (route) in
      let editRouteViewController = EditRouteViewController.instantiateFromStoryboard(route: route)
      self.navigationController?.pushViewController(editRouteViewController, animated: true)
    }
  }
}
