//
//  CreatePostViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 14/05/2021.
//

import UIKit

class CreatePostViewController: UIViewController {
  enum EditedImage {
    case first
    case second
  }
  
  @IBOutlet weak var image1Container: UIView!
  @IBOutlet weak var imageView1: UIImageView!
  @IBOutlet weak var image2Container: UIView!
  @IBOutlet weak var imageView2: UIImageView!
  @IBOutlet weak var postText: UITextView!
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var route: Route!
  var image1: UIImage?
  var image2: UIImage?
  var currentlyEditedImage: EditedImage?
  
  class func instantiateFromStoryboard() -> CreatePostViewController {
    let storyboard = UIStoryboard(name: "Maps", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "CreatePostViewController") as! CreatePostViewController
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    activityIndicator.isHidden = true
    setPlaceholderText()
    
    postButton.addDefaultShadow()
    postButton.addDefaultRoundedCorners()
    
    image1Container.addDefaultRoundedCorners(clipsToBounds: true)
    image2Container.addDefaultRoundedCorners(clipsToBounds: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  @IBAction func image1ButtonAction() {
    currentlyEditedImage = .first
    pickPhoto()
  }
  
  @IBAction func image2ButtonAction() {
    currentlyEditedImage = .second
    pickPhoto()
  }
  
  @IBAction func createPost() {
    view.isUserInteractionEnabled = false
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    
    let images = [image1, image2].compactMap({ $0 })
    
    FirebaseManager.createNewPost(forRouteID: route.id, withText: postText.text, images: images) { (post, error) in
      self.view.isUserInteractionEnabled = true
      self.activityIndicator.isHidden = true
      self.activityIndicator.stopAnimating()
      if let error = error {
        print(error.localizedDescription)
        return
      } else {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
      }
    }
  }
  
  @IBAction func skip() {
    navigationController?.popToRootViewController(animated: true)
  }
  
  func setPlaceholderText() {
    postText.text = "I just finished a pub crawl on a route called \(route.name)! Give it a try!"
  }
 
  func pickPhoto() {
    let alert = UIAlertController(title: nil, message: nil,
                                  preferredStyle: .actionSheet)
    
    let actionCancel = UIAlertAction(title: "Cancel", style: .cancel,
                                     handler: nil)
    alert.addAction(actionCancel)
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let actionPhoto = UIAlertAction(title: "Take Photo",
                                      style: .default, handler: { _ in
                                        self.showImagePicker(source: .camera)
                                      })
      alert.addAction(actionPhoto)
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let actionLibrary = UIAlertAction(title: "Choose From Library",
                                        style: .default, handler: { _ in
                                          self.showImagePicker(source: .photoLibrary)
                                        })
      alert.addAction(actionLibrary)
    }
    
    present(alert, animated: true, completion: nil)
  }
}

// MARK:- Image Picker Delegates

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func showImagePicker(source: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = source
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
       didFinishPickingMediaWithInfo info:
                     [UIImagePickerController.InfoKey : Any]) {

    let image = info[UIImagePickerController.InfoKey.editedImage]
                                                  as? UIImage
    if let image = image {
      switch currentlyEditedImage {
      case .first:
        imageView1.image = image
        image1 = image
      case .second:
        imageView2.image = image
        image2 = image
      default:
        break
      }
    }

    dismiss(animated: true, completion: nil)
  }


  func imagePickerControllerDidCancel(_ picker:
                        UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

