//
//  NewRouteViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 28/04/2021.
//

import UIKit

class NewRouteViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var nameTextField: UITextField!
//  @IBAction weak var roundedButtonContainer: UIView!
  @IBOutlet weak var nextButton: UIBarButtonItem!
  
  class func instantiateFromStoryboard() -> NewRouteViewController {
    let storyboard = UIStoryboard(name: "Routes", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "NewRouteViewController") as! NewRouteViewController
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nextButton.isEnabled = nameTextField.hasText
    nameTextField.delegate = self
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    nextButton.isEnabled = nameTextField.hasText
  }
  
  @IBAction func cancel() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func nextStep() {
    guard let nameEntered = nameTextField.text else { return }
    if !nameEntered.isEmpty {
      print(nameEntered)
      FirebaseManager.createNewRoute(name: nameEntered) { (route) in
        let editRouteViewController = EditRouteViewController.instantiateFromStoryboard(route: route)
        self.navigationController?.pushViewController(editRouteViewController, animated: true)
      }
    }
  }
}
