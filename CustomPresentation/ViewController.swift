//
//  ViewController.swift
//  CustomPresentation
//
//  Created by kahayash on 2017/01/12.
//  Copyright © 2017年 kahayash. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tooltipButton: UIButton!
    @IBOutlet weak var dropdownButton: UIButton!
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tooltipButtonDidTap(_ sender: UIButton) {
        let vc = UIViewController()
        vc.view.backgroundColor = .black
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }

    @IBAction func dropdownButtonDidTap(_ sender: UIButton) {
        let vc = UITableViewController()
        vc.view.backgroundColor = .white
        
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func drawerButtonDidTap(_ sender: UIButton) {
        let vc = UITableViewController()
        vc.view.backgroundColor = .white
        
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        
        // ####################
        // ツールチップ
        // ####################
//        let controller = TooltopPresentationController(presentedViewController: presented, presenting: presenting)
//        let buttonFrame = tooltipButton.frame
//        controller.presentedViewFrame = CGRect(x: buttonFrame.minX - 10, y: buttonFrame.minY - 40, width: buttonFrame.width + 20, height: 40)
//        
        
        // ####################
        // ドロップダウン
        // ####################
//        let controller = DropDownPresentationController(presentedViewController: presented, presenting: presenting)
//        controller.targetFrame = dropdownButton.frame

        
        // ####################
        // ドロワー
        // ####################
        let controller = DrawerPresentationController(presentedViewController: presented, presenting: presenting)
        controller.gestureDelegate = self
        
        return controller
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // ####################
        // ドロップダウン
        // ####################
//        let animator = DropDownAnimator(direction: .present)
        
        // ####################
        // ドロワー
        // ####################
        let animator = DrawerAnimator(direction: .present)
        
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // ####################
        // ドロップダウン
        // ####################
//        let animator = DropDownAnimator(direction: .dismiss)
        
        // ####################
        // ドロワー
        // ####################
        let animator = DrawerAnimator(direction: .dismiss)
        
        return animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}

extension ViewController: DrawerPresentationControllerDelegate {
    func presentationController(vc: DrawerPresentationController, containerViewDidPan sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view)
        let prgress: CGFloat = vc.presentedView.flatMap { translation.x / $0.frame.width } ?? 0
        switch sender.state {
        case .began:
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            dismiss(animated: true, completion: nil)
        case .cancelled:
            interactiveTransition?.cancel()
        case .changed:
            interactiveTransition?.update(prgress)
        case .ended:
            sender.velocity(in: sender.view).x > 0 ? interactiveTransition?.finish() : interactiveTransition?.cancel()
            interactiveTransition = nil
        case .failed:
            interactiveTransition?.cancel()
            interactiveTransition = nil
        case .possible:
            break
        }
    }
}
