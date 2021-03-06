//
//  Repository.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

protocol User {
    var login: String? {get set}
    var avatarUrl: String? {get set}
}

struct RepositoriesArray: Decodable {
    var total: Int
    var repositories: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case repositories = "items"
    }
}

struct Repository: Decodable {
    
    var id: Int
    var name: String?
    var description: String?
    var owner: Owner?
    var starsCount: Int?
    var forksCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case owner
        case starsCount = "stargazers_count"
        case forksCount = "forks_count"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.owner = try container.decodeIfPresent(Owner.self, forKey: .owner)
        self.starsCount = try container.decodeIfPresent(Int.self, forKey: .starsCount)
        self.forksCount = try container.decodeIfPresent(Int.self, forKey: .forksCount)
    }
    
    // convenience init for testing
    init(name: String) {
        self.id = 0
        self.name = name
    }
}

struct Owner: User, Decodable {
    var login: String?
    var avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
