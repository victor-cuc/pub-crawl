//
//  RoundedTextField.swift
//  DummyProject
//
//  Created by Victor Cuc on 04/04/2021.
//

import UIKit

class RoundedTextFieldContainer: UIView {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var iconImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if self.iconImageView != nil {
      self.iconImageView.tintColor = .black
    }
    self.textField.attributedPlaceholder = NSAttributedString(string: self.textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    self.backgroundColor = .white
    self.addFullRoundedCorners()
    self.addDefaultShadow()
  }
}
