//
//  PullRequest.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/4/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

struct PullRequest {
    
    var title: String?
    var body: String?
    var date: String?
    var url: String?
    var state: String?
    var ownerNick: String?
    var ownerAvatarUrl: String?
    
    init(title: String? = nil, body: String? = nil, date: String? = nil, url: String? = nil, state: String? = nil, ownerNick: String? = nil, ownerAvatarUrl: String? = nil) {
        self.title = title
        self.body = body
        self.date = date
        self.url = url
        self.state = state
        self.ownerNick = ownerNick
        self.ownerAvatarUrl = ownerAvatarUrl
    }
    
//    static func totalStates(_ pulls: [PullRequest]) -> (Int, Int) {
    
//        var totals = (open: 0, closed: 0)
//
//        for pull in pulls {
//            switch pull.state {
//            case "open":
//                totals.open += 1
//            case "closed":
//                totals.closed += 1
//            default:
//                break;
//            }
//        }
//
//        return totals
//    }
    
}

