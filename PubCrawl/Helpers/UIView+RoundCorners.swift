//
//  UIView+RoundedCorners.swift
//  DummyProject
//
//  Created by Victor Cuc on 04/04/2021.
//

import UIKit

protocol RoundCorners: UIView {
  func addFullRoundedCorners(clipsToBounds: Bool)
  func addDefaultRoundedCorners(clipsToBounds: Bool)
  func addRoundedCorners(radius: CGFloat, clipsToBounds: Bool)
}

extension RoundCorners {
  func addFullRoundedCorners(clipsToBounds: Bool = false) {
    addRoundedCorners(radius: frame.height / 2, clipsToBounds: clipsToBounds)
  }
  
  func addDefaultRoundedCorners(clipsToBounds: Bool = false) {
    addRoundedCorners(radius: Constants.Appearance.defaultCornerRadius, clipsToBounds: clipsToBounds)
  }
  
  func addRoundedCorners(radius: CGFloat, clipsToBounds: Bool = false) {
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = false
    self.clipsToBounds = clipsToBounds
  }
}

extension UIView: RoundCorners {
}
