//
//  PullRequestsHandler.swift
//  SwiftRepositories
//
//  Created by Felipe Lefevre Marino on 05/03/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import Foundation

struct PullRequestsResponse {
    let pullRequests: [PullRequestViewModel]?
    let statusCode: NetworkingStatus
    let message: String?
    
    init(_ pullRequests: [PullRequestViewModel]?, status: NetworkingStatus, message: String? = nil) {
        self.pullRequests = pullRequests
        self.statusCode = status
        self.message = message
    }
}

typealias PullRequestsCompletion = (_ response: PullRequestsResponse?) -> Void

class PullRequestsHandler {
    
    class func getAll(fromRepository repository: RepositoryViewModel?, completion: @escaping PullRequestsCompletion) {
        guard let ownerLogin = repository?.ownerUsername, let repositoryName = repository?.name else {
            completion(PullRequestsResponse(nil, status: .badRequest, message: "Invalid owner and repositories")) //add to constants - but show generic message to user
            return
        }
        
        let url = Constants.API.baseUrl + "/repos/\(ownerLogin)/\(repositoryName)/pulls"
        
        HTTPNetworking.request(method: .get, url: url, success: { response in
            guard response?.data != nil else { return }
            
            let pullRequestsArray = try? JSONDecoder().decode([PullRequest].self, from: response!.data!)
            let pullRequestsViewModel = pullRequestsArray?.map({ return PullRequestViewModel(pullRequest: $0) })
            let success = PullRequestsResponse(pullRequestsViewModel, status: .success)
            
            completion(success)
        }) { response, _ in
            let failure = PullRequestsResponse(nil, status: response?.statusCode ?? .unknown, message: response?.message)
            completion(failure)
        }
    }
}

