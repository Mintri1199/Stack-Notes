//
//  MainCustomLayout.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/10/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class MainCustomLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        
        // This is the available width of the screen
        let availableWidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        
        self.itemSize = CGSize(width: availableWidth, height: 80)
        self.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.sectionInsetReference = .fromSafeArea
        
        self.minimumLineSpacing = 20
    }
}
