//
//  ViewController.swift
//  DummyProject
//
//  Created by Cata on 4/3/21.
//

import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailField: RoundedTextFieldContainer!
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
//    do {
//      try Auth.auth().signOut()
//    } catch let signOutError as NSError {
//      print("Error signing out: \(signOutError)")
//    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      if user != nil {
        print("Already signed in with \(user?.email)")
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
    let email = emailField.textField.text!
    let password = passwordField.textField.text!
    
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
      if let error = error {
        print("Error logging in: \(error)")
        return
      }
      guard let strongSelf = self else { return }
      let routesViewController = RoutesViewController.instantiateFromStoryboard()
      strongSelf.navigationController?.pushViewController(routesViewController, animated: true)
    }
  }
  
  @IBAction func createAction() {
    let registerViewController = RegisterViewController.instantiateFromStoryboard()
    self.navigationController?.pushViewController(registerViewController, animated: true)
  }
}

