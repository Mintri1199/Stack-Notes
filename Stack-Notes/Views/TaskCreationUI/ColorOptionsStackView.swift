//
//  ColorOptionsStackView.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/16/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class ColorOptionsStackView: UIStackView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    axis = .horizontal
    spacing = 20
    distribution = .fillEqually
  }
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    addArrangedSubview(pinkButton)
    addArrangedSubview(yellowButton)
    addArrangedSubview(greenButton)
    addArrangedSubview(blueButton)
    addArrangedSubview(purpleButton)
  }
  var pinkButton: ColorButton = {
    var button = ColorButton(frame: .zero)
    button.circleLayer.fillColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    button.borderLayer.lineWidth = 0
    return button
  }()
  var yellowButton: ColorButton = {
    var button = ColorButton(frame: .zero)
    button.borderLayer.lineWidth = 0
    button.circleLayer.fillColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    return button
  }()
  var greenButton: ColorButton = {
    var button = ColorButton(frame: .zero)
    button.borderLayer.lineWidth = 0
    button.circleLayer.fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    return button
  }()
  var blueButton: ColorButton = {
    var button = ColorButton(frame: .zero)
    button.borderLayer.lineWidth = 0
    button.circleLayer.fillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    return button
  }()
  var purpleButton: ColorButton = {
    var button = ColorButton(frame: .zero)
    button.borderLayer.lineWidth = 0
    button.circleLayer.fillColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    return button
  }()
  
  func preselect(color: UIColor) {
    guard let buttons = arrangedSubviews as? [ColorButton] else { print("Color buttons in the stack view are ill assign"); return }
    buttons.forEach { (button) in
      if button.circleLayer.fillColor == color.cgColor {
        button.borderLayer.lineWidth = 4
      } else {
        button.borderLayer.lineWidth = 0
      }
    }
  }
}
