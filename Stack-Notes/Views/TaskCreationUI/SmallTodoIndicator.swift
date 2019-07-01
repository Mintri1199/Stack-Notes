//
//  SmallTodoIndicator.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 7/1/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class SmallTodoIndicator: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
//    layer.borderWidth = 2
//    layer.borderColor = UIColor.lightGray.cgColor
    layer.cornerRadius = 20
    clipsToBounds = true
    setupLabel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  var nameLabel: UILabel = {
    var label = UILabel(frame: .zero)
    label.text = "Small Task"
    label.textColor = .lightGray
    label.backgroundColor = .white
    label.textAlignment = .center
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "Helvetica", size: 40)
    // The next two lines allow the text to change dynamically with its width
    label.minimumScaleFactor = 0.2
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  func setupLabel() {
    addSubview(nameLabel)
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: topAnchor),
      nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
      ])
  }
}
