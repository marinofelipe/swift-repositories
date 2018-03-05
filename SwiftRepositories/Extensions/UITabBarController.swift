//
//  UITabBarController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let firstBar = self.tabBar.items?.first {
            firstBar.image = #imageLiteral(resourceName: "fork").resizing(withNewHeight: 30.0)
        }
        
        tabBar.tintColor = .black
    }
}
