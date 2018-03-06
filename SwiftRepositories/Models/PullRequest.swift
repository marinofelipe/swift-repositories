//
//  PullRequest.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/4/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

enum PullRequestState: String {
    case closed, open
}

struct PullRequest: Decodable {
    
    var id: Int?
    var title: String?
    var description: String?
    var date: String?
    var author: Author?
    var state: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "body"
        case date = "created_at"
        case author = "user"
        case url = "html_url"
        case state = "state"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.author = try container.decodeIfPresent(Author.self, forKey: .author)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
    }
}

struct Author: User, Decodable {
    var login: String?
    var avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
