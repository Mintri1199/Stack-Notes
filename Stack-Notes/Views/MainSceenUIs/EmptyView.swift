//
//  EmptyView.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/10/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Config the label
    let titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You don't have any todos."
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        return label
    }()
    let messageLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your todos will be here."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryTextSilver
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        return label
    }()
    
    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
            ])
    }
}
