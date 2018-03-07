//
//  PullRequestsHandlerStubTests.swift
//  SwiftRepositoriesTests
//
//  Created by Felipe Lefèvre Marino on 3/7/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
@testable import SwiftRepositories

class PullRequestsSuccessStubTests: XCTestCase {
    
    var alamofireManagerUnderTest: SessionManager!
    var underTestController: PullRequestsViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        underTestController = storyboard.instantiateViewController(withIdentifier: Constants.Identifier.Storyboard.pullRequests) as! PullRequestsViewController
        UIApplication.shared.keyWindow?.rootViewController = underTestController
        XCTAssertNotNil(underTestController.preloadView())
        
        alamofireManagerUnderTest = Alamofire.SessionManager.default
        
        OHHTTPStubs.setEnabled(true, for: alamofireManagerUnderTest.session.configuration)
        stub(condition: isHost("api.github.com")) { _ in
            // Stub it with our "pullRequests.json" stub file (which is in same bundle as self)
            guard let stubPath = OHPathForFile("pullRequests.json", type(of: self)) else {
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
    
    func testPullRequestsHandlerValidCall() {
        let promise = expectation(description: "Did receive answer on success block")
        
        let testViewModel = RepositoryViewModel(name: "alamofire", ownerUsername: "alamofire")
        PullRequestsHandler.getAll(fromRepository: testViewModel) { response in
            if response?.statusCode == .success {
                promise.fulfill()
            } else {
                XCTFail("Did not returned with success")
            }
        }

        self.waitForExpectations(timeout: 20.0, handler: nil)
    }
}
