//
//  ColorOptionsStackView.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/16/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class ColorOptionsStackView: UIStackView {
    // MARK: variables
    var selectedColorButton = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        spacing = 20
        distribution = .fillEqually
        addArrangedSubview(pinkButton)
        addArrangedSubview(yellowButton)
        addArrangedSubview(greenButton)
        addArrangedSubview(blueButton)
        addArrangedSubview(purpleButton)
        print(arrangedSubviews)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var pinkButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.tag = 0
        button.circleLayer.fillColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    var blueButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.tag = 1
        button.circleLayer.fillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    var yellowButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.tag = 2
        button.circleLayer.fillColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    var greenButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.tag = 3
        button.circleLayer.fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    var purpleButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.tag = 4
        button.circleLayer.fillColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    // MARK: Objc function
    @objc func colorSelected(_ sender: ColorButton) {
        print("tapped")
        if !sender.isSelected {
            // Create lineWidth Expand animation
            let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
            lineWidthAnimation.setValue("expand", forKey: "name")
            lineWidthAnimation.fromValue = 0
            lineWidthAnimation.toValue = 5
            lineWidthAnimation.duration = 0.25
            lineWidthAnimation.fillMode = .both
            lineWidthAnimation.delegate = self
            sender.borderLayer.add(lineWidthAnimation, forKey: nil)
            selectedColorButton = sender.tag
            sender.isSelected = true
        }
    }
    
    private func shrinkButton(sender: ColorButton) {
        let shrinkBorder = CABasicAnimation(keyPath: "lineWidth")
        shrinkBorder.setValue("shrink", forKey: "name")
        shrinkBorder.setValue(sender.borderLayer, forKey: "layer")
        shrinkBorder.toValue = 0
        shrinkBorder.duration = 0.5
        shrinkBorder.delegate = self
        shrinkBorder.fillMode = .both
        sender.borderLayer.lineWidth = 0
        sender.borderLayer.add(shrinkBorder, forKey: nil)
        sender.isSelected = false
    }
}

extension ColorOptionsStackView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String, let layer = anim.value(forKey: "layer") as? CAShapeLayer else { return }
        if name == "expand" {
            layer.lineWidth = 5
        } else if name == "shrink" {
            layer.lineWidth = 0
        }
    }
    func animationDidStart(_ anim: CAAnimation) {
        guard let name = anim.value(forKey: "name") as? String else { return }
        
        if name == "expand" {
            arrangedSubviews.forEach { (button) in
                guard let button = button as? ColorButton else { return }
                if button.tag != selectedColorButton {
                    if button.borderLayer.lineWidth == 0 {
                        shrinkButton(sender: button)
                    }
                    
                }
            }
        }
    }
}
