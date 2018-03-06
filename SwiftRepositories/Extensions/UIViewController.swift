//
//  UIViewController.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
import SwiftMessages

extension UIViewController {
    
    //to make tests more readable
    func preloadView() {
        _ = view
    }
    
    // MARK: Titleless navigation bar back button
    internal func titlelessBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    // MARK: show snackbar
    func showSnackBar(with message: String, theme: Theme = .error) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        
        let title = theme == .warning ? "Warning" : "Error"
        view.configureContent(title: title, body: message)
        view.button?.isHidden = true
        
        SwiftMessages.show(view: view)
    }
}
