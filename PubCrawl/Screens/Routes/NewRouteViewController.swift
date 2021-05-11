//
//  NewRouteViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 28/04/2021.
//

import UIKit

class NewRouteViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var nextButton: UIBarButtonItem!
  @IBOutlet weak var imageView: UIImageView!
  
  var image: UIImage?
  
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
      FirebaseManager.createNewRoute(name: nameEntered, thumbnail: image) { (route, error) in
        if let route = route {
          let editRouteViewController = EditRouteViewController.instantiateFromStoryboard(route: route)
          var viewControllers = self.navigationController?.viewControllers
          viewControllers?.removeLast()
          viewControllers?.append(editRouteViewController)
          self.navigationController?.setViewControllers(viewControllers!, animated: true)
        } else {
          print(error?.localizedDescription)
        }
      }
    }
  }
}

extension NewRouteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func takePhotoWithCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  // MARK:- Image Picker Delegates
  func imagePickerController(_ picker: UIImagePickerController,
       didFinishPickingMediaWithInfo info:
                     [UIImagePickerController.InfoKey : Any]) {

    image = info[UIImagePickerController.InfoKey.editedImage]
                                                  as? UIImage
    if let image = image {
      imageView.image = image
    }

    dismiss(animated: true, completion: nil)
  }


  func imagePickerControllerDidCancel(_ picker:
                        UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func pickPhoto() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      showPhotoMenu()
    } else {
      choosePhotoFromLibrary()
    }
  }

  func showPhotoMenu() {
    let alert = UIAlertController(title: nil, message: nil,
                         preferredStyle: .actionSheet)

    let actionCancel = UIAlertAction(title: "Cancel", style: .cancel,
                                handler: nil)
    alert.addAction(actionCancel)

    let actionPhoto = UIAlertAction(title: "Take Photo",
                                    style: .default, handler: { _ in
                                      self.takePhotoWithCamera()
                                    })
    alert.addAction(actionPhoto)

    let actionLibrary = UIAlertAction(title: "Choose From Library",
                                      style: .default, handler: { _ in
                                        self.choosePhotoFromLibrary()
                                      })
    alert.addAction(actionLibrary)

    present(alert, animated: true, completion: nil)
  }
}
