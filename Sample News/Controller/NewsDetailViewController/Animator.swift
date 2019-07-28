//
//  Animator.swift
//  Sample News
//
//  Created by Emtiyaj Ali on 28/07/19.
//  Copyright © 2019 Emtiyaj Ali. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.15
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (() -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let newsView = presenting ? toView : transitionContext.view(forKey: .from)!
        let initialFrame = presenting ? originFrame : newsView.frame
        let finalFrame = presenting ? newsView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            newsView.transform = scaleTransform
            newsView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            newsView.clipsToBounds = true
        }
        
        newsView.layer.cornerRadius = presenting ? 20.0 : 0.0
        newsView.layer.masksToBounds = true
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(newsView)
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            //usingSpringWithDamping: 0.5,
            //initialSpringVelocity: 0.2,
            animations: {
                newsView.transform = self.presenting ? .identity : scaleTransform
                newsView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                newsView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
    
    
}
