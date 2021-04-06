//
//  UIView+Shadow.swift
//  DummyProject
//
//  Created by Victor Cuc on 04/04/2021.
//

import UIKit

protocol ShadowView: UIView {
  func addDefaultShadow()
}

extension ShadowView {
  func addDefaultShadow() {
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowRadius = 8
    self.layer.shadowOpacity = 0.15
    self.layer.shadowOffset = CGSize(width: 0, height: 8)
  }
}

extension UIView: ShadowView {
}
