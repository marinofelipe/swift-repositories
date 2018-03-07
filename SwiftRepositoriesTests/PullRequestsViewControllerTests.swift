//
//  PullRequestsViewControllerTests.swift
//  SwiftRepositoriesTests
//
//  Created by Felipe Lefèvre Marino on 3/7/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import SwiftRepositories

class PullRequestsViewControllerTests: XCTestCase {
    
    var underTestController: PullRequestsViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        underTestController = storyboard.instantiateViewController(withIdentifier: Constants.Identifier.Storyboard.pullRequests) as! PullRequestsViewController
        
        UIApplication.shared.keyWindow?.rootViewController = underTestController
        
        XCTAssertNotNil(underTestController.preloadView())
    }
    
    override func tearDown() {
        underTestController = nil
        super.tearDown()
    }
    
    // MARK: After loading states
    func testIfViewsAreCorrectlyConfigured() {
        XCTAssertEqual(underTestController.activityIndicator.isAnimating, true)
        XCTAssertNotNil(underTestController.openedCollectionView)
        XCTAssertNotNil(underTestController.closedCollectionView)
        XCTAssertEqual(underTestController.title, "Pull Requests")
    }
    
    func testCollectionAfterLoading() {
        XCTAssertEqual(underTestController.openedCollectionView.numberOfItems(inSection: 0), 0)
        XCTAssertEqual(underTestController.closedCollectionView.numberOfItems(inSection: 0), 0)
    }
    
    // MARK: Collection View datasource
    func testIfConformsToCollectionViewDataSource() {
        XCTAssert(underTestController.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(underTestController.responds(to: #selector(underTestController.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(underTestController.responds(to: #selector(underTestController.collectionView(_:cellForItemAt:))))
    }
    
    // MARK: API fetch performance
    func testPullRequestsFetchPerformance() {
        self.measure {
            underTestController.fetchPullRequests()
        }
    }
}

