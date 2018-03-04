//
//  RepositoriesViewModel.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

struct RepositoriesViewModel {
    
    var title: String? = "Swift Repositories"
    var searchPlaceholder: String? = "search repositories.."
    var repositories: [RepositoryViewModel]?
}

extension RepositoriesViewModel {
    
    init(repositories: [RepositoryViewModel]) {
        self.repositories = repositories
    }
}

struct RepositoryViewModel {
    
    var name: String?
    var description: String?
    var ownerName: String?
    var ownerImage: UIImage?
    var starsCount: String?
    var forksCount: String?
}

extension RepositoryViewModel {
    
    init(repository: Repository) {
        self.name = repository.name
        self.description = repository.description
        self.ownerName = repository.owner?.name
        //self.ownerImage = load image repository.owner?.imageUrl
        self.starsCount = repository.starsCount
        self.forksCount = repository.forksCount
    }
}
