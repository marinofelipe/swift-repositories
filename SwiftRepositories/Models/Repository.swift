//
//  Repository.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

struct Repository {
    
    var id: Int? = 0
    var name: String? = "Repositório"
    var description: String? = "lorem ipsum description"
    var owner: Owner?
    var starsCount: String? = "10"
    var forksCount: String? = "3"
}

struct Owner {
    var name: String? = "Alamofire"
    var imageUrl: String? = ""
}
