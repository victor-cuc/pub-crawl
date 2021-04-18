//
//  ImageView+Firebase.swift
//  PubCrawl
//
//  Created by Victor Cuc on 18/04/2021.
//

import UIKit
import FirebaseStorage

extension UIImageView {
  func loadImageFromFirebase(reference: StorageReference?, placeholder: UIImage? = nil, animated: Bool = true) {
    self.image = placeholder
    guard let reference = reference else { return }
    // Max image size = 1MB
    reference.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
      guard let self = self else { return }
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      if let data = data {
        if animated {
          UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.image = UIImage(data: data)
          })
        } else {
          self.image = UIImage(data: data)
        }
      }
    }
  }
}
