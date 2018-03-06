//
//  RepositoriesHandler.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/4/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import Foundation

struct RepositoriesResponse {
    let repositories: [RepositoryViewModel]?
    let total: Int?
    let statusCode: NetworkingStatus
    let message: String?
    
    init(_ repositories: [RepositoryViewModel]?, total: Int? = nil, status: NetworkingStatus, message: String? = nil) {
        self.repositories = repositories
        self.total = total
        self.statusCode = status
        self.message = message
    }
}

typealias RepositoriesCompletion = (_ response: RepositoriesResponse?) -> Void

class RepositoriesHandler {
    
    class func get(atPage page: Int = 1, completion: @escaping RepositoriesCompletion) {
        
        var url = Constants.API.baseUrl + Constants.API.repositoriesByStars
        url += "&page=\(page)&per_page=10"
        
        HTTPNetworking.request(method: .get, url: url, success: { response in
            guard response?.data != nil else { return }
            
            let repositoriesArray = try? JSONDecoder().decode(RepositoriesArray.self, from: response!.data!)
            
            let repositoriesViewModel = repositoriesArray?.repositories.map({ return RepositoryViewModel(repository: $0) })
            let success = RepositoriesResponse(repositoriesViewModel, total: repositoriesArray?.total, status: .success)
            
            completion(success)
        }) { response, _ in
            let failure = RepositoriesResponse(nil, status: response?.statusCode ?? .unknown, message: response?.message)
            completion(failure)
        }
    }
}

struct RepositoriesPaging {
    var itemsPerPage = 10
    var totalItems = 300
    var currentPage = 1
    lazy var numberOfPages: Int = {
        var pagesCount = totalItems / itemsPerPage
        totalItems % itemsPerPage > 0 ? pagesCount += 1 : ()
        
        return pagesCount
    }()
}
