//
//  TodoVIew.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/10/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

// This will be the view for add todo VC
class TodoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layer.cornerRadius = 30
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var titleTextField = TitleTextField()
    var descriptionTextView = TodoTaskDescription()
    private func setupViews() {
        addSubview(titleTextField)
        addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            titleTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 30).cgPath
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowOpacity = 0.4
    }
}
