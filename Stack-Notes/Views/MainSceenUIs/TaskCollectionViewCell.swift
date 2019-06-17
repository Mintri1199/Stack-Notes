//
//  TaskCollectionViewCell.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/16/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class TodoCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        backgroundColor = .red
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Walk the Dog"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    let checkBox: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return button
    }()
    // MARK: - Setup UIs
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(checkBox)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            checkBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBox.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            checkBox.heightAnchor.constraint(equalTo: checkBox.widthAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -10)
            ])
    }
}
