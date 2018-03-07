//
//  RepositoriesHandlerSuccessStubTests.swift
//  SwiftRepositoriesTests
//
//  Created by Felipe Lefèvre Marino on 3/7/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
@testable import SwiftRepositories

class RepositoriesHandlerSuccessStubTests: XCTestCase {
    
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
            // Stub it with our "beers.json" stub file (which is in same bundle as self)
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
    
    func testRepositoriesHandlerValidCall() {
        let promise = expectation(description: "Did receive answer on success block")
        
        RepositoriesHandler.get(atPage: 1) { response in
            if response?.statusCode == .success {
                promise.fulfill()
            } else {
                XCTFail("Did not returned with success")
            }
        }
        
        self.waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func testControllerStateAfterFetching() {
        let promise = expectation(description: "Did receive answer on success block")
        underTestController.fetchRepositories {
            XCTAssertEqual(self.underTestController.collectionView.numberOfItems(inSection: 0), 3)
            promise.fulfill()
        }
        
        self.waitForExpectations(timeout: 20.0, handler: nil)
    }
}
