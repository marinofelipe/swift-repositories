//
//  Constants.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import Foundation

struct Constants {
    
    struct API {
        static var baseUrl: String {
            return Bundle.main.object(forInfoDictionaryKey: "ApiUrl") as! String
        }
    }
    
    struct Identifier {
        struct Cell {
            static let repository = "RepositoryCell"
            static let pullRequest = "PullRequestCell"
        }
        
        struct Storyboard {
            static let repositories = "RepositoriesViewController"
            static let favorites = "FavoritesViewController"
            static let pullRequests = "PullRequestsViewController"
        }
    }
    
    struct Segue {
        static let pullRequests = "showPullRequests"
        static let openInBrowser = "openInBrowser"
    }
    
    struct Message {
        static let genericError = "Could not retrieve information. Please try again later."
        static let notConnected = "Not connected to internet!"
    }
}
