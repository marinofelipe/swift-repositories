//
//  UIViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //to make tests more readable
    func preloadView() {
        _ = view
    }
    
    internal func titlelessBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
}
