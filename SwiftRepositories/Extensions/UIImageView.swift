//
//  UIImageView.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/4/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    // MARK: Load image
    func load(stringUrl: String, placeholder: UIImage = #imageLiteral(resourceName: "ic-placeholder")) {
        if let url = URL(string: stringUrl) {
            self.af_setImage(withURL: url, placeholderImage: placeholder,
                             filter: nil, progress: nil, progressQueue: DispatchQueue.main,
                             imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false,
                             completion: nil)
        } else {
            image = #imageLiteral(resourceName: "ic-placeholder")
        }
    }
}
