//
//  UINavigationController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override open func awakeFromNib() {
        setCustomAppearance()
    }
    
    private func setCustomAppearance() {
        self.navigationBar.barTintColor = UIColor.black
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20.0), .foregroundColor: UIColor.white]
    }
}
