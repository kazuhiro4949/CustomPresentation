//
//  DropDownAnimator.swift
//  CustomPresentation
//
//  Created by kahayash on 2017/01/12.
//  Copyright © 2017年 kahayash. All rights reserved.
//

import UIKit

class DropDownAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Direction {
        case present
        case dismiss
    }
    
    let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .present:
            present(using: transitionContext)
        case .dismiss:
            dismiss(using: transitionContext)
        }
    }
    
    func present(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to), let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = finalFrame
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        toVC.view.frame.size.height = 0
        fromVC.beginAppearanceTransition(false, animated: true)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            toVC.view.frame.size.height = finalFrame.height
        }, completion: { _ in
            fromVC.endAppearanceTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        toVC.beginAppearanceTransition(true, animated: true)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            fromVC.view.frame.size.height = 0
        }, completion: { _ in
            toVC.endAppearanceTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
