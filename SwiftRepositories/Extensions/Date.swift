//
//  Date.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/4/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToStringUsingFormat(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func convertToLongString() -> String {
        return convertToStringUsingFormat(format: "EE, d LLL yyyy, HH:mm")
    }
    
    func convertToString() -> String {
        return convertToStringUsingFormat(format: "yyyy-MM-dd")
    }
    
    static func fromString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter.date(from: dateString)!
    }
}
