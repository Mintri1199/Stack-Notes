//
//  TodoTaskDescription.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/16/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class TodoTaskDescription: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        text = "Description"
        textColor = UIColor.lightGray
        translatesAutoresizingMaskIntoConstraints = false
        autocorrectionType = .yes
        textAlignment = .left
        font = UIFont(name: "Helvetica", size: 20)
        textContainerInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 20, right: 10)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
