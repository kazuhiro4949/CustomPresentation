//
//  DrawerPresentationController.swift
//  CustomPresentation
//
//  Created by kahayash on 2017/01/12.
//  Copyright © 2017年 kahayash. All rights reserved.
//

import UIKit

protocol DrawerPresentationControllerDelegate: class {
    func presentationController(vc: DrawerPresentationController, containerViewDidPan sender: UIPanGestureRecognizer)
}

class DrawerPresentationController: UIPresentationController {
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(DropDownPresentationController.overlayViewDidTap(sender:)))
        view.addGestureRecognizer(tapRec)
        return view
    }()
    weak var gestureDelegate: DrawerPresentationControllerDelegate?
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        overlayView.frame = containerView?.frame ?? .zero
        containerView?.insertSubview(overlayView, at: 0)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawerPresentationController.containerViewDidPan(sender:)))
        containerView?.addGestureRecognizer(panGesture)
        
        overlayView.alpha = 0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.overlayView.alpha = 0.5
            }, completion: { (_) in
        })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.overlayView.alpha = 0
            }, completion: { (_) in
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
    }
    
    
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width / 2, height: parentSize.height)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewBound = containerView?.bounds ?? .zero
        let containerSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBound.size)
        let origin = CGPoint(x: containerViewBound.maxX - containerSize.width, y: containerViewBound.minY)
        return CGRect(origin: origin, size: containerSize)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        overlayView.frame = containerView?.frame ?? .zero
    }
    
    func overlayViewDidTap(sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    func containerViewDidPan(sender: UIPanGestureRecognizer) {
        gestureDelegate?.presentationController(vc: self, containerViewDidPan: sender)
    }
    
}
