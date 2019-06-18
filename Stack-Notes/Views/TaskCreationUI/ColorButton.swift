//
//  ColorButton.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/16/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    var circleLayer = CAShapeLayer()
    var borderLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSelected = false
        addTarget(self, action: #selector(colorSelected), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        layer.addSublayer(circleLayer)
        layer.addSublayer(borderLayer)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        circleLayer.position = CGPoint(x: 0, y: 0)
        //Draw the circle border
        borderLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineWidth = 0
        borderLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(borderLayer)
    }
    // MARK: Objc function
    @objc func colorSelected() {
        print("tapped")
        weirdBehavior(bool: isSelected)
//        if isSelected {
//            borderLayer.lineWidth = 5
//        } else {
//            borderLayer.lineWidth = 0
//        }
    }
    
    func weirdBehavior(bool: Bool) {
        if !bool{
            let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
            lineWidthAnimation.fromValue = 0
            lineWidthAnimation.toValue = 5
            lineWidthAnimation.duration = 0.25
            lineWidthAnimation.fillMode = .both
            lineWidthAnimation.delegate = self
            borderLayer.lineWidth = 5
            borderLayer.add(lineWidthAnimation, forKey: nil)
            isSelected = true
        } else {
            let shrinkBorder = CABasicAnimation(keyPath: "lineWidth")
            shrinkBorder.toValue = 0
            shrinkBorder.duration = 0.5
            shrinkBorder.delegate = self
            shrinkBorder.fillMode = .both
            borderLayer.lineWidth = 0
            borderLayer.add(shrinkBorder, forKey: nil)
            isSelected = false
            
        }
    }
}

extension ColorButton: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isSelected {
            borderLayer.lineWidth = 5
        } else {
            borderLayer.lineWidth = 0
        }
    }
}
