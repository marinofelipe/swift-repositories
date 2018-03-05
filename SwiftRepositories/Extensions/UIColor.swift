//
//  UIColor.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/5/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

extension UIImage {
    
    func with(color: UIColor) -> UIImage {
        var newImage = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        color.set()
        newImage.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
