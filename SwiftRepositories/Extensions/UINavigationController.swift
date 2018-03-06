//
//  UINavigationController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/6/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

extension UINavigationController: UINavigationControllerDelegate {
    
    override open func awakeFromNib() {
        delegate = self
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (toVC as? WebViewController) != nil || (fromVC as? WebViewController) != nil {
            return nil
        }
        
        let animationController = AnimatedTransitioningController()
        animationController.operation = operation
        
        if let repositoriesVC = self.viewControllers.first as? RepositoriesViewController {
            animationController.image = repositoriesVC.cellImageView.image
            animationController.startingFrameOnMainView = repositoriesVC.imageFrameOnMainView
            
            var finalFrame = repositoriesVC.imageFrameOnMainView
            finalFrame.size.height = UIScreen.main.bounds.width - 20
            finalFrame.size.width = UIScreen.main.bounds.width - 20
            finalFrame.origin.x = UIScreen.main.bounds.width / 2 - finalFrame.width / 2
            finalFrame.origin.y = UIScreen.main.bounds.height / 2 - finalFrame.height / 2
            animationController.finalFrame = finalFrame
            
            return animationController
        }
        
        return nil
    }
}
