//
//  RepositoriesViewModel.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

struct RepositoryListingViewModel {
    
    var title: String? = "Swift Repositories"
    var searchPlaceholder: String? = "search repositories.."
    var repositories: [RepositoryViewModel]?
}

extension RepositoryListingViewModel {
    
    init(repositories: [RepositoryViewModel]) {
        self.repositories = repositories
    }
}

struct RepositoryViewModel {
    
    var id: Int?
    var name: String?
    var description: String?
    var ownerUsername: String?
    var ownerImageUrl: String?
    var starsCount: String?
    var forksCount: String?
    var isFavorite: Bool = false
}

extension RepositoryViewModel {
    
    init(repository: Repository) {
        self.id = repository.id
        self.name = repository.name
        self.description = repository.description
        self.ownerUsername = repository.owner?.username
        self.ownerImageUrl = repository.owner?.imageUrl
        
        if let starsCount = repository.starsCount {
            self.starsCount = String(starsCount)
        }
        if let forksCount = repository.forksCount {
            self.forksCount = String(forksCount)
        }
    }
}
