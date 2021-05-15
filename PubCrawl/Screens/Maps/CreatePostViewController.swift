//
//  CreatePostViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 14/05/2021.
//

import UIKit

class CreatePostViewController: UIViewController {
  
  @IBOutlet weak var image1: UIImageView!
  @IBOutlet weak var image2: UIImageView!
  @IBOutlet weak var image2ViewGroup: UIView!
  @IBOutlet weak var postText: UITextView!
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var route: Route!
  
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
    
    image2ViewGroup.isHidden = true
    
//    image1.addDefaultRoundedCorners()
//    image2.addDefaultRoundedCorners()
  }
  
  @IBAction func changeImage1() {
    
  }
  
  @IBAction func changeImage2() {
    
  }
  
  @IBAction func createPost() {
    view.isUserInteractionEnabled = false
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    
    FirebaseManager.createNewPost(forRouteID: route.id, withText: postText.text) { (post, error) in
      self.view.isUserInteractionEnabled = true
      self.activityIndicator.isHidden = true
      self.activityIndicator.stopAnimating()
      if let error = error {
        print(error.localizedDescription)
        return
      } else {
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  @IBAction func skip() {
    navigationController?.popViewController(animated: true)
  }
  
  func setPlaceholderText() {
    postText.text = "I just finished a pub crawl on a route called \(route.name)! Give it a try!"
  }
}
