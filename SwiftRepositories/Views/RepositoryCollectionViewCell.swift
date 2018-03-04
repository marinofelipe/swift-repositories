//
//  RepositoryCollectionViewCell.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class RepositoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerUsernameLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    
    fileprivate var shadowOffsetWidth: Int = 0
    fileprivate var shadowOffsetHeight: Int = 4
    fileprivate var shadowColor: UIColor? = UIColor.gray
    fileprivate var shadowOpacity: Float = 0.5
    fileprivate var cornerRadius: CGFloat = 5
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCustomLayer()
    }
    
    private func setupCustomLayer() {
        layer.cornerRadius = cornerRadius
        contentView.backgroundColor = UIColor.clear
        
        let shadowPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 10, y: 0), size: CGSize(width: bounds.width - 20, height: bounds.height - 2)), cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
