//
//  NotTappablePresentationController.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 04/10/22.
//

import UIKit

class NotTappablePresentationController: UIPresentationController {

    let blurEffectView: UIVisualEffectView!
    
    public private(set) var modalTransitionSize: Double
    
    init(modalTransitionSize: Double, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        self.modalTransitionSize = modalTransitionSize
        let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * (1.0 - modalTransitionSize)),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * (modalTransitionSize)))
    }
    
    override func presentationTransitionWillBegin() {
        
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.7
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 25)
    }
    
    override func containerViewDidLayoutSubviews() {
        
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
}
