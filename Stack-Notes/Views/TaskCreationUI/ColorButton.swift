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
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        layer.shadowRadius = 2.0
//        layer.shadowOpacity = 0.5
//        layer.masksToBounds = false
//        circleLayer.shadowPath = UIBezierPath(ovalIn: bounds).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        circleLayer.position = CGPoint(x: 0, y: 0)
        
        //Draw the circle border
        borderLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineWidth = 6
        borderLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(borderLayer)
    }
}
