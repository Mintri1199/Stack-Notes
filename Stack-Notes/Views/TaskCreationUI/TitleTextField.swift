//
//  TitleTextField.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/16/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class TitleTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        autocorrectionType = .yes
        font = UIFont(name: "Helvetica", size: 40)
        adjustsFontSizeToFitWidth = true
        textAlignment = .center
        attributedPlaceholder = NSAttributedString(string: "Enter Title",
                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Provide padding to the text
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        super.drawText(in: rect.inset(by: insets))
    }

}
