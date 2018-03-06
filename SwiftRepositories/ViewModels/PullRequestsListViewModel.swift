//
//  PullRequestsViewModel.swift
//  SwiftRepositories
//
//  Created by Felipe Lefevre Marino on 05/03/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

struct PullRequestsListViewModel {
    
    var title: String? = "Pull Requests"
    var pullRequests: [PullRequestViewModel]?
}

extension PullRequestsListViewModel {
    
    init(pullRequests: [PullRequestViewModel]) {
        self.pullRequests = pullRequests
    }
}

struct PullRequestViewModel {
    
    var id: Int?
    var title: String?
    var description: String?
    var date: String?
    var authorUsername: String?
    var authorAvatarUrl: String?
    var state: String?
    var url: String?
}

extension PullRequestViewModel {
    
    init(pullRequest: PullRequest) {
        self.id = pullRequest.id
        self.title = pullRequest.title
        self.description = pullRequest.description
        
        if let date = pullRequest.date {
            self.date = Date.fromString(date).convertToLongString()
        }
        
        self.authorUsername = pullRequest.author?.login
        self.authorAvatarUrl = pullRequest.author?.avatarUrl
        self.state = pullRequest.state
        self.url = pullRequest.url
    }
}

