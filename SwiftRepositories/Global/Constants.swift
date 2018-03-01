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
}
