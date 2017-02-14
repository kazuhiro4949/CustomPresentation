//
//  TooltopPresentationController.swift
//  CustomPresentation
//
//  Created by kahayash on 2017/01/12.
//  Copyright © 2017年 kahayash. All rights reserved.
//

import UIKit

class TooltopPresentationController: UIPresentationController {
    var presentedViewFrame = CGRect.zero
    var pointerSize = CGSize(width: 10, height: 10)
    var cornerRadius: CGFloat = 10
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let rec = UITapGestureRecognizer(target: self, action: #selector(DropDownPresentationController.overlayViewDidTap(sender:)))
        view.addGestureRecognizer(rec)
        return view
    }()
    
    private var balloonMaskLayer: CALayer {
        let frame = frameOfPresentedViewInContainerView
        let bounds = frame.offsetBy(dx: -frame.minX, dy: -frame.minY)
        
        let balloon = CAShapeLayer()
        balloon.frame = bounds
        balloon.path = makeBallonPath(bounds: bounds, pointerSize: pointerSize, cornerRadius: cornerRadius)
        return balloon
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        overlayView.frame = containerView?.frame ?? .zero
        containerView?.insertSubview(overlayView, at: 0)
        
        presentedView?.layer.mask = balloonMaskLayer
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: presentedViewFrame.width, height: presentedViewFrame.height)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView?.bounds.size ?? .zero)
        return CGRect(origin: CGPoint(x: presentedViewFrame.minX, y: presentedViewFrame.minY), size: containerSize)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        overlayView.frame = containerView?.frame ?? .zero
    }
    
    func overlayViewDidTap(sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    private func makeBallonPath(bounds: CGRect, pointerSize: CGSize, cornerRadius: CGFloat) -> CGPath {
        let path = CGMutablePath()
        path.move(
            to: CGPoint(x: bounds.size.width/2, y: bounds.maxY)
        )
        path.addLine(
            to: CGPoint(x: bounds.size.width/2 - pointerSize.width, y: bounds.maxY - pointerSize.height)
        )
        path.addArc(
            tangent1End: CGPoint(x: bounds.origin.x, y: bounds.maxY - pointerSize.height),
            tangent2End: CGPoint(x: bounds.origin.x, y: bounds.maxY - pointerSize.height - cornerRadius),
            radius: cornerRadius
        )
        path.addArc(
            tangent1End: CGPoint(x: bounds.minX, y: bounds.minY),
            tangent2End: CGPoint(x: bounds.minX + cornerRadius, y: bounds.minY),
            radius: cornerRadius
        )
        path.addArc(
            tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY),
            tangent2End: CGPoint(x: bounds.maxX, y: bounds.minY + cornerRadius),
            radius: cornerRadius
        )
        path.addArc(
            tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY - pointerSize.height),
            tangent2End: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY - pointerSize.height),
            radius: cornerRadius
        )
        path.addLine(
            to: CGPoint(x: bounds.size.width/2 + pointerSize.width, y: bounds.maxY - pointerSize.height)
        )
        path.closeSubpath()
        return path
    }
}
