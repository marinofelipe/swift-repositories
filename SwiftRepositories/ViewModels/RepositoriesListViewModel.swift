//
//  RepositoriesViewModel.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

struct RepositoriesListViewModel {
    
    var title: String? = "Swift Repositories"
    var searchPlaceholder: String? = "search repositories.."
    var repositories: [RepositoryViewModel]?
}

extension RepositoriesListViewModel {
    
    init(repositories: [RepositoryViewModel]) {
        self.repositories = repositories
    }
}

struct RepositoryViewModel {
    
    var id: Int?
    var name: String?
    var description: String?
    var ownerUsername: String?
    var ownerAvatarUrl: String?
    var starsCount: String?
    var forksCount: String?
    var isFavorite: Bool = false
}

extension RepositoryViewModel {
    
    init(repository: Repository) {
        self.id = repository.id
        self.name = repository.name
        self.description = repository.description
        self.ownerUsername = repository.owner?.login
        self.ownerAvatarUrl = repository.owner?.avatarUrl
        
        if let starsCount = repository.starsCount {
            self.starsCount = String(starsCount)
        }
        if let forksCount = repository.forksCount {
            self.forksCount = String(forksCount)
        }
    }
    
    // MARK: init from Core Data
    init(repositoryEntity: RepositoryEntity) {
        self.id = Int(repositoryEntity.id)
        self.name = repositoryEntity.name
        self.description = repositoryEntity.body_description
        self.ownerUsername = repositoryEntity.owner_username
        self.ownerAvatarUrl = repositoryEntity.owner_avatar_url
        self.forksCount = repositoryEntity.forks_count
        self.starsCount = repositoryEntity.stars_count
        self.isFavorite = repositoryEntity.isFavorite
    }
}

