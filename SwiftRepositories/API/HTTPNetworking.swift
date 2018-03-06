//
//  HTTPNetworking.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/1/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import Alamofire

enum NetworkingStatus: Int {
    case notFound = 404
    case success = 200
    case badRequest = 500
    case serverError = 505
    case offline = 999
    case unknown = 666
    case jsonNotParsable = 888
}

struct NetworkingResponse {
    let data: Data?
    let statusCode: NetworkingStatus
    let message: String?
    
    init(_ data: Data?, status: NetworkingStatus, message: String = "") {
        self.data = data
        self.statusCode = status
        self.message = message
    }
}

typealias NetworkingSuccess = (_ serviceResponse: NetworkingResponse?) -> Void
typealias NetworkingFailure = (_ serviceResponse: NetworkingResponse?, _ error: Error?) -> Void

class HTTPNetworking {
    
    fileprivate class func requestAlamofire(method: HTTPMethod, url: String,
                                            parameters: [String: Any]? = nil,
                                            success: @escaping NetworkingSuccess,
                                            failure: @escaping NetworkingFailure) {
        
        guard Reachability.shared.isConnected() else {
            print("\nAPI - ERROR: offline ‼️")
            failure(NetworkingResponse(nil, status: .offline, message: Constants.Message.notConnected), nil)
            return
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.addValue(Constants.API.token, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 45
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        let manager = Alamofire.SessionManager.default
        manager.request(request).responseJSON { response in
            
            let value = response.data
            
            //Handling failure on responses
            switch response.result {
            case .failure(let error):
                guard response.response?.statusCode != 200 else {
                    print("\nAPI - RESULT: \(response.result) ✅\nDETAILS: \(String(describing: response.response))")
                    success(NetworkingResponse(nil, status: .success))
                    return
                }
                print("\nAPI - RESULT: \(response.result) ❌\nDETAILS: \(String(describing: response.response))\nERROR: \(error)")
                failure(NetworkingResponse(nil, status: .unknown, message: Constants.Message.genericError), error)
                break
            default:
                print("\nAPI - RESULT: \(response.result) ✅\nDETAILS: \(String(describing: response.response))")
                
                //Handling different types of success responses, as 200, 404..
                if let code = response.response?.statusCode, let value = value {
                    print("\nCODE: \(code) \(code == 200 ? "✅" : "⚠️")")
                    switch code {
                    case NetworkingStatus.success.rawValue:
                        success(NetworkingResponse(value, status: .success))
                    default:
                        if let status = NetworkingStatus(rawValue: code) {
                            failure(NetworkingResponse(value, status: status, message: Constants.Message.genericError), response.error)
                        } else {
                            failure(NetworkingResponse(value, status: .unknown, message: Constants.Message.genericError), response.error)
                        }
                    }
                }
                break
            }
        }
    }
    
    class func request(method: HTTPMethod, url: String,
                       parameters: [String: Any]? = nil,
                       success: @escaping NetworkingSuccess,
                       failure: @escaping NetworkingFailure) {
        
        self.requestAlamofire(method: method, url: url, parameters: parameters, success: { response in
            
            guard response?.data != nil else {
                success(NetworkingResponse(nil, status: .success))
                return
            }
            
            success(NetworkingResponse(response!.data, status: .success))
        }) { networkingFailure, error in
            failure(networkingFailure, error)
        }
    }
}

