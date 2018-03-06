//
//  PullRequestsCollectionViewCell.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/5/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

class PullRequestsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorUsername: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        layer.cornerRadius = 2.0
        super.layoutSubviews()
    }
    
    // MARK: Setup
    func setup(with pullRequest: PullRequestViewModel?) {
        titleLabel.text = pullRequest?.title
        descriptionLabel.text = pullRequest?.description
        
        if let avatarUrl = pullRequest?.authorAvatarUrl {
            authorAvatarImageView.load(stringUrl: avatarUrl)
        }
        
        authorUsername.text = pullRequest?.authorUsername
        dateLabel.text = pullRequest?.date
    }
}
