//
//  DropDownPresentationController.swift
//  CustomPresentation
//
//  Created by kahayash on 2017/01/12.
//  Copyright © 2017年 kahayash. All rights reserved.
//

import UIKit

class DropDownPresentationController: UIPresentationController {
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let rec = UITapGestureRecognizer(target: self, action: #selector(DropDownPresentationController.overlayViewDidTap(sender:)))
        view.addGestureRecognizer(rec)
        return view
    }()
    
    private let maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.fillRule = kCAFillRuleEvenOdd
        return layer
    }()
    
    var targetFrame = CGRect.zero
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        maskLayer.frame = overlayView.bounds
        overlayView.frame = containerView?.frame ?? .zero
        containerView?.insertSubview(overlayView, at: 0)

        maskLayer.path = {
            let maskPath = UIBezierPath(rect: overlayView.bounds)
            maskPath.append(UIBezierPath(rect: targetFrame))
            return maskPath.cgPath
        }()
        overlayView.layer.mask = maskLayer
        
        overlayView.alpha = 0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.overlayView.alpha = 0.5
        }, completion: {(_) in })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.overlayView.alpha = 0
        }, completion: { [weak self] (context) in
            self?.overlayView.removeFromSuperview()
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: targetFrame.width, height: 200)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView?.bounds.size ?? .zero)
        return CGRect(origin: CGPoint(x: targetFrame.minX, y: targetFrame.maxY), size: containerSize)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        overlayView.frame = containerView?.frame ?? .zero
    }
    
    func overlayViewDidTap(sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
