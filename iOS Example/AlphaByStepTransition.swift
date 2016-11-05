//
//  AlphaByStepTransition.swift
//  AZTransitions
//
//  Created by Alex Zimin on 06/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import AZTransitions

private let animationDuration: TimeInterval = 1

final class AlphaByStepTransition: CustomModalTransition {
  override init() {
    super.init(duration: animationDuration)
  }
  
  // Ony present
  func performTransition(interactive: Bool) {
    perfromAnimation()
  }
  
  private func perfromAnimation() {
    let halfDuration = duration / 2
    
    transitionContainerView.bringSubview(toFront: toViewController.view)
    
    toViewController.view.alpha = 0.0
    
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIViewKeyframeAnimationOptions.allowUserInteraction, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: halfDuration, animations: {
        self.fromViewController.view.alpha = 0.5
      })
      UIView.addKeyframe(withRelativeStartTime: halfDuration, relativeDuration: halfDuration, animations: {
        self.fromViewController.view.alpha = 1.0
        self.toViewController.view.alpha = 0.8
      })
    }, completion: {
      success in
      self.finishAnimation(completion: nil)
    })
  }
}
