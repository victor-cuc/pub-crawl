//
//  ViewController.swift
//  DummyProject
//
//  Created by Cata on 4/3/21.
//

import UIKit

class RegisterViewController: UIViewController {
  
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var nameField: RoundedTextFieldContainer!
  @IBOutlet weak var emailField: RoundedTextFieldContainer!
  @IBOutlet weak var passwordField: RoundedTextFieldContainer!
  
  
  class func instantiateFromStoryboard() -> RegisterViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController

    return viewController
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureRegisterButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  // MARK: - UI Configuration

  func configureRegisterButton() {
    registerButton.addDefaultShadow()
    registerButton.addFullRoundedCorners()
  }

  // MARK: - Actions
  
  @IBAction func registerAction() {
    print("register has been tapped")
  }
  
  @IBAction func backAction() {
    self.navigationController?.popViewController(animated: true)
  }
}

