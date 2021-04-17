//
//  UIView+RoundedCorners.swift
//  DummyProject
//
//  Created by Victor Cuc on 04/04/2021.
//

import UIKit

protocol RoundCorners: UIView {
  func addFullRoundedCorners()
  func addDefaultRoundedCorners()
  func addRoundedCorners(radius: CGFloat)
}

extension RoundCorners {
  func addFullRoundedCorners() {
    addRoundedCorners(radius: frame.height / 2)
  }
  
  func addDefaultRoundedCorners() {
    addRoundedCorners(radius: Constants.Appearance.defaultCornerRadius)
  }
  
  func addRoundedCorners(radius: CGFloat) {
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = false
  }
}

extension UIView: RoundCorners {
}
