//
//  MapMarkerView.swift
//  PubCrawl
//
//  Created by Victor Cuc on 09/05/2021.
//

import UIKit

class MapMarkerView: UIView {
  let kCONTENT_XIB_NAME = "MapMarkerView"
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var numberLabel: UILabel!
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpView()
  }
  
  func setUpView() {
    Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
    contentView.addFullRoundedCorners()
    contentView.layer.borderWidth = 2
    contentView.layer.borderColor = UIColor.black.cgColor
    
    contentView.fixInView(self)
  }
  
  func invertColors() {
    contentView.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
    numberLabel.textColor = UIColor(named: "AccentColor")
    contentView.backgroundColor = .black
  }
}

extension UIView {
  func fixInView(_ container: UIView!) -> Void{
    self.translatesAutoresizingMaskIntoConstraints = false;
    self.frame = container.frame;
    container.addSubview(self);
    NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
  }
}
