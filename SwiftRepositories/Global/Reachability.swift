//
//  Reachability.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import Alamofire

class Reachability {
    static let shared = Reachability()
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    var connectionState: NetworkReachabilityManager.NetworkReachabilityStatus = .notReachable
    
    internal func isConnected() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    // MARK: Connection observer
    internal func listenToNetworkConnection() {
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { status in
            self.connectionState = status
            
            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
            }
        }
    }
}
