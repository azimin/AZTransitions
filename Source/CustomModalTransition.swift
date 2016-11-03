//
//  CustomModalTransition.swift
//  TransitionsHelper
//
//  Created by Alex Zimin on 02/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

@objc
public protocol CustomModalTransitionType: NSObjectProtocol {
  @objc optional func performTransition(interactive: Bool)
  @objc optional func performDismissingTransition(interactive: Bool)
}

extension CustomModalTransition: CustomModalTransitionType { }

public enum TransitionViewControllerType {
  case presented
  case presenting
  case none
  
  public var revesed: TransitionViewControllerType {
    switch self {
    case .presented:
      return .presenting
    case .presenting:
      return .presented
    case .none:
      fatalError("Wrong type")
    }
  }
}

open class CustomModalTransition: NSObject {
  
  // MARK: - Init
  
  public init(duration: TimeInterval) {
    self.duration = duration
  }
  
  public override init() {
    self.duration = 0.25
    super.init()
  }
  
  // MARK: - Default parametrs
  
  public private(set) var duration: TimeInterval
  
  // MARK: - Transition Parameters
  
  public fileprivate(set) var transitionContext: UIViewControllerContextTransitioning!
  public fileprivate(set) var transitionContainerView: UIView!
  public fileprivate(set) var presentedViewController: UIViewController!
  public fileprivate(set) var presentingViewController: UIViewController!
  public fileprivate(set) var isDismissing: Bool = false
  public fileprivate(set) var isInteractive: Bool = false
  
  public func viewControllerFor(type: TransitionViewControllerType) -> UIViewController {
    switch type {
    case .presented:
      return presentedViewController
    case .presenting:
      return presentingViewController
    case .none:
      fatalError("Wrong type")
    }
  }
  
  public func viewControllerTypeFrom(viewController: UIViewController) -> TransitionViewControllerType {
    if viewController == presentedViewController {
      return .presented
    }
    if viewController == presentingViewController {
      return .presenting
    }
    return .none
  }
  
  // MARK: - Animating the Transition
  
  public func prepareForTransition(isInteractive: Bool) {
    
  }
  
  public func finishAnimation(completion: ((_ finished: Bool) -> Void)?) {
    let success = !transitionContext.transitionWasCancelled
    
    completion?(success)
    
    transitionContext.completeTransition(success)
    
    self.transitionContext = nil
    self.presentingViewController = nil
    self.presentedViewController = nil
  }
  
  // MARK: - Interactive Transition
  
  public func beginInteractiveDismissalTransition(completion: (() -> Void)?) {
    self.interactionController = UIPercentDrivenInteractiveTransition()
    owningController.dismiss(animated: true, completion: completion)
  }
  
  public func updateInteractiveTransitionToProgress(progress: CGFloat) {
    interactionController.update(progress)
  }
  
  public func cancelInteractiveTransition() {
    interactionController.completionSpeed = 0.999 // http://stackoverflow.com/a/22968139/188461
    interactionController.cancel()
    
    self.interactionController = nil
  }
  
  public func finishInteractiveTransition() {
    interactionController.finish()
    interactionController = nil
  }
  
  // MARK: - Rotation Helpers
  
  public private(set) var initialTransform: CGAffineTransform!
  public private(set) var finalTransform: CGAffineTransform!
  
  public func initialCenterFor(viewControllerType: TransitionViewControllerType) -> CGPoint {
    let frame = transitionContext.initialFrame(for: viewControllerFor(type: viewControllerType))
    return frame.az_center
  }
  
  public func finalCenterFor(viewControllerType: TransitionViewControllerType) -> CGPoint {
    let frame = transitionContext.finalFrame(for: viewControllerFor(type: viewControllerType))
    return frame.az_center
  }
  
  public func initialBoundsFor(viewControllerType: TransitionViewControllerType) -> CGRect {
    let frame = transitionContext.initialFrame(for: viewControllerFor(type: viewControllerType))
    let transform = viewControllerType == .presented ? initialTransform : finalTransform
    let frameAfterRotation = frame.applying(transform!)
    return CGRect(x: 0, y: 0, width: frameAfterRotation.width, height: frameAfterRotation.height)
  }
  
  public func finalBoundsFor(viewControllerType: TransitionViewControllerType) -> CGRect {
    let frame = transitionContext.finalFrame(for: viewControllerFor(type: viewControllerType))
    let transform = (viewControllerType == .presented) ? initialTransform : finalTransform
    let frameAfterRotation = frame.applying(transform!)
    return CGRect(x: 0, y: 0, width: frameAfterRotation.width, height: frameAfterRotation.height)
  }
  
  fileprivate func prepareTransitionParameters() {
    if isDismissing {
      transitionContainerView.insertSubview(presentingViewController.view, at: 0)
      
      self.initialTransform = presentedViewController.view.transform;
      self.finalTransform = presentingViewController.view.transform;
      
      presentingViewController.view.frame = self.transitionContext.finalFrame(for: presentingViewController)
    } else {
      transitionContainerView.addSubview(presentedViewController.view)
      
      self.initialTransform = presentingViewController.view.transform
      self.finalTransform = presentedViewController.view.transform
      
      presentingViewController.view.frame = self.transitionContext.initialFrame(for: presentingViewController)
    }
  }
  
  // MARK: - Private
  
  fileprivate var interactionController: UIPercentDrivenInteractiveTransition!
  fileprivate var owningController: UIViewController!
}

// MARK: - UIViewControllerTransitioningDelegate

extension CustomModalTransition: UIViewControllerTransitioningDelegate {
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    // If subclass don't implementing dismissing protocol
    if !self.responds(to: #selector(CustomModalTransitionType.performTransition(interactive:))) {
      return nil
    }
    
    guard presented == owningController else { return nil }
    
    self.presentedViewController = presented
    self.presentingViewController = presenting
    self.isDismissing = false
    
    return self
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    // If subclass don't implementing dismissing protocol
    if !self.responds(to: #selector(CustomModalTransitionType.performDismissingTransition(interactive:))) {
      return nil
    }
    
    guard dismissed == owningController else { return nil }
    
    self.presentedViewController = dismissed
    self.presentingViewController = dismissed.presentingViewController
    self.isDismissing = true
    
    return self
  }
  
  public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactionController
  }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension CustomModalTransition: UIViewControllerAnimatedTransitioning {
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    self.transitionContainerView = transitionContext.containerView
    self.isInteractive = transitionContext.isInteractive
    
    prepareTransitionParameters()
    
    prepareForTransition(isInteractive: isInteractive)
    
    if isDismissing {
      (self as CustomModalTransitionType).performDismissingTransition?(interactive: isInteractive)
    } else {
      (self as CustomModalTransitionType).performTransition?(interactive: isInteractive)
    }
  }
}

// MARK: - UIViewController Extensions

private var associatedObjectHandle: UInt8 = 0

public extension UIViewController {
  public var az_modalTransition: CustomModalTransition? {
    get {
      return objc_getAssociatedObject(self, &associatedObjectHandle) as? CustomModalTransition
    }
    
    set {
      self.az_modalTransition?.owningController = nil
      
      self.transitioningDelegate = newValue
      
      if let transition = newValue {
        // FIXME: - Play with it
        self.modalPresentationStyle = .fullScreen
        transition.owningController = self
      }
      
      objc_setAssociatedObject(self, &associatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

// MARK: - CGRect Extensions

private extension CGRect {
  var az_center: CGPoint {
    return CGPoint(x: self.midX, y: self.midY)
  }
}
