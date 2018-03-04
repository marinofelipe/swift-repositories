//
//  UIImage.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: Image from UIView
    class func image(ofView view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 1.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    // MARK: Image resizing
    internal func resizing(withNewHeight height: CGFloat) -> UIImage {
        let scale = height / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: height), false, 0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!.withRenderingMode(.alwaysTemplate)
    }
}
