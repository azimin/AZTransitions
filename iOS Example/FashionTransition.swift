//
//  FashionTransition.swift
//  iOS Example
//
//  Created by Alex Zimin on 02/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import AZTransitions

private let animationDuration: TimeInterval = 1
private let sizeScaleValue: CGFloat = 0.35

private enum ViewControllerStyle {
  case compact
  case original
}

final class FashionTransition: CustomModalTransition {
  override init() {
    super.init(duration: animationDuration)
  }
  
  func performTransition(interactive: Bool) {
    perfromAnimation(isPresenting: true)
  }
  
  func performDismissingTransition(interactive: Bool) {
    perfromAnimation(isPresenting: false)
  }
  
  private func perfromAnimation(isPresenting: Bool) {
    let halfDuration = duration / 2
    
    let onScreenViewControllerType: TransitionViewControllerType = isPresenting ? .presenting : .presented
    let shouldBeOnScreenViewControllerType: TransitionViewControllerType = isPresenting ? .presented : .presenting
    
    scale(viewControllerType: onScreenViewControllerType, toStyle: .original)
    scale(viewControllerType: shouldBeOnScreenViewControllerType, toStyle: .compact)
    
    let backgroundView = UIView(frame: transitionContainerView.frame)
    backgroundView.backgroundColor = UIColor.black
    transitionContainerView.insertSubview(backgroundView, at: 0)
    
    UIView.animate(withDuration: halfDuration, animations: {
      self.scale(viewControllerType: onScreenViewControllerType, toStyle: .compact)
    }, completion: {
      (completion) in
      UIView.animate(withDuration: halfDuration, animations: {
        self.scale(viewControllerType: shouldBeOnScreenViewControllerType, toStyle: .original)
      }, completion: { (completion) in
        backgroundView.removeFromSuperview()
        self.finishTransition()
      })
    })
  }
  
  private var itemCompactWidth: CGFloat {
    return self.transitionContainerView.frame.width * sizeScaleValue
  }
  
  private var space: CGFloat {
    let coefficent = (1 - sizeScaleValue * 2) / 3
    return self.transitionContainerView.frame.width * coefficent
  }
  
  private func scale(viewControllerType: TransitionViewControllerType, toStyle style: ViewControllerStyle) {
    let viewController = viewControllerFor(type: viewControllerType)
    let anotherViewController = viewControllerFor(type: viewControllerType.revesed)
    
    let offset: CGFloat = viewControllerType == .presented ? ((space * 2) + itemCompactWidth) : space
    
    switch style {
    case .compact:
      scale(viewController: viewController, toValue: sizeScaleValue, withOffset: offset)
    default:
      transitionContainerView.insertSubview(anotherViewController.view, belowSubview: viewController.view)
      scale(viewController: viewController, toValue: 1, withOffset: 0)
    }
  }
  
  private func scale(viewController: UIViewController, toValue value: CGFloat, withOffset offset: CGFloat) {
    viewController.view.transform = CGAffineTransform(scaleX: value, y: value)
    viewController.view.frame.origin.x = offset
  }
  
  private func finishTransition() {
    presentingViewController.view.transform = CGAffineTransform.identity
    presentedViewController.view.transform = CGAffineTransform.identity
    finishAnimation(completion: nil)
  }
}
