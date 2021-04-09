//
//  ViewController.swift
//  DummyProject
//
//  Created by Cata on 4/3/21.
//

import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var usernameField: RoundedTextFieldContainer!
  @IBOutlet weak var passwordField: RoundedTextFieldContainer!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var createButton: UIButton!
  
  var handle: AuthStateDidChangeListenerHandle?
  
  class func instantiateFromStoryboard() -> LoginViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    
    return viewController
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLoginButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      if user != nil {
        print("Already signed in")
      }
    }
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
  
  deinit {
    if let handle = handle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
  }

  
  // MARK: - UI Configuration
  
  func configureLoginButton() {
    loginButton.addDefaultShadow()
    loginButton.addFullRoundedCorners()
  }
  
  // MARK: - Actions
  
  @IBAction func loginAction() {
    print("login has been tapped")
  }
  
  @IBAction func createAction() {
    let registerViewController = RegisterViewController.instantiateFromStoryboard()
    self.navigationController?.pushViewController(registerViewController, animated: true)
  }
}

