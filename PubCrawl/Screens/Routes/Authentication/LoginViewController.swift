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
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var inputFieldStackView: UIStackView!
    
  class func instantiateFromStoryboard() -> LoginViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    
    return viewController
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLoginButton()
    toggleErrorLabel(error: nil, animated: true)
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
  
  func configureLoginButton() {
    loginButton.addDefaultShadow()
    loginButton.addFullRoundedCorners()
  }
  
  func toggleErrorLabel(error: Error?, animated: Bool) {
    errorLabel.text = error?.localizedDescription
    let hideErrorLabel = error == nil
    guard hideErrorLabel != errorLabel.isHidden else {
      return
    }
    
    UIView.animate(withDuration: 0.3) {
      self.errorLabel.isHidden = hideErrorLabel
      self.inputFieldStackView.layoutIfNeeded()
    }
  }
  
  // MARK: - Actions
  
  @IBAction func loginAction() {
    let email = emailField.textField.text!
    let password = passwordField.textField.text!
    
    activityIndicator.startAnimating()
    loginButton.imageView?.tintColor = .clear
    view.isUserInteractionEnabled = false
    self.toggleErrorLabel(error: nil, animated: true)
    
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
      guard let self = self else { return }
      
      self.activityIndicator.stopAnimating()
      self.loginButton.imageView?.tintColor = .white
      self.view.isUserInteractionEnabled = true
      
      if let error = error {
        print("Error logging in: \(error)")
        self.toggleErrorLabel(error: error, animated: true)
        return
      }
      
      let routesViewController = RoutesViewController.instantiateFromStoryboard()
      self.navigationController?.pushViewController(routesViewController, animated: true)
    }
  }
  
  @IBAction func createAction() {
    let registerViewController = RegisterViewController.instantiateFromStoryboard()
    self.navigationController?.pushViewController(registerViewController, animated: true)
  }
}
