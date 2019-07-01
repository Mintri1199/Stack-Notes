//
//  CellAnimator.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/30/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

class ExpandAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  let animationDuration = 0.5
  var operation: UINavigationController.Operation = .push
  weak var storeContext: UIViewControllerAnimatedTransitioning?
  
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if operation == .push {
      let fromVC = transitionContext.viewController(forKey: .from) as! MainCollectionViewController
      let toVC = transitionContext.viewController(forKey: .to) as! TodoDetailViewController
      transitionContext.containerView.addSubview(toVC.view)
      
      
    }
  }
}
