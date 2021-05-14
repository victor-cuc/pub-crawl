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
  
  var route: Route!
  
  class func instantiateFromStoryboard() -> CreatePostViewController {
    let storyboard = UIStoryboard(name: "Maps", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "CreatePostViewController") as! CreatePostViewController
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    
  }
  
  @IBAction func skip() {
    
  }
  
  func setPlaceholderText() {
    postText.text = "I just finished a pub crawl on a route called \(route.name)! Give it a try!"
  }
}
