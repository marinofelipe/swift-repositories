//
//  RefreshControl.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import Foundation
import UIKit

internal protocol RefreshControlDelegate: class {
    func willRefresh()
}

internal class RefreshControl: UIRefreshControl {
    
    internal weak var delegate: RefreshControlDelegate?
    
    // MARK: Initializers
    public override init() {
        super.init()
        addTarget(self, action: #selector(RefreshControl.refreshData), for: .valueChanged)
    }
    
    public convenience init?(withTitle title: String = "", color: UIColor = UIColor.black, font: UIFont = UIFont(name: "Avenir-Medium", size: 16.0)!) {
        self.init()
        
        config(withTitle: title, color: color, font: font)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configurations
    private func config(withTitle title: String, color: UIColor, font: UIFont) {
        attributedTitle = NSAttributedString(string: title, attributes: [.font: font, .foregroundColor: color])
        tintColor = color
    }
    
    @objc private func refreshData() {
        if let delegate = delegate {
            delegate.willRefresh()
        }
    }
}


