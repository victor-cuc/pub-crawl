//
//  UIView+RoundedCorners.swift
//  DummyProject
//
//  Created by Victor Cuc on 04/04/2021.
//

import UIKit

protocol RoundCorners: UIView {
  func addFullRoundedCorners()
}

extension RoundCorners {
  func addFullRoundedCorners() {
    self.layer.cornerRadius = self.frame.height / 2
    self.layer.masksToBounds = false
  }
}

extension UIView: RoundCorners {
}
