//
//  ViewController.swift
//  DummyProject
//
//  Created by Cata on 4/3/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
  
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var usernameField: RoundedTextFieldContainer!
  @IBOutlet weak var emailField: RoundedTextFieldContainer!
  @IBOutlet weak var passwordField: RoundedTextFieldContainer!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var inputFieldStackView: UIStackView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var ref: DatabaseReference! = Database.database().reference()
  
  class func instantiateFromStoryboard() -> RegisterViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController

    return viewController
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureRegisterButton()
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

  func configureRegisterButton() {
    registerButton.addDefaultShadow()
    registerButton.addFullRoundedCorners()
  }
  
  
  func toggleErrorLabel(error: Error?, animated: Bool) {
    errorLabel.text = error?.localizedDescription
    let hideErrorLabel = error == nil
    guard hideErrorLabel != errorLabel.isHidden else {
      return
    }
    print("Hide error label: \(hideErrorLabel)")
    
    UIView.animate(withDuration: 0.3) {
      self.errorLabel.isHidden = hideErrorLabel
      self.inputFieldStackView.layoutIfNeeded()
    }
  }

  // MARK: - Actions
  
  @IBAction func registerAction() {
    let email = emailField.textField.text!
    let password = passwordField.textField.text!
    
    activityIndicator.startAnimating()
    registerButton.imageView?.tintColor = .clear
    view.isUserInteractionEnabled = false
    self.toggleErrorLabel(error: nil, animated: true)
    
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      
      self.activityIndicator.stopAnimating()
      self.registerButton.imageView?.tintColor = .white
      self.view.isUserInteractionEnabled = true
      
      if let error = error {
        print("Error registering: \(error)")
        self.toggleErrorLabel(error: error, animated: true)
        return
      }
      
      guard let authResult = authResult else { return }
      print("Registration successfull - \(authResult.user)")
      
      self.ref.child("users").child(authResult.user.uid).setValue(["username": self.usernameField?.textField.text ?? nil])
      
      let routesViewController = RoutesViewController.instantiateFromStoryboard()
      self.navigationController?.pushViewController(routesViewController, animated: true)
    }
  }
  
  @IBAction func backAction() {
    self.navigationController?.popViewController(animated: true)
  }
}

