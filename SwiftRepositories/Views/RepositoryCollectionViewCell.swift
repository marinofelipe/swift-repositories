//
//  RepositoryCollectionViewCell.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

protocol FavoriteRepositoryDelegate: class {
    func didFavorite()
}

class RepositoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerUsernameLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksImageView: UIImageView!
    @IBOutlet weak var starsImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    fileprivate var shadowOffsetWidth: Int = 0
    fileprivate var shadowOffsetHeight: Int = 4
    fileprivate var shadowColor: UIColor? = UIColor.gray
    fileprivate var shadowOpacity: Float = 0.5
    fileprivate var cornerRadius: CGFloat = 5
    
    fileprivate var favoriteButtonImage: UIImage {
        get {
            let favorite = viewModel?.isFavorite ?? false
            if !favorite {
                return #imageLiteral(resourceName: "ic-star").with(color: UIColor.white)
            } else {
                return #imageLiteral(resourceName: "ic-star").with(color: UIColor(red: 255.0/255.0, green: 135.0/255.0, blue: 38.0/255.0, alpha: 1.0))
            }
        }
    }
    
    fileprivate var viewModel: RepositoryViewModel?
    
    // MARK: Layout
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let forkTemplateImage = #imageLiteral(resourceName: "ic-fork").withRenderingMode(.alwaysTemplate)
        forksImageView.image = forkTemplateImage
        forksImageView.tintColor = .lightGray
        
        let starTemplateImage = #imageLiteral(resourceName: "ic-star").withRenderingMode(.alwaysTemplate)
        starsImageView.image = starTemplateImage
        starsImageView.tintColor = .lightGray
        
        favoriteButton.setImage(#imageLiteral(resourceName: "ic-star").with(color: UIColor.white), for: .normal)
    }
    
    override func layoutSubviews() {
        setupCustomLayer()
        favoriteButton.setImage(favoriteButtonImage, for: .normal)
        
        super.layoutSubviews()
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
    
    // MARK: Setup
    func setup(with repository: RepositoryViewModel?) {
        viewModel = repository
        if let ownerImageUrl = repository?.ownerImageUrl {
            imageView.load(stringUrl: ownerImageUrl)
        }
        nameLabel.text = repository?.name
        descriptionLabel.text = repository?.description
        forksCountLabel.text = repository?.forksCount
        starsCountLabel.text = repository?.starsCount
        ownerUsernameLabel.text = repository?.ownerUsername
    }
    
    // MARK: Actions
    @IBAction func touchedFavoriteButton(_ sender: Any) {
        if viewModel != nil {
            viewModel!.isFavorite = !viewModel!.isFavorite
        }
        UIView.transition(with: favoriteButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.favoriteButton.setImage(self.favoriteButtonImage, for: .normal)
        })
    }
}
