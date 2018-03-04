//
//  Repository.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

struct Repository {
    
    var id: Int?
    var name: String?
    var description: String?
    var owner: Owner?
    var starsCount: String?
    var forksCount: String?
    
    init(id: Int? = nil, name: String? = nil, description: String? = nil, owner: Owner? = nil, starsCount: String? = nil, forksCount: String? = nil) {
        
        self.id = id
        self.name = name
        self.description = description
        self.owner = owner
        self.starsCount = starsCount
        self.forksCount = forksCount
    }
}

struct Owner {
    var name: String? = "Alamofire"
    var imageUrl: String? = ""
}
