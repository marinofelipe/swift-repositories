//
//  HTTPNetworkingStubTests.swift
//  SwiftRepositoriesTests
//
//  Created by Felipe Lefèvre Marino on 3/7/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
@testable import SwiftRepositories

class HTTPNetworkingStubTests: XCTestCase {
    
    var alamofireManagerUnderTest: SessionManager!
    var underTestController: RepositoriesViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        underTestController = storyboard.instantiateViewController(withIdentifier: Constants.Identifier.Storyboard.repositories) as! RepositoriesViewController
        UIApplication.shared.keyWindow?.rootViewController = underTestController
        XCTAssertNotNil(underTestController.preloadView())
        
        alamofireManagerUnderTest = Alamofire.SessionManager.default
        
        OHHTTPStubs.setEnabled(true, for: alamofireManagerUnderTest.session.configuration)
        stub(condition: isHost("api.github.com")) { _ in
            // Stub it with our "repositories.json" stub file (which is in same bundle as self)
            guard let stubPath = OHPathForFile("repositories.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return fixture(filePath: stubPath, status: 200, headers: nil)
        }
    }
    
    override func tearDown() {
        alamofireManagerUnderTest = nil
        underTestController = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    // MARK: Alamofire testing
    
    func testAlamofireManagerWithValidCall() {
        var url = Constants.API.baseUrl + Constants.API.repositoriesByStars
        url += "&page=1&per_page=10"
        let promiseStatusCode = 200
        let promise = expectation(description: "received return status 200")
        
        alamofireManagerUnderTest.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                XCTAssertEqual(promiseStatusCode, response.response?.statusCode)
                promise.fulfill()
                break
            case .failure:
                XCTFail("Did not received return 200")
                break
            }
        }
        
        self.waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    // MARK: HTTPClient tests
    
    //expecting result to be 200
    func testHTTNetworkingValidCall() {
        let promiseStatusCode: NetworkingStatus = .success
        let promise = expectation(description: "received status code 200 and response as Data object")
        var url = Constants.API.baseUrl + Constants.API.repositoriesByStars
        url += "&page=1&per_page=10"
        HTTPNetworking.request(method: .get, url: url, success: { response in
            
            XCTAssertEqual(promiseStatusCode, response?.statusCode)
//            XCTAssertEqual(response?.data, )
            promise.fulfill()
        }) { _, _ in
            XCTFail("Did not receive status code 200 and response as Data object")
        }
        
        self.waitForExpectations(timeout: 20.0, handler: nil)
    }
}
