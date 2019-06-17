//
//  CollectionViewExtension.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/10/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    // Set up an empty view when there is nothing
//    func setEmptyView(title: String, message: String) {
//        let emptyView = UIView(frame: CGRect(x: self.center.x,
//                                             y: self.center.y,
//                                             width: self.bounds.size.width,
//                                             height: self.bounds.size.height))
//        let titleLabel = UILabel()
//        let messageLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
//        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
//        emptyView.addSubview(titleLabel)
//        emptyView.addSubview(messageLabel)
//        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
//        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
//        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
//        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
//        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
//        titleLabel.text = title
//        messageLabel.text = message
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = .center
//        self.backgroundView = emptyView
//        self.separatorStyle = .none
//
//        let bool = UserDefaults.standard.bool(forKey: "theme")
//        let theme = bool ? ColorTheme.dark : ColorTheme.light
//
//        emptyView.backgroundColor = theme.viewControllerBackgroundColor
//        titleLabel.textColor = theme.secondaryTextColor
//        messageLabel.textColor = theme.secondaryTextColor
//
//    }
    
    func restore() {
        self.backgroundView = nil
    }
}
