//
//  AnimatedTransitioningController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class AnimatedTransitioningController: NSObject {
    
    var image: UIImage? = nil
    var startingFrameOnMainView = CGRect.zero
    var finalFrame = CGRect.zero
    var duration = 0.666
    var operation: UINavigationControllerOperation = .push
}

extension AnimatedTransitioningController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if operation == .push {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                presentedView.alpha = 0
                
                let imageView = UIImageView(image: image)
                presentedView.addSubview(imageView)
                
                let scaleX = startingFrameOnMainView.width / finalFrame.width
                imageView.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
                imageView.frame = startingFrameOnMainView
                
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    imageView.transform = .identity
                    imageView.frame = self.finalFrame
                    
                    presentedView.alpha = 1
                    imageView.alpha = 0
                }, completion: { success in
                    imageView.removeFromSuperview()
                    transitionContext.completeTransition(success)
                })
            }
        } else {
            if let returningView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                
                var currentFrame = CGRect.zero
                currentFrame.size.height = UIScreen.main.bounds.width - 20
                currentFrame.size.width = UIScreen.main.bounds.width - 20
                currentFrame.origin.x = UIScreen.main.bounds.width / 2 - finalFrame.width / 2
                currentFrame.origin.y = UIScreen.main.bounds.height / 2 - finalFrame.height / 2
                
                let imageView = UIImageView(image: image)
                returningView.addSubview(imageView)
                
                let scaleY = currentFrame.height / startingFrameOnMainView.height
                
                imageView.transform = CGAffineTransform(scaleX: scaleY, y: scaleY)
                imageView.frame = currentFrame
                
                returningView.alpha = 0
                containerView.addSubview(returningView)
                
                UIView.animate(withDuration: duration, animations: {
                    imageView.transform = .identity
                    imageView.frame = self.startingFrameOnMainView
                    returningView.alpha = 1
                    imageView.alpha = 0
                }, completion: { success in
                    imageView.removeFromSuperview()
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
}

