//
//  ColorOptionsStackView.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/16/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class ColorOptionsStackView: UIStackView {
//    private let colorCases: [ColorIdentity] = [.red, .blue, .green, .black, .white]
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
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var pinkButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.circleLayer.fillColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
//        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    var blueButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.circleLayer.fillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    var yellowButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.circleLayer.fillColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
//        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    var greenButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.circleLayer.fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
    var purpleButton: ColorButton = {
        var button = ColorButton(frame: .zero)
        button.circleLayer.fillColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
//        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        return button
    }()
//    // MARK: Objc function
//    @objc func colorSelected(_ sender: ColorButton) {
//        print("tapped")
//        if !sender.isSelected {
//            let expandBorder = CABasicAnimation(keyPath: "lineWidth")
//            expandBorder.toValue = 5
//            expandBorder.duration = 0.25
//            sender.circleLayer.add(expandBorder, forKey: nil)
//            sender.circleLayer.lineWidth = 5
//            sender.isSelected = true
//        } else {
//            let shrinkBorder = CABasicAnimation(keyPath: "lineWidth")
//            shrinkBorder.toValue = 0
//            shrinkBorder.duration = 0.5
//            sender.circleLayer.add(shrinkBorder, forKey: nil)
//            sender.circleLayer.lineWidth = 0
//            sender.isSelected = false
//
//        }
//    }
}

